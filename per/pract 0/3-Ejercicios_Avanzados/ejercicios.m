#!/usr/bin/octave -qf
# load("videosTr.gz")
load("gauss2D")
verbose = true;
# se guarda con el nombre de data
printf("\n1.El módulo de cada vector de características.")
[fData ,cData]= size(data);
vectores_caracteristicas = data(:,1:columns(data)-1);
vec_al_cuadrado = vectores_caracteristicas.^2;
vec_suma = sum(vec_al_cuadrado,2);
modulo = sqrt(vec_suma);

### DEBUG
if(verbose)
printf("\nDatos introducidos = \n")
disp(data)
input ("", "s");
printf("\nVectores caracteristicas al cuadrado = \n")
disp(vec_al_cuadrado)
printf("\nVectores caracteristicas al cuadrado sumados = \n")
disp(vec_suma)
printf("\nModulo = \n")
disp(modulo)
input ("", "s");
end;
### FIN DEBUG


printf("\n2) El reordenamiento de los vectores de características por valor de su módulo de mayor a menor.")
modulo_ordenado = sort(modulo);
modulo_ordenado_mayor_a_menor = flip(modulo_ordenado);

### DEBUG
if(verbose)
printf("\nModulo Ordenado = \n")
disp(modulo_ordenado)
printf("\nModulo ordenado de mayor a menor = \n")
disp(modulo_ordenado_mayor_a_menor)
input ("", "s");
end;
### FIN DEBUG

printf("\n3)Los vectores de características de módulo unitario\n")
vector_caracteristicas_modulo_unitario =[];
i=1;
while(i<=fData)
vector_caracteristicas_modulo_unitario =[vector_caracteristicas_modulo_unitario; vectores_caracteristicas(i,:).*modulo(i)];
i++;
endwhile

### DEBUG
if(verbose)
printf("Vector caracteristicas * Modulo")
i=1;
while(i<=fData)
printf("%s",disp([vectores_caracteristicas(i,:),modulo(i)]))
i++;
endwhile;
input ("", "s");
printf("Vector caracteristicas modulo unitario")
disp(vector_caracteristicas_modulo_unitario)
input ("", "s");
end;

### FIN DEBUG


printf("\n4)La distancia Euclídea del primer vector de características al resto de vectores de características:")
vector_restado = vectores_caracteristicas - vectores_caracteristicas(1,:);
vector_restado_al_cuadrado = vector_restado.^2;
vec_suma = sum(vector_restado,2);
distancia_Euclidea = sqrt(vec_suma);

### DEBUG
if(verbose)
printf("\nTodos los vectores restandoles el primero = \n")
disp(vector_restado)
printf("\nTodos los vectores restandoles el primero al cuadrado = \n")
disp(vector_restado_al_cuadrado)
input ("", "s");
printf("Suma por fila")
disp(vec_suma)
printf("Distancia Euclidea Resultante\n")
disp(distancia_Euclidea)
end;
### FIN DEBUG


printf("\n5a).La media xc  de cada clase.")
# matriz de clases y medias de la forma clase comp1 comp2...
clases=unique(data(:,cData)); % clases -> valores distintos de la ultima columna (clases)					
numClases=numel(clases); % numClases => numero de valores distintos ( numero de clases )
numero_de_muestras_por_clase = zeros(numClases,2);
media_de_la_clase = [];
n = 1;
while (n <= numClases)
clase = clases(n);
indices_muestras_Clase_n = find(data(:,cData)==clase);
numero_de_muestras_por_clase(n,1) = clase;
numero_de_muestras_por_clase(n,2) = numel(indices_muestras_Clase_n);
muestras_de_la_clase = data(indices_muestras_Clase_n,1:cData-1);
suma_muestras_de_la_clase = sum(muestras_de_la_clase,1);
suma_muestras_dividido = suma_muestras_de_la_clase./(numero_de_muestras_por_clase(n,2));
### IMPORTANTE
### EN MEDIA_DE_LA_CLASE TENDREMOS   nomClase  numMuestras [vectorMediaMuestras ....
media_de_la_clase = [media_de_la_clase;clase numel(indices_muestras_Clase_n) suma_muestras_dividido];
n++;
endwhile;

### DEBUG
if(verbose)
input ("", "s");
printf("\Numero de Elementos = %s",disp(fData))
printf("\nNumero de clases Distintas = %s \n",disp(numClases))
clases
printf("\nClase   Elem \n")
disp(numero_de_muestras_por_clase)
input ("", "s");
printf("    Clase     Elementos    Media-Vectores\n")
disp(media_de_la_clase)
end;
### FIN DEBUG


printf("\n5b)Matriz de covarianzas Σc\n")
matriz_covarianza=[];
matriz_objetos_menos_media=[];
matriz_multiplicados = [];
mc_etiqueta=[];
n=1;
while (n <= numClases)
obs=[]
clase = clases(n);
indice_clase = find(media_de_la_clase(:,1)==clase);
num_muestras_clase = media_de_la_clase(indice_clase,2);
media_clase = media_de_la_clase(indice_clase,3:end);
indices_muestras_Clase_n = find(data(:,cData)==clase);
muestras_de_la_clase = data(indices_muestras_Clase_n,1:cData-1);
i=1;
while(i<=num_muestras_clase)
objeto = muestras_de_la_clase(i,:);
objeto_menos_media_clase = objeto - media_clase;
matriz_objetos_menos_media = [matriz_objetos_menos_media; clase objeto_menos_media_clase];
mult = objeto_menos_media_clase* objeto_menos_media_clase';
obs=[obs;mult];
matriz_multiplicados=[matriz_multiplicados;clase mult];
i++;
endwhile;
suma =sum(obs);
matriz_covarianza=[matriz_covarianza;suma/num_muestras_clase];
mc_etiqueta= [mc_etiqueta; clase suma/num_muestras_clase];
n++
endwhile;

### DEBUG
if(verbose)
input ("", "s");
printf("\Numero de Elementos = %s",disp(fData))
printf("\nNumero de clases Distintas = %s \n",disp(numClases))
clases
printf("\nClase   Elem \n")
disp(numero_de_muestras_por_clase)
input ("", "s");
printf("Matriz Objetos menos media de la clase\n")
printf("    Clase      Objeto - media clase\n")
disp(matriz_objetos_menos_media)
printf("Matriz Objetos multiplicados\n")
printf("    Clase   Multiplicacion\n")
disp(matriz_multiplicados)
input ("", "s");
printf("Matriz Covarianza\n")
disp(matriz_covarianza)
printf("Matriz Covarianza Etiquetada\n")
printf("   Clase   Covarianza\n")
disp(mc_etiqueta)
end;
### FIN DEBUG

printf("\n6. La normalización de los vectores de características utilizando media y desviación típica de su clase:");
vectores_normalizados=[]
desviacion_tipica = diag(matriz_covarianza)
i=1;
while(i<=fData)
vector_caracteristicas= data(i,1:end-1)
clase = data(i,end)
indice_vector_media_clase = find(media_de_la_clase(:,1)==clase)
media_clase = media_de_la_clase(indice_vector_media_clase,3:end)
resta= vector_caracteristicas - media_clase
division = resta / desviacion_tipica
vectores_normalizados=[vectores_normalizados; division]
i++;
end;
