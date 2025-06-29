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
    function trim(s) { sub(/^[ \t]+/, "", s); sub(/[ \t]+$/, "", s); return s }
    BEGIN { macro_name = ""; code_found = 0; in_macro = 0; macro_buffer = "" }
    # Ignore commented-out #define lines
    /^[ \t]*\/\// { next }
    /^[ \t]*#/ && $0 !~ /^[ \t]*#define/ { next }
    # Detect macro definition lines
    /^[ \t]*#define[ \t]+/ {
        # Output previous macro if any
        if (in_macro && macro_name != "") {
            if (code_found) print macro_name >> expanded;
            else print macro_name >> unexpanded;
        }
        # Start new macro
        macro_buffer = $0;
        in_macro = 1;
        code_found = 0;
        # Remove #define and leading whitespace
        line = $0;
        sub(/^[ \t]*#define[ \t]+/, "", line);
        # Extract macro name (handles parameters)
        if (match(line, /^([A-Za-z_][A-Za-z0-9_]*)/, arr)) {
            macro_name = arr[1];
        } else {
            macro_name = "";
        }
        # Check if macro continues to next line
        if ($0 ~ /\\[ \t]*$/) next;
        # Otherwise, process macro body
        macro_body = line;
        sub(/^[A-Za-z_][A-Za-z0-9_]*[ \t]*(\(.*\))?[ \t]*/, "", macro_body);
        if (macro_body ~ /[^ \t]/) code_found = 1;
        in_macro = 0;
        next;
    }
    # Handle continuation lines for macros
    in_macro && /\\[ \t]*$/ {
        macro_buffer = macro_buffer "\n" $0;
        next;
    }
    in_macro {
        macro_buffer = macro_buffer "\n" $0;
        # Check for code in continuation lines (ignore comments and empty lines)
        line = $0;
        gsub(/\/\*.*\*\//, "", line); # Remove block comments
        gsub(/\/\/.*$/, "", line);    # Remove line comments
        if (line ~ /[^ \t\\]/) code_found = 1;
        # If this is the last line of the macro (no trailing backslash)
        if ($0 !~ /\\[ \t]*$/) {
            if (macro_name != "") {
                if (code_found) print macro_name >> expanded;
                else print macro_name >> unexpanded;
            }
            in_macro = 0;
        }
        next;
    }
    END {
        # Output last macro if file ends during macro
        if (in_macro && macro_name != "") {
            if (code_found) print macro_name >> expanded;
            else print macro_name >> unexpanded;
        }
    }
    ' "$file"

    # Sort and deduplicate each output file
    /usr/bin/sort -u -o "$expanded_out" "$expanded_out"
    /usr/bin/sort -u -o "$unexpanded_out" "$unexpanded_out"
done