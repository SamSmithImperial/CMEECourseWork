#!/bin/bash

### Extract Mitogenome IDs from Site-100 database ###

echo "Extracting Mitogenome IDs from metadatabase"
Rscript Scripts/Extract_mt_ids.R
echo "Mitogenome IDs obtained and stored in ../data/mt_ids.txt"

### Place mt_ids.txt into my server directory ###

scp -o ProxyJump=sams@orca.nhm.ac.uk ../data/Other/mt_ids.txt sams@franklin.nhm.ac.uk:/mbl/share/workspaces/groups/voglerlab/samsmith/data/

### log into the server and execute the bash script ###

### Retreive GenBank files from the Server ###

echo "Accessing and Receiving GenBank files from NHM Franklin server. User credentials required!"
scp -o ProxyJump=sams@orca.nhm.ac.uk -r sams@franklin.nhm.ac.uk:/mbl/share/workspaces/groups/voglerlab/samsmith/data/All_MGs .

### Process GenBank Files ###

echo "Processing GenBank files and outputting table with all PCGs present"
ipython3 Scripts/Process_GBs.py

### Tidy the Data & find the IDs of Complete mitogenomes ###

echo "Tidying GenBank data and identifying complete mitogenomes"
Rscript Scripts/tidy_data.R
echo "output ../data/Other/complete_mt_ids.txt & Complete_MG_Sequences.csv"

### Move complete mitogenomes into new folder ###

echo "Moving complete mitogenomes into new folder"
source_dir="../data/All_MGs"
dest_dir="../data/Complete_MGs"

while IFS= read -r file; do
    mv "$source_dir/$file" "$dest_dir/"
done < "../data/Other/complete_mt_ids.txt"

### combine all of the gb files ###

echo "Initiating Translation Process"
cat ../data/Complete_MGs/* > ../data/Other/combined.gb

### extract genes and convert to fasta ###

tjcreedyPL/biotools/extract_genes.py -g ../data/Other/combined.gb -o ../data/tree_building/1_nt_raw/ -k --genetypes CDS

### translate.py ###

echo "Translating..."
nt_raw_dir="../data/tree_building/1_nt_raw/"
aa_raw_dir="../data/tree_building/2_aa_raw/"

for file in "$nt_raw_dir"*
do
    filename=$(basename "$file")

    tjcreedyPL/biotools/translate.py 5 < "$file" > "${aa_raw_dir}${filename}"
done

### Which Genes were translated ###

ipython3 Scripts/COX1_names.py

### Signal Clustering ###
echo "Executing Signal Clustering Algorithm"
input_file="../data/tree_building/1_nt_raw/COX1.fasta"
output_dir="../data/Sig_Clusters"

c_values=(50 200 500)

k_values=(4 5 6 7 10 15 20 25)

for c in "${c_values[@]}"; do
  for k in "${k_values[@]}"; do
    output_file="${output_dir}/COX1_${c}_k${k}.csv"
    ./SigClust/SigClust -i 100 -c "$c" -k "$k" "$input_file" > "$output_file"
  done
done

### Make Data frame with all aligned sequences and IDs ###

ipython3 Scripts/alignedtable.py

### Generate Score function and Pairwise Matrix ###

Rscript Scripts/Pairwise_Matrix.R

### Kmeans Clustering ###

Rscript Scripts/Kmeans.R

### SigClust Centers ###

Rscript Scripts/SigClust_centers.R

### Plot Distributions ###

Density_Plots.R

