#!/bin/bash

# Source and destination directories
source_dir="../data/Complete_MGs"
dest_dir="../data/Sample_MGs"

# List the files in the source directory, limit to the first 500 files
ls -1 "$source_dir" | head -n 2000 | xargs -I {} cp "$source_dir/{}" "$dest_dir/"
