#!/bin/sh
#PBS -l nodes=1,walltime=00:05:00
#PBS -q cpa
#PBS -d .

OMP_NUM_THREADS=4 ./divi_par_bucle1
OMP_NUM_THREADS=4 ./divi_par_bucle2
