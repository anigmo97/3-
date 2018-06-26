#!/usr/bin/gnuplot
set term jpeg
set title "Resultados comparativos entre PCA y LDA."
set output 'Comparacion2.jpg'
set xlabel "Dimensionalidad espacio reducido"
set ylabel "Error(%)"
set xtics 1                                                            
set ytics 10                                                           
set xrange [1:9]
set yrange [10:70]
plot 'PCA2.dat' using 1:2 with linespoints title "PCA",\
"LDA2.dat" using 1:2 with linespoints title "LDA"