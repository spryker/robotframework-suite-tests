#!/usr/bin/env bash
# Script to run Spryker Robot Framework tests without Docker (requires Spryker running via DockerSDK and /etc/hosts configuration)
# Usage from robotframework-suite-tests/ folder: ./bin/run-tests-native.sh [api|ui]
# Usage form suite/ folder: ./vendor/bin/run-tests-native.sh or vendor/spryker/robotframework-suite-tests/bin/run-robot-suite-tests.sh [api|ui]

set -eo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# 1. Script in vendor/spryker/robotframework-suite-tests/bin/
# 2. Script symlinked in vendor/bin/
if [[ "$SCRIPT_DIR" == */vendor/spryker/robotframework-suite-tests/bin ]]; then
    PROJECT_ROOT="$(cd "$SCRIPT_DIR/../../../.." && pwd)"
elif [[ "$SCRIPT_DIR" == */vendor/bin ]]; then
    PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
fi

RESULTS_DIR="$PROJECT_ROOT/.robot/results"

if [[ "$SCRIPT_DIR" == */vendor/bin ]]; then
    TESTS_DIR="$(cd "$SCRIPT_DIR/.." && pwd)/spryker/robotframework-suite-tests"
else
    TESTS_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
fi

VENV_DIR="$PROJECT_ROOT/.robot/.venv"

HEADLESS="true"
POSITIONAL=()
for arg in "$@"; do
    case "$arg" in
        --headed) HEADLESS="false" ;;
        *)        POSITIONAL+=("$arg") ;;
    esac
done

TEST_TYPE="${POSITIONAL[0]:-api}"
TEST_PATH="${POSITIONAL[1]:-}"

if [[ "$TEST_TYPE" == "--help" || "$TEST_TYPE" == "-h" ]]; then
    echo "Usage: $0 [api|ui] [optional-test-path] [--headed]"
    echo ""
    echo "Options:"
    echo "  --headed   Run UI tests in headed (visible) browser mode (default: headless)"
    echo ""
    echo "Examples:"
    echo "  $0 api                                    # Run all API tests"
    echo "  $0 api tests/api/mp_b2b/glue             # Run specific API tests"
    echo "  $0 ui                                     # Run UI tests headless"
    echo "  $0 ui --headed                            # Run UI tests with visible browser"
    exit 0
fi

# Normalize TEST_PATH: strip TESTS_DIR prefix if user passed a full path from project root
if [ -n "$TEST_PATH" ]; then
    TESTS_DIR_RELATIVE="${TESTS_DIR#$PROJECT_ROOT/}"
    TEST_PATH="${TEST_PATH#$TESTS_DIR_RELATIVE/}"
fi

echo "🤖 Robot Framework Native Test Runner"
echo "======================================"
echo "Test Type: $TEST_TYPE"
echo "Project Root: $PROJECT_ROOT"
echo "Tests Dir: $TESTS_DIR"
echo "Results Dir: $RESULTS_DIR"
if [[ "$TEST_TYPE" == "ui" ]]; then
    echo "Headless: $HEADLESS"
fi
echo ""

# Find Python 3 (prefer python3, fall back to versioned binaries)
PYTHON_BIN=""
for candidate in python3 python3.14 python3.13 python3.12 python3.11; do
    if command -v "$candidate" > /dev/null 2>&1; then
        major=$("$candidate" -c "import sys; print(sys.version_info.major)" 2>/dev/null)
        if [ "$major" -eq 3 ]; then
            PYTHON_BIN="$candidate"
            break
        fi
    fi
done

if [ -z "$PYTHON_BIN" ]; then
    echo "❌ Python 3 not found. Install it with:"
    echo "   sudo apt install python3 python3-venv   # Debian/Ubuntu"
    echo "   brew install python3                    # macOS"
    exit 1
fi

# Check if virtual environment exists and is valid (python present and pip importable)
if [ ! -f "$VENV_DIR/bin/python" ] || ! "$VENV_DIR/bin/python" -c "import pip" 2>/dev/null; then
    if ! "$PYTHON_BIN" -c "import venv" 2>/dev/null; then
        echo "❌ python3-venv is not installed. Install it with:"
        echo "   sudo apt install python3-venv   # Debian/Ubuntu"
        echo "   brew install python3            # macOS"
        exit 1
    fi
    echo "📦 Creating virtual environment with $PYTHON_BIN..."
    rm -rf "$VENV_DIR"
    "$PYTHON_BIN" -m venv "$VENV_DIR"
    echo "✅ Virtual environment created"
    echo ""
