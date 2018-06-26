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
debug=False



def AND_NOT(p1,p2):
    #print("INICIO AND_NOT")
    res=[]
    c1 = c2 = 0
    while(c1<len(p1) and c2<len(p2)):
        if(p1[c1][0] == p2[c2][0]):
            c1+=1
            c2+=1
        elif p1[c1][0]< p2[c2][0]:
            res.append(p1[c1])
            c1+=1
        else:
            c2+=1
    while(c1 < len(p1)):
        res.append(p1[c1])
        c1+=1
    return res

def NOT(p2):
    global lista_noticias
    #print("INICIO NOT")
    c1 = c2 = 0
    res = []
    while( c2 < len(p2)):
        if(lista_noticias[c1]== p2[c2][0]):
            c1 += 1
            c2 += 1
        elif(lista_noticias[c1]< p2[c2][0]):
            res.append([lista_noticias[c1]])
            c1+=1
        else:
            c2+=1
    while( c1 < len(lista_noticias)):
        res.append([lista_noticias[c1]])
        c1+=1
    #print("FIN NOT len(res) = ",len(res))
    return res

def AND_palabras(p1,p2):
    res=[]
    c1 = c2 = 0
    while(c1<len(p1) and c2<len(p2)):
        if(p1[c1] == p2[c2]):
            res.append(p1[c1])
            c1+=1
            c2+=1
        elif p1[c1]< p2[c2]:
            c1+=1
        else:
            c2+=1
    return res

def AND(p1,p2):
    res=[]
    c1 = c2 = 0
    while(c1<len(p1) and c2<len(p2)):
        if(p1[c1][0] == p2[c2][0]):
            res.append(p2[c2])
            c1+=1
            c2+=1
        elif p1[c1][0]< p2[c2][0]:
            c1+=1
        else:
            c2+=1
    return res

def OR(p1,p2):
    c1 = c2 = 0
    l = []
    res = []
    while(c1 < len(p1) and c2 < len(p2)):
        if(p1[c1][0] == p2[c2][0]):
            l.append(p1[c1][0])
            res.append(p1[c1])
            c1+=1
            c2+=1
        elif(p1[c1][0]< p2[c2][0]):
            if(p1[c1][0] not in l):
                l.append(p1[c1][0])
                res.append(p1[c1])
                c1+=1
        else:
            if(p2[c2][0] not in l):
                l.append(p2[c2][0])
                res.append(p2[c2])
                c2+=1
    while(c1 < len(p1)):
        res.append(p1[c1])
        c1+=1
    while(c2 < len(p2)):
        res.append(p2[c2])
        c2+=1
    return res

def OR_palabras(p1,p2,k):
    c1 = c2 = 0
    res = p1
    news = [p[0] for p in p1]
    while(c2 < len(p2)):
        if(p2[c2][0] not in news):
            res.append(p2[c2])
        c2+=1
    return res

def OR_NOT(p1,p2):
    #print(len(p1)," OR NOT ",len(p2))
    p2 = NOT(p2)
    return OR(p1,p2)

def consecutivas(p1,p2,k):
    res=[]
    c1=c2 =0
    while(c1 <len(p1) and c2<len(p2)):
        if(p1[c1][0] == p2[c2][0]):
            lista_aux =[]
            lista_aux2 =[]
            l_pos1 = p1[c1][1]
            l_pos2 = p2[c2][1]
            pp1 = pp2 = 0
            while(pp1 < len(l_pos1)):
                while(pp2 < len(l_pos2)):
                    if (l_pos2[pp2]-l_pos1[pp1]==k):
                        lista_aux.append(l_pos2[pp2])
                    elif(l_pos2[pp2] > l_pos1[pp1]):
                        break
                    pp2+=1
                while(len(lista_aux)>0 and abs(lista_aux[0]-l_pos1[pp1])>k):
                    lista_aux.remove(lista_aux[0])
                if(len(lista_aux)>0):
                    lista_aux2 += lista_aux
                pp1+=1
            if(len(lista_aux2)>0):
                res.append([p1[c1][0],lista_aux2])  
            c1+=1
            c2+=1
        else:
            if(p1[c1][0] < p2[c2][0]):
                c1+=1
            else:
                c2+=1
    #print("FIN CONSECUTIVAS \n")
    #print("res consecutivas = ,",res)
    return res

