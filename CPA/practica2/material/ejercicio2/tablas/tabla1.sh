#!/bin/sh
#PBS -l nodes=1,walltime=00:05:00
#PBS -q cpa
#PBS -d .

OMP_NUM_THREADS=1 ./bucle1_tabla
OMP_NUM_THREADS=2 ./bucle1_tabla
OMP_NUM_THREADS=3 ./bucle1_tabla
OMP_NUM_THREADS=4 ./bucle1_tabla
OMP_NUM_THREADS=5 ./bucle1_tabla
OMP_NUM_THREADS=6 ./bucle1_tabla
OMP_NUM_THREADS=7 ./bucle1_tabla
OMP_NUM_THREADS=8 ./bucle1_tabla
OMP_NUM_THREADS=9 ./bucle1_tabla
OMP_NUM_THREADS=10 ./bucle1_tabla
OMP_NUM_THREADS=15 ./bucle1_tabla
OMP_NUM_THREADS=20 ./bucle1_tabla
OMP_NUM_THREADS=30 ./bucle1_tabla
