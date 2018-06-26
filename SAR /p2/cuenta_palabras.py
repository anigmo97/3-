#! -*- encoding: utf8 -*-
# inspired by Lluís Ulzurrun and Víctor Grau work
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

def getDicFrec(listaCompleta,vocabulario):
    frecuencia = [listaCompleta.count(p) for p in vocabulario]
    return dict(zip(vocabulario,frecuencia))
 

def text_statistics(filename, to_lower=True, remove_stopwords=True):
    # COMPLETAR
    er = re.compile("(\w+)(\W*)")
    stopWords =[]
    for word, puntuation in er.findall(open('stopwords_en.txt', 'r').read()):
                stopWords.append(word.lower()) 
    stopWords= list(set(stopWords))

    word_list = []
    for word, puntuation in er.findall(open(filename, 'r').read()):
        if(word.isalnum()):
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
   
    print("Lines :"+str(numLineasFichero(open(filename,'r'))))
    if(remove_stopwords):
        print("Words (without stopWords) :"+str(len(word_list)))
    else:
        print("Words (with stopWords) :"+str(len(word_list)))

    print ("Vocabulary: "+str(len(vocabularioPalabras)))
    print ("Number of symbols: "+str(len(listaCaracteres)))
    print ("Number of different symbols: "+str(len(vocabularioCaracteres)))

    lineas = len(open(filename).readlines())
    print("\nWords by alphabetical order: ")
    aux = sorted(dicPalabras.items(), key=operator.itemgetter(0))
    for item in aux:
        print("       " +item[0] + "-->"+ str(item[1]))

    print("\nWords by frequency: ")
    aux1 = sorted(dicPalabras.items(), key=operator.itemgetter(1))
    aux1.reverse()
    for item in aux1:
        print("       " +item[0] + "-->"+ str(item[1]))

    print("\nCharacters by alphabetical order: ")
    aux = sorted(dicCaracteres.items(), key=operator.itemgetter(0))
    for item in aux:
        print("       " +item[0] + "-->"+ str(item[1]))
    
    print("\nChracters by frequency: ")
    aux1 = sorted(dicCaracteres.items(), key=operator.itemgetter(1))
    aux1.reverse()
    for item in aux1:
        print("       " +item[0] + "-->"+ str(item[1]))


def syntax():
    print ("\n%s filename.txt [to_lower?[remove_stopwords?]\n" % sys.argv[0])
    sys.exit()

if __name__ == "__main__":
    if len(sys.argv) < 2:
        syntax()
    name = sys.argv[1]
    lower = False
    stop = False
    if len(sys.argv) > 2:
        lower = (sys.argv[2] in ('1', 'True', 'yes'))
        if len(sys.argv) > 3:
            stop = (sys.argv[3] in ('1', 'True', 'yes'))
    text_statistics(name, to_lower=lower, remove_stopwords=stop)
