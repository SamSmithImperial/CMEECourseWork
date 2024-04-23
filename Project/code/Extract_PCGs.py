import os
import pandas as pd
from Bio import pairwise2
from Bio.Align import PairwiseAligner
from Bio.Seq import Seq

####################################################
### Extract Sequences and PCG from Genbank Files ###
####################################################

def create_dataframe(directory):
    """Create a DataFrame containing file names, DNA sequences, and sequences of protein coding regions of GenBank files in the specified directory. 
    Takes a directory argument with path to GenBank files. 
    Returns pandas DataFrame containing File name, DNA sequences, and sequences of protein coding regions."""
    
    files_list = os.listdir(directory)
    unique_genes = set()

    # Extract unique gene names from all GenBank files
    for file in files_list:
        file_path = os.path.join(directory, file)
        gb_record = SeqIO.read(file_path, "genbank")
        for feature in gb_record.features:
            if feature.type == "CDS" and 'gene' in feature.qualifiers:
                unique_genes.update(feature.qualifiers['gene'])

    # Initialize DataFrame with columns for File name, DNA sequence, and unique genes
    columns = ['FileName', 'Sequence'] + list(unique_genes)
    df = pd.DataFrame(columns=columns)

    # Iterate through GenBank files and fill DataFrame
    rows = []
    for file in files_list:
        file_path = os.path.join(directory, file)
        gb_record = SeqIO.read(file_path, "genbank")
        Sequence = str(gb_record.seq)
        gene_sequences = {gene: 'NA' for gene in unique_genes}  # Initialize all gene sequences to 'NA'

        for feature in gb_record.features:
            if feature.type == "CDS" and 'gene' in feature.qualifiers:
                gene_name = feature.qualifiers['gene'][0]
                cds_sequence = str(feature.extract(gb_record.seq))
                gene_sequences[gene_name] = cds_sequence

        row_data = {'FileName': file, 'Sequence': Sequence, **gene_sequences}
        rows.append(row_data)

    df = pd.concat([df, pd.DataFrame(rows)], ignore_index=True)

    return df

directory = '../data/StaphyMGs' # Directory containing sequences
df = create_dataframe(directory)
df.to_csv("../data/sequences.csv", index=False) 

