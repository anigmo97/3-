#!/usr/bin/octave -qf
% Argumento X -> matriz con los vectores en el espacio original
% VALORES RETORNADOS
    % m -> Media de los vectores
    % W -> matriz de proyección que contiene por filas los vectores propios ordenados de mayor a menor valor propio asociado

function [media_datos,W]=pca(X)
    num_muestras = columns(X);# Número de muestras
    # Vector media datos
    media_datos = sum(X,2) / num_muestras; # sumamos las columnas y dividimos por nº muestras
    matriz_menos_media = X - media_datos; # a cada columna se le resta la media de los datos
    matriz_covarianza = (matriz_menos_media*matriz_menos_media')./num_muestras; # Calcula matriz cov
     # Obtención de los eigenvalues y eigenvectors ordenados según eigenvalue ascendente
    [V, lambda]=eig(matriz_covarianza);
    [eigval, order]=sort(-diag(lambda)'); # se ordenan por mayor valor propio
    W = V(:,order);#(:,:);# Se devuelven todos los eigenvectors
endfunction;