def get_posting(res,parte,opcion,indice_invertido,indice_perm_1,indice_perm_varios,k,primero):
    reference = ["DATE","TEXT","CATEGORY","TITLE"]
    if(opcion in range(1,17) or opcion in range(21,37) or opcion in range(41,57) or opcion in range(61,77) ):
        parte = parte.split(":")[-1]
    elif(opcion in [17,18,19,20,57,58,59,60]):
        parte = parte.split()[1]
    elif(opcion in [37,38,39,40]):
        parte = parte.split()[2]
    #print("operacion en el diccionario ",reference[k]," con -> ",parte)
    if(opcion in range(1,81,4)):
        #print("Operacion de tipo posicional")
        parte = er.findall(parte.lower())
        lpalabras = [palabra for palabra,puntuacion in parte]
        #modificado
        lpostings = [indice_invertido.get(palabra,[]) for palabra,puntuacion in parte]
        if(len(lpostings)>1):
            primer = True
            l3 =[]
            while(len(lpostings)>0):
                if(not primer):
                    l1 = l3
                else:
                    l1 = lpostings.pop(0)
                l2 = lpostings.pop(0)
                l3 = consecutivas(l1,l2,1)
                if(primer==True):
                    primer=False
            p = l3
        else:
            #modificado
            p = indice_invertido.get(parte[0][0],[])
    elif(opcion in range(2,81,4)):
        #print("Operacion de tipo permuterm * ")
        parte += "$"
        i = parte.find("*")
        if(i == 0):
            lista_palabras = list(indice_perm_varios[parte[1:]].keys())
            # print("buscamos un sufijo ->",parte[1:])
            # print("lista palabras -> ",lista_palabras)
        elif(i == len(parte)-2):
            lista_palabras = list(indice_perm_varios[parte[:-2]].keys())
            # print("buscamos un prefijo ->",parte[:-2])
            # print("lista palabras -> ",lista_palabras)
        else:
            # print("buscamos palabras que empiecen por ",parte[:i],"\n y palabras que acaben por ",parte[i+1:])
            l_palabras_prefijo = list(indice_perm_varios[parte[:i]].keys())
            l_palabras_sufijo = list(indice_perm_varios[parte[i+1:]].keys())
            #lista_palabras = AND_palabras(l_palabras_prefijo,l_palabras_sufijo)
            lista_palabras  = list(set(l_palabras_prefijo).intersection(l_palabras_sufijo))
            #MODIFICADO
            long_palabra =(len(parte[:i])+len(parte[i+1:])-1)
            lista_palabras= [p for p in lista_palabras if len(p)>=long_palabra]
            #FIN MODIFICADO
        lpostings= [indice_invertido[l] for l in lista_palabras]
        num = [ pos[0] for p in lpostings for pos in p]
        if(len(lpostings)>1):
            le=len(lpostings)
            l3 =[]
            while(len(lpostings)>0):
                if(len(l3)>0):
                    l1 = l3
                    k=1
                else:
                    k=0
                    l1 = lpostings.pop(0)
                l2 = lpostings.pop(0)
                l3 = OR(l1,l2)
            p = l3
        else:
            p = lpostings[0]       


    elif(opcion in range(3,81,4)):
        #print("OPERACION TIPO PERMUTERM ?")
        parte = parte.replace("?","*")
        lista_palabras=indice_perm_1.get(parte,[])
        lpostings= [indice_invertido[l] for l in lista_palabras]
        noticias = [n[0] for post in lpostings for n in post]
        if(len(lpostings)>1):
            l3 =[]
            while(len(lpostings)>0):
                if(len(l3)>0):
                    l1 = l3
                    k=1
                else:
                    k=0
                    l1 = lpostings.pop(0)
                l2 = lpostings.pop(0)
                l3 = OR_palabras(l1,l2,k)
            p = l3
        else:
            p = lpostings   

    else: 
        # normales
         p = indice_invertido.get(parte,[])
    #print("\n--->",p)
    if(primero):
        if opcion in range(1,21):
            return NOT(p)
        else:
            return p
    elif(opcion in range(1, 21)):
        if(debug):print("\t\tOPERACION AND NOT")
        return AND_NOT(res,p)
    elif(opcion in range(21,41)):
        if(debug):print("\t\tOPERACION OR NOT")
        return OR_NOT(res,p)
    elif(opcion in range(41,61)):
        if(debug):print("\t\tOPERACION OR")
        return OR(res,p)
    else:
        if(debug):print("\t\tOPERACION AND")
        return AND(res,p)







