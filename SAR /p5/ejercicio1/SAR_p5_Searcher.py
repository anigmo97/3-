#!/usr/bin/env python

from whoosh.index import open_dir
from whoosh.qparser import QueryParser

ix = open_dir(".")
with ix.searcher() as searcher:
    text = input("Inserte consulta o escriba '..' para ejemplos:")
    if text != '..':
        while len(text) > 0:
            query = QueryParser("content", ix.schema).parse(text)
            results = searcher.search(query,limit=None)
            print("Numero de resultados obtenidos ",str(len(results)))
            for r in results:
                print (r)
            text = input("Dime más:")
    else:
        for consulta in ["valencia","valencia AND NOT Salenko","futbol","Los Angeles AND Aeroflot"]:
                print("\n Realizando la consulta "+consulta+" ...")
                query = QueryParser("content", ix.schema).parse(consulta)
                results = searcher.search(query,limit=None)
                print("Numero de resultados obtenidos ",str(len(results)))
                for r in results:
                    print (r)
                input("Pulse una tecla para mostrar otro ejemplo...")

# elegir sobre que campo buscar
# title:gol and valencia
# title:gol  and title:valencia