// Sean: aj, 1 ≤ j ≤ C, C vectores de pesos iniciales;
// (y1, c1), . . . ,(yN, cN), N muestras de aprendizaje;
// α ∈ R>0, “factor de aprendizaje”;
// b ∈ R, “margen” (para ajustar la convergencia).
do {
m = 0 // numero de muestras bien clasificadas ´
for (n = 1; n ≤ N; n++) {
i = cn;
g = ai t yn ; 
error=false
for (j = 1; j ≤ C; j++){
if (j 6= i){
    if (ajt yn + b > g) {
    aj = aj − α yn ;
    error=true;
    }
}
if (error) {
    ai = ai + α yn ;
} else{ 
    m = m + 1
}
}
}
} while (m < N)


// Sean: aj, 1 ≤ j ≤ C, C vectores de pesos iniciales;
// (y1, c1), . . . ,(yN, cN), 
// N muestras de aprendizaje;
// α ∈ R>0, “factor de aprendizaje”;
// b ∈ R, “margen” (para ajustar la convergencia).
do {
    m = 0 // número de muestras bien clasificadas ´
    for (n = 1; n ≤ N; n++) {
        i = cn;
        g = ait yn ; 
        error=false;
        for (j = 1; j ≤ C; j++){
            if (j != i){
                if (ajt yn + b > g) {
                    aj = aj − α yn ;
                    error=true;
                }
            }
        }
        if (error) {ai = ai + α yn ;} 
        else{ m = m + 1;}
    }
} while (m < N)
    