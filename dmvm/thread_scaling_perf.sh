#!/bin/bash -l

for i in 2 4 6 8; do
    export OMP_NUM_THREADS=$i
    echo -n "$i "
    likwid-pin -C S0:1-$i ./matrix 2>&1 | grep "Throughput:" | awk '{print $2}'
done
