#include <stdio.h>
#include <mpi.h>
#include <unistd.h>
#include <stdlib.h>
#include <likwid.h>

#define HOSTNAME_MAXSIZE        (30)

int main (int argc, char **argv, char **envp){

        int     rank, size;
        char    hn[HOSTNAME_MAXSIZE];

        const int MATRIX_SIZE = 1000;

        float matrix[MATRIX_SIZE][MATRIX_SIZE];

        int i,j,k,m;

        LIKWID_MARKER_INIT;

        MPI_Init (&argc, &argv);        /* starts MPI */

        MPI_Comm_rank (MPI_COMM_WORLD, &rank);  /* get current process id */
        MPI_Comm_size (MPI_COMM_WORLD, &size);  /* get number of processes */
        gethostname(hn, HOSTNAME_MAXSIZE);
        fprintf( stdout, "[%s] Hello world from process %d of %d\n", hn, rank, size );
  
        LIKWID_MARKER_REGISTER("matmult");
        LIKWID_MARKER_REGISTER("printdone");

        LIKWID_MARKER_START("matmult");
        for(m=0; m< 10; ++m)
        for( i = 0; i < MATRIX_SIZE; i++) {
          for( j = 0; j < MATRIX_SIZE; j++) {
            for( k = 0; k < MATRIX_SIZE; k++) {
              matrix[i][j] += matrix[i][k] * matrix[k][j];
            }
          }
        }
        LIKWID_MARKER_STOP("matmult");
        LIKWID_MARKER_START("printdone");
        printf("Done!\n");
        LIKWID_MARKER_STOP("printdone");
        MPI_Finalize();   /* ends MPI */

        LIKWID_MARKER_CLOSE;
        return 0;
}

