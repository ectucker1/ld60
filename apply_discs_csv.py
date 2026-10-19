#!/usr/bin/env python3
"""Apply name and description edits from discs.csv back to the Disc .tres files.

Each row is matched to its file by the "Resource Path" column. Only the
`name` and `desc` properties are written; all other columns are ignored.

Usage:
    python3 apply_discs_csv.py [csv_path] [--dry-run]
"""
import argparse
import csv
import re
import sys
from pathlib import Path

PROJECT_ROOT = Path(__file__).resolve().parent

# Matches a quoted Godot string property, including escaped quotes and
# literal newlines inside the string.
STRING_PROP = r'^{key} = "((?:[^"\\]|\\.)*)"[ \t]*$'


def godot_escape(value: str) -> str:
    return value.replace("\\", "\\\\").replace('"', '\\"')


def godot_unescape(value: str) -> str:
    return re.sub(r'\\(.)', lambda m: {"n": "\n", "t": "\t"}.get(m.group(1), m.group(1)), value)


# Quotes are only added in the spreadsheet to stop cells being read as
# formulas, so any at the start or end of a value are stripped.
QUOTES_AND_WHITESPACE = "\"'“”‘’ \t\r\n"


def clean_value(value: str) -> str:
    """Strip surrounding whitespace and quotes, and turn typed \\n sequences
    into real line breaks."""
    return value.strip(QUOTES_AND_WHITESPACE).replace("\\n", "\n")


def set_string_prop(text: str, key: str, value: str) -> tuple[str, str | None]:
    """Return the updated file text and the previous value (None if unset)."""
    header, sep, body = text.partition("[resource]")
    if not sep:
        raise ValueError("no [resource] section")

    line = f'{key} = "{godot_escape(value)}"'
    pattern = re.compile(STRING_PROP.format(key=key), re.M)
    match = pattern.search(body)
    if match:
        old = godot_unescape(match.group(1))
        body = body[:match.start()] + line + body[match.end():]
    else:
        # Property is at its script default; insert it after the script line
        # (or after name, so desc follows it like in the other resources).
        old = None
        anchors = [m for m in re.finditer(r'^(script|name) = .*$', body, re.M)]
        if not anchors:
            raise ValueError("no script line in [resource] section")
        end = anchors[-1].end()
        body = body[:end] + "\n" + line + body[end:]
    return header + sep + body, old


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    parser.add_argument("csv_path", nargs="?", default=PROJECT_ROOT / "discs.csv", type=Path)
    parser.add_argument("--dry-run", action="store_true", help="show changes without writing files")
    args = parser.parse_args()

    # utf-8-sig strips the BOM that spreadsheet apps often add on export.
    with open(args.csv_path, newline="", encoding="utf-8-sig") as f:
        rows = list(csv.DictReader(f))

    changed_files = 0
    errors = 0
    for row in rows:
        path = PROJECT_ROOT / row["Resource Path"]
        if not path.is_file():
            print(f"ERROR: {row['Resource Path']}: file not found", file=sys.stderr)
            errors += 1
            continue

        text = path.read_text(encoding="utf-8")
        new_text = text
        changes = []
        try:
            for key, column in (("name", "Name"), ("desc", "Description")):
                value = clean_value(row[column])
                updated, old = set_string_prop(new_text, key, value)
                # Unset properties default to REPLACE_ME, so leave those alone.
                if old != value and not (old is None and value == "REPLACE_ME"):
                    new_text = updated
                    changes.append(f"  {key}: {old!r} -> {value!r}")
        except ValueError as e:
            print(f"ERROR: {row['Resource Path']}: {e}", file=sys.stderr)
            errors += 1
            continue

        if changes:
            changed_files += 1
            print(row["Resource Path"])
            print("\n".join(changes))
            if not args.dry_run:
                path.write_text(new_text, encoding="utf-8")

    verb = "Would update" if args.dry_run else "Updated"
    print(f"{verb} {changed_files} file(s).")
    return 1 if errors else 0


if __name__ == "__main__":
    sys.exit(main())
