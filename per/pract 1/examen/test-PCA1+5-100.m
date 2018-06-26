#!/usr/bin/octave -qf
if (nargin!=7)
printf("Usage: test_PCA.m <trdata> <trlabels> <tedata> <telabels> <mink> <stepk> <maxk>\n");
exit(1);
end
arg_list=argv();
mink=str2num(arg_list{5});
stepk=str2num(arg_list{6});
maxk=str2num(arg_list{7});
load(arg_list{1});   # Muestras de entrenamiento
load(arg_list{2});   # Muestras de test
load(arg_list{3}); # Etiquetas clases muestras entrenamiento
load(arg_list{4}); # Etiquetas clases muestras test
KNN =1;

[Error_Datos_Originales] = knn(X,xl,Y,yl,KNN);
printf("Error Datos originales = ")
disp(Error_Datos_Originales);
% X   -> Muestras de entrenamiento
% xl  -> Etiqueta clases muestras entrenamiento
% Y   -> Muestras de test
% yl  -> Etiqueta clases muestras test
% KNN -> Nº muestras de entrenamiento más cercanas en distancia Euclídea a considerar (Siempre 1)

[media_vectores,Matriz_PCA] = pca(X);
Resultados_PCA=[];
Resultados_Originales=[];
k=mink;
while (k <= maxk)
    Matriz_PCA_Dimension_K = Matriz_PCA'(1:k,:);
    Muestras_Entrenamiento_Proyectadas = Matriz_PCA_Dimension_K * (X-media_vectores);
    Muestras_Test_Proyectadas = Matriz_PCA_Dimension_K * (Y-media_vectores);
    [Error_Reconstruccion_dimension_k] = knn(Muestras_Entrenamiento_Proyectadas,xl,Muestras_Test_Proyectadas,yl,KNN);   
    printf("Error %s dimensiones = ",disp(k));
    disp(Error_Reconstruccion_dimension_k);
    Resultados_PCA= [Resultados_PCA ; k ,Error_Reconstruccion_dimension_k];
    Resultados_Originales= [Resultados_Originales ; k ,Error_Datos_Originales];
    k+=stepk;
endwhile;
printf("\n\n");
disp(Resultados_PCA);

save_precision(5)
save "test-PCA.dat" Resultados_PCA
save "test-DatosOriginales.dat" Resultados_Originales