-- 1
SELECT A.nombre
FROM Autor A
WHERE A.nacionalidad='Argentina';

-- 2
SELECT O.titulo
FROM Obra O
WHERE O.titulo LIKE '%mundo%';

-- 3 

SELECT E.id_lib,COUNT(*)
FROM ESTA_EN E
WHERE E.id_lib IN (SELECT L.id_lib
                   FROM Libro L
                   WHERE L.año<1990)
GROUP BY E.id_lib
HAVING COUNT(*)>1;


o


SELECT L.id_lib,L.num_obras
FROM Libro L
WHERE L.año<1990 AND L.num_obras>1


-- 4

SELECT COUNT(*)
FROM Libro L
WHERE L.año IS NOT NULL;

-- 5

SELECT COUNT(*)
FROM Libro L
WHERE L.num_obras>1;

-- 6

SELECT L.id_lib
FROM Libro L
WHERE L.año='1997' AND L.titulo IS NULL

-- 7

SELECT L.titulo
FROM Libro L
WHERE L.titulo IS NOT NULL 
ORDER BY  L.titulo DESC;

--8

SELECT SUM(L.num_obras)
FROM Libro L
WHERE L.año BETWEEN 1990 AND 1999

            Ó

SELECT COUNT(*)
FROM Esta_en E 
WHERE E.id_lib IN (SELECT L.id_lib
                  FROM Libro L
                  WHERE L.año BETWEEN 1990 AND 1999)


-- 9

SELECT COUNT(DISTINCT(E.autor_id))
FROM Escribir E 
WHERE E.cod_ob IN (SELECT O.cod_ob
                   FROM Obra O
                   WHERE O.titulo LIKE '%ciudad%')

-- 10

SELECT O.titulo
FROM Obra O 
WHERE O.cod_ob IN (SELECT E.cod_ob
                  FROM Escribir E
                  WHERE E.autor_id = (SELECT A.autor_id
                                      FROM Autor A
                                      WHERE A.nombre = 'Camús, Albert'))
                                       -- tiene un puto espacio entre el nombre

-- 11

SELECT A.nombre
FROM Autor A
WHERE A.autor_id = (SELECT E.autor_id
                    FROM Escribir E
                    WHERE E.cod_ob = (SELECT O.cod_ob
                                      FROM Obra O
                                      WHERE O.titulo ='La tata'))

-- 12

SELECT A.nombre 
FROM Amigo A
WHERE A.num IN (SELECT L.num
                FROM Leer L
                WHERE L.cod_ob IN (SELECT ES.cod_ob
                                   FROM Escribir ES
                                   WHERE ES.autor_id = 'RUKI'))

-- 13
SELECT L.id_lib, L.titulo
FROM Libro L
WHERE L.titulo IS NOT NULL AND (SELECT COUNT(*)
                                FROM Esta_en E
                                WHERE E.id_lib = L.id_lib)>1;

-- 14

SELECT O.titulo,A.nombre
FROM (Autor A JOIN Escribir E ON A.autor_id = E.autor_id) 
              JOIN Obra O ON O.cod_ob = E.cod_ob
WHERE A.nacionalidad = 'Francesa' ;