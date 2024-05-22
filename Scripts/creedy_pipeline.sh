#!/bin/bash

############################
### make all directories ###
############################

# mkdir ...
# mkdir ...

#########################################
### combine all of the gb files ###
#########################################

cat ../data/Complete_MGs/* > ../data/combined.gb

##########################################
### extract genes and convert to fasta ###
##########################################

tjcreedyPL/biotools/extract_genes.py -g ../data/combined.gb -o ../data/1_nt_raw/ -k --genetypes CDS

####################
### translate.py ###
####################

nt_raw_dir="../data/1_nt_raw/"
aa_raw_dir="../data/2_aa_raw/"

for file in "$nt_raw_dir"*
do
    filename=$(basename "$file")

    tjcreedyPL/biotools/translate.py 5 < "$file" > "${aa_raw_dir}${filename}"
done

##########################
### SigClust Algorithm ###
##########################

./SigClust/SigClust -c 20 --fasta-output ../data/1_nt_raw/COX1.fasta > COX1_20.cluster
./SigClust/SigClust -c 20 --fasta-output ../data/1_nt_raw/ND1.fasta > ND1_20.cluster

#############
### Align ###
#############

mafft --globalpair --maxiterate 1000 --anysymbol --thread 10 "../data/2_aa_raw/COX1.fasta" > "../data/3_aa_aln/COX1.fasta"

#####################
### backtranslate ###
#####################

tjcreedyPL/biotools/backtranslate.py -i ../data/3_aa_aln/COX1.fasta ../data/1_nt_raw/COX1.fasta 5 > ../data/4_nt_aln/COX1.fasta