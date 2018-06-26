#!/usr/bin/octave -qf
if (nargin!=7)
printf("Usage: ldaexp.m <trdata> <trlabels> <tedata> <telabels> <mink> <stepk> <maxk>\n");
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

[Matriz_LDA]=lda(X,xl);
disp(rows(Matriz_LDA));
Resultados_LDA=[];
clases = unique(xl) % clases -> valores distintos de la ultima columna (clases)					
numClases = numel(clases) % numero de clases

k=mink;
while (k <= numClases-1 )
    %% CALCULOS LDA
    printf("LDA");
    Matriz_LDA_Dimension_K = Matriz_LDA'(1:k,:);
    Muestras_Entrenamiento_Proyectadas_LDA = Matriz_LDA_Dimension_K * X;
    Muestras_Test_Proyectadas_LDA = Matriz_LDA_Dimension_K * Y;
    [Error_Reconstruccion_dimension_k_LDA] = knn(Muestras_Entrenamiento_Proyectadas_LDA,xl,Muestras_Test_Proyectadas_LDA,yl,KNN);   
    Resultados_LDA= [Resultados_LDA ; k ,Error_Reconstruccion_dimension_k_LDA];
    k+=stepk;
    printf("\n");
endwhile;
printf("\n\n");

save_precision(4)
save "test-LDA.dat" Resultados_LDA