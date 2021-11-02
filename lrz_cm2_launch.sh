#!/bin/bash -l
# 

#SBATCH --job-name=hello
#SBATCH -o ./%x.%j.out
#SBATCH -e ./%x.%j.err
#SBATCH --mail-type=NONE
#SBATCH --nodes=1-1
## MPI only:
#SBATCH --ntasks-per-node=10
## OpenMP:
##SBATCH --cpus-per-task=10
#SBATCH --time=00:20:00
#SBATCH --export=NONE
#SBATCH --get-user-env
#SBATCH --cluster=cm2_tiny
#SBATCH --partition=cm2_tiny
#

module load slurm_setup
module load likwid/5.2.0-gcc8
module list

unset LIKWID_FORCE 
# run hello exec: 
## MPI only:
likwid-mpirun -np 10 -g CLOCK -m  ./hellompi.exe

## OpenMP:
#export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK
#likwid-mpirun -np 1 -omp intel -t $SLURM_CPUS_PER_TASK -g CLOCK -m  ./helloomp.exe
