#!/bin/sh

show_help() {
  echo "Usage: $0 -t <text-to-remove> [-d <directory>] [-dryRun true|false]"
  echo
  echo "Renames files in the specified directory by removing a given text from filenames."
  echo
  echo "Options:"
  echo "  -t <text>         Text to remove from filenames (required)."
  echo "  -d <directory>    Directory to process (optional, defaults to current directory)."
  echo "  -dryRun true|false"
  echo "                    Whether to actually rename files (default: true)."
  echo "                    To apply changes, you must set: -dryRun false"
  echo "  -h, --help        Show this help message and exit."
}

# Defaults
target=""
directory="."
dry_run="true"

# Parse arguments
while [ "$#" -gt 0 ]; do
  case "$1" in
  -h | --help)
    show_help
    exit 0
    ;;
  -t)
    shift
    target="$1"
    ;;
  -d)
    shift
    directory="$1"
    ;;
  -dryRun)
    shift
    dry_run="$1"
    ;;
  *)
    echo "Unknown option: $1"
    show_help
    exit 1
    ;;
  esac
  shift
done

# Validate required argument
if [ -z "$target" ]; then
  echo "Error: -t <text-to-remove> is required."
  echo
  show_help
  exit 1
fi

# Change to target directory
cd "$directory" 2>/dev/null || {
  echo "Error: Directory not found or inaccessible: $directory"
  exit 1
}

echo "Working in directory: $(pwd)"
echo "Removing text: \"$target\" from filenames..."
echo "Dry run mode: $dry_run"
if [ "$dry_run" = "true" ]; then
  echo "⚠️  This is a dry run. No files will be renamed."
  echo "    To actually rename files, use: -dryRun false"
fi
echo

found_files=0

for file in *"$target"*; do
  [ -e "$file" ] || continue
  found_files=1
  newname=$(echo "$file" | sed "s/$target//g")
  if [ "$dry_run" = "true" ]; then
    echo "[DRY RUN] Would rename: \"$file\" → \"$newname\""
  else
    echo "Renaming: \"$file\" → \"$newname\""
    mv -- "$file" "$newname"
  fi
done

if [ "$found_files" -eq 0 ]; then
  echo "No files found containing \"$target\"."
else
  echo
  if [ "$dry_run" = "true" ]; then
    echo "Dry run complete. No changes were made."
  else
    echo "Renaming complete."
  fi
fi
