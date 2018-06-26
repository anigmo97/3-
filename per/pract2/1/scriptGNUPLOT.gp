#!/usr/bin/gnuplot

set term jpeg
set title 'Resultados distribucion multinomial con suavizado Laplace'
set output 'Comparacion1.jpg'
set format x '%.0e'
set xlabel "epsilon"
set yrange [0:0.4]
set xrange [0:1]
set ylabel "% error"   
set ytics (0.25, 0.5, 1, 2, 5, 10, 20)  
set key off                                                   
plot 'matriz.dat' using 1:2 with linespoints 



