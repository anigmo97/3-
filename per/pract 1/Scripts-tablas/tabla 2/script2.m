#!/usr/bin/octave -qf
load("trdata.mat.gz");   # Muestras de entrenamiento
load("tedata.mat.gz");   # Muestras de test
load("trlabels.mat.gz"); # Etiquetas clases muestras entrenamiento
load("telabels.mat.gz"); # Etiquetas clases muestras test 
KNN =1;

% knn(X,xl,Y,yl,KNN);
% X   -> Muestras de entrenamiento
% xl  -> Etiqueta clases muestras entrenamiento
% Y   -> Muestras de test
% yl  -> Etiqueta clases muestras test
% KNN -> Nº muestras de entrenamiento más cercanas en distancia Euclídea a considerar (Siempre 1)


[media_vectores,Matriz_PCA] = pca(X);
[Matriz_LDA]=lda(X,xl);
disp(rows(Matriz_LDA));

Resultados_PCA=[];
Resultados_LDA=[];
clases = unique(xl) % clases -> valores distintos de la ultima columna (clases)					
numClases = numel(clases) % numero de clases

k=1;
while (k <= numClases  )
    %% CALCULOS PCA
    printf("PCA");
    Matriz_PCA_Dimension_K = Matriz_PCA'(1:k,:);
    Muestras_Entrenamiento_Proyectadas_PCA = Matriz_PCA_Dimension_K * X;
    Muestras_Test_Proyectadas_PCA = Matriz_PCA_Dimension_K * Y;
    [Error_Reconstruccion_dimension_k_PCA] = knn(Muestras_Entrenamiento_Proyectadas_PCA,xl,Muestras_Test_Proyectadas_PCA,yl,KNN);   
    Resultados_PCA= [Resultados_PCA ; k ,Error_Reconstruccion_dimension_k_PCA];
    %% CALCULOS LDA
    printf("LDA");
    Matriz_LDA_Dimension_K = Matriz_LDA'(1:k,:);
    Muestras_Entrenamiento_Proyectadas_LDA = Matriz_LDA_Dimension_K * X;
    Muestras_Test_Proyectadas_LDA = Matriz_LDA_Dimension_K * Y;
    [Error_Reconstruccion_dimension_k_LDA] = knn(Muestras_Entrenamiento_Proyectadas_LDA,xl,Muestras_Test_Proyectadas_LDA,yl,KNN);   
    Resultados_LDA= [Resultados_LDA ; k ,Error_Reconstruccion_dimension_k_LDA];
    k+=1;
    printf("\n");
endwhile;
printf("\n\n");
disp(Resultados_PCA);

save_precision(5)
save "PCA2.dat" Resultados_PCA
save "LDA2.dat" Resultados_LDA