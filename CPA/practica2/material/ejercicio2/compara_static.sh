#!/bin/sh
#PBS -l nodes=1,walltime=00:05:00
#PBS -q cpa
#PBS -d .


OMP_SCHEDULE="static"OMP_NUM_THREADS=2 ./bucle1_comparacion
OMP_SCHEDULE="static"OMP_NUM_THREADS=2 ./bucle2_comparacion
OMP_SCHEDULE="static" OMP_NUM_THREADS=4 ./bucle1_comparacion
OMP_SCHEDULE="static" OMP_NUM_THREADS=4 ./bucle2_comparacion
OMP_SCHEDULE="static" OMP_NUM_THREADS=8 ./bucle1_comparacion
OMP_SCHEDULE="static" OMP_NUM_THREADS=8 ./bucle2_comparacion
OMP_SCHEDULE="static" OMP_NUM_THREADS=16 ./bucle1_comparacion
OMP_SCHEDULE="static" OMP_NUM_THREADS=16 ./bucle2_comparacion