#!/bin/bash -l

for i in 2 4 6 8; do
    export OMP_NUM_THREADS=$i
    likwid-perfctr -C S0:1-$i -g CLOCK ./matrix 2>&1 | grep "INSTR_RETIRED_ANY" | grep -v STAT
done
