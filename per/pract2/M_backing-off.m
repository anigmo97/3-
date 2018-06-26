#!/usr/bin/octave -qf

output_precision(7)
if (nargin!=1 )
    printf("Usage: multinomial.m <data_filename> ");
    exit(1);
end

arglist=argv(); # lista de argumentos
datafile=arglist{1}; # el argumento 1 se guarda en datafile

disp("Loading data...");
load(datafile); # se carga la matriz "data"
disp("Data load complete.");

[nrows,ncols]=size(data); # obtenemos el numero de columnas y de filas
rand("seed",23); 

matriz_solucion=[];


cont = 0
while(cont<30)
    perm = randperm(nrows); # Obtenemos un vector aleatorio de indices de data
    pdata=data(perm,:);     # tomamos perm filas y todas sus columnas de data
    trper=0.9;              # fijamos el porcentaje de muestras de entrenaiento
    ntr=floor(nrows*trper); # retorna el mayor entero no > nrows * trper (calculamos el numero de muestras de entrenamiento)
    nte=nrows-ntr;          # nº de muestras - nº muestras entrenamiento = nº muestras de test
    tr=pdata(1:ntr,:);      # tomamos las muestras de entrenamiento y sus etiquetas
    te=pdata(ntr+1:nrows,:); # tomamos las muestras de test y sus etiquetas


    ## CALCULO DE LAS PROBABILIDADES A PRIORI DE LAS CLASES

    # Indices de las muestras de cada clase (en entrenamiento)
    indices_ham = find(tr(:,end)==0);
    indices_spam = find(tr(:,end)==1);

    # Num elementos de cada clase (en entrenamiento)
    num_elem_ham = size(indices_ham,1);
    num_elem_spam = size(indices_spam,1);

    # Seleccion de elementos de cada clase (en entrenamiento)
    muestras_de_la_clase_ham =  tr(indices_ham , 1:end-1);
    muestras_de_la_clase_spam = tr(indices_spam, 1:end-1);

    # Probabilidad a priori clases
    probabilidad_ham = num_elem_ham / ntr;
    probabilidad_spam = num_elem_spam / ntr;


    # Prototipo clase ham
    suma_columnas = sum(muestras_de_la_clase_ham,1);
    suma_componentes = sum(suma_columnas,2);
    prototipo_ham = (suma_columnas./suma_componentes) ;

    #Prototipo clase spam
    suma_columnas = sum(muestras_de_la_clase_spam,1);
    suma_componentes = sum(suma_columnas,2);
    prototipo_spam =(suma_columnas./suma_componentes);


    # muestras test
    muestras_test = te(:,1:end-1);

    #etiquetas_test
    etiquetas_test = te(:,end);

    # Suavizado 
    j =1;
    v=[];
    matriz_epsilon=[];
    while j <= 20
        epsilon = 10^(-j);  # Actualizamos epsilon
        matriz_epsilon=[matriz_epsilon epsilon]; # Guardamos los epsilon usados para graficarlos

        
        # CALCULO SUAVIZADO BACKING-OFF
        printf("\nLLegó");
        indices_componentes_nulos_ham= find(prototipo_ham==0);
        indices_componentes_no_nulos_ham = find(not(prototipo_ham==0));

        indices_componentes_nulos_spam = find(prototipo_spam==0);
        indices_componentes_no_nulos_spam = find(not(prototipo_spam==0));
        printf("\nLLegó 2");

        cantidad_a_repartir_ham = epsilon * size(indices_componentes_no_nulos_ham);
        cantidad_a_repartir_spam = epsilon * size(indices_componentes_no_nulos_spam);

        cantidad_por_nulo_ham = cantidad_a_repartir_ham/ size(indices_componentes_nulos_ham);
        cantidad_por_nulo_spam =cantidad_a_repartir_spam / size(indices_componentes_nulos_spam);
        vector_a_sumar_ham = prototipo_ham == zeros(columns(prototipo_ham))';
        [nrows,ncolums]=size(prototipo_ham);
        printf("\nLLegó 4.1");
        vector_a_restar_ham= prototipo_ham == not(zeros(columns(prototipo_ham)));
        printf("\nLLegó 4.2");
        vector_a_sumar_spam= prototipo_ham == zeros(columns(prototipo_spam));
        vector_a_sumar_spam= not(prototipo_ham == zeros(columns(prototipo_spam)));
        printf("\nLLegó 5");
        prototipo_ham = prototipo_ham + (vector_a_sumar_ham.*cantidad_por_nulo_ham);
        prototipo_ham = prototipo_ham - (vector_a_restar_ham.*epsilon);
        prototipo_spam = prototipo_spam + (vector_a_sumar_spam.*cantidad_por_nulo_spam);
        prototipo_spam = prototipo_spam - (vector_a_restar_spam.*epsilon);


        wh = log(prototipo_ham);
        ws = log(probabilidad_spam);
        wh0 = log(probabilidad_ham);
        ws0 = log(probabilidad_spam);
        gh = muestras_test * wh' + wh0;   # calculamos los valores que da el clasificador de la clase ham para todas las muestras de test
        gs = muestras_test * ws' + ws0;   # calculamos los valores que da el clasificador de la clase spam para todas las muestras de test
        aux = etiquetas_test == (gs > gh); # obtenemos un vector en el que los 1 son aciertos y los 0 fallos ( acierto -> clase elegida == etiqueta)
        errores = size(find(aux==0))(1,1);  # obtenemos el numero de errores
        v=[v errores];
        j++;
    end
    disp(v);
    matriz_solucion=[matriz_solucion; v];
cont++;
disp(cont);
end



# Preparamos la matriz para graficarla en gnuplot
media_errores = ((sum(matriz_solucion)/30)/nte)*100; #Dividimos la suma por columnas entre 30 (iteraciones) y entre el número de muestras de test totales
matriz_desviaciones =(std(matriz_solucion)./nte)*200;# Obtenemos la desviacion tipica y la dividimos entre el número de muestras de test totales
matriz_gnuplot= [matriz_epsilon' media_errores' matriz_desviaciones'] # creamos la matriz a graficar

disp(matriz_gnuplot)

save_precision(8)
save "matriz_gnuplot.dat" matriz_gnuplot
