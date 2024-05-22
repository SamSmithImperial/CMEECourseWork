#!/bin/bash

# Source and destination directories
source_dir="../data/All_MGs"
dest_dir="../data/Complete_MGs"

# Read each line from the text file
while IFS= read -r file; do
    # Move the file from source to destination
    mv "$source_dir/$file" "$dest_dir/"
done < "../data/complete_mt_ids.txt"
