#!/bin/bash

# -----------------------------------------------------------------------------
# Untraced_Macros.sh
#
# Scans all .codda files in the current directory and its subdirectories for
# C-style macro definitions (#define).
#
# For each macro found, determines if it contains code (expanded) or not
# (unexpanded), based on whether the macro definition line or its continuation
# contains non-comment, non-preprocessor, non-empty content.
#
# Outputs:
#   - For each .codda file, generates:
#       expanded_macros_<file>.txt:   Macro names with code (expanded)
#       unexpanded_macros_<file>.txt: Macro names without code (unexpanded)
#   - Output files are sorted and deduplicated.
#
# Usage:
#   Run from the directory containing .codda files.
#   No arguments required.
#
# Notes:
#   - Output file names are based on the relative path of each .codda file,
#     with slashes replaced by underscores.
#   - Old output files are removed at the
# -----------------------------------------------------------------------------

# Remove old output files if they exist
rm -f expanded_macros_*.txt unexpanded_macros_*.txt

# Search all *.codda files in the current directory and subdirectories
find . -type f -name "*.codda" | while read -r file; do
    # Create a safe output file suffix based on the codda file path
    out_suffix=$(echo "$file" | sed 's|^\./||; s|/|_|g; s|\.codda$||')
    expanded_out="expanded_macros_${out_suffix}.txt"
    unexpanded_out="unexpanded_macros_${out_suffix}.txt"

    awk -v expanded="$expanded_out" -v unexpanded="$unexpanded_out" '
    # Helper function to trim whitespace (not used in logic, but available)
    function trim(s) { sub(/^[ \t]+/, "", s); sub(/[ \t]+$/, "", s); return s }
    BEGIN { macro_name = ""; code_found = 0 }
    # Detect macro definition lines
    /^\s*#define/ {
        if (macro_name != "") {
            # Output previous macro before processing new one
            if (code_found) {
                print macro_name >> expanded
            } else {
                print macro_name >> unexpanded
            }
        }
        # Start new macro: extract macro name
        line = $0
        sub(/^\s*#define[ \t]+/, "", line)
        split(line, arr, /[ \t\(]/)
        macro_name = arr[1]
        code_found = 0
        next
    }
    {
        # For lines after #define, check if there is code (non-empty, non-comment, non-preprocessor)
        if (macro_name != "" && code_found == 0) {
            if ($0 ~ /^[ \t]*$/ || $0 ~ /^\/\// || $0 ~ /^#/) {
                next
            } else {
                code_found = 1
            }
        }
    }
    END {
        # Output last macro at end of file
        if (macro_name != "") {
            if (code_found) {
                print macro_name >> expanded
            } else {
                print macro_name >> unexpanded
            }
        }
    }
    ' "$file"

    # Sort and deduplicate each output file
    /usr/bin/sort -u -o "$expanded_out" "$expanded_out"
    /usr/bin/sort -u -o "$unexpanded_out" "$unexpanded_out"
done