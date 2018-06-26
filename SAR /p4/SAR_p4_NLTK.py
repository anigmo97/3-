#! -*- encoding: utf8 -*-

#Acceder al corpus en castellano cess_esp
from nltk.corpus import cess_esp
from nltk.corpus import brown
from nltk.probability import *
import nltk, re, pprint
from nltk import word_tokenize
from nltk.probability import *
from nltk.stem.snowball import SnowballStemmer
import unittest
from operator import itemgetter
import operator

print("\n\nIMPORTANTE: \n En este código se asume la existencia de un directorio 'ficheros' que:\n contiene “spam.txt”, “quijote.txt” y “tirantloblanc.txt” ")
input("\nPULSE UNA TECLA PARA CONTINUAR...")
#Mostrar el número de palabras que contiene este corpus
print("\n\nEJERCICIO 1\n")
print("\n--------------------------------------------------------------------------------\n ")
cess_esp.words()
palabras = len(cess_esp.words())
print("1.1) Cargando Corpus cess_esp...")
print("\n--------------------------------------------------------------------------------\n ")
print ("\n\n1.2) Numero de palabras que contiene el corpus: \n"+str(palabras))

#Obtener oraciones del corpus:
frases = cess_esp.sents()
numFrases = len(cess_esp.sents())
print("\n--------------------------------------------------------------------------------\n ")
print ("\n\n1.3) Numero de frases que contiene el corpus: \n"+str(numFrases))


nomFichero = cess_esp.fileids()[0]
texto= cess_esp.words(nomFichero)
fdist = FreqDist(texto)
# Visualizar los pares (palabra, frecuencia) correspondientes a las 20 palabras más frecuentes:
items = fdist.most_common(20)
print("\n--------------------------------------------------------------------------------\n ")
print ("\n\n1.4) 20 items mas frecuentes: \n" +str(items))

#Obtener el vocabulario del primer fichero del corpus (ordenado por frecuencia)
vocabulario = [w for w,f in sorted(fdist.items(), key=itemgetter(1), reverse=True)]
print("\n--------------------------------------------------------------------------------\n ")
print ("\n\n1.5) Vocabulario del primer fichero del corpus : \n" +str(vocabulario))
##o set(texto)
##o [w for w,f in fdist.most_common()]

#Obtener de forma ordenada las palabras del vocabulario de longitud mayor que 7 y que aparezcan más de 2 veces
# en el primer fichero del corpus. 
palabras_pedidas=[w for w in set(texto) if fdist[w]>2 and len(w)>7]
print("\n--------------------------------------------------------------------------------\n ")
print("\n\n1.6) Palabras del vocabulario de longitud mayor que 7 y que aparezcan más de 2 veces en el primer fichero del corpus: \n"+ str(sorted(palabras_pedidas)))


#Obtener la frecuencia de aparición de las palabras en el primer fichero del corpus. Además, y para el mismo fichero
# obtener la frecuencia de la palabra 'a'.
frecuencias = [f for w,f in sorted(fdist.items(), key=itemgetter(1), reverse=True)]
freq_a = fdist['a']
print("\n--------------------------------------------------------------------------------\n ")
print("\n\n1.7) Frecuencia de aparicion de las palabras en el primer fichero: \n"+str(frecuencias))
print("Frecuencia de aparcición de la preposición a: "+str(freq_a))

# Obtener el número de palabras que sólo aparecen una vez en el primer fichero del corpus.
num = len([w for w in set(texto) if fdist[w]==1])
print("\n--------------------------------------------------------------------------------\n ")
print("\n\n1.8) Numero de palabras que aparecen una vez en e fichero: "+str(num))


#Obtener la palabra más frecuente del fichero del corpus
palabra_mas_frecuente = fdist.max() 
print("\n--------------------------------------------------------------------------------\n ")
print("\n\n1.9) Palabra mas frecuente del fichero del corpus: \n"+str(palabra_mas_frecuente))

# Cargar los ficheros de PoliformaT (“spam.txt”, “quijote.txt” y “tirantloblanc.txt” ) como un corpus propio.
from nltk.corpus import PlaintextCorpusReader
corpus_root = './ficheros'

new_corpus = PlaintextCorpusReader(corpus_root, '.*') 
lista_ficheros = new_corpus.fileids()
print("\n--------------------------------------------------------------------------------\n ")
print ("\n\n1.10) Ficheros que componen el corpus: \n"+str(lista_ficheros)+"\n")
print("\n-------------IMPORTANTE CAMBIAR LA RUTA DE LOS ARCHIVOS EN EL CÓDIGO------------\n ")
print("Ruta actual : "+corpus_root)

# Calcular el número de palabras, el número de palabras distintas y el número de frases de los tres documentos
print("\n--------------------------------------------------------------------------------\n1.11) ")
print("\n"+"Palabras".rjust(35," ")+"Vocabulario".rjust(12," ")+ "Frases".rjust(12," "))
for fichero in lista_ficheros:
    texto1= new_corpus.words(fichero)
    fdist1 = FreqDist(texto1)
    numPalabras = len(texto1)
    numPalabrasDistintas = len(fdist1.keys())
    numFrases = len(new_corpus.sents(fichero))
    print ("Fichero: "+str(fichero).ljust(20," ")+str(numPalabras).ljust(10," ")+str(numPalabrasDistintas).ljust(15," ")+str(numFrases))
print("\n\n--------------------------------------------------------------------------------\n")




print("\n--------------------------------------------------------------------------------\n ")
print("\n\nEJERCICIO 2\n")
palabras = ["what", "when", "where", "who","why"]
categorias = brown.categories()
lista ={}
for p in palabras:
    lista[p]=[]
for category in categorias: 
    words = brown.words(categories=category)
    fdist = FreqDist(words)
    for p in palabras:
        numApariciones = fdist[p]
        lista[p].append(category)
        lista[p].append(numApariciones)
print("\n\nMostrando los items del diccionario:")
print(lista)
# for p in lista.items():
#     print(str(p)+"\n\n") 

print("\n--------------------------------------------------------------------------------\n ")


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
print(" ".join(tokens_ordenados[-10:]))
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
print(" ".join(palabras[-10:]))
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
print(" ".join(palabras[-10:]))
print("\n--------------------------------------------------------------------------------\n ")

print("3.12) Obtener las frecuencias de aparición de los ítems que componen el nuevo documento. Visualizar los primeros 20 ítems")
print (fdist_stem.most_common(20))
print("\n--------------------------------------------------------------------------------\n ")
