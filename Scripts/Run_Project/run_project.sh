#!/bin/bash

### Extract Mitogenome IDs from Site-100 database ###

echo "Extracting Mitogenome IDs from metadatabase"
Rscript Scripts/Extract_mt_ids.R
echo "Mitogenome IDs obtained and stored in ../data/mt_ids.txt"

### Retreive GenBank files from the Server ###

echo "Accessing and Receiving GenBank files from NHM Franklin server. User credentials required!"
scp -o ProxyJump=sams@orca.nhm.ac.uk -r sams@franklin.nhm.ac.uk:/mbl/share/workspaces/groups/voglerlab/samsmith/data/All_MGs .

### Process GenBank Files ###

echo "Processing GenBank files and outputting table with all PCGs present"
ipython3 Scripts/process_GBs.py

### Tidy the Data & find the IDs of Complete mitogenomes ###

echo "Tidying GenBank data and identifying complete mitogenomes"
Rscript Scripts/tidy.R

### Move complete mitogenomes into new folder ###

echo "Moving complete mitogenomes into new folder"
source_dir="../data/All_MGs"
dest_dir="../data/Complete_MGs"

while IFS= read -r file; do
    mv "$source_dir/$file" "$dest_dir/"
done < "../data/complete_mt_ids.txt"

### Run Complete mitogenomes through TJCreedy PL ###

echo "translating, aligning, backtranslating"
bash Scripts/creedy_pipeline.sh

### Make Data frame with all aligned sequences and IDs ###

ipython3 Scripts/alignedtable.py

### Generate Score function and Pairwise Matrix ###

Rscript Scripts/pairwise2.R

### Cluster ###

Rscript Scripts/k_means.R
