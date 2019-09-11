#!/bin/octave -qf
##./experiment.m OCR_14x14 '[1 10]' '[1 10]'
## octave experiment.m ../datos/OCR_14x14 '[1 10]' '[1 10]'

if (nargin!=3)
printf("Usage: ./experiment.m <data> <alphas> <bes>\n");
printf("./experiment.m OCR_14x14 '[1 10]' '[1 10]'");
exit(1);
end
arg_list=argv(); 			%arg_list = arguments
data=arg_list{1};		    % data = argumento1
as=str2num(arg_list{2}); 	%as = valores de Alpha
bs=str2num(arg_list{3}); 	%bs = valores de Beta
load(data); 				%carga el archivo que le pases por parámetro 
[N,L]=size(data);			% N => numero Filas  L=> numero Columnas
D=L-1;						% D => Columnas - 1 (En la ultima te dice la clase )
ll=unique(data(:,L));		% De todas las filas hasta la penúltima columna
							% Quita elementos repetidos 
C=numel(ll);				% C => numero de columnas distintas
rand("seed",23);			% crea numero aleatorio con semilla 23 
data=data(randperm(N),:);	% retorna un vector fila que contiene una permutación
							% aleatoria de las filas y columnas. (mezcla)
NTr=round(.7*N);			% NTr => integer mas cercano a ( 0,7 * N) coge el 70% filas
M=N-NTr;					% M (pruebas de test) = Filas - 70 % filas
te=data(NTr+1:N,:);			% te = Array (datos entrenamiento)
% El mejor es el de Ete mas pequeño 
printf("#  alfa    beta ErrPerceptron numeroIteracionesPerceptron, erroresDeTest, intervalos    Ete(%s)   Ite(%s) \n","%","%")
printf("#     a       b     E   k   Ete    Ete(%s)   Ite(%s) \n","%","%")
printf("#   -----   -----  --- ---  ----    ---  -------------\n");
for a=as 		% por cada alfa
	for b=bs	% por cada Beta
		 % perceptron(ArrayDatos[1:70%],beta, alfa)
		[w,E,k]=perceptron(data(1:NTr,:),b,a);
		% w -> vector de pesos
		% E -> numero de errores en la traza de perceptron
		% k -> numero de iteraciones realizadas para ajustar los vectores de pesos
		% si k == K no se pudieron ajustar antes de alcanzar el numero maximo de iteraciones
		rl = zeros(M,1);  % creamos un vector de zeros con 0,3Filas y 1 columna
			for n=1:M % para todos los test (30% de los totales)
			rl(n)=ll(linmach(w,[1 te(n,1:D)]')); %guarda en el vector r1 que clase tienemayor valor
			% para cada objeto de test (30%)
			end
		[nerr m]=confus(te(:,L),rl); % te da el numero de errores
		##calcula ite(%)
% M=300; 
output_precision(2); % saca dos decimales
m=nerr/M;  % porcentaje de error errores/ pruebas de test
s=sqrt(m*(1-m)/M);  % tamaño intervalo confianza
r = 1.96 * s; % formula lo que le puedes sumar y restar a la m (intervalo confianza)
%mete=((m-r)+(m+r))*50; ##calcula Ete(%)
		%printf("%8.1f %8.1f %3d %3d  %3d %8.1f  [%.3f, %.3f]\n",a,b,E,k,nerr,mete,(m-r)*100,(m+r)*100);
		if ((m-r)*100>0)
			printf("%8.1f %8.1f %3d %3d  %3d %8.1f  [%.3f, %.3f]\n",a,b,E,k,nerr,m*100,(m-r)*100,(m+r)*100);
		else
			printf("%8.1f %8.1f %3d %3d  %3d %8.1f  [%.3f, %.3f]\n",a,b,E,k,nerr,m*100,0,(m+r)*100);
		endif
		%alfa beta ErroresEnPerceptron numeroIteracionesPerceptron, erroresDeTest, intervalos
	end
end

## a = factor de aprendizaje
## b = margen
## M = Maximo numero de iteraciones
## K = numero de iteraciones maximas a realizar 
## k = numero iteraciones realizadas en perceptron
## m = probabilidad de error
## s = tamaño intervalo confianza 

