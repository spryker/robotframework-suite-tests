"""Robot Framework Listener v3 that prints detailed failure info to stderr.

When a test fails, outputs:
- Source file and line number
- Failure message
- Keyword call stack with source locations
- A copy-pasteable robot command to reproduce the failure locally

Also logs full Python tracebacks at INFO level for visibility in log.html
without requiring DEBUG log level.
"""

import sys
import traceback

ROBOT_LISTENER_API_VERSION = 3


def end_test(data, result):
    """Print structured failure details to stderr when a test fails."""
    try:
        if not result.passed:
            _print_failure_block(data, result)
    except Exception:
        pass


def end_keyword(data, result):
    """Log full traceback at INFO level for failing keywords in log.html."""
    try:
        if result.status == 'FAIL':
            _log_keyword_traceback()
    except Exception:
        pass


def _print_failure_block(data, result):
    """Build and print the structured failure block."""
    separator = '=' * 80
    source = getattr(data, 'source', 'unknown')
    lineno = getattr(data, 'lineno', '?')
    message = getattr(result, 'message', 'No message')

    lines = [
        '',
        separator,
        'FAILURE: %s' % data.name,
        '  Source: %s:%s' % (source, lineno),
        '  Message: %s' % message,
    ]

    keyword_stack = _collect_failed_keywords(result.body)
    if keyword_stack:
        lines.append('  Keyword Stack:')
        for depth, keyword_name, keyword_source in keyword_stack:
            indent = '    ' + '   ' * depth
            lines.append('%s-> %s [%s]' % (indent, keyword_name, keyword_source))

    docker_command, native_command = _build_reproduce_commands(data, source)
    if docker_command or native_command:
        lines.append('  Reproduce:')
    if docker_command:
        lines.append('    # Requires: docker/sdk boot deploy.ci.api.mariadb.robot.yml && docker/sdk up')
        lines.append('    %s' % docker_command)
    if native_command:
        lines.append('    # Or run natively on an already-booted system:')
        lines.append('    %s' % native_command)

    lines.append(separator)
    lines.append('')

    sys.stderr.write('\n'.join(lines) + '\n')
    sys.stderr.flush()


def _build_reproduce_commands(data, source):
    """Build reproduce commands for both Docker and native execution.

    Returns a tuple of (docker_command, native_command).
    """
    try:
        source_str = str(source) if source else ''
        test_name = getattr(data, 'longname', '') or getattr(data, 'name', '')

        if 'tests/api' in source_str:
            env = 'api_suite'
            suite_type = 'api'
            suite_selector = "-s '*'.tests.api.suite"
        elif 'tests/parallel_ui' in source_str or 'tests/ui' in source_str:
            env = 'ui_suite'
            suite_type = 'ui'
            suite_selector = "-s '*'.tests.parallel_ui.suite"
        else:
            env = 'api_suite'
            suite_type = 'api'
            suite_selector = ''

        # Extract the test directory path from source for native runner
        native_test_path = _extract_native_test_path(source_str)

        # Docker command
        docker_parts = [
            'docker/sdk exec robot-framework robot',
            '--listener resources/libraries/failure_detail_listener.py',
            '-v env:%s' % env,
            '-v dms:true',
            '-v docker:true',
        ]

        if env == 'ui_suite':
            docker_parts.extend(['-v headless:true', '-v ignore_console:false'])

        docker_parts.extend([
            '-d results',
            "--test '%s'" % test_name,
        ])

        if suite_selector:
            docker_parts.append(suite_selector)

        docker_parts.append('.')
        docker_command = ' '.join(docker_parts)

        # Native command using the shell script runner
        native_parts = [
            'vendor/bin/run-robot-suite-tests.sh',
            suite_type,
        ]

        if native_test_path:
            native_parts.append(native_test_path)

        native_command = ' '.join(native_parts)

        return docker_command, native_command
    except Exception:
        return '', ''


def _extract_native_test_path(source_str):
    """Extract the vendor-relative test directory path from a source file path.

    Converts a path like '/opt/robotframework/tests/api/suite/glue/carts/positive.robot'
    into 'vendor/spryker/robotframework-suite-tests/tests/api/suite/glue/carts'.
    """
    try:
        # Find the tests/ segment in the path
        marker = '/tests/'
        idx = source_str.find(marker)

        if idx < 0:
            return ''

        # Get the relative path from tests/ onward, drop the filename
        relative = 'tests/' + source_str[idx + len(marker):]
        directory = relative.rsplit('/', 1)[0] if '/' in relative else relative

        return 'vendor/spryker/robotframework-suite-tests/%s' % directory
    except Exception:
        return ''


def _collect_failed_keywords(body, depth=0):
    """Recursively walk keyword results to build a call stack of failures."""
    stack = []

    for item in body:
        if getattr(item, 'type', None) not in ('KEYWORD', 'kw'):
            continue

        if getattr(item, 'status', None) != 'FAIL':
            continue

        source = getattr(item, 'source_name', None) or getattr(item, 'source', None)
        lineno = getattr(item, 'lineno', None)

        if source and lineno:
            location = '%s:%s' % (source, lineno)
        elif source:
            location = source
        else:
            owner = getattr(item, 'owner', None) or getattr(item, 'libname', '')
            location = owner if owner else 'unknown'

        keyword_name = getattr(item, 'keyword_name', None) or getattr(item, 'kwname', '') or getattr(item, 'name', '')
        stack.append((depth, keyword_name, location))

        child_body = getattr(item, 'body', [])
        if child_body:
            stack.extend(_collect_failed_keywords(child_body, depth + 1))

    return stack


def _log_keyword_traceback():
    """Log the current Python traceback at INFO level if available."""
    try:
        from robot.api import logger
        exc_info = sys.exc_info()

        if exc_info[2] is not None:
            tb_lines = traceback.format_exception(*exc_info)
            logger.info('Full traceback:\n' + ''.join(tb_lines))
    except Exception:
        pass
