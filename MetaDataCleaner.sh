#!/usr/bin/env bash

echo "All metadata will be deleted from all .png images in this directory and all subdirectories."
read -p "Press Enter to continue..."

echo "The deletion of the metadata has begun"
sleep 2
exiftool -r -all= -overwrite_original -ext png .

echo "Metadata was successfully removed."
sleep 3
