#!/usr/bin/octave -qf
load("trdata.mat.gz");   # Muestras de entrenamiento
load("tedata.mat.gz");   # Muestras de test
load("trlabels.mat.gz"); # Etiquetas clases muestras entrenamiento
load("telabels.mat.gz"); # Etiquetas clases muestras test 
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
k=1;
while (k <= 40)
    Matriz_PCA_Dimension_K = Matriz_PCA'(1:k,:);
    Muestras_Entrenamiento_Proyectadas = Matriz_PCA_Dimension_K * X;
    Muestras_Test_Proyectadas = Matriz_PCA_Dimension_K * Y;
    [Error_Reconstruccion_dimension_k] = knn(Muestras_Entrenamiento_Proyectadas,xl,Muestras_Test_Proyectadas,yl,KNN);   
    printf("Error %s dimensiones = ",disp(k));
    disp(Error_Reconstruccion_dimension_k);
    Resultados_PCA= [Resultados_PCA ; k ,Error_Reconstruccion_dimension_k];
    Resultados_Originales= [Resultados_Originales ; k ,Error_Datos_Originales];
    k+=1;
endwhile;
printf("\n\n");
disp(Resultados_PCA);

save_precision(5)
save "PCA.dat" Resultados_PCA
save "DatosOriginales.dat" Resultados_Originales