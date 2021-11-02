#!/bin/bash -l
# 

#SBATCH --job-name=hello
#SBATCH -o ./%x.%j.out
#SBATCH -e ./%x.%j.err
#SBATCH --mail-type=NONE
#SBATCH --nodes=1-1
#SBATCH --ntasks-per-node=10
##SBATCH --ntasks=10
#SBATCH --time=00:20:00
#SBATCH --export=NONE
#SBATCH --get-user-env
#SBATCH --cluster=cm2_tiny
#SBATCH --partition=cm2_tiny
#

module load slurm_setup
module load likwid/5.2.0-gcc8
module list
#likwid-topology
unset LIKWID_FORCE 
#export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK
# run 
#likwid-mpirun -np 1 -g CLOCK -m  ./hello.exe
likwid-mpirun -np 10 -g CLOCK -m  ./hello.exe
