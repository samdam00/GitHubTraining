#!/bin/bash

###############################################################################
# test_fix_quotes.sh
#
# Unit tests for fix_quotes.sh
#
# This script runs a series of tests to verify the correct behavior of the
# fix_quotes.sh script, which is expected to replace double quotes with
# curly single quotes (‘ ’) for all but the first quoted value in
# "case objective" lines or blocks. The tests cover a variety of scenarios,
# including single-line and multi-line blocks, edge cases with odd numbers
# of quotes, empty quoted values, special characters, and mixed quote types.
#
# Usage:
#   ./test_fix_quotes.sh
#
# Each test creates a temporary file with input content, runs fix_quotes.sh
# on it, and compares the output to the expected result. Pass/fail counts
# are displayed at the end, and the script exits with a nonzero status if
# any test fails.
###############################################################################

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
FIX_QUOTES="$SCRIPT_DIR/fix_quotes.sh"

pass_count=0
fail_count=0

# run_test <test_name> <input_string> <expected_output>
# Runs fix_quotes.sh on the input and compares the result to the expected output.
run_test() {
    local name="$1"
    local input="$2"
    local expected="$3"

    tmpfile=$(mktemp "${TMPDIR:-/tmp}/fix_quotes_test_XXXXXX.svc")
    echo -e "$input" > "$tmpfile"

    (cd "$(dirname "$tmpfile")" && bash "$FIX_QUOTES" > /dev/null 2>&1)

    output=$(cat "$tmpfile")
    if [[ "$output" == "$expected" ]]; then
        echo "PASS: $name"
        ((pass_count++))
    else
        echo "FAIL: $name"
        echo "Expected:"
        echo "$expected"
        echo "Got:"
        echo "$output"
        ((fail_count++))
    fi

    rm -f "$tmpfile"
}

# 1. Single-line case objective with multiple quoted values
run_test "Single-line, multiple quoted"
'case objective "foo" "bar" "baz"'
'case objective "foo" ‘bar’ ‘baz’'

# 2. Multi-line case objective block
run_test "Multi-line block"
'case objective "foo"
"bar"
"baz"'
'case objective "foo"
‘bar’
‘baz’'

# 3. Block with only one quoted value (should remain unchanged)
run_test "Single quoted value"
'case objective "foo"'
'case objective "foo"'

# 4. Block with odd number of quotes (should remain unchanged)
run_test "Odd number of quotes"
'case objective "foo" "bar'
'case objective "foo" "bar'

# 5. File with no case objective block
run_test "No case objective"
'other line
another line'
'other line
another line'

# 6. Multiple case objective blocks
run_test "Multiple blocks"
'case objective "foo" "bar"
something else
case objective "a" "b" "c"'
'case objective "foo" ‘bar’
something else
case objective "a" ‘b’ ‘c’'

# 7. Block with nested quotes (should only replace inner pairs)
run_test "Nested quotes"
'case objective "foo" "bar \"baz\"" "qux"'
'case objective "foo" ‘bar \"baz\"’ ‘qux’'

# 8. Block with empty quoted values
run_test "Empty quoted values"
'case objective "foo" "" "bar"'
'case objective "foo" ‘’ ‘bar’'

# 9. Block with spaces between quotes
run_test "Spaces between quotes"
'case objective "foo"   "bar"    "baz"'
'case objective "foo"   ‘bar’    ‘baz’'

# 10. Block with tabs and spaces
run_test "Tabs and spaces"
'case objective	"foo"	"bar" "baz"'
'case objective	"foo"	‘bar’ ‘baz’'

# 11. Block with special characters inside quotes
run_test "Special characters"
'case objective "foo" "!@#$%^&*()" "bar"'
'case objective "foo" ‘!@#$%^&*()’ ‘bar’'

# 12. Block with only outer quotes (should remain unchanged)
run_test "Only outer quotes"
'case objective "foo bar baz"'
'case objective "foo bar baz"'

# 13. Block with single quotes (should remain unchanged)
run_test "Single quotes"
"case objective 'foo' 'bar'"
"case objective 'foo' 'bar'"

# 14. Block with mixed quote types (should only process double quotes)
run_test "Mixed quotes"
'case objective "foo" '\''bar'\'' "baz"'
'case objective "foo" '\''bar'\'' ‘baz’'

echo "Tests passed: $pass_count"
echo "Tests failed: $fail_count"

if [[ $fail_count -eq 0 ]]; then
    exit 0
else
    exit 1
fi