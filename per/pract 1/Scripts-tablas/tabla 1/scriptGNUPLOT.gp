#!/usr/bin/gnuplot
set term jpeg
set title "Resultados comparativos entre PCA y espacio original."
set output 'Comparacion1.jpg'
set xlabel "Dimensionalidad espacio PCA"
set ylabel "Error(%)"
set xtics 10                                                            
set ytics 1                                                           
set xrange [10:100]
set yrange [4:11]
plot 'PCA.dat' using 1:2 with linespoints title "PCA",\
"DatosOriginales.dat" using 1:2 with linespoints title "DatosOriginales"