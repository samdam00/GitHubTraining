#!/bin/bash

###############################################################################
# fix_case_objective_quotes.sh
#
# Description:
#   This script scans all `.svc` files in the current directory and its
#   subdirectories. It searches for `case objective` blocks (which may span
#   single or multiple lines) and replaces all inner "quoted" values within
#   the outermost quotes of these blocks with typographic quotes ‘quoted’.
#
#   The script preserves the outermost quotes and only replaces inner pairs.
#   It handles both single-line and multi-line `case objective` blocks.
#
# How it works:
#   1. For each `.svc` file found:
#      - Reads the file line by line.
#      - Detects the start of a `case objective` block.
#      - Accumulates lines if the block spans multiple lines.
#      - When a complete block is detected (even number of quotes >= 2):
#         - Finds the outermost quotes.
#         - Replaces all inner "..." with ‘...’ using sed.
#         - Writes the processed block to a temporary file.
#      - If not in a block, writes the line as-is.
#   2. After processing, replaces the original file with the updated content.
#
# Usage:
#   Run this script from the directory containing your `.svc` files:
#       ./fix_case_objective_quotes.sh
#
# Dependencies:
#   - bash
#   - grep
#   - wc
#   - tr
#   - cut
#   - sed
#   - mktemp
#
# Notes:
#   - Only processes `case objective` blocks with at least two quotes.
#   - Leaves blocks with an odd number of quotes or less than two quotes unchanged.
#   - Backs up nothing; original files are overwritten.
###############################################################################

process_block() {
    local block="$1"
    local quote_count
    quote_count=$(echo "$block" | grep -o '"' | wc -l | tr -d ' ')

    if [[ $((quote_count % 2)) -eq 0 && $quote_count -ge 2 ]]; then
        local outer_start outer_end before middle after
        outer_start=$(echo "$block" | grep -abo '"' | head -n1 | cut -d: -f1)
        outer_end=$(echo "$block" | grep -abo '"' | tail -n1 | cut -d: -f1)
        before=${block:0:outer_start+1}
        middle=${block:outer_start+1:outer_end-outer_start-1}
        after=${block:outer_end}
        middle=$(echo "$middle" | sed -E 's/"([^"]+)"/‘\1’/g')
        echo "${before}${middle}${after}"
        return 0
    else
        return 1
    fi
}

find . -type f -name "*.svc" | while read -r file; do
    tmp_file=$(mktemp)
    inside_block=0
    block=""

    while IFS= read -r line || [[ -n "$line" ]]; do
        if [[ "$line" =~ case[[:space:]]+objective ]]; then
            block="$line"
            if processed=$(process_block "$block"); then
                echo "$processed" >> "$tmp_file"
            else
                inside_block=1
            fi
        elif [[ $inside_block -eq 1 ]]; then
            block="${block}"$'\n'"$line"
            if processed=$(process_block "$block"); then
                echo "$processed" >> "$tmp_file"
                inside_block=0
                block=""
            fi
        else
            echo "$line" >> "$tmp_file"
        fi
    done < "$file"

    # Write incomplete block if any
    if [[ $inside_block -eq 1 ]]; then
        echo "$block" >> "$tmp_file"
    fi

    mv "$tmp_file" "$file"
    echo "Updated: $file"
done