fi

# Check if dependencies are installed (check for robot command)
if [ ! -f "$VENV_DIR/bin/robot" ]; then
    echo "📦 Installing Robot Framework dependencies..."
    "$VENV_DIR/bin/python" -m pip install --upgrade pip
    "$VENV_DIR/bin/python" -m pip install --prefer-binary -U -r "$TESTS_DIR/requirements.txt"
    echo "✅ Dependencies installed"
    echo ""
fi

# Activate virtual environment by adding it to PATH
# This is crucial for pabot to find robot command
export PATH="$VENV_DIR/bin:$PATH"
echo "✅ Virtual environment activated"
echo ""


# Create results directory
mkdir -p "$RESULTS_DIR"

# Determine number of CPUs and number of parallel processes for pabot
if command -v nproc > /dev/null 2>&1; then
    CPU_COUNT=$(nproc)
else
    # macOS fallback
    CPU_COUNT=$(sysctl -n hw.ncpu)
fi
if [ "$CPU_COUNT" -le 2 ]; then
    PROCESSES=$CPU_COUNT
else
    PROCESSES=$((CPU_COUNT / 2))
fi

case "$TEST_TYPE" in
    api)
        if [ -z "$TEST_PATH" ]; then
            # No path specified - run all API tests
            TEST_TARGET="."
            SUITE_FILTER=(-s "*.tests.api.suite")
            echo "🧪 Running API tests (all)..."
        else
            # Path specified - run specific tests
            TEST_TARGET="$TEST_PATH"
            SUITE_FILTER=()
            echo "🧪 Running API tests..."
            echo "Target: $TEST_PATH"
        fi

        cd $TESTS_DIR
        robot \
            --listener resources/libraries/failure_detail_listener.py \
            -v env:api_suite \
            -v dms:true \
            -v docker:false \
            -v project_location:$PROJECT_ROOT \
            -v ignore_console:false \
            -d "$RESULTS_DIR" \
            --exclude skip-due-to-issueORskip-due-to-refactoring \
            "${SUITE_FILTER[@]}" \
            "$TEST_TARGET"
        ;;

    ui)
        # Check if Chromium browser is already installed
        SITE_PACKAGES=$(python -c "import site; print(site.getsitepackages()[0])")
        BROWSER_PATH="$SITE_PACKAGES/Browser/wrapper/node_modules/playwright-core/.local-browsers"

        if [ ! -d "$BROWSER_PATH" ] || [ -z "$(find "$BROWSER_PATH" -type d -name "chromium-*" 2>/dev/null)" ]; then
            echo "📦 Installing Chromium browser (first time only)..."
            WRAPPER_DIR="$SITE_PACKAGES/Browser/wrapper"
            RFBROWSER_LOG=$(rfbrowser init chromium 2>&1) || {
                if echo "$RFBROWSER_LOG" | grep -q "does not support chromium"; then
                    # rfbrowser's npm install already ran and succeeded; only the browser
                    # download failed because playwright-core has no builds for this OS.
                    # Patch the platform detection to map ubuntu26.x -> ubuntu24.04 builds,
                    # then download the browser directly without re-running rfbrowser init
                    # (which would reset node_modules).
                    echo "⚠️  Playwright does not support this OS yet. Patching platform detection to use ubuntu24.04 builds..."
                    CORE_BUNDLE="$WRAPPER_DIR/node_modules/playwright-core/lib/coreBundle.js"
                    sed -i 's/if (major < 26)/if (major < 28)/g' "$CORE_BUNDLE"
                    cd "$WRAPPER_DIR"
                    node_modules/.bin/playwright install chromium
                    cd - > /dev/null
                else
                    echo "$RFBROWSER_LOG"
                    exit 1
                fi
            }
            echo "✅ Chromium installed"
        else
            echo "✅ Chromium already installed at $BROWSER_PATH, skipping download"
        fi

        # Create subdirectories
        mkdir -p "$RESULTS_DIR/dynamic_set" "$RESULTS_DIR/dynamic_set/pabot_results" "$RESULTS_DIR/static_set" "$RESULTS_DIR/rerun"

        # In headed mode, pabot workers each spawn their own Node.js rfbrowser server
        # which has no display access. The documented fix (Browser/browser.py) is to start
        # one shared server in the main process (which has DISPLAY) and point all workers
        # to it via ROBOT_FRAMEWORK_BROWSER_NODE_PORT.
        if [ "$HEADLESS" = "false" ]; then
            RF_NODE_PORT=$(python3 -c "import socket; s=socket.socket(); s.bind(('', 0)); p=s.getsockname()[1]; s.close(); print(p)")
            echo "🌐 Starting shared rfbrowser node server on port $RF_NODE_PORT..."
            node "$SITE_PACKAGES/Browser/wrapper/index.js" 127.0.0.1 "$RF_NODE_PORT" &
            RF_NODE_PID=$!
            export ROBOT_FRAMEWORK_BROWSER_NODE_PORT="$RF_NODE_PORT"
            trap "kill $RF_NODE_PID 2>/dev/null || true" EXIT
            sleep 1
            echo "✅ rfbrowser node server started (PID $RF_NODE_PID)"
        fi

        echo "🧪 Running UI tests..."
        cd $TESTS_DIR

        echo "Running dynamic smoke tests with $PROCESSES parallel processes (detected $CPU_COUNT CPUs)..."
        pabot --processes "$PROCESSES" --testlevelsplit \
            --listener resources/libraries/failure_detail_listener.py \
            -v env:ui_suite \
            -v docker:false \
            -v headless:$HEADLESS \
            -v ignore_console:false \
            -v dms:true \
            -v project_location:$PROJECT_ROOT \
            -d "$RESULTS_DIR/dynamic_set" \
            --exclude skip-due-to-issueORskip-due-to-refactoringORstatic-set \
            --include smoke \
            -s '*'.tests.parallel_ui.suite \
            . || true

        echo ""
        echo "Running static smoke tests sequentially..."
        robot \
            --listener resources/libraries/failure_detail_listener.py \
            -v env:ui_suite \
            -v docker:false \
            -v headless:$HEADLESS \
            -v ignore_console:false \
            -v dms:true \
            -v project_location:$PROJECT_ROOT \
            -d "$RESULTS_DIR/static_set" \
            --exclude skip-due-to-issueORskip-due-to-refactoring \
            --include static-setANDsmoke \
            -s '*'.tests.parallel_ui.suite \
            . || true

        # Merge results
        echo "Merging test results..."
        rebot -d "$RESULTS_DIR" --output output.xml --merge \
            "$RESULTS_DIR/dynamic_set/output.xml" \
            "$RESULTS_DIR/static_set/output.xml" || true

        echo "Rerunning failed tests..."
        robot \
            --listener resources/libraries/failure_detail_listener.py \
            -v env:ui_suite \
            -v docker:false \
            -v dms:true \
            -v headless:$HEADLESS \
            -v ignore_console:false \
            -v project_location:$PROJECT_ROOT \
            -d "$RESULTS_DIR/rerun" \
            --runemptysuite \
            --rerunfailed "$RESULTS_DIR/output.xml" \
            --output rerun.xml \
            -s '*'.tests.parallel_ui.suite \
            $TESTS_DIR || true

        if [ -f "$RESULTS_DIR/rerun/rerun.xml" ] && [ -s "$RESULTS_DIR/rerun/rerun.xml" ]; then
            echo "Merging rerun results..."
            rebot -d "$RESULTS_DIR" --merge \
                "$RESULTS_DIR/output.xml" \
                "$RESULTS_DIR/rerun/rerun.xml" || true
        else
            echo "✅ All tests passed on first run, no rerun needed"
        fi
        ;;

    *)
        echo "❌ Unknown test type: $TEST_TYPE"
        echo "Usage: $0 [api|ui] [optional-test-path]"
        echo ""
        echo "Examples:"
        echo "  $0 api                                    # Run all API tests"
        echo "  $0 api tests/api/mp_b2b/glue             # Run specific tests"
        echo "  $0 api tests/api/mp_b2b/glue/cart_endpoints  # Run even more specific tests"
        exit 1
        ;;
esac

echo ""
echo "✅ Tests completed!"
echo "📊 Results: $RESULTS_DIR/report.html"


