### make new directories for backbone fasta files ###

# mkdir 4_nt_aln_backbone

### fill new directory with fasta files only include the cluster centers ###

mapfile -t ids < Cluster_center_IDs.txt

for fasta_file in 4_nt_aln/*.fasta; do
    # Create a new file in the target directory
    output_file="4_nt_aln_backbone/$(basename "$fasta_file")"
    
    # Initialize an empty string to store the output
    output=""

    # Read through the FASTA file
    while IFS= read -r line; do
        if [[ $line == ">"* ]]; then
            # This is a header line; check if it matches any of the IDs
            header=$line
            sequence_name=$(echo "$line" | sed 's/>//')
            if [[ " ${ids[@]} " =~ " ${sequence_name} " ]]; then
                include_sequence=true
                output+="$header"$'\n'
            else
                include_sequence=false
            fi
        elif [[ $include_sequence == true ]]; then
            # This is a sequence line to be included
            output+="$line"$'\n'
        fi
    done < "$fasta_file"

    # Write the output to the new file
    echo -n "$output" > "$output_file"
done


### Tree Building with cluster centers ###

catfasta2phyml/catfasta2phyml.pl -c -fasta ../data/4_nt_aln_backbone/* > ../data/5_nt_supermatrix.fasta 2> ../data/5_nt_partitions.txt

tjcreedyPL/biotools/partitioner.py -a DNA < ../data/5_nt_partitions.txt > ../data/5_nt_gene_partitions.txt
# Partition by genes and all three codon positions
tjcreedyPL/biotools/partitioner.py -a DNA -c < ../data/5_nt_partitions.txt > ../data/5_nt_gene+codon123_partitions.txt
# Partition by genes and first two codon positions
tjcreedyPL/biotools/partitioner.py -a DNA -c -u 1 2 < ../data/5_nt_partitions.txt > ../data/5_nt_gene+codon12_partitions.txt

iqtree -s ../data/5_nt_supermatrix.fasta -m MF+MERGE -T AUTO --threads-max 10 --prefix ../data/6_nt_gene+codon123 -Q ../data/5_nt_gene+codon123_partitions.txt
iqtree -s ../data/5_nt_supermatrix.fasta -m MF+MERGE -T AUTO --threads-max 10 --prefix ../data/6_nt_gene+codon12 -Q ../data/5_nt_gene+codon12_partitions.txt


### Build each cluster tree ###

### 'glue' each cluster to respective node on backbone tree ###


