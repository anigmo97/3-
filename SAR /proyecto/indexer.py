#! -*- encoding: utf8 -*-
# AUTOR : ANGEL IGUALADA MORAGA
from operator import itemgetter
import re
import sys
import operator
# se usa para saber si existe el fichero
import os.path
from os import scandir, getcwd
# se usa para sacar colores por terminal
from colorama import init, Fore, Back, Style
#import pickle
import _pickle as pickle
#import cPickle as pickle
from os import walk

er = re.compile("(\w+)(\W*)")
patron_noticia = u"<DOC>([\s\S]*?)</DOC>"
patron_Titulo = u"<TITLE>([\s\S]*?)</TITLE>" 
patron_contenido = u"<TEXT>([\s\S]*?)</TEXT>"
patron_categoria =u"<CATEGORY>([\s\S]*?)</CATEGORY>"
patron_fecha = u"<DATE>([\s\S]*?)</DATE>"


def getNews(ruta_directorio):
    print(" \n ",ruta_directorio)
    path, ficheros, archivos = next(walk(sys.argv[1]))
    docId = 1
    dic_documentos ={}
    lista_noticias = []
    indice_invertido_text = {}
    indice_invertido_title = {}
    indice_invertido_category = {}
    indice_invertido_date = {}
    indice_perm_1_text = {}
    indice_perm_varios_text = {}
    indice_perm_1_title = {}
    indice_perm_varios_title = {}
    indice_perm_1_category = {}
    indice_perm_varios_category = {}
    indice_perm_1_date = {}
    indice_perm_varios_date = {}
    hash_pos_text = {}
    hash_pos_title = {}
    hash_pos_category = {}
    hash_pos_date = {}
    for archivo in archivos:
        print("\n\nIndexando "+archivo+" (docId = "+str(docId)+") ...")
        ruta_relativa= ruta_directorio+"/"+archivo
        dic_documentos[docId]= ruta_relativa
        scanner = open(ruta_relativa, 'r')
        contenido_fichero = scanner.read()
        noticias = re.findall(patron_noticia,contenido_fichero)
        print("Se han extraído "+str(len(noticias)) +" noticias del archivo ",archivo)
        contador_noticias = 1
        for noticia in noticias:
            newid = (docId,contador_noticias)
            lista_noticias.append(newid)
            #print("Noticia ",contador_noticias,"con newid = ",newid)
            titulo = re.findall(patron_Titulo,noticia)
            cuerpo = re.findall(patron_contenido,noticia) 
            categoria = re.findall(patron_categoria,noticia) 
            fecha = re.findall(patron_fecha,noticia)
            if (len(cuerpo) > 0):
                cuerpo= cuerpo[0]
                indice_invertido_text,hash_pos_text,indice_perm_1_text,indice_perm_varios_text=tokeniza(newid,indice_invertido_text,hash_pos_text,cuerpo,indice_perm_1_text,indice_perm_varios_text)
            if len(titulo) > 0:
                titulo = titulo[0]
                titulo = re.sub(r"\s+", " ", titulo)  #Cuando hay 2 o mas espacios ponemos 1
                indice_invertido_title,hash_pos_title,indice_perm_1_title,indice_perm_varios_title = tokeniza(newid,indice_invertido_title,hash_pos_title,titulo,indice_perm_1_title,indice_perm_varios_title)
            if (len(categoria) > 0):
                categoria = categoria[0]
                indice_invertido_category,hash_pos_category,indice_perm_1_category,indice_perm_varios_category = tokeniza(newid,indice_invertido_category,hash_pos_category,categoria,indice_perm_1_category,indice_perm_varios_category)
            if (len(fecha) > 0):
                fecha = fecha[0]
                indice_invertido_date,hash_pos_date,indice_perm_1_date,indice_perm_varios_date = tokeniza(newid,indice_invertido_date,hash_pos_date,fecha,indice_perm_1_date,indice_perm_varios_date)
            contador_noticias+=1
        scanner.close()
        docId+=1
    #print(dic_documentos)
    print("\n",Back.GREEN,Fore.WHITE,"Se extrajeron ",len(lista_noticias)," noticas en total",Style.RESET_ALL)
    return (dic_documentos,lista_noticias,indice_invertido_title,indice_invertido_category,indice_invertido_date,indice_invertido_text,indice_perm_1_text,indice_perm_1_title,indice_perm_1_category,indice_perm_1_date,indice_perm_varios_text,indice_perm_varios_title,indice_perm_varios_category,indice_perm_varios_date)

