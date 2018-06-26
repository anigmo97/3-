#!/usr/bin/octave -qf

if (nargin!=1)
printf("Usage: multinomial.m <data_filename>");
exit(1);
end

arglist=argv(); # lista de argumentos
datafile=arglist{1}; # el argumento 1 se guarda en datafile
disp("Loading data...");
load(datafile); # se carga la matriz "data"
disp("Data load complete.");

[nrows,ncols]=size(data); # obtenemos el numero de columnas y de filas
rand("seed",23); 
perm = randperm(nrows); # Obtenemos un vector aleatorio de indices de data
pdata=data(perm,:);     # tomamos perm filas y todas sus columnas de data
trper=0.9;              # fijamos el porcentaje de muestras de entrenaiento
ntr=floor(nrows*trper); # retorna el mayor entero no > nrows * trper (calculamos el numero de muestras de entrenamiento)
nte=nrows-ntr;          # nº de muestras - nº muestras entrenamiento = nº muestras de test
tr=pdata(1:ntr,:);      # tomamos las muestras de entrenamiento
te=pdata(ntr+1:nrows,:); # tomamos las muestras de test


## CALCULO DE LAS PROBABILIDADES A PRIORI DE LAS CLASES

clases = unique(tr(:,end)); % clases -> valores distintos de la ultima columna (clases)					
numClases = numel(clases); % numero de clases
probabilidades_clases=[]; 
prototipos_clases =[];
n=1;
while (n <= numClases)
    indices_muestras_Clase_n=find(tr(:,end)==clases(n)); % Obtengo los indices de filas de la clase
    probabilidades_clases= [probabilidades_clases ; (numel(indices_muestras_Clase_n)/ntr) clases(n)];
    muestras_de_la_clase = data(indices_muestras_Clase_n,1:end-1);
    suma_columnas = sum(muestras_de_la_clase,1);
    suma_componentes = sum(suma_columnas,2)
    prototipos_clases =[prototipos_clases ; (suma_columnas./suma_componentes) clases(n)];
    n++;
endwhile;

printf("Probabilidad  Clase\n");
disp(probabilidades_clases)

#  Probabilidad  Clase
#    0.34152   0.00000
#    0.65848   1.00000


