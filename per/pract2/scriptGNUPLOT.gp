#!/usr/bin/gnuplot

set term jpeg
set title 'Resultados distribucion multinomial con suavizado Laplace'
set output 'Comparacion1.jpg'
set format x '%.0e'
set xlabel "epsilon"
set yrange [0.25:25]
set xrange [1e-21:1]
set ylabel "% error"   
set ytics (0.25, 0.5, 1, 2, 5, 10, 20) 
set logscale x
set logscale y  
set key off                                                   
plot 'matriz_gnuplot.dat' using 1:2 with linespoints ,'' using 1:2:3 with yerrorbars