def resuelve_consulta(texto):
    global dic_documentos,indice_invertido_title,indice_invertido_category,indice_invertido_date,indice_invertido_text
    global posting_list_resultado
    global indice_perm_1_text,indice_perm_varios_text
    global indice_perm_1_date,indice_perm_varios_date
    global indice_perm_1_category,indice_perm_varios_category
    global indice_perm_1_title,indice_perm_varios_title
    if(debug):print("\n\n\n")
    cont = 0
    consulta_tokenizada = er.findall(texto.lower())
    if(debug):print("\n\nCONSULTA    -> ",texto)
    texto = texto.replace("AND", "")
    if(debug):print("ELIMINAMOS AND -> ",texto)
    primer= True
    res=[]
    while(len(texto)>0):
        if(texto ==""):
            exit(0)
        patron = r"(NOT date:\".*?\")|(NOT date:\w*\*\w*)|(NOT date:\w*\?\w*)|(NOT date:\w+)|(NOT category:\".*?\")|(NOT category:\w*\*\w*)|(NOT category:\w*\?\w*)|(NOT category:\w+)|(NOT text:\".*?\")|(NOT text:\w*\*\w*)|(NOT text:\w*\?\w*)|(NOT text:\w+)|(NOT headline:\".*?\")|(NOT headline:\w*\*\w*)|(NOT headline:\w*\?\w*)|(NOT headline:\w+)|(NOT \".*?\")|(NOT \w*\*\w*)|(NOT \w*\?\w*)|(NOT \w+)|(OR NOT date:\".*?\")|(OR NOT date:\w*\*\w*)|(OR NOT date:\w*\?\w*)|(OR NOT date:\w+)|(OR NOT category:\".*?\")|(OR NOT category:\w*\*\w*)|(OR NOT category:\w*\?\w*)|(OR NOT category:\w+)|(OR NOT text:\".*?\")|(OR NOT text:\w*\*\w*)|(OR NOT text:\w*\?\w*)|(OR NOT text:\w+)|(OR NOT headline:\".*?\")|(OR NOT headline:\w*\*\w*)|(OR NOT headline:\w*\?\w*)|(OR NOT headline:\w+)|(OR NOT \".*?\")|(OR NOT \w*\*\w*)|(OR NOT \w*\?\w*)|(OR NOT \w+)|(OR date:\".*?\")|(OR date:\w*\*\w*)|(OR date:\w*\?\w*)|(OR date:\w+)|(OR category:\".*?\")|(OR category:\w*\*\w*)|(OR category:\w*\?\w*)|(OR category:\w+)|(OR text:\".*?\")|(OR text:\w*\*\w*)|(OR text:\w*\?\w*)|(OR text:\w+)|(OR headline:\".*?\")|(OR headline:\w*\*\w*)|(OR headline:\w*\?\w*)|(OR headline:\w+)|(OR \".*?\")|(OR \w*\*\w*)|(OR \w*\?\w*)|(OR \w+)|(date:\".*?\")|(date:\w*\*\w*)|(date:\w*\?\w*)|(date:\w+)|(category:\".*?\")|(category:\w*\*\w*)|(category:\w*\?\w*)|(category:\w+)|(text:\".*?\")|(text:\w*\*\w*)|(text:\w*\?\w*)|(text:\w+)|(headline:\".*?\")|(headline:\w*\*\w*)|(headline:\w*\?\w*)|(headline:\w+)|(\".*?\")|(\w*\*\w*)|(\w*\?\w*)|(\w+)"
        # NOT date:"hola" NOT date:ca*a NOT date:ca?a NOT date:casa NOT category:"aaa" NOT category:ca*sa NOT category:ca?sa NOT category:casa NOT text:"te"  NOT text:ca*a NOT text:ca?a NOT text:esd NOT headline:"titu" NOT headline:ca*sa  NOT headline:ca?sa NOT headline:casa NOT "cosa" NOT ca*sa NOT ca?sa NOT casa OR NOT date:"lis" OR NOT date:ca*sa OR NOT date:ca?sa OR NOT date:124 OR NOT category:"cat"  OR NOT category:ca*sa OR NOT category:ca?sa OR NOT category:casa OR NOT text:"cas"  OR NOT text:ca*a OR NOT text:ca?a OR NOT text:casa OR NOT headline:"sss" OR NOT headline:ca*sa  OR NOT headline:ca?sa OR NOT headline:casa OR NOT "liss" OR NOT ca*sa OR NOT ca?sa  OR NOT casa  OR date:"lis" OR date:ca*sa OR date:ca?sa OR date:124 OR category:"cat"  OR category:ca*sa OR category:ca?sa OR category:casa OR text:"cas"  OR text:ca*a OR text:ca?a OR text:casa OR headline:"sss" OR headline:ca*sa OR headline:ca?sa OR headline:casa OR "liss" OR ca*sa OR ca?sa OR casa date:"dfdf" date:ca*sa date:ca?sa date:123 category:"cat" category:ca*sa category:ca?sa  category:cat text:"tes" text:ca*sa text:ca?sa text:casa headline:"lis" headline:ca*sa headline:ca?sa headline:casa "lo es" ca*sa ca?sa casa
        primer_match = re.search(patron,texto)
        parte = primer_match.group()
        opcion = primer_match.lastindex
        if(debug):print("\n\tEl match fue -> ",parte)
        texto = texto[primer_match.span()[1]:]
        #print("El texto queda -> ",texto)
        print("\nOPCION ",opcion," ->",parte," ",len(res)," ",parte)
        
        
        if(opcion in [1,2,3,4,21,22,23,24,41,42,43,44,61,62,63,64]): #operaciones en el indice date
            if(debug):print("\tOPERACION SOBRE INDICES DATE")
            res = get_posting(res,parte,opcion,indice_invertido_date,indice_perm_1_date,indice_perm_varios_date,0,primer)
            #print("\t\t\tTRAS LAS OPERACION TENEMOS ",len(res))
        elif(opcion in [9,10,11,12,17,18,19,20,29,30,31,32,37,38,39,40,49,50,51,52,57,58,59,60,69,70,71,72,77,78,79,80]):#operaciones en el indice text
            if(debug):print("\tOPERACION SOBRE INDICES TEXT")
            res = get_posting(res,parte,opcion,indice_invertido_text,indice_perm_1_text,indice_perm_varios_text,1,primer)
            #print("\t\t\tTRAS LAS OPERACION TENEMOS ",len(res))
        elif(opcion in [5,6,7,8,25,26,27,28,45,46,47,48,65,66,67,68]):
            if(debug):print("\tOPERACION SOBRE INDICES CATEGORY")
            res = get_posting(res,parte,opcion,indice_invertido_category,indice_perm_1_category,indice_perm_varios_category,2,primer)
            #print("\t\t\tTRAS LAS OPERACION TENEMOS ",len(res))
        else:
            if(debug):print("\tOPERACION SOBRE INDICES TITLE")
            res = get_posting(res,parte,opcion,indice_invertido_title,indice_perm_1_title,indice_perm_varios_title,3,primer)
            #print("\t\t\tTRAS LAS OPERACION TENEMOS ",len(res))
        primer= False
    return res


