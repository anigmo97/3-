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
 

clean_re = re.compile('\W+')
def clean_text(text):
    return clean_re.sub(' ', text)

def sort_dic(d):
    for key, value in sorted(sorted(d.items()), key=itemgetter(1), reverse=True):
        yield key, value

def crea_lista_frases(archivo1):
    fichero = open(archivo1, 'r')
    tokenized_sents = [word_tokenize(i) for i in fichero]
    lista_frases =[]
    i = 0
    elemento = []
    for linea in tokenized_sents:
        if(len(linea)==0):
            i+=1
            lista_frases.append(elemento)
            elemento=[]
        else:
            for palabra in linea:
                if(palabra.isalnum()):
                    elemento.append(palabra.lower())
                elif(palabra in (";",".",":","\n\n")):
                    i+=1
                    lista_frases.append(elemento)
                    elemento=[]
    if(elemento):
        lista_frases.append(elemento) 
    i = 0             
    while i < len(lista_frases):
        lista_frases[i]= ["$"]+lista_frases[i]+["$"]
        i+=1
    return lista_frases

def crea_diccionario(lista_frases):
    dict_palabras={ }
    for frase in lista_frases:
        i = 0
        while i < len(frase)-1:
            palabra = frase[i]
            palabra_siguiente = frase[i+1]
            if(palabra in dict_palabras.keys()):
                dict_palabras[palabra][0]+=1
                if(dict_palabras[palabra][1].has_key(palabra_siguiente)):
                    dict_palabras[palabra][1][palabra_siguiente]+=1
                else:
                    dict_palabras[palabra][1][palabra_siguiente]=1
            else:
                dict_palabras[palabra]=[1,{}]
                dict_palabras[palabra][1][palabra_siguiente]=1
            i+=1
    return dict_palabras

def ordena_diccionario(aux1):
    # Nos devuelve una lista no un diccionario
    #aux = sorted(dict_words.items(), key=operator.itemgetter(0))
    ## ESTA LINEA ES MAGIA   #aux1 ={k[0]: k[1:] for k in aux}
    #aux1 = dict(aux)
    for key in aux1.keys():
         aux1[key][1]= sorted(aux1[key][1].items(), key=operator.itemgetter(1))
         aux1[key][1].reverse()
    aux2 = sorted(aux1.items(), key=operator.itemgetter(0))
    for i in aux2:
        print (i[0].ljust(10, "-")+"---> "+str(i[1][0]).ljust(5," ")+ "  "+ str(i[1][1][0:]))
    # aux3 = dict(aux2)
    # for i in aux3.items():
    #     print i
    # sort_dic(aux3)
    # for i in aux3.items():
    #     print i
    return dict(aux2)


def save_object(object, file_name):
    with open(file_name, "wb") as fh:
        pickle.dump(object, fh)






def crea_indice(lista_frases,archivo2):
    print("archivo destino -> "+archivo2)
    # for i in lista_frases:
    #     print i
    dict_palabras = crea_diccionario(lista_frases)
    dict_ordenado = ordena_diccionario(dict_palabras)
    save_object(dict_ordenado,archivo2)


def syntax():
    print ("\n%s filename1.txt filename1.txt\n" % sys.argv[0])
    sys.exit()

if __name__ == "__main__":
    if len(sys.argv) < 3:
        syntax()
    else:
        existe_fichero1 = os.path.isfile(sys.argv[1])
        existe_fichero2 = os.path.isfile(sys.argv[2])
        if(not existe_fichero1):
            raise Exception("\n\n"+Back.WHITE+Fore.RED+"           El fichero "+sys.argv[1]+" no existe\n"+Style.RESET_ALL+"\n")
        if(not existe_fichero2):
            raise Exception("\n\n"+Back.WHITE+Fore.RED+"           El fichero "+sys.argv[2]+" no existe\n"+Style.RESET_ALL+"\n")
        lista_frases = crea_lista_frases(sys.argv[1])
        crea_indice(lista_frases,sys.argv[2])
