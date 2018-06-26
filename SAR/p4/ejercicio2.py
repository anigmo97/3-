#! -*- encoding: utf8 -*-

#Acceder al corpus en castellano cess_esp
from nltk.corpus import brown
from nltk.probability import *
import operator

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


     