def carga_indice(file_name):
    with open(file_name, 'rb') as fh:
        obj = pickle.load(fh)
        return obj


def syntax():
    print("\n\n"+Back.WHITE+Fore.RED+"El número de argumentos proporcionados no es el correcto"+Style.RESET_ALL)
    print (Fore.YELLOW+"\t\tSintaxis: %s Fichero_indices" % sys.argv[0])
    print ("\t\tEjemplo: %s indices.txt\n\n" % sys.argv[0] +Style.RESET_ALL)
    sys.exit()


def do_test():
    global lista_noticias
    l_querys1 = ["casa","hola","de","alzira","valencia","alzira valencia","fútbol","fútbol valencia","fútbol valencia gol","fin","fin de","fin de semana","próximo fin de semana"]
    l_querys1 += ["NOT valencia","valencia NOT alzira","valencia NOT alzira OR gol","valencia AND NOT alzira OR gol" ,"vacaciones playa OR montaña","vacaciones playa OR NOT montaña"]
    l_querys1 += ["buena noticia","mala noticia","nuestra vida","chile y perú","fin de semana","ingresos brutos","miles de personas","ciencia y tecnología","la inteligencia militar","la televisión argentina",'"buena noticia"' ,'"mala noticia"' ,'"nuestra vida"','"chile y perú"' ,'"fin de semana"' ,'"ingresos brutos"' ,'"miles de personas"' ,'"ciencia y tecnología"' ,'"la inteligencia militar"' ,'"la televisión argentina"'] 
    l_querys1 += ["headline:de" ,"headline:de AND de","headline:de OR de","category:deportes AND castellón OR category:politica AND NOT valencia","headline:europa AND category:politica AND NOT españa",'date:19940108 AND category:varios AND "agente policial"',"category:deportes OR category:varios AND date:19940105 AND NOT españa"] 
    l_querys1 += ["casa","ca*a","ca*a AND NOT casa"]
    l_querys1 += ["cosa","casa","c?sa"]
    resultados_minienero =[189,2,3552,2,107,2,189,14,5,340,340,112,28,3447,105,144,144,21,3533,5,2,22,39,112,1,47,3,16,8,2,1,1,4,76,1,16,1,2,0,933,932,3553,1267,32,2,146,189,1823,1634,32,189,215]
    resultados_enero =[894,13,16743,27,541,14,1001,72,16,1544,1544,575,187,16225,527,762,762,88,16686,18,6,74,168,575,7,175,26,43,24,11,3,6,16,403,6,74,12,3,3,4213,4204,16752,5108,76,2,146,894,8553,7659,199,894,1083]
    if(len(lista_noticias)>4000):
        resultados = resultados_enero
    else:
        resultados= resultados_minienero
    res =[]
    print(" COMENZANDO TEST...\n")

    cont = 0
    while(cont < len(l_querys1)):
        if(cont == 13):
            print("PRIMER CONJUNTO SUPERADO SIN ERRORES DE EJECUCION\n")
        elif(cont == 19):
            print("SEGUNDO CONJUNTO SUPERADO SIN ERRORES DE EJECUCION\n")
        elif(cont == 39):
            print("TERCER CONJUNTO SUPERADO SIN ERRORES DE EJECUCION\n")
        elif (cont == 46):
            print("CUARTO CONJUNTO SUPERADO SIN ERRORES DE EJECUCION\n")
        elif (cont == 49):
            print("QUINTO CONJUNTO SUPERADO SIN ERRORES DE EJECUCION\n")
        elif (cont == 52):
            print("SEXTO CONJUNTO SUPERADO SIN ERRORES DE EJECUCION\n")    
        res.append(len(resuelve_consulta(l_querys1[cont])))
        cont+=1
    c=0
    if(debug):print("\n\n\n")
    while( c < len(res)):
        if(res[c] == resultados[c]):
            print('{0:70} ==> {1:5d}'.format(l_querys1[c], res[c]))
        else:
            Style.RESET_ALL
            print(Back.WHITE+Fore.RED+'{0:70} ==> {1:5d}'.format(l_querys1[c], res[c])+"("+str(resultados[c])+")"+Style.RESET_ALL)
        c+=1
    if(debug):print("\n\n\n")
    
    exit(0)



