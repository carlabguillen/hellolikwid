
omp:
	mpicc -g $(LIKWID_INC) -DLIKWID_PERFMON hellompi.c -qopenmp -o helloomp.exe $(LIKWID_LIB) -llikwid


mpi:
	mpicc -g $(LIKWID_INC) -DLIKWID_PERFMON hellompi.c -o hellompi.exe $(LIKWID_LIB) -llikwid


clean:
	rm -f hello*.exe hello.*.err hello.*.out


