#!/bin/bash

# Define the source directory where the files are located
source_dir="../MMGdatabase/gbmaster_2024-04-04"

# Define the destination directory where you want to move the files
destination_dir="StaphyMGs"

# Read each filename from the text file
while IFS= read -r filename; do
    # Check if the file exists in the source directory
    if [ -e "$source_dir/$filename"* ]; then
        # Move the file from the source directory to the destination directory
        cp "$source_dir/$filename"* "$destination_dir/"
    else
        echo "File '$filename' does not exist in the source directory."
    fi
done < "mt_ids.txt"