def muestra_Resultado(res):
    global dic_documentos
    rutas = [dic_documentos[resultado[0][0]] for resultado in res[0:11]]
    num_res = len(res)
    res = res[0:11]
    num_noticia = [resultado[0][1] for resultado in res[0:11]]
    lista_contenidos = []    
    c = 0
    while c < len(res):
        scanner = open(rutas[c], 'r')
        fichero_dividido = scanner.read().split("</DOC>")
        noticia = fichero_dividido[num_noticia[c]-1]
        lista_contenidos.append(noticia)
        scanner.close()
        c+=1
    c = 0
    if(len(res)<3):
        while c < len(res):
            noticia = lista_contenidos[c]
            content = re.findall(patron_contenido,noticia)[0]
            ls = er.findall(content)
            title = re.findall(patron_Titulo,noticia)
            titulo = re.sub(r"\s+", " ", title[0])
            print("\n"+Fore.BLUE+"----------------------------------------------------------------"+Style.RESET_ALL)
            print("----",rutas[c],"   ",res[c])
            print("----------------------------------------------------------------")
            print(titulo+"\n")
            antes = ls[0:res[c][1][0]]
            ant =""
            for pal,pun in antes:
                ant+= pal+pun
            ese = ls[res[c][1][0]]
            despues = ls[res[c][1][0]+1:]
            desp=""
            for pal,pun in despues:
                desp+= pal+pun
            print(ant+Back.GREEN+ese[0]+Style.RESET_ALL+ese[1]+str(desp))
            print("\n"+Fore.BLUE+"----------------------------------------------------------------"+Style.RESET_ALL+"\n\n\n\n")
            c+=1
    elif(len(res)<6):
        while c < len(res):
            noticia = lista_contenidos[c]
            pos = res[c][1]
            content = re.findall(patron_contenido,noticia)[0]
            ls = er.findall(content)
            title = re.findall(patron_Titulo,noticia)[0]
            titulo = re.sub(r"\s+", " ", title)
            if(pos[0]>10 and pos[0] < len(content)-10):
                snippet = ls[pos[0]-10:pos[0]+10]
            elif(pos[0]>10):
                snippet = ls[pos[0]-10:]
            elif (pos[0]<len(content)-10):
                snippet = ls[:pos[0]+10]
            else:
                snippet = content
            s=""
            for t,p in snippet:
                s+=t+p

            print("\n"+Fore.BLUE+"----------------------------------------------------------------"+Style.RESET_ALL)
            print("----",rutas[c],"   ",res[c])
            print("----------------------------------------------------------------")
            print(titulo+"\n")
            print("...",s,"...")
            print("\n"+Fore.BLUE+"----------------------------------------------------------------"+Style.RESET_ALL+"\n\n\n\n")
            c+=1
        #print(rutas)
    else:
        while c < len(res):
            noticia = lista_contenidos[c]
            title = re.findall(patron_Titulo,noticia)[0]
            titulo = re.sub(r"\s+", " ", title)
            print(titulo)
            c+=1
    print("\nSe recuperaron ",num_res," resultados")


