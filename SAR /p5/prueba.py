#!/usr/bin/env python

import os
from os import walk
import whoosh
from whoosh.index import create_in
from whoosh.fields import Schema, ID, TEXT
import re


patron_noticia = u"<DOC>([\s\S]*?)</DOC>"
patron_Titulo = u"<TITLE>([\s\S]*?)</TITLE>" 
patron_contenido = u"<TEXT>([\s\S]*?)</TEXT>"

scanner = open("./enero/19940104.sgml", 'r')
contenido = scanner.read()
text = contenido.split("</DOC>")[0]
noticias = re.findall("<TITLE>([\s\S]*?)</TITLE>",contenido)
print(len(noticias))
# for noticia in noticias:
#         print("NOTICIA ----------------\n\n")
#         print(noticia)
#         input()
#         #titulo = noticia.split("TITLE")
#         for c1 in re.findall("<TITLE>([\s\S]*?)</TITLE>",noticia):
#             print("1 = "+c1)
#             input()
print(text)
x = re.findall(u"<DOC>([\s\S]*?)</DOC>" , u"<TITLE>([\s\S]*?)</TITLE>", text)
print (x)
scanner.close()