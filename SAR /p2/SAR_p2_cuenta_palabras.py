#! -*- encoding: utf8 -*-
# AUTOR : ANGEL IGUALADA MORAGA
# AMPLIACION REALIZADA
import operator
from operator import itemgetter
import re
import sys

clean_re = re.compile('\W+')
def clean_text(text):
    return clean_re.sub(' ', text)

def sort_dic(d):
    for key, value in sorted(sorted(d.items()), key=itemgetter(1), reverse=True):
        yield key, value

def numLineasFichero(fichero):
    try:
        fichero.seek(0)
        return len(fichero.readlines())
    except AttributeError:
        print("Debes insertar un fichero")
        return -1

#####################################################################################################################
#####################################################################################################################
####################################### CODIGO AÑADIDO ##############################################################

def getDicFrec(listaCompleta,vocabulario):
    frecuencia = [listaCompleta.count(p) for p in vocabulario]
    return dict(zip(vocabulario,frecuencia))

def printSortedDic(dic,byFrequency=False):
    aux1 = sorted(dic.items(), key=operator.itemgetter(int(byFrequency)),reverse=byFrequency)
    for item in aux1:
        print("       " +item[0] + "-->"+ str(item[1]))

 

def text_statistics(filename, to_lower=True, remove_stopwords=True,do_extra=True):
    er = re.compile("(\w+)(\W*)")
    stopWords =[]
    for word, puntuation in er.findall(open('stopwords_en.txt', 'r').read()):
                stopWords.append(word.lower()) 
    stopWords= list(set(stopWords)) # lista con el vocabulario

    ficheroAbierto=open(filename, 'r')
    word_list = []
    pTotal =0
    for word, puntuation in er.findall(ficheroAbierto.read()):
        if(word.isalnum()):
            pTotal+=1
            if(to_lower):
                if(remove_stopwords):
                    if(word.lower() not in stopWords):
                        word_list.append(word.lower())
                else:
                    word_list.append(word.lower())
            else:
                word_list.append(word)

    vocabularioPalabras = list(set(word_list))
    listaPalabrasDivididas = list(map(list, word_list))
    listaCaracteres = [item for sublist in listaPalabrasDivididas for item in sublist]
    # for sublist in l:
    # for item in sublist:
    #     flat_list.append(item)
    vocabularioCaracteres = list(set(listaCaracteres))
    dicCaracteres = getDicFrec(listaCaracteres,vocabularioCaracteres)
    dicPalabras =getDicFrec(word_list,vocabularioPalabras)

    print("Lines :"+str(numLineasFichero(ficheroAbierto)))
    print("Words (with stopWords) :"+str(pTotal))
    if(remove_stopwords):
        print("Words (without stopWords) :"+str(len(word_list)))
    print ("Vocabulary: "+str(len(vocabularioPalabras)))
    print ("Number of symbols: "+str(len(listaCaracteres)))
    print ("Number of different symbols: "+str(len(vocabularioCaracteres)))
    print("\nWords by alphabetical order: ")
    printSortedDic(dicPalabras)
    print("\nWords by frequency: ")
    printSortedDic(dicPalabras,True)
    print("\nCharacters by alphabetical order: ")
    printSortedDic(dicCaracteres)
    print("\nChracters by frequency: ")
    printSortedDic(dicCaracteres,True)


##########################################################################
    #                       CODIGO AMPLIACION
    if(do_extra):
        dic_tuplas={}
        ficheroAbierto.seek(0)
        fichero= ficheroAbierto.readlines()
        for linea in fichero:
            if(to_lower):
                linea = linea.lower()
            palabras2=[]
            for word, puntuation in er.findall(linea):
                if(word.isalnum()):
                    if(to_lower):
                        if(remove_stopwords):
                            if(word.lower() not in stopWords):
                                palabras2.append(word.lower())
                        else:
                            palabras2.append(word.lower())
                    else:
                        palabras2.append(word)
            palabras2 = ["$"]+palabras2+["$"]
            i=1
            while i< len(palabras2):
                tupla= palabras2[i-1]+"-"+palabras2[i]
                dic_tuplas[tupla]=dic_tuplas.get(tupla,0)+1
                i+=1
        print("\nCouples by alphabetical order: ")
        printSortedDic(dic_tuplas)
        print("\nCouples by frequency: ")
        printSortedDic(dic_tuplas,True)

        dic_tuplas_Caracteres={}
        for palabra in vocabularioPalabras:
            i=1
            while i< len(palabra):
                tupla= palabra[i-1]+"-"+palabra[i]
                dic_tuplas_Caracteres[tupla]=dic_tuplas_Caracteres.get(tupla,dicPalabras[palabra])+dicPalabras[palabra] 
                i+=1
        
        print("\nCouples by alphabetical order: ")
        printSortedDic(dic_tuplas_Caracteres)
        print("\nCouples by frequency: ")
        printSortedDic(dic_tuplas_Caracteres,True)

##########################################################################
    #                      FIN CODIGO AMPLIACION #########################
##########################################################################



def syntax():
    print ("\n%s filename.txt [to_lower?[remove_stopwords?]\n" % sys.argv[0])
    sys.exit()

if __name__ == "__main__":
    if len(sys.argv) < 2:
        syntax()
    name = sys.argv[1]
    lower = False
    stop = False
    extra= False
    if len(sys.argv) > 2:
        lower = (sys.argv[2] in ('1', 'True', 'yes'))
        if len(sys.argv) > 3:
            stop = (sys.argv[3] in ('1', 'True', 'yes'))
            if len(sys.argv) > 4:
                extra = (sys.argv[4].lower()==("extra"))
    text_statistics(name, to_lower=lower, remove_stopwords=stop,do_extra=extra)