if __name__ == "__main__":
    if len(sys.argv) != 2:
        syntax()
    else:
        nombre ="./"+sys.argv[1]
        if not os.path.exists(nombre):
            raise Exception("\n\n"+Back.WHITE+Fore.RED+"           El fichero "+sys.argv[1]+" no existe"+Style.RESET_ALL+"\n\n")
    # carga indices
    dic_documentos,lista_noticias,indice_invertido_title,indice_invertido_category,indice_invertido_date,indice_invertido_text,indice_perm_1_text,indice_perm_1_title,indice_perm_1_category,indice_perm_1_date,indice_perm_varios_text,indice_perm_varios_title,indice_perm_varios_category,indice_perm_varios_date = carga_indice(sys.argv[1])
    #print(dic_documentos)
    #consecutivas([[11,[2,4]],[19,[12,24,53,54]]],[[19,[5,6,7,8,9,12,26,30,52,54,55]]])
    print("Terminos text : ",len(indice_invertido_text.keys()))
    print("Terminos category : ",len(indice_invertido_category.keys()))
    print("Terminos title : ",len(indice_invertido_title.keys()))
    print("Terminos date : ",len(indice_invertido_date.keys()))
    print("Terminos perm text : ",len(indice_perm_varios_text.keys()))
    print("Terminos perm category : ",len(indice_perm_varios_category.keys()))
    print("Terminos perm title : ",len(indice_perm_varios_title.keys()))
    print("Terminos perm date : ",len(indice_perm_varios_date.keys()),"\n\n")
    #print(list(indice_invertido_text.items())[0:11])
    # for ind in indice_perm_varios_date.keys():
    #     print(ind)
    text =" "
    while len(text) > 0:
        text = input("Inserte consulta: ")
        if(text =="test"):
            do_test()
        elif(text == ""):
            exit(0)
        res = resuelve_consulta(text)
        muestra_Resultado(res)
        print("\n"+Fore.YELLOW+"----------------------------------------------------------------")
        print("\n"+Fore.YELLOW+"-------------------------FIN CONSULTA---------------------------")
        print("\n"+Fore.YELLOW+"----------------------------------------------------------------\n\n"+Style.RESET_ALL)

