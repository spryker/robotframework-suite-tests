"""Robot Framework Listener v3 that prints detailed failure info to stderr.

When a test fails, outputs:
- Source file and line number
- Failure message
- Keyword call stack with source locations

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

    lines.append(separator)
    lines.append('')

    sys.stderr.write('\n'.join(lines) + '\n')
    sys.stderr.flush()


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
