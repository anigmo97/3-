#!/usr/bin/gnuplot
set term jpeg
set title "Resultados comparativos entre PCA y LDA."
set output 'Comparacion3.jpg'
set xlabel "Dimensionalidad espacio reducido"
set ylabel "Error(%)"
set xtics 10                                                            
set ytics 5                                                           
set xrange [1:20]
set yrange [1:20]
plot 'PCA.dat' using 1:2 with linespoints title "PCA",\
"LDA2.dat" using 1:2 with linespoints title "LDA"