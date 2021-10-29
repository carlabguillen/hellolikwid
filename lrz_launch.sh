#!/bin/bash -l
#
## allocate 1 nodes with 20 physical cores, without hyperthreading

#SBATCH --job-name=hello
#SBATCH -o ./%x.%j.out
#SBATCH -e ./%x.%j.err
#SBATCH --mail-type=NONE
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=10
##SBATCH --ntasks=10
#SBATCH --time=00:20:00
#SBATCH --export=NONE
#SBATCH --get-user-env
#SBATCH --cluster=mpp3
#SBATCH --partition=mpp3_batch
#

module load slurm_setup
module load likwid/5.0.1-perf
module list
#likwid-topology
unset LIKWID_FORCE 
# run 
likwid-mpirun -np 10 -g CLOCK -m  ./hello.exe
