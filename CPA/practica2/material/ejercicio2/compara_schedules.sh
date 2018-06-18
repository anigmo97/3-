#!/bin/sh
#PBS -l nodes=1,walltime=00:05:00
#PBS -q cpa
#PBS -d .

#printf("schedule 1 = static , schedule 2 = dynamic");
OMP_NUM_THREADS=8 ./bucle1_comparacion
OMP_NUM_THREADS=8 ./bucle2_comparacion
OMP_SCHEDULE="static,2" OMP_NUM_THREADS=8 ./bucle1_comparacion
OMP_SCHEDULE="static,2" OMP_NUM_THREADS=8 ./bucle2_comparacion
OMP_SCHEDULE="static,4" OMP_NUM_THREADS=8 ./bucle1_comparacion
OMP_SCHEDULE="static,4" OMP_NUM_THREADS=8 ./bucle2_comparacion
OMP_SCHEDULE="dynamic" OMP_NUM_THREADS=8 ./bucle1_comparacion
OMP_SCHEDULE="dynamic" OMP_NUM_THREADS=8 ./bucle2_comparacion
