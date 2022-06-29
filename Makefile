
omp:
	mpicc -g $(LIKWID_INC) hellompi.c -qopenmp -o helloomp.exe $(LIKWID_LIB)


mpi:
	mpicc -g $(LIKWID_INC) hellompi.c -o hellompi.exe $(LIKWID_LIB)


clean:
	rm -f hello*.exe hello.*.err hello.*.out


