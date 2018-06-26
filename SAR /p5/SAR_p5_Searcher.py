#!/usr/bin/env python

# ANGEL IGUALADA MORAGA

from whoosh.index import open_dir
from whoosh.qparser import QueryParser
import re

patron_noticia = u"<DOC>([\s\S]*?)</DOC>"
patron_contenido = u"<TEXT>([\s\S]*?)</TEXT>"

ix = open_dir(".")
with ix.searcher() as searcher:
    text = input("Inserte consulta: ")
    while len(text) > 0:
        query = QueryParser("content", ix.schema).parse(text)
        results = searcher.search(query)
        print("Número resultados:",len(results)) 
        if(len(results)>0):
            print("   documento".ljust(25," ")+"Numero Noticia".ljust(20," ")+"Titulo".rjust(20," "))
        for r in results:
            print ("   "+r["path"].ljust(25," ") +" "+r["num_noticia"].ljust(20," ") +" "+r["title"] )
        if(len(results)<4):
            for r in results:
                scanner = open(r["path"], 'r')
                fichero_dividido = scanner.read().split("</DOC>")
                noticia = fichero_dividido[int(r["num_noticia"])]
                content = re.findall(patron_contenido,noticia)
                scanner.close()
                print("\n"+content[0])
        text = input("Inserte consulta: ")


# EJEMPLO consulta 1 resultado: Guinea AND malabo AND obiang AND Nguema AND vicisitudes