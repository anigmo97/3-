set term jpeg
set term jpeg
set title "Comparacion paralelizaciones Bucle 1 "
set output 'b1c.jpg'
set xlabel "nº Hilos"
set ylabel "Tº (segs)"
set xtics 2                                                            
set ytics 5                                                           
set xrange [0:33]
set yrange [0:50]
plot 'b1-dynamic.dat' using 1:2 with linespoints title "bucle 1 (dynamic)",\
"b1-static.dat" using 1:2 with linespoints title "bucle 1 (static,0)",\
"b1-static1.dat" using 1:2 with linespoints title "bucle 1 (static,1)"

