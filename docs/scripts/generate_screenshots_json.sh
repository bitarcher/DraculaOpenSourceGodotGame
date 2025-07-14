#!/bin/bash

# Check if a directory is provided
if [ -z "$1" ]; then
  echo "Usage: $0 <path_to_screenshots_directory>"
  exit 1
fi

SCREENSHOTS_DIR="$1"
OUTPUT_JSON="/home/michel-strasser/DraculaWebSite/screenshots.json"

# Check if the provided directory exists
if [ ! -d "$SCREENSHOTS_DIR" ]; then
  echo "Error: Directory \"$SCREENSHOTS_DIR\" not found."
  exit 1
fi

# --- Rename files to remove problematic characters ---
echo "Renaming files in $SCREENSHOTS_DIR..."
for FILE in "$SCREENSHOTS_DIR"/*.png; do
  if [ -f "$FILE" ]; then
    FILENAME=$(basename -- "$FILE")
    EXTENSION="${FILENAME##*.}"
    BASENAME="${FILENAME%.*}"

    # Clean the basename: replace spaces with hyphens, remove apostrophes, convert to lowercase, remove non-alphanumeric (except hyphens)
    CLEAN_BASENAME=$(echo "$BASENAME" | \
      sed "s/[[:space:]]/-/g" | \
      sed "s/[’']//g" | \
      tr "[:upper:]" "[:lower:]" | \
      sed "s/[^a-z0-9-]//g" \
    )

    NEW_FILENAME="${CLEAN_BASENAME}.${EXTENSION}"
    NEW_PATH="${SCREENSHOTS_DIR}/${NEW_FILENAME}"

    if [ "$FILE" != "$NEW_PATH" ]; then
      echo "  Renaming '$FILENAME' to '$NEW_FILENAME'"
      mv "$FILE" "$NEW_PATH"
    fi
  fi
done
echo "File renaming complete."
# --- End New: Rename files ---

# Start JSON array
printf "[
" > "$OUTPUT_JSON"

FIRST_FILE=true

# Find all .png files (now renamed) and add them to the JSON array
find "$SCREENSHOTS_DIR" -maxdepth 1 -type f -name "*.png" | sort | while read -r FILE;
do
  # Calculate relative path from the HTML directory
  RELATIVE_PATH="$(realpath --relative-to="/home/michel-strasser/DraculaOpenSourceGodotGame/docs" "$FILE")"
  if [ "$FIRST_FILE" = true ]; then
    printf "  \"%s\"" "$RELATIVE_PATH" >> "$OUTPUT_JSON"
    FIRST_FILE=false
  else
    printf ",\n  \"%s\"" "$RELATIVE_PATH" >> "$OUTPUT_JSON"
  fi
done

# End JSON array
printf "\n]
" >> "$OUTPUT_JSON"

echo "Generated $OUTPUT_JSON with screenshots from $SCREENSHOTS_DIR"
