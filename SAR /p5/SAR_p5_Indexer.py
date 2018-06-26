#!/usr/bin/env python

# ANGEL IGUALADA MORAGA

import os
from os import walk
import whoosh
from whoosh.index import create_in
from whoosh.fields import Schema, ID, TEXT
import re

patron_noticia = u"<DOC>([\s\S]*?)</DOC>"
patron_Titulo = u"<TITLE>([\s\S]*?)</TITLE>" 
patron_contenido = u"<TEXT>([\s\S]*?)</TEXT>"
print("\n IMPORTANTE \n LA CARPETA ENERO DEBE ESTAR EN EL DIRECTORIO ACTUAL\n")
schema = Schema(title=TEXT(stored=True), path=ID(stored=True), content=TEXT,num_noticia=ID(stored=True))
ix = create_in("./", schema)
writer = ix.writer()
ruta_directorio = "./enero"
path, ficheros, archivos = next(walk(ruta_directorio))
for archivo in archivos:
    print("\n\nIndexando "+archivo+" ...")
    ruta_relativa= ruta_directorio+"/"+archivo
    scanner = open(ruta_relativa, 'r')
    contenido_fichero = scanner.read()
    noticias = re.findall(patron_noticia,contenido_fichero)
    print("Se han extraído "+str(len(noticias)) +" noticias del archivo ",archivo)
    contador_noticias = 1
    for noticia in noticias:
        lista_matches = re.findall(patron_Titulo,noticia)
        cuerpo_noticia = re.findall(patron_contenido,noticia) 
        if len(lista_matches)>0:
            titulo = lista_matches[0]
            titulo = re.sub(r"\s+", " ", titulo)  #Cuando hay 2 o mas espacios ponemos 1
        if (len(cuerpo_noticia) > 0):
            cuerpo_noticia = cuerpo_noticia[0]
            writer.add_document(title=titulo, path=ruta_relativa,content=cuerpo_noticia,num_noticia=str(contador_noticias))
        contador_noticias+=1
    scanner.close()
writer.commit()
