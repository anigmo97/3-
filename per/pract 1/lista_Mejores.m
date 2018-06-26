#!/usr/bin/octave -qf
if (nargin<1)
printf("Usage: lista_Mejores.m <datos_PCA> <datos_LDA> <datos_PCA+LDA>\n");
exit(1);
end
arg_list=argv();
load(arg_list{1});   # Resultados_PCA
load(arg_list{2});   # Resutados_LDA
load(arg_list{3}); # Resultados_PCA_LDA

col2_PCA = Resultados_PCA(:,2);
[valor,ind_PCA]=min(col2_PCA);
Resultados_PCA(ind_PCA,:)
col2_LDA = Resultados_LDA(:,2);
[v2,ind_LDA]=min(col2_LDA);
Resultados_LDA(ind_LDA,:)
col3_PCA_LDA = Resultados_PCA_LDA(:,3);
[v3,ind_PCA_LDA]=min(col3_PCA_LDA);
Resultados_PCA_LDA(ind_PCA_LDA,:)