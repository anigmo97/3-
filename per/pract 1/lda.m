#!/usr/bin/octave -qf

function [W]=lda(X,xl)
    #Calcula la media (global) de los datos X
    mediaDatos= sum(X,2)/columns(X);
    #Inicializa Sb = Sw = 0
    Sb = Sw = 0;
    clases = unique(xl) % clases -> valores distintos de la ultima columna (clases)					
    numClases = numel(clases) % numero de clases 
    n=1;
    while (n <= numClases)
        i0=find(xl(1,:)==clases(n)); % Obtengo los indices de filas de la clase 
        data0=X(:,i0); % Obtengo los Datos de la clase 
        n0=columns(data0);% numero de elementos de la clase
        mu0=sum(data0,2)/n0;% media de los datos de la clase
        cov0=((data0-mu0)*(data0-mu0)')/n0;% Calculamos la matriz de covarianza
        Sb= Sb + n0*((mu0-mediaDatos)*(mu0-mediaDatos)');% numero elementos
        Sw = Sw + cov0;
        #Para cada clase c:
            #•HECHO Calcula la media de los elementos de la clase
            #•HECHO Calcula Sb = Sb + nc(xc − x)(xc − x)'
            #•HECHO Calcula la matriz de covarianzas Σc 
            #•HECHO Calcula Sw = Sw + Σc
        n++;
    endwhile;
    # Obtención de los eigenvalues y eigenvectors y ordenacion según eigenvalue ascendente
    [V, lambda]=eig(Sb,Sw);
    [eigval, order]=sort(-diag(lambda)');
    W = V(:,order)(:,:);# Se devuelven todos los eigenvectors
    % W -> matriz de proyección que contiene por filas todos los vectores propios ordenados de mayor a menor valor propio asociado
endfunction