input ("", "s")
## ESTIMACION DE LOS PROTOTIPOS MULTINOMIALES DE CADA CLASE
#printf("Prototipo  Clase\n")
#disp(prototipos_clases);
[nrows,ncol] = size(prototipos_clases);
printf("     PROTOTIPO\n      Num filas:")
disp(nrows) 
printf("     Num columnas");
disp(ncol)
input ("", "s")
## Clasificador multinomial
n=1;
valores_clasificador_clase_n= [];
while (n <= numClases)
    # Calculo W_clase
    indice_prototipo_clase_n = find(prototipos_clases(:,end)==clases(n)); ## averiguo cual es el prototipo de la clase
    prototipo_clase_n = prototipos_clases(indice_prototipo_clase_n,1:end-1); ## obtengo el prototipo sin la etiqueta
    W_Clase = log(prototipo_clase_n);
    #Calculo W_clase_inicial
    indice_probabilidad_clase_n =find(probabilidades_clases(:,end)==clases(n));
    probabilidad_clase= probabilidades_clases(indice_probabilidad_clase_n,1); 
    W_Clase_Inicial= log(probabilidad_clase);
    valores_clasificador_clase_n =[valores_clasificador_clase_n ; (W_Clase*te(:,1:end-1)'+W_Clase_Inicial) clases(n) ];
    # conjunto test fila
    # prototipo filas
    n++;
endwhile;
printf("Valores Clasificador \n");
[nrows,ncol] = size(valores_clasificador_clase_n);
printf("     Valores clasificadores\n      Num filas:")
disp(nrows) 
printf("     Num columnas");
disp(ncol)
input ("", "s")
printf("Primeros 10 valores: ")
disp(valores_clasificador_clase_n(:,10));

#Hay 37.822 correos
# 10% test = 3784 correos

## Calculo de los errores SIN SUAVIZAR
# clases_asignadas = max(valores_clasificador_clase_n)
clases_correctas = te(:,end)
#disp(clases_correctas)
[max_val, idx] = max(valores_clasificador_clase_n(:,1:end-1), [], 1);
[nrows,ncol] = size(idx);
idx = idx.-1;
printf("     \n\nValores clasificadores\n      Num filas:")
disp(nrows) 
printf("     Num columnas");
disp(ncol)
[nrows,ncol] = size(clases_correctas);
printf("     \n\nEtiquetas clases\n      Num filas:")
disp(nrows) 
printf("     Num columnas");
disp(ncol)

vector_fallos = idx != clases_correctas';
[nrows,ncol] = size(vector_fallos);
printf("     \n\nDimensiones vector fallos\n      Num filas:")
disp(nrows) 
printf("     Num columnas");
disp(ncol)
num_fallos = sum(vector_fallos);

datos = rows(te);
porcentaje_fallos = (num_fallos / datos)*100;
printf("\n\nNum datos : ")
disp(datos)
printf(" NumErrores ")
disp(num_fallos )
printf(" % Error ")
disp(porcentaje_fallos )

## FIN Calculo de los errores SIN SUAVIZAR
epsilon=0.1
n=1;
while (n <= numClases)
    # Calculo W_clase
    valores_clase_n = valores_clasificador_clase_n(n,1:end-1).+epsilon
    suma = sum(valores_clase_n)
    valores_clasificador_clase_n(n,1:end-1)./suma
    n++;
endwhile;

clases_correctas = te(:,end)
#disp(clases_correctas)
[max_val, idx] = max(valores_clasificador_clase_n(:,1:end-1), [], 1);
[nrows,ncol] = size(idx);
idx = idx.-1;
printf("     \n\nValores clasificadores\n      Num filas:")
disp(nrows) 
printf("     Num columnas");
disp(ncol)
[nrows,ncol] = size(clases_correctas);
printf("     \n\nEtiquetas clases\n      Num filas:")
disp(nrows) 
printf("     Num columnas");
disp(ncol)

printf("\n\n\n\n SUAVIZADO")
vector_fallos = idx != clases_correctas';
[nrows,ncol] = size(vector_fallos);
printf("     \n\nDimensiones vector fallos\n      Num filas:")
disp(nrows) 
printf("     Num columnas");
disp(ncol)
num_fallos = sum(vector_fallos);

datos = rows(te);
porcentaje_fallos = (num_fallos / datos)*100;
printf("\n\nNum datos : ")
disp(datos)
printf(" NumErrores ")
disp(num_fallos )
printf(" % Error ")
disp(porcentaje_fallos )


# Suavizado

n=1;
alfa = 0.1;
nuevos_protos =[];
while (n <= 3)
    # Calculo W_clase
    indice_prototipo_clase_n = find(prototipos_clases(:,end)==clases(n)); ## averiguo cual es el prototipo de la clase
    prototipo_clase_n = prototipos_clases(indice_prototipo_clase_n,1:end-1); ## obtengo el prototipo sin la etiqueta
    suma = sum(prototipo_clase_n);
    prototipo_clase_n(n,1:end-1)./suma;
    nuevos_protos= [nuevos_protos ; prototipo_clase_n clases(n)];
    W_Clase = log(prototipo_clase_n);
    #Calculo W_clase_inicial
    indice_probabilidad_clase_n =find(probabilidades_clases(:,end)==clases(n));
    probabilidad_clase= probabilidades_clases(indice_probabilidad_clase_n,1); 
    W_Clase_Inicial= log(probabilidad_clase);
    valores_clasificador_clase_n =[valores_clasificador_clase_n ; (W_Clase*te(:,1:end-1)'+W_Clase_Inicial) clases(n) ];
    # conjunto test fila
    # prototipo filas
    n++;
endwhile;



[max_val, idx] = max(valores_clasificador_clase_n(:,1:end-1), [], 1);
[nrows,ncol] = size(idx);
idx = idx.-1;
printf("     \n\nValores clasificadores\n      Num filas:")
disp(nrows) 
printf("     Num columnas");
disp(ncol)
[nrows,ncol] = size(clases_correctas);
printf("     \n\nEtiquetas clases\n      Num filas:")
disp(nrows) 
printf("     Num columnas");
disp(ncol)

vector_fallos = idx != clases_correctas';
[nrows,ncol] = size(vector_fallos);
printf("     \n\nDimensiones vector fallos\n      Num filas:")
disp(nrows) 
printf("     Num columnas");
disp(ncol)
num_fallos = sum(vector_fallos);

datos = rows(te);
porcentaje_fallos = (num_fallos / datos)*100;
printf("\n\nNum datos : ")
disp(datos)
printf(" NumErrores ")
disp(num_fallos )
printf(" % Error ")
disp(porcentaje_fallos )
