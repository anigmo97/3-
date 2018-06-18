#!/bin/sh
#PBS -l nodes=1,walltime=00:05:00
#PBS -q cpa
#PBS -d .

#printf("schedule 1 = static , schedule 2 = dynamic");
OMP_NUM_THREADS=8 ./divi_par_bucle1
OMP_NUM_THREADS=8 ./divi_par_bucle2
