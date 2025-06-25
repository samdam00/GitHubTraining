#!/bin/bash

# Remove old output files if they exist
rm -f expanded_macros.txt unexpanded_macros.txt

# Search all *.txt files in the current directory
for file in *.txt; do
    # Find expanded macros: #define MACRO ... (with code block)
    awk '
    function trim(s) { sub(/^[ \t]+/, "", s); sub(/[ \t]+$/, "", s); return s }
    /^\s*#define/ {
        # Remove #define and trim
        line = $0
        sub(/^\s*#define[ \t]+/, "", line)
        # Join lines if macro name continues with \
        while (line ~ /\\\s*$/) {
            sub(/\\\s*$/, "", line)
            if (getline nextline) {
                line = line trim(nextline)
            } else {
                break
            }
        }
        line = trim(line)
        split(line, arr, /[ \t\(]/)
        macro_name = arr[1]
        # Now check if next non-empty, non-comment line is code
        code_found = 0
        while (getline nextline) {
            if (nextline ~ /^[ \t]*$/ || nextline ~ /^\/\//) continue
            if (nextline ~ /^#/) break
            code_found = 1
            break
        }
        if (macro_name != "") {
            if (code_found) {
                print macro_name >> "expanded_macros.txt"
            } else {
                print macro_name >> "unexpanded_macros.txt"
            }
        }
        next
    }
    ' "$file"
done

sort -u -o expanded_macros.txt expanded_macros.txt
sort -u -o unexpanded_macros.txt unexpanded_macros.txt