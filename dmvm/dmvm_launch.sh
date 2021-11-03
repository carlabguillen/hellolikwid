#!/bin/bash -l
# 
#SBATCH --reservation=hcow1w21
#SBATCH --job-name=dmvm
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

## OpenMP:
echo "Instruction count"
for T in {2..$SLURM_CPUS_PER_TASK..2}; do
    export OMP_NUM_THREADS=$T
    likwid-mpirun -np 1 -t $T -g CLOCK ./matrix 2>&1 | grep "INST_RETIRED_ANY" | grep -v STAT
done
echo "L1 <-> L2 data volume (in GByte)"
for T in {2..$SLURM_CPUS_PER_TASK..2}; do
    export OMP_NUM_THREADS=$T
    likwid-mpirun -np 1 -t $T -g L2 ./matrix 2>&1 | grep "L2 data volume" | grep -v STAT
done
echo "L1 <-> L2 data volume (in GByte)"
for T in {2..$SLURM_CPUS_PER_TASK..2}; do
    export OMP_NUM_THREADS=$T
    likwid-mpirun -np 1 -t $T -g FLOPS_AVX ./matrix 2>&1 | grep "Packed DP" | grep -v STAT
done
