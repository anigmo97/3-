
#include <stdio.h>
#include <omp.h>
#define M_numerosTotales 100000
#define Num_Top 10

/*
 Macro para determinar si el número n, que tiene c divisores,
 tiene más divisores que el número almacenado en la posición p de los vectores.
 A igual número de divisores, se considera mejor si es un número más pequeño.
 ---
 Macro that returns TRUE if number n, which has c divisors, is "BETTER" (i.e. it has
 more divisors) than the number stored at position p of the vectors.
 If both have the same number of divisors, the smallest number is considered better
*/
#define MEJOR(num_n,numDivs_n,p) ( 
    numDivs_n > vc_top_numDivs[p] ||(numDivs_n == vc_top_numDivs[p] && num_n < vn[p]) )

int main()
{
  int numDivs_n,num_n,vc_top_numDivs[N],vn[N],i,ini,inc,k;

  /* Inicializar las cuentas máximas */
  for ( i = 0 ; i < Num_Top ; i++ ) {
    vc_top_numDivs[i] = 0; vn[i] = 0;
  }

  /* Bucle principal: contar divisores para los números desde 1 hasta M */
  for ( n = 1 ; n <= M_numerosTotales ; n++ ) {
            c = 1; /* por el 1, que siempre es divisor */
            if ( n % 2 == 0 ) {
            ini = 2; inc = 1;
            } else { /* no mirar pares, que seguro que no son divisores */
            ini = 3; inc = 2;
            }
            /* Contar divisores */
            for ( i = ini ; i <= n ; i += inc ) { if ( n % i == 0 ) c++;}
            /* Insertar en vector si es de los N con más divisores */
            if ( MEJOR(n,c,Num_Top-1) ) {
                //numero n con c divisores N-1 
                for ( i = Num_Top - 1 ; i > 0 && MEJOR(n,c,i-1) ; i-- ) {
                    vc_top_numDivs[i] = vc_top_numDivs[i-1]; vn[i] = vn[i-1];
                    }
                vc_top_numDivs[i] = c; vn[i] = n;
            }
  }

  /* Imprimir los N con más divisores */
  printf("Los %d enteros con más divisores hasta %d son:\n",Num_Top,M_numerosTotales);
  for ( k = 0 ; k < Num_Top ; k++ ) {
    printf(" %d, con %d divisores\n",vn[k],vc_top_numDivs[k]);
  }

  return 0;
}
