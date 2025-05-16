#!/bin/sh
# A minimal script to recompile updated or missing LaTeX PDFs.

set -e  # Exit on error

# Ensure required arguments are passed: base commit and latest commit
before="$1"
after="$2"

# Find all .tex files under "papers/" recursively
find papers -name '*.tex' | while IFS= read -r texfile; do
  pdffile="${texfile%.tex}.pdf"

  # Check if .tex file changed OR if corresponding .pdf is missing
  if git diff --quiet "$before" "$after" -- "$texfile"; then
    [ -f "$pdffile" ] && continue  # Skip unchanged if .pdf already exists
  fi

  # Compile the .tex file into a .pdf
  printf 'Compiling: %s\n' "$texfile"
  dir=$(dirname "$texfile")
  file=$(basename "$texfile")

  (
    cd "$dir"
    pdflatex -interaction=nonstopmode "$file" >/dev/null
  )
done

