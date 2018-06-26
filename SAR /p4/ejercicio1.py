#! -*- encoding: utf8 -*-

#Acceder al corpus en castellano cess_esp
from nltk.corpus import cess_esp
from nltk.probability import *
import unittest
from operator import itemgetter

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
corpus_root = '/home/angel/Escritorio/Enlace hacia universidad/3/CUATRIMESTRE--B/SAR (PYTHON)/practicas/p4/ficheros'

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