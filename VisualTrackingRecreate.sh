#!/usr/bin/env bash

set -euo pipefail

INPUT="pic.png"
WEBP_TMP="pic.webp"
JPG_TMP="pic_80.jpg"
RESIZED_TMP="pic_resized.jpg"
NOISY_TMP="pic_noisy.jpg"
OUTPUT="final_pic.jpg"

if [ ! -f "$INPUT" ]; then
    echo "Error: Input file '$INPUT' not found!" >&2
    exit 1
fi

echo "Starting image pipeline..."

# Step 1: Convert PNG to WebP
echo "--> Step 1: Converting $INPUT to $WEBP_TMP..."
cwebp -q 100 "$INPUT" -o "$WEBP_TMP"

# Step 2: Convert WebP to JPG at 80% quality
echo "--> Step 2: Converting $WEBP_TMP to $JPG_TMP (80% quality)..."
convert "$WEBP_TMP" -quality 80 "$JPG_TMP"

# Step 3: Resize to 95% and then up to 105.28%
echo "--> Step 3: Downscaling to 95% and upscaling to 105.28%..."
convert "$JPG_TMP" -resize 95% -resize 105.28% "$RESIZED_TMP"

# Step 4: Add invisible Gaussian noise (-attenuate controls noise strength)
echo "--> Step 4: Adding subtle Gaussian noise..."
convert "$RESIZED_TMP" -attenuate 0.3 +noise Gaussian "$NOISY_TMP"

# Step 5: Rotate 0.5 degrees
echo "--> Step 5: Rotating image by 0.5 degrees..."
convert "$NOISY_TMP" -background white -rotate 0.3 "$OUTPUT"

# Clean up temporary files
rm -f "$WEBP_TMP" "$JPG_TMP" "$RESIZED_TMP" "$NOISY_TMP"

exiftool -all= -overwrite_original "$OUTPUT"

echo "Done! Processed file saved as: $OUTPUT"
