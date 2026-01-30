#!/usr/bin/env bash
# Script to run Spryker Robot Framework tests without Docker (requires Spryker running via DockerSDK and /etc/hosts configuration)
# Usage from robotframework-suite-tests/ folder: ./bin/run-tests-native.sh [api|ui]
# Usage form suite/ folder: ./vendor/bin/run-tests-native.sh or vendor/spryker/robotframework-suite-tests/bin/run-robot-suite-tests.sh [api|ui]

set -e

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

TEST_TYPE="${1:-api}"

echo "🤖 Robot Framework Native Test Runner"
echo "======================================"
echo "Test Type: $TEST_TYPE"
echo "Project Root: $PROJECT_ROOT"
echo "Tests Dir: $TESTS_DIR"
echo "Results Dir: $RESULTS_DIR"
echo ""

# Check if virtual environment exists and is valid
if [ ! -f "$VENV_DIR/bin/python" ]; then
    echo "📦 Creating virtual environment..."
    python3 -m venv "$VENV_DIR"
    echo "✅ Virtual environment created"
    echo ""
fi

# Check if dependencies are installed (check for robot command)
if [ ! -f "$VENV_DIR/bin/robot" ]; then
    echo "📦 Installing Robot Framework dependencies..."
    "$VENV_DIR/bin/pip" install --upgrade pip
    "$VENV_DIR/bin/pip" install -U -r "$TESTS_DIR/requirements.txt"
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
        echo "🧪 Running API tests..."
        cd $TESTS_DIR
        robot \
            -v env:api_suite \
            -v dms:true \
            -v docker:false \
            -v project_location:$PROJECT_ROOT \
            -v ignore_console:false \
            -d "$RESULTS_DIR" \
            --exclude skip-due-to-issueORskip-due-to-refactoring \
            -s '*'.tests.api.suite \
            .
        ;;

    ui)
        # Check if Chromium browser is already installed
        SITE_PACKAGES=$(python -c "import site; print(site.getsitepackages()[0])")
        BROWSER_PATH="$SITE_PACKAGES/Browser/wrapper/node_modules/playwright-core/.local-browsers"

        if [ ! -d "$BROWSER_PATH" ] || [ -z "$(find "$BROWSER_PATH" -type d -name "chromium-*" 2>/dev/null)" ]; then
            echo "📦 Installing Chromium browser (first time only)..."
            rfbrowser init chromium
            echo "✅ Chromium installed"
        else
            echo "✅ Chromium already installed at $BROWSER_PATH, skipping download"
        fi

        # Create subdirectories
        mkdir -p "$RESULTS_DIR/dynamic_set" "$RESULTS_DIR/dynamic_set/pabot_results" "$RESULTS_DIR/static_set" "$RESULTS_DIR/rerun"

        echo "🧪 Running UI tests..."
        cd $TESTS_DIR

        echo "Running dynamic smoke tests with $PROCESSES parallel processes (detected $CPU_COUNT CPUs)..."
        pabot --processes "$PROCESSES" --testlevelsplit \
            -v env:ui_suite \
            -v docker:false \
            -v headless:true \
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
            -v env:ui_suite \
            -v docker:false \
            -v headless:true \
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
            -v env:ui_suite \
            -v docker:false \
            -v dms:true \
            -v headless:true \
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
        echo "Usage: $0 [api|ui]"
        exit 1
        ;;
esac

echo ""
echo "✅ Tests completed!"
echo "📊 Results: $RESULTS_DIR/report.html"


