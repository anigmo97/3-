#! -*- encoding: utf8 -*-

from operator import itemgetter
import re
import sys
from nltk import word_tokenize
from nltk.corpus import stopwords
import operator
# se usa para saber si existe el fichero
import os.path
# se usa para sacar colores por terminal
from colorama import init, Fore, Back, Style
import pickle
import cPickle as pickle
import random

# random.randint(a, b)
# Return a random integer N such that a <= N <= b.
# random.choice(seq)
# Return a random element from the non-empty sequence seq. If seq is empty,
# raises IndexError.


def escribe(indice):
    num_frases = 0
    frases= [ ]
    while num_frases < 10:
        frase=["$"]
        i=0
        while i < 25 :
            palabra= frase[i]
            if(palabra == "$" and i > 0):
                break
            dict_posibilidades = indice[palabra][1]
            p = elegir_siguiente_palabra(dict_posibilidades)
            frase.append(p)
            i+=1
        num_frases+=1
        frases.append(frase)
    print("\n\n  Frases Escritas  (se guardan en escrito.txt:")
    for phrase in frases:
        print " ".join(phrase) 
    save_object(frases,"escrito.txt")  

def save_object(object, file_name):
    with open(file_name, "wb") as fh:
        pickle.dump(object, fh)
    
    

def elegir_siguiente_palabra(dict_posibilidades):
    total = 0
    lista_posibilidades = [ ]
    for value in dict_posibilidades:
        total+= value[1]
        for number in range(value[1]):
            lista_posibilidades.append(value[0]) 
    valor = random.randint(0, total-1)
    return lista_posibilidades[valor]

def load_object(file_name):
    with open(file_name, 'rb') as fh:
        obj = pickle.load(fh)
        return obj


def syntax():
    print ("\n%s filename1.txt \n" % sys.argv[0])
    sys.exit()

if __name__ == "__main__":
    if len(sys.argv) < 2:
        syntax()
    else:
        existe_fichero1 = os.path.isfile(sys.argv[1])
        if(not existe_fichero1):
            raise Exception("\n\n"+Back.WHITE+Fore.RED+"           El fichero "+sys.argv[1]+" no existe\n"+Style.RESET_ALL+"\n")
        dict_indice = load_object(sys.argv[1])
        escribe(dict_indice)
