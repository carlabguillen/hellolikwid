#!/bin/bash -l
#
## allocate 1 nodes with 20 physical cores, without hyperthreading
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=10
##SBATCH --ntasks=10
#
## allocate nodes for 6 hours
#SBATCH --time=00:20:00
# job name 
#SBATCH --job-name=helloword
## do not export environment variables
#SBATCH --export=NONE
#SBATCH --partition=devel
#SBATCH --constraint=hwperf
#
## first non-empty non-comment line ends SBATCH options

## do not export environment variables
unset SLURM_EXPORT_ENV
# jobs always start in submit directory

#load required modules (compiler,...)
module load intel64

##export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK

module load likwid/5.0.1
module list
#likwid-topology
unset LIKWID_FORCE 
# run 
likwid-mpirun -np 10 -g CLOCK --mpiopts "--mpi=pmi2" -m  /home/hpc/k_m85q/m85q0067/helloworld_mpi/hello.exe
