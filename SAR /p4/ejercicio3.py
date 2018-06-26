#! -*- encoding: utf8 -*-
# -*- coding: UTF-8 -*-
import nltk, re, pprint
from nltk import word_tokenize
from nltk.probability import *
from nltk.stem.snowball import SnowballStemmer

print("\n\nEJERCICIO 3\n")
print("\n--------------------------------------------------------------------------------\n ")
print("3.1) Cargando quijote.txt...")
print("\n--------------------------------------------------------------------------------\n ")
text = open('./ficheros/quijote.txt').read()
fdist=FreqDist(text)
print("\n\n")

print("3.2) Mostrar todos los símbolos del documento ordenados por orden alfabético")
print(sorted(fdist.keys()))
print(" ".join(sorted(fdist.keys())))


print("\n--------------------------------------------------------------------------------\n ")
print("3.3) Eliminando -> ",'¡! " ’ ( ) , - . : ; ¿? ] « »        ...')
simbolos = ["'","¡","!",'"',"’","(",")" ,",", "-",".",":",";","¿","?", "]","«", "»"]
lista = [l for l in text if l not in simbolos ]
text_filtrado= "".join(lista)
fdist_filtrado=FreqDist(text_filtrado)

print("\n--------------------------------------------------------------------------------\n ")

print("3.4) Mostrar todos los símbolos del documento filtrado ordenados por orden alfabético")
print(sorted(fdist_filtrado.keys()))
print(" ".join(sorted(fdist_filtrado.keys())))
print("\n--------------------------------------------------------------------------------\n ")

print("3.5) Obtener el número de palabras y el número de palabras distintas del texto filtrado. Mostrar la 10 primeras y las 10 últimas en orden alfabético")
tokens=nltk.word_tokenize(text_filtrado,"spanish")
tokens_sin_reps = list(set(tokens))
tokens_ordenados = sorted(tokens_sin_reps)
print("Numero de palabras: ",str(len(tokens)))
print("Numero de palabras distintas: ",str(len(FreqDist(tokens))))
print(" ".join(tokens_ordenados[0:10]))
print(" ".join(tokens_ordenados[-11:-1]))
print("\n--------------------------------------------------------------------------------\n ")

print("3.6) Obtener las frecuencias de aparición de los ítems que componen el documento filtrado. ")
fdist_palabras_filtrado = FreqDist(tokens)
print (fdist_palabras_filtrado.most_common(20))
print("\n--------------------------------------------------------------------------------\n ")

print("3.7) Crear un nuevo documento eliminando las stopwords del texto filtrado ")
stopwords = nltk.corpus.stopwords.words("spanish")
tokens_sin_stops = [w for w in tokens if w.lower() not in stopwords]
texto_sin_stop = " ".join(tokens_sin_stops)
print("Eliminando stopwords...")
print("\n--------------------------------------------------------------------------------\n ")

print("3.8) Obtener el número de palabras y el número de palabras distintas del texto sin stopwords. Mostrar la 10 primeras y las 10 últimas en orden alfabético ")
print("Numero de palabras: ",str(len(tokens_sin_stops)))
print("Numero de palabras distintas: ",str(len(FreqDist(tokens_sin_stops))))
fdist_palabras_sin = FreqDist(tokens_sin_stops)
palabras = sorted(fdist_palabras_sin.keys())
print(" ".join(palabras[0:10]))
print(" ".join(palabras[-11:-1]))
print("\n--------------------------------------------------------------------------------\n ")

print("3.9) Obtener las frecuencias de aparición de los ítems que componen el documento sin stopwords. Visualizar los primeros 20 ítems.")
print (fdist_palabras_sin.most_common(20))
print("\n--------------------------------------------------------------------------------\n ")

print("3.10) Crear un nuevo documento sustituyendo cada palabra del texto sin stopwords por su raíz. Para ello se utilizará el stemmer snowball.")
stemmer = SnowballStemmer("spanish")
tokens_raices = [stemmer.stem(w) for w in tokens_sin_stops ]
print ("Realizando Steming...")
print("\n--------------------------------------------------------------------------------\n ")

print("3.11) 1 Obtener el número de palabras y el número de palabras distintas del nuevo documento. Mostrar la 10 primeras y las 10 últimas en orden alfabético")
fdist_stem = FreqDist(tokens_raices)
print("Numero de palabras: ",str(len(tokens_raices)))
print("Numero de palabras distintas: ",str(len(fdist_stem)))
palabras = sorted(fdist_stem.keys())
print(" ".join(palabras[0:10]))
print(" ".join(palabras[-11:-1]))
print("\n--------------------------------------------------------------------------------\n ")

print("3.12) Obtener las frecuencias de aparición de los ítems que componen el nuevo documento. Visualizar los primeros 20 ítems")
print (fdist_stem.most_common(20))
print("\n--------------------------------------------------------------------------------\n ")