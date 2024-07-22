#!/bin/bash

############################
### make all directories ###
############################

# mkdir ...
# mkdir ...

#########################################
### combine all of the gb files ###
#########################################

cat ../data/Complete_MGs/* > ../data/Other/combined.gb

##########################################
### extract genes and convert to fasta ###
##########################################

tjcreedyPL/biotools/extract_genes.py -g ../data/Other/combined.gb -o ../data/tree_building/1_nt_raw/ -k --genetypes CDS

####################
### translate.py ###
####################

nt_raw_dir="../data/tree_building/1_nt_raw/"
aa_raw_dir="../data/tree_building/2_aa_raw/"

for file in "$nt_raw_dir"*
do
    filename=$(basename "$file")

    tjcreedyPL/biotools/translate.py 5 < "$file" > "${aa_raw_dir}${filename}"
done

##########################
### SigClust Algorithm ###
##########################

./SigClust/SigClust -i 100 -c 50 -k 4 ../data/tree_building/1_nt_raw/COX1.fasta > ../data/Sig_Clusters/COX1_50_k4.csv
./SigClust/SigClust -i 100 -c 50 -k 5 ../data/tree_building/1_nt_raw/COX1.fasta > ../data/Sig_Clusters/COX1_50_k5.csv
./SigClust/SigClust -i 100 -c 50 -k 6 ../data/tree_building/1_nt_raw/COX1.fasta > ../data/Sig_Clusters/COX1_50_k6.csv
./SigClust/SigClust -i 100 -c 50 -k 7 ../data/tree_building/1_nt_raw/COX1.fasta > ../data/Sig_Clusters/COX1_50_k7.csv

./SigClust/SigClust -i 100 -c 50 -k 10 ../data/tree_building/1_nt_raw/COX1.fasta > ../data/Sig_Clusters/COX1_50_k10.csv
./SigClust/SigClust -i 100 -c 50 -k 15 ../data/tree_building/1_nt_raw/COX1.fasta > ../data/Sig_Clusters/COX1_50_k15.csv
./SigClust/SigClust -i 100 -c 50 -k 20 ../data/tree_building/1_nt_raw/COX1.fasta > ../data/Sig_Clusters/COX1_50_k20.csv
./SigClust/SigClust -i 100 -c 50 -k 25 ../data/tree_building/1_nt_raw/COX1.fasta > ../data/Sig_Clusters/COX1_50_k25.csv

./SigClust/SigClust -i 100 -c 200 -k 4 ../data/tree_building/1_nt_raw/COX1.fasta > ../data/Sig_Clusters/COX1_200_k4.csv
./SigClust/SigClust -i 100 -c 200 -k 5 ../data/tree_building/1_nt_raw/COX1.fasta > ../data/Sig_Clusters/COX1_200_k5.csv
./SigClust/SigClust -i 100 -c 200 -k 6 ../data/tree_building/1_nt_raw/COX1.fasta > ../data/Sig_Clusters/COX1_200_k6.csv
./SigClust/SigClust -i 100 -c 200 -k 7 ../data/tree_building/1_nt_raw/COX1.fasta > ../data/Sig_Clusters/COX1_200_k7.csv

./SigClust/SigClust -i 100 -c 200 -k 10 ../data/tree_building/1_nt_raw/COX1.fasta > ../data/Sig_Clusters/COX1_200_k10.csv
./SigClust/SigClust -i 100 -c 200 -k 15 ../data/tree_building/1_nt_raw/COX1.fasta > ../data/Sig_Clusters/COX1_200_k15.csv
./SigClust/SigClust -i 100 -c 200 -k 20 ../data/tree_building/1_nt_raw/COX1.fasta > ../data/Sig_Clusters/COX1_200_k20.csv
./SigClust/SigClust -i 100 -c 200 -k 25 ../data/tree_building/1_nt_raw/COX1.fasta > ../data/Sig_Clusters/COX1_200_k25.csv

./SigClust/SigClust -i 100 -c 500 -k 4 ../data/tree_building/1_nt_raw/COX1.fasta > ../data/Sig_Clusters/COX1_500_k4.csv
./SigClust/SigClust -i 100 -c 500 -k 5 ../data/tree_building/1_nt_raw/COX1.fasta > ../data/Sig_Clusters/COX1_500_k5.csv
./SigClust/SigClust -i 100 -c 500 -k 6 ../data/tree_building/1_nt_raw/COX1.fasta > ../data/Sig_Clusters/COX1_500_k6.csv
./SigClust/SigClust -i 100 -c 500 -k 7 ../data/tree_building/1_nt_raw/COX1.fasta > ../data/Sig_Clusters/COX1_500_k7.csv

./SigClust/SigClust -i 100 -c 500 -k 10 ../data/tree_building/1_nt_raw/COX1.fasta > ../data/Sig_Clusters/COX1_500_k10.csv
./SigClust/SigClust -i 100 -c 500 -k 15 ../data/tree_building/1_nt_raw/COX1.fasta > ../data/Sig_Clusters/COX1_500_k15.csv
./SigClust/SigClust -i 100 -c 500 -k 20 ../data/tree_building/1_nt_raw/COX1.fasta > ../data/Sig_Clusters/COX1_500_k20.csv
./SigClust/SigClust -i 100 -c 500 -k 25 ../data/tree_building/1_nt_raw/COX1.fasta > ../data/Sig_Clusters/COX1_500_k25.csv



./SigClust/SigClust -i 20 -c 100 ../data/tree_building/1_nt_raw/COX1.fasta > ../data/Sig_Clusters/COX1_100.csv

./SigClust/SigClust -i 20 -c 4 ../data/tree_building/1_nt_raw/ND1.fasta > ND1_4.cluster
./SigClust/SigClust -i 20 -c 129 ../data/tree_building/1_nt_raw/ND1.fasta > ND1_129.cluster

#############
### Align ###
#############

mafft --globalpair --maxiterate 500 --anysymbol --thread 14 "../data/tree_building/2_aa_raw/COX1.fasta" > "../data/tree_building/3_aa_aln/COX1.fasta"
mafft --globalpair --maxiterate 1000 --anysymbol --thread 10 "../data/tree_building/2_aa_raw/ND1.fasta" > "../data/tree_building/3_aa_aln/ND1.fasta"
mafft --globalpair --maxiterate 1000 --anysymbol --thread 10 "../data/tree_building/2_aa_raw/ATP6.fasta" > "../data/tree_building/3_aa_aln/ATP6.fasta"
mafft --globalpair --maxiterate 1000 --anysymbol --thread 10 "../data/tree_building/2_aa_raw/ATP8.fasta" > "../data/tree_building/3_aa_aln/ATP8.fasta"
mafft --globalpair --maxiterate 1000 --anysymbol --thread 10 "../data/tree_building/2_aa_raw/COX2.fasta" > "../data/tree_building/3_aa_aln/COX2.fasta"
mafft --globalpair --maxiterate 1000 --anysymbol --thread 10 "../data/tree_building/2_aa_raw/COX3.fasta" > "../data/tree_building/3_aa_aln/COX3.fasta"
mafft --globalpair --maxiterate 1000 --anysymbol --thread 10 "../datatree_building//2_aa_raw/CYTB.fasta" > "../data/tree_building/3_aa_aln/CYTB.fasta"
mafft --globalpair --maxiterate 1000 --anysymbol --thread 10 "../data/tree_building/2_aa_raw/ND2.fasta" > "../data/tree_building/3_aa_aln/ND2.fasta"
mafft --globalpair --maxiterate 1000 --anysymbol --thread 10 "../data/tree_building/2_aa_raw/ND3.fasta" > "../data/tree_building/3_aa_aln/ND3.fasta"
mafft --globalpair --maxiterate 1000 --anysymbol --thread 10 "../data/tree_building/2_aa_raw/ND4.fasta" > "../data/tree_building/3_aa_aln/ND4.fasta"
mafft --globalpair --maxiterate 1000 --anysymbol --thread 10 "../data/tree_building/2_aa_raw/ND4L.fasta" > "../data/tree_building/3_aa_aln/ND4L.fasta"
mafft --globalpair --maxiterate 1000 --anysymbol --thread 10 "../data/tree_building/2_aa_raw/ND5.fasta" > "../data/tree_building/3_aa_aln/ND5.fasta"
mafft --globalpair --maxiterate 1000 --anysymbol --thread 10 "../data/tree_building/2_aa_raw/ND6.fasta" > "../data/tree_building/3_aa_aln/ND6.fasta"

#####################
### backtranslate ###
#####################

tjcreedyPL/biotools/backtranslate.py -i ../data/tree_building/3_aa_aln/COX1.fasta ../data/tree_building/1_nt_raw/COX1.fasta 5 > ../data/tree_building/4_nt_aln/COX1.fasta
tjcreedyPL/biotools/backtranslate.py -i ../data/3_aa_aln/ND1.fasta ../data/1_nt_raw/ND1.fasta 5 > ../data/4_nt_aln/ND1.fasta
tjcreedyPL/biotools/backtranslate.py -i ../data/3_aa_aln/ATP6.fasta ../data/1_nt_raw/ATP6.fasta 5 > ../data/4_nt_aln/ATP6.fasta
tjcreedyPL/biotools/backtranslate.py -i ../data/3_aa_aln/ATP8.fasta ../data/1_nt_raw/ATP8.fasta 5 > ../data/4_nt_aln/ATP8.fasta
tjcreedyPL/biotools/backtranslate.py -i ../data/3_aa_aln/COX2.fasta ../data/1_nt_raw/COX2.fasta 5 > ../data/4_nt_aln/COX2.fasta
tjcreedyPL/biotools/backtranslate.py -i ../data/3_aa_aln/COX2.fasta ../data/1_nt_raw/COX3.fasta 5 > ../data/4_nt_aln/COX3.fasta
tjcreedyPL/biotools/backtranslate.py -i ../data/3_aa_aln/CYTB.fasta ../data/1_nt_raw/CYTB.fasta 5 > ../data/4_nt_aln/CYTB.fasta
tjcreedyPL/biotools/backtranslate.py -i ../data/3_aa_aln/ND2.fasta ../data/1_nt_raw/ND2.fasta 5 > ../data/4_nt_aln/ND2.fasta
tjcreedyPL/biotools/backtranslate.py -i ../data/3_aa_aln/ND3.fasta ../data/1_nt_raw/ND3.fasta 5 > ../data/4_nt_aln/ND3.fasta
tjcreedyPL/biotools/backtranslate.py -i ../data/3_aa_aln/ND4.fasta ../data/1_nt_raw/ND4.fasta 5 > ../data/4_nt_aln/ND4.fasta
tjcreedyPL/biotools/backtranslate.py -i ../data/3_aa_aln/ND4L.fasta ../data/1_nt_raw/ND4L.fasta 5 > ../data/4_nt_aln/ND4L.fasta
tjcreedyPL/biotools/backtranslate.py -i ../data/3_aa_aln/ND5.fasta ../data/1_nt_raw/ND5.fasta 5 > ../data/4_nt_aln/ND5.fasta
tjcreedyPL/biotools/backtranslate.py -i ../data/3_aa_aln/ND6.fasta ../data/1_nt_raw/ND6.fasta 5 > ../data/4_nt_aln/ND6.fasta