def make_permuterm(perm_1,perm_varios,word):
    c = 1
    pref=[]
    perms = []
    p = word +"$"
    if( p not in perm_varios.keys()):
            perm_varios[p]= {word:""}
    else:
        perm_varios[p][word]=""

    while(c <= len(word)):
        prefijo = p[:c]
        sufijo  = p[-c:]
        # print(prefijo," ",sufijo)
        # input()
        if( prefijo not in perm_varios.keys()):
            perm_varios[prefijo]= {word:""}
        else:
            perm_varios[prefijo][word]=""
        
        if( sufijo not in perm_varios.keys()):
            perm_varios[sufijo]= {word:""}
        else:
            perm_varios[sufijo][word]=""

        word2 = word[:c-1]+"*"+word[c:]
        # print(word2)
        if(word2 in perm_1.keys()):
            perm_1[word2][word]=""
        else:
             perm_1[word2] = {word : ""}
        c+=1
    return perm_1,perm_varios

def tokeniza(newid,indice,hash_pos,texto,indice_perm_1,indice_perm_varios):
    pos = 0
    for word, puntuation in er.findall(texto.lower()):
        indice_perm_1,indice_perm_varios = make_permuterm(indice_perm_1,indice_perm_varios,word)
        if word not in indice.keys():
            indice[word]= [[newid,[pos]]]
            hash_pos[(word,newid)]= 0
        else:
            if((word,newid) in hash_pos.keys()):
                ya_aparecio_en_esta_noticia = True
            else:
                ya_aparecio_en_esta_noticia = False
            
            if ya_aparecio_en_esta_noticia:
                cont = hash_pos[(word,newid)]
                lista_posiciones = indice[word][cont]
                lista_posiciones[1].append(pos)
                #cambio cont - 1
                indice[word][cont] = lista_posiciones
            else:
                hash_pos[(word,newid)]=len(indice[word])
                indice[word].append([newid,[pos]])
        pos+=1
    return indice,hash_pos,indice_perm_1,indice_perm_varios


def guarda_objeto(objeto_pickle,file_name):
    with open(file_name, "wb") as fh:
        pickle.dump(objeto_pickle, fh)
        

def ls(ruta = getcwd()):
    return [arch.name for arch in scandir(ruta) if arch.is_file() ] #and arch.name.endswith("txt")

def syntax():
    print ("\n%s Direcctorio-Documentos filename.txt\n" % sys.argv[0])
    print ("\n Ejemplo DiscoW/ indices.txt" )
    sys.exit()



if __name__ == "__main__":
    if len(sys.argv) != 3:
        syntax()
    else:
        if sys.argv[1] in ("cwd","pwd","current","this","./"):
            ruta = ls()
            ruta_directorio = "./"
        elif os.path.exists(sys.argv[1]):
            ruta = ls(sys.argv[1])
            ruta_directorio = sys.argv[1]
        else:
            raise Exception("\n\n"+Back.WHITE+Fore.RED+"           El directorio "+sys.argv[1]+" no existe"+Style.RESET_ALL+"\n\n")
        if(not sys.argv[2].endswith(".txt")):
            raise Exception("\n\n"+Back.WHITE+Fore.RED+"           El fichero debe tener extension .txt "+Style.RESET_ALL+"\n\n")
        print("\n\n"+Back.GREEN+Fore.WHITE+"La ruta seleccionada contine:\n "+str(ruta)+Style.RESET_ALL+"\n\n")
        objeto_pickle = getNews(ruta_directorio)
        guarda_objeto(objeto_pickle,sys.argv[2])
        print("\n\n"+Back.GREEN+Fore.WHITE+"En la ruta:    "+ruta_directorio)
        print("Se ha creado un fichero llamado "+Fore.BLACK+sys.argv[2]+Fore.WHITE)
        print("Contenido = (dic_documentos,lista_noticias,indice_invertido_title,indice_invertido_category,indice_invertido_date,indice_invertido_text,indice_perm_1_text,indice_perm_1_title,indice_perm_1_category,indice_perm_1_date,indice_perm_varios_text,indice_perm_varios_title,indice_perm_varios_category,indice_perm_varios_date)"+Style.RESET_ALL+"\n\n")