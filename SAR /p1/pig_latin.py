#!/usr/bin/python3
#! -*- encoding: utf8 -*-


"""
1.- Pig Latin

Nombre Alumno: ANGEL IGUALADA MORAGA
AMPLIACION REALIZADA
"""
import re
import sys
import os
##  NO NECESARIOS
try:
    import colorama 
    from colorama import Fore, Back, Style
    colorama.init()
    errorColorama=False               
except (ImportError,NameError) as e:
    errorColorama = True

    


##
# import difflib
# from difflib_data import * diff ejecutable



def piglatin_word(word):
    vocales =  ( "a e i o u y")
    if(word.isalpha()):
        primeraLetraMayuscula = word[0].isupper()
        todaLaPalabraMayusculas = word.isupper()
        word = word.lower()
        comienzaConVocal = word[0] in vocales
        if comienzaConVocal:
            word += "yay"
        else:
            i=0
            while word[0] not in vocales and i< len(word):
                word= word[1:]+word[0]
                i+=1
            word+="ay"
        if(todaLaPalabraMayusculas):
            word=word.upper()
        elif primeraLetraMayuscula:
            word= word.title()

    # COMPLETAR
    return word


def piglatin_sentence(sentence):

    er = re.compile("(\w+)(\W*)")

    word_list = []
    for word, puntuation in er.findall(sentence):
        word_list.append(piglatin_word(word)+puntuation)
    res = ''.join(word_list)
    return  res


if __name__ == "__main__":
    frase = "  "
    if len(sys.argv) == 3:
        if(sys.argv[1]!="-f" or not sys.argv[2].endswith(".txt")):
            x = str(__file__)
            if(errorColorama):
                print("\n\n"+" Correct use python script -f filename.txt "+" \n\n") 
            else:
                print("\n\n"+Back.WHITE+Fore.RED+" Correct use python script -f filename.txt "+Style.RESET_ALL+" \n\n") 
            exit(1)
        else:
            existe_fichero1 = os.path.isfile(sys.argv[2]) 
            if(not existe_fichero1):
                raise Exception("\n\n"+Back.WHITE+Fore.RED+"           El fichero "+sys.argv[2]+" no existe\n"+Style.RESET_ALL+"\n")
            else:
                fichero = open (sys.argv[2], 'rt')
                leido = fichero.read()
                fichero.close()
                nombre= sys.argv[2][0:-4]+"_traduccion.txt"
                fichero = open ( nombre, 'w' ) 
                fichero.write(piglatin_sentence(leido))
                fichero.close()
                if(errorColorama):
                    print("\n\n"+"Traduccion guardada en "+str(nombre)+"\n\n")
                else:
                    print("\n\n"+Back.GREEN+"Traduccion guardada en "+str(nombre)+Style.RESET_ALL+"\n\n")

                
    elif len(sys.argv) == 2:
        print (piglatin_sentence(sys.argv[1]))
    else:
        while frase!="":
            frase = str(input("Por favor introduzca una frase: "))
            print(piglatin_sentence(frase))



