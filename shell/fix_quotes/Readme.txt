# fix_quotes.sh

## Overview

This script recursively processes all `.svc` files in the current directory and its subdirectories. It identifies lines that begin with `case objective` and replaces inner double-quoted (`"`) segments within those lines with typographic single quotes (`‘` and `’`), while preserving the outer quotes.

## Purpose

Sometimes `.svc` files may contain strings like:

```
case objective "some text "quoted" end"
```

The script transforms this into:

```
case objective "some text ‘quoted’ end"
```

This is useful for improving formatting or preparing text for publishing or display systems that require smart quotes.

## Usage

### 1. Make the script executable

```bash
chmod +x fix_quotes.sh
```

### 2. Run the script

```bash
./fix_quotes.sh
```

It will:
- Recursively scan for `.svc` files.
- Modify matching lines in-place.
- Print the name of each updated file.

## Example

Given this `.svc` file content:

```text
some unrelated line
case objective "intro text "highlight" conclusion"
another line
```

After running the script:

```text
some unrelated line
case objective "intro text ‘highlight’ conclusion"
another line
```

## Notes

- Only lines beginning with `case objective` are modified.
- Only text inside the outermost quotes is scanned for inner quoted segments.
- A backup mechanism is not built-in—consider backing up files beforehand if needed:

```bash
find . -name "*.svc" -exec cp {} {}.bak \;
```

---