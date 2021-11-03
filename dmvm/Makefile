# Set CFLAGS for building, which compiler is used, is determined automatically
CFLAGS_GCC=-O3 -fopenmp -ffast-math -std=c99 -ftree-vectorize -mavx
#CFLAGS_GCC=-O0
CFLAGS_ICC=-O3 -qopenmp -xHost
# Tune compilation with defines.
# Possible defines:
# * -DDO_QUADRATIC   Run loop over the whole quadratic matrix instead of only
#                    the upper triangular part
DEFINES=

# Number of elements in a matrix row (max 40000)
ROWSIZE=30000

# Number of calculation rounds
ROUNDS=100



###############################################################################
# No need to edit below variables and targets
CC=gcc
TEST_ICC=$(shell which icc 2>/dev/null)
ifneq ($(TEST_ICC),)
	CC=icc
endif
CFLAGS=
ifeq ($(CC),gcc)
	CFLAGS += $(CFLAGS_GCC)
endif
ifeq ($(CC),icc)
	CFLAGS += $(CFLAGS_ICC)
endif

DEFINES += -DN=$(ROWSIZE) -DROUNDS=$(ROUNDS)

all: matrix

ifndef LIKWID_DEFINES
LIKWID_DEFINES = -DLIKWID_PERFMON
endif
ifndef LIKWID_LIB
LIKWID_LIB = -L$(shell dirname $(shell which likwid-perfctr))/../lib -llikwid -lm
endif
ifndef LIKWID_INCLUDE
LIKWID_INCLUDE = -I$(shell dirname $(shell which likwid-perfctr))/../include
endif
DEFINES += $(LIKWID_DEFINES)

ifeq ($(LIKWID_LIB),)
matrix:
	$(CC) $(DEFINES) $(CFLAGS)  matrix.c -o matrix
else
matrix:
	$(CC) $(DEFINES) $(CFLAGS) $(LIKWID_LIB) $(LIKWID_INC)  matrix.c -o matrix -llikwid
endif


clean:
	rm -f matrix

.PHONY: matrix
