#!/usr/bin/octave -qf
if (nargin!=7)
printf("Usage: pcaexp.m <trdata> <trlabels> <tedata> <telabels> <mink> <stepk> <maxk>\n");
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
% X   -> Muestras de entrenamiento
% xl  -> Etiqueta clases muestras entrenamiento
% Y   -> Muestras de test
% yl  -> Etiqueta clases muestras test
% KNN -> Nº muestras de entrenamiento más cercanas en distancia Euclídea a considerar (Siempre 1)

[media_vectores,Matriz_PCA] = pca(X);

Resultados_PCA=[];
Resultados_LDA=[];
clases = unique(xl) % clases -> valores distintos de la ultima columna (clases)					
numClases = numel(clases) % numero de clases
k=mink;
while (k <= maxk)
    Matriz_PCA_Dimension_K = Matriz_PCA'(1:k,:);
    Muestras_Entrenamiento_Proyectadas = Matriz_PCA_Dimension_K * (X-media_vectores);
    Muestras_Test_Proyectadas = Matriz_PCA_Dimension_K * (Y-media_vectores);
    % LDA
    [Matriz_LDA]=lda(Muestras_Entrenamiento_Proyectadas,xl);
    kk=1;
    while(kk<=min(numClases-1,k))
    Matriz_LDA_Dimension_K = Matriz_LDA'(1:kk,:);
    Muestras_Entrenamiento_Proyectadas_LDA = Matriz_LDA_Dimension_K * Muestras_Entrenamiento_Proyectadas;
    Muestras_Test_Proyectadas_LDA = Matriz_LDA_Dimension_K * Muestras_Test_Proyectadas;
    [Error_Reconstruccion_dimension_k_LDA] = knn(Muestras_Entrenamiento_Proyectadas_LDA,xl,Muestras_Test_Proyectadas_LDA,yl,KNN);   
    Resultados_LDA= [Resultados_LDA ; k,kk ,Error_Reconstruccion_dimension_k_LDA];
    kk+=10
    endwhile
    k+=stepk;
endwhile;
printf("\n\n");
disp(Resultados_LDA)
Resultados_PCA_LDA= Resultados_LDA;

save_precision(5)
save "PCA+LDA.dat" Resultados_PCA_LDA
#save "DatosOriginales.dat" Resultados_Originales