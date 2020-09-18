#!/bin/bash
#SBATCH --mail-type BEGIN,END,FAIL
#SBATCH --cpus-per-task 10
#SBATCH --ntasks 1
#SBATCH --time 12:0:0
 
module purge;
module load bluebear
module load bear-apps/2019b
module load R/3.6.2-foss-2019b
R -f RWshortv2.R
