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

LIKWID_MARKERS=

## OpenMP:
echo "#######################################"
echo "# Instruction count"
echo "#######################################"
for T in 1 2 4 6 8; do
    echo -n "$T thread(s) |"
    likwid-mpirun -s 0x0 $(LIKWID_MARKERS) -np 1 -t $T -g CLOCK ./matrix 2>&1 | grep "INSTR_RETIRED_ANY" | grep -v STAT
done
echo "#######################################"
echo "# L1 <-> L2 data volume (in GByte)"
echo "#######################################"
for T in 1 2 4 6 8; do
    echo -n "$T thread(s) |"
    likwid-mpirun -s 0x0 $(LIKWID_MARKERS) -np 1 -t $T -g L2 ./matrix 2>&1 | grep "L2 data volume" | grep -v STAT
done
echo "#######################################"
echo "# DP FLOP rate"
echo "#######################################"
for T in 1 2 4 6 8; do
    echo -n "$T thread(s) |"
    likwid-mpirun -s 0x0 $(LIKWID_MARKERS) -np 1 -t $T -g FLOPS_AVX ./matrix 2>&1 | grep "Packed DP" | grep -v STAT
done
