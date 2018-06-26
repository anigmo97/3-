#! -*- encoding: utf8 -*-

from operator import itemgetter
import re
import sys
import operator
# se usa para saber si existe el fichero
import os.path
# se usa para sacar colores por terminal
try:
    import colorama 
    from colorama import Fore, Back, Style
    colorama.init()
    errorColorama=False               
except (ImportError,NameError) as e:
    errorColorama = True
import _pickle as pickle

def save_dictTostring(d):
    fich = "diccionario.txt" if sys.argv[2]!="diccionario.txt" else "diccionario1.txt"
    f = open(fich, "w")
    f.write("\n")
    f.write("INDICE GENERADO\n")
    for l in ordena_diccionario(indice):
        f.write(str(l)+"\n")
    f.close()
    if(not errorColorama):
        print("\n\n"+Back.GREEN+Fore.WHITE+"   Se ha creado el fichero "+fich+" y se ha guardado en él un string con el indice ordenado"+Style.RESET_ALL+"\n")

def save_object(object, file_name):
    with open(file_name, "wb") as fh:
        pickle.dump(object, fh)

def ordena_diccionario(aux1):
    # ORDENA LAS PALABRAS QUE HAN APARECIDO DESPUES POR FRECUENCIA
    for key in aux1.keys():
         aux1[key][1]= sorted(aux1[key][1].items(), key=operator.itemgetter(1),reverse=True)
    # ORDENA LOS TERMINOS ALFABETICAMENTE
    aux2 = sorted(aux1.items(), key=operator.itemgetter(0))
    return aux2


def crea_indice(archivo1):
    patronPalabras = re.compile("(\w+)(\W*)") #regex dividir alfanumericos y no alfanumericos
    texto= open(archivo1,'r').read()
    texto = re.sub(r"\n{2,}", "#$~", texto)  #Cuando hay 2 o mas \n ponemos #$~
    lista_Lineas = re.split(r'[(;)|(.)|(!)|(?)|(#$~){2}]',texto)
    lista_Lineas = list(filter(lambda a: a != "", lista_Lineas))
    dict_palabras={}
    for i in lista_Lineas:
        frase = i
        palabras = ["$"]+[x[0] for x in patronPalabras.findall(frase)]+["$"]
        i = 0
        while i < len(palabras)-1:
                palabra = palabras[i].lower()
                palabra_siguiente = palabras[i+1].lower()
                if(palabra in dict_palabras.keys()):
                    dict_palabras[palabra][0]+=1
                    if(palabra_siguiente in dict_palabras[palabra][1] ):
                        dict_palabras[palabra][1][palabra_siguiente]+=1
                    else:
                        dict_palabras[palabra][1][palabra_siguiente]=1
                else:
                    dict_palabras[palabra]=[1,{}]
                    dict_palabras[palabra][1][palabra_siguiente]=1
                i+=1
    dict_palabras['$'][0]=len(lista_Lineas)
    return dict_palabras


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
            if(not errorColorama):
                raise Exception("\n\n"+Back.WHITE+Fore.RED+"           El fichero "+sys.argv[1]+" no existe\n"+Style.RESET_ALL+"\n")
            else:
                raise Exception("\n\n"+"           El fichero "+sys.argv[1]+" no existe\n"+"\n")
        indice = crea_indice(sys.argv[1])
        save_object(indice,sys.argv[2])
        if(not errorColorama):
            print("\n\n"+Back.GREEN+Fore.WHITE+"   Se ha creado el fichero "+sys.argv[1]+" y se ha guardado en él el indice"+Style.RESET_ALL+"\n")
        save_dictTostring(indice)
        
