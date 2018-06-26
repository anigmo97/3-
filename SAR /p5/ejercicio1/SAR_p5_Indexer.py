#!/usr/bin/env python

import os
from os import walk
import whoosh
from whoosh.index import create_in
from whoosh.fields import Schema, ID, TEXT



schema = Schema(title=TEXT(stored=True), path=ID(stored=True), content=TEXT)
ix = create_in("./", schema)
writer = ix.writer()
ruta_directorio = "./enero"
path, ficheros, archivos = next(walk(ruta_directorio))
contador=0
for archivo in archivos:
    print("indexando "+archivo+" ...")
    ruta_relativa= ruta_directorio+"/"+archivo
    scanner = open(ruta_relativa, 'r')
    contenido = scanner.read()
    contador +=1
    writer.add_document(title=str(contador), path=ruta_relativa,content=contenido)
    scanner.close()
writer.commit()



