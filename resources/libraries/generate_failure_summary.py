"""Parse Robot Framework output.xml and generate a Markdown failure summary.

Usage:
    python generate_failure_summary.py results/output.xml

Outputs Markdown to stdout, suitable for writing to $GITHUB_STEP_SUMMARY.
"""

import os
import sys


def main():
    if len(sys.argv) < 2:
        print('Usage: python generate_failure_summary.py <output.xml>', file=sys.stderr)
        sys.exit(1)

    output_path = sys.argv[1]

    if not os.path.isfile(output_path):
        print('File not found: %s' % output_path, file=sys.stderr)
        sys.exit(1)

    try:
        from robot.api import ExecutionResult
    except ImportError:
        print('robot.api not available', file=sys.stderr)
        sys.exit(1)

    result = ExecutionResult(output_path)
    failures = []
    _collect_failures(result.suite, failures)

    if not failures:
        print('### Robot Framework Tests: All Passed')
        return

    print('### Robot Framework Test Failures')
    print('')
    print('| Test | Source | Error |')
    print('|------|--------|-------|')

    for test_name, source, message in failures:
        safe_name = _escape_markdown(test_name)
        safe_source = _escape_markdown(source)
        safe_message = _escape_markdown(_truncate(message, 200))
        print('| %s | %s | %s |' % (safe_name, safe_source, safe_message))

    total = result.suite.statistics.failed
    print('')
    print('**%d test(s) failed.**' % total)


def _collect_failures(suite, failures):
    """Recursively collect failed tests from suite hierarchy."""
    for test in suite.tests:
        if test.status == 'FAIL':
            source = getattr(test, 'source', '') or ''
            lineno = getattr(test, 'lineno', '') or ''
            if source:
                source_display = source
                if lineno:
                    source_display = '%s:%s' % (source_display, lineno)
            else:
                source_display = 'unknown'

            failures.append((test.name, source_display, test.message or 'No message'))

    for child_suite in suite.suites:
        _collect_failures(child_suite, failures)


def _escape_markdown(text):
    """Escape pipe characters and newlines for Markdown table cells."""
    return text.replace('|', '\\|').replace('\n', ' ').replace('\r', '')


def _truncate(text, max_length):
    """Truncate text to max_length, adding ellipsis if needed."""
    if len(text) <= max_length:
        return text

    return text[:max_length - 3] + '...'


if __name__ == '__main__':
    main()
