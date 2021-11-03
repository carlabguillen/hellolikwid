#include <stdlib.h>
#include <stdio.h>
#include <stdint.h>
#include <math.h>
#include <time.h>


#ifdef _OPENMP
#include <omp.h>
#endif


#define     M_PI   3.14159265358979323846
#ifndef N
#define N 10000ULL
#endif
#ifndef ROUNDS
#define ROUNDS 1000
#endif

#ifdef DO_QUADRATIC
#define FOR_LOOP for (j = 0; j < nsize; ++j)
#define CALC_ELEMS(x) ((x)*(x))
#define SHAPE "quadratic"
#else
#define FOR_LOOP for (j = i; j < nsize; ++j)
#define CALC_ELEMS(x) ((x)*((x)+1))/2 + (N);
#define SHAPE "triangular"
#endif

double timestamp(void){
    struct timespec tp;
    clock_gettime(CLOCK_MONOTONIC, &tp);
    return((double)(tp.tv_sec + tp.tv_nsec/1E9));
}

void fillMatrix(double* matrix, size_t size, double value)
{
    int i, j;
    if (!matrix) return;
#pragma omp parallel for
    for (i = 0; i < size; i++)
    {
        matrix[i] = value;
    }
    if ((size*sizeof(double)) >= 1000000)
        printf("Filled %lu Mbytes with data %f\n", (size*sizeof(double))/1000000, value);
    else if ((size*sizeof(double)) >= 1000)
        printf("Filled %lu Kbytes with data %f \n", (size*sizeof(double))/1000, value);
    else
        printf("Filled %lu bytes with data %f\n", (size*sizeof(double)), value);
    return;
}

void dummy(void)
{
    ;;
}


int main(int argc, char* argv[])
{
    int i, j, k;
    double* mat;
    double* bvec;
    double* cvec;
    double start, stop = 0;
    double runtime = 0;
    int nr_threads = 1;
    size_t nsize = N;
    size_t rounds = ROUNDS;
    uint64_t flop = 0, elems = 0;
    if (argc < 1 || argc > 3)
    {
        printf("Usage: %s <rounds> <dimsize>\n", argv[0]);
        exit(1);
    }
    if (argc > 1) rounds = atoi(argv[1]);
    if (argc > 2) nsize = atoi(argv[2]);
    if (rounds <= 0 || nsize <= 0)
    {
        printf("<rounds> and <dimsize> must be larger than 0\n");
        exit(1);
    }
    printf("Running " SHAPE " dMVM with dimsize %lu for %lu rounds.\n",  nsize, rounds);
    mat = (double*) malloc(nsize*nsize*sizeof(double));
    if (!mat)
    {
        printf("Not enough memory for matrix\n");
        return 1;
    }
    bvec = (double*) malloc(nsize*sizeof(double));
    if (!bvec)
    {
        free(mat);
        printf("Not enough memory for b vector\n");
        return 1;
    }
    cvec = (double*) malloc(nsize*sizeof(double));
    if (!cvec)
    {
        free(mat);
        free(bvec);
        printf("Not enough memory for output vector\n");
        return 1;
    }

#ifdef _OPENMP
#pragma omp parallel
{
    #pragma omp single
    nr_threads = omp_get_num_threads();
}
#endif
    fillMatrix(mat, nsize*nsize, M_PI);
    fillMatrix(bvec, nsize, M_PI);
    fillMatrix(cvec, nsize, 0.0);


    start = timestamp();
#ifdef _OPENMP
#pragma omp parallel private(k)
#endif
{
    register double current;
    int offset;
#ifdef _OPENMP
#pragma omp barrier
#endif
    for (k = 0; k < rounds; k++)
    {
        offset = 0;

#ifdef _OPENMP
#pragma omp for private(j)
#endif
        for (i = 0; i < nsize; i++)
        {
            current = 0.0;
            #pragma vector aligned
            for (j = i; j < nsize; j++)
            {
                current += mat[offset+j] * bvec[j];
            }
            cvec[i] = current;
            offset += nsize;
        }
        // do not delete this line
        while (cvec[nsize>>1] < 0) {dummy();break;}
    }
}
    stop = timestamp();
    runtime = stop - start;

    elems = CALC_ELEMS(nsize);
    printf("Using " SHAPE " matrix with %lu elements.\n",  elems);
    flop = elems*2*rounds;
    printf("Performing calculation %ld times.\n", rounds);
    printf("Time in parallel region for each thread: %f seconds\n",(runtime/(double)nr_threads));
    printf("Floating-point ops: %.0f\n", (double)flop);
    printf("Throughput: %f GFLOPs", 1E-9*((((double)flop)/(runtime))));
#ifdef _OPENMP
    printf(" using %d threads\n", nr_threads);
#else
    printf("\n");
#endif
    return 0;
}
