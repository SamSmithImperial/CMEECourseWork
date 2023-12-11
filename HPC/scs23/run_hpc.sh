##!/bin/bash

#PBS -l walltime=12:00:00
#PBS -l select=1:ncpus=1:mem=1gb

module load anaconda3/personal

cp $HOME/run_files/scs23_HPC_2023_main.R $TMPDIR

echo "R is about to run"

R --vanilla <$HOME/run_files/scs23_HPC_2022_neutral_cluster.R

mv HPC_CLUSTER_* $HOME/output_files/

echo "R has finished running" 