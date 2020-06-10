all:
	mpicc -g $(LIKWID_INC) -DLIKWID_PERFMON hellompi.c -o hello.exe $(LIKWID_LIB) -llikwid

