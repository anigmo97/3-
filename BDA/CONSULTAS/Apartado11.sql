## 1
SELECT codigo,tipo,premio,color
FROM maillot;
## 2
SELECT dorsal,nombre
FROM ciclista
WHERE edad <= 25;

## 3
SELECT nompuerto,altura
FROM puerto
WHERE categoria='E';
## 4
SELECT netapa
FROM ETAPA
WHERE salida=llegada;

## 5
SELECT COUNT(*)
FROM ciclista;

## 6
SELECT COUNT(*)
FROM ciclista
WHERE edad >'25';
## 7
SELECT COUNT(*)
FROM equipo;

## 8
SELECT AVG(edad)
FROM ciclista;
## 9
SELECT MAX(altura), MIN(altura)
FROM puerto;

## 10
SELECT p.nompuerto,p.categoria
FROM puerto p, ciclista c
WHERE p.dorsal = c.dorsal AND c.nomeq ='Banesto';
## 11
SELECT p.nompuerto,p.netapa,e.km
FROM puerto p, etapa e
WHERE p.netapa=e.netapa;
## 12
SELECT e.nomeq,e.director
FROM equipo e, ciclista c
WHERE EXISTS (SELECT *
                FROM c
                WHERE c.edad >33 AND e.nombre = c.nombre);
## 13
SELECT  DISTINCT c.nombre,m.color
FROM ciclista c,maillot m, llevar lle
WHERE c.dorsal = lle.dorsal AND lle.codigo = m.codigo;
## 14
SELECT  DISTINCT c.nombre,e.netapa
FROM ciclista c, llevar ll, etapa e, maillot m
WHERE c.dorsal = ll.dorsal 
AND c.dorsal = e.dorsal 
AND m.codigo = ll.codigo 
AND EXISTS (SELECT *
            FROM maillot m2, llevar lle2
            WHERE lle2.dorsal = c.dorsal
            AND m2.codigo = lle2.codigo
            AND m2.color='Amarillo');

## 15
SELECT e2.netapa 
FROM etapa e,etapa e2
WHERE e2.salida<>e.llegada AND e2.netapa= e.netapa+1;
##16
SELECT e.netapa,e.salida
FROM Etapa e
WHERE NOT EXISTS (SELECT *
                  FROM Puerto p
                  WHERE p.netapa=e.netapa);
## 17
SELECT AVG(c.edad)
FROM Ciclista c
WHERE c.dorsal IN (SELECT e.dorsal
                   FROM Etapa e)
## 18
SELECT p.nompuerto
FROM Puerto p
WHERE p.altura > (SELECT AVG(pu.altura)
                  FROM Puerto pu)
## 19
SELECT e.salida,e.llegada
FROM Etapa e
WHERE e.netapa = (SELECT pu.netapa
                 FROM Puerto pu
                 WHERE pu.pendiente =  (SELECT MAX(p.pendiente)
                                        FROM Puerto p))
## 20
SELECT c.dorsal,c.nombre
FROM Ciclista c
WHERE c.dorsal IN (SELECT pu.dorsal
                 FROM Puerto pu
                 WHERE pu.altura =(SELECT MAX(p.altura)
                                   FROM Puerto p))

## 21
SELECT c.nombre
FROM Ciclista c
WHERE c.edad = (SELECT MIN(c1.edad)
                 FROM Ciclista c1)

## 22
SELECT c.nombre,c.edad
FROM Ciclista c
WHERE c.edad = (SELECT MIN(c1.edad)
                 FROM Ciclista c1
                 WHERE c1.dorsal IN ( SELECT e.dorsal
                                      FROM Etapa e))
    and
    c.dorsal IN ( SELECT e.dorsal
                                      FROM Etapa e);
## 23
SELECT c.nombre
FROM Ciclista c
WHERE c.dorsal IN (SELECT p.dorsal
                   FROM Puerto p)
           AND 
        (SELECT COUNT(p1.dorsal)
         FROM Puerto p1
         WHERE p1.dorsal=c.dorsal)>1;

## 24

SELECT e.netapa
FROM Etapa e
WHERE NOT EXISTS (SELECT *
                  FROM Puerto p
                  WHERE p.altura <'700' AND p.netapa = e.netapa)
                  AND EXISTS (SELECT *
                              FROM Puerto pu
                              WHERE pu.netapa = e.netapa);
## 25 

SELECT e.nomeq,e.director
FROM Equipo e
WHERE NOT EXISTS (SELECT *
                  FROM Ciclista c
                  WHERE c.nomeq = e.nomeq
                           AND 
                        c.edad < 26)
            AND 
            
        EXISTS (SELECT *
                FROM Ciclista c1
                WHERE c1.nomeq= e.nomeq)
ORDER BY e.nomeq;    

## 26 

SELECT c.dorsal,c.nombre
FROM Ciclista c
WHERE EXISTS (SELECT *
              FROM Etapa e
              WHERE e.dorsal = c.dorsal)
              
              AND NOT EXISTS (SELECT *
                              FROM Etapa e1
                              WHERE e1.dorsal = c.dorsal 
                                        AND 
                                    e1.km <=170)
ORDER BY c.dorsal;

## 27
SELECT c.nombre
FROM Ciclista c
WHERE           EXISTS (SELECT e.dorsal
                        FROM Etapa e
                        WHERE e.dorsal = c.dorsal
                                   AND 
                        EXISTS     (SELECT *
                                    FROM Puerto p1
                                    WHERE p1.netapa = e.netapa
                                    
                            AND NOT EXISTS(SELECT *
                                           FROM Puerto p
                                           WHERE p.netapa = e.netapa
                                           AND p.dorsal<>c.dorsal)));

## 28 
SELECT e.nomeq
FROM Equipo e
WHERE EXISTS (SELECT *
              FROM Ciclista c
              WHERE c.nomeq = e.nomeq)
     AND NOT EXISTS (SELECT *
                     FROM Ciclista c
                     WHERE c.nomeq = e.nomeq
                                 AND 
                                 c.dorsal NOT IN (SELECT p.dorsal
                                                  FROM Puerto p)
                                 AND
                                 c.dorsal NOT IN (SELECT ll.dorsal
                                                  FROM Llevar ll));

## 29
SELECT m.codigo,m.color
FROM Maillot m
WHERE EXISTS(SELECT *
             FROM Llevar ll
             WHERE ll.codigo = m.codigo)
      AND (SELECT COUNT(DISTINCT(nomeq))
           FROM Ciclista c
           WHERE c.dorsal IN (SELECT llev1.dorsal
                              FROM Llevar llev1
                              WHERE llev1.codigo=m.codigo))=1;

## 30
SELECT e.nomeq
FROM Equipo e
WHERE EXISTS (
SELECT c.nombre
FROM Ciclista c
WHERE c.nomeq = e.nomeq
            AND c.dorsal IN (SELECT p.dorsal
                   FROM Puerto p
                   WHERE p.dorsal= c.dorsal 
                               AND
                        p.categoria = '1')
                        AND c.dorsal NOT IN (SELECT p1.dorsal
                                             FROM Puerto p1
                                             WHERE p1.categoria<>'1'))
            AND NOT EXISTS (SELECT c2.nombre
FROM Ciclista c2
WHERE c2.nomeq = e.nomeq
            AND c2.dorsal IN (SELECT p1.dorsal
                                             FROM Puerto p1
                                             WHERE p1.categoria<>'1'));
## 31
SELECT e.netapa,COUNT(*)
FROM Etapa e,Puerto p
WHERE p.netapa = e.netapa
GROUP BY e.netapa
ORDER BY e.netapa;
                    
## 32 
SELECT e.nomeq,COUNT(*)
FROM Equipo e,Ciclista c
WHERE c.nomeq = e.nomeq
GROUP BY e.nomeq
ORDER BY e.nomeq;

## 33
(SELECT e.nomeq,COUNT(*)
FROM Equipo e,Ciclista c
WHERE c.nomeq = e.nomeq
GROUP BY e.nomeq
) UNION 
(SELECT e1.nomeq, 0
 FROM Equipo e1
 WHERE NOT EXISTS (SELECT *
                    FROM Ciclista c2
                    WHERE c2.nomeq = e1.nomeq));
## 34 
SELECT e.director,e.nomeq
FROM Equipo e,Ciclista c
WHERE c.nomeq = e.nomeq
GROUP BY e.nomeq,e.director
HAVING COUNT(*)>3 AND AVG(c.edad)<=30
ORDER BY e.director;

## 35 
SELECT c.nombre,COUNT(*)
FROM Ciclista c, Etapa e
WHERE e.dorsal = c.dorsal
              AND 
        c.nomeq IN (SELECT e1.nomeq
                    FROM Equipo e1
                    WHERE e1.nomeq IN (SELECT c5.nomeq
                                 FROM Ciclista c5,Equipo e5
                                 WHERE c5.nomeq = e5.nomeq
                                 GROUP BY c5.nomeq
                                 HAVING COUNT(*)>5))
GROUP BY c.nombre
ORDER BY c.nombre;

## 36 
SELECT e.nomeq, avg(c.edad)
FROM Equipo e JOIN Ciclista c ON c.nomeq = e.nomeq
GROUP BY e.nomeq
HAVING AVG(c.edad) =(SELECT MAX(AVG(c1.edad))
                   FROM Equipo e1,Ciclista c1
                   WHERE E1.nomeq = c1.nomeq
                   GROUP BY e1.nomeq);

SELECT e.nomeq, avg(c.edad)
FROM Equipo e JOIN Ciclista c ON c.nomeq = e.nomeq
GROUP BY e.nomeq
HAVING AVG(c.edad) =(SELECT MAX(AVG(c1.edad))
                    FROM Equipo e1 JOIN Ciclista c1
                    ON E1.nomeq = c1.nomeq
                    GROUP BY e1.nomeq);

## 37

SELECT eq.director
FROM Equipo eq
WHERE eq.nomeq IN(
SELECT e.nomeq
                  FROM (Equipo e JOIN Ciclista c ON c.nomeq=e.nomeq)JOIN Llevar ll ON ll.dorsal = c.dorsal
                  GROUP BY e.nomeq
                  HAVING COUNT(ll.dorsal) = (SELECT MAX(COUNT(lle.dorsal))
                                          FROM (Equipo e1 JOIN Ciclista c1 ON c1.nomeq = e1.nomeq)
                                          JOIN Llevar lle ON lle.dorsal = c1.dorsal
                                          GROUP BY e1.nomeq));


##-----------------------------------------------------------
SELECT e.director
FROM (Equipo e JOIN Ciclista c ON c.nomeq=e.nomeq)JOIN Llevar ll ON ll.dorsal = c.dorsal
GROUP BY e.director
HAVING COUNT(ll.dorsal) = (SELECT MAX(COUNT(lle.dorsal))
                           FROM (Equipo e1 JOIN Ciclista c1 ON c1.nomeq = e1.nomeq)
                           JOIN Llevar lle ON lle.dorsal = c1.dorsal
                           GROUP BY e1.nomeq);


## 38
SELECT m.codigo,m.color
FROM Maillot m 
WHERE EXISTS (SELECT *
              FROM llevar ll
              WHERE ll.codigo = m.codigo
                        AND 
                 ll.dorsal IN ( SELECT c.dorsal
                                FROM Ciclista c
                                WHERE NOT EXISTS (SELECT *
                                                  FROM Etapa e 
                                                  WHERE e.dorsal = c.dorsal)))
ORDER BY m.color;

## ------------------o------------------------------
SELECT m.codigo,m.color
FROM Maillot m 
WHERE m.codigo IN (SELECT ll.codigo
                  FROM Llevar ll
                  WHERE ll.dorsal IN
                  (SELECT c.dorsal
                   FROM Ciclista c
                         MINUS
                  SELECT e.dorsal
                  FROM Etapa e))
ORDER BY m.color;

## 39 

SELECT e.netapa, e.salida,e.llegada
FROM Etapa e
WHERE e.km >190
        AND 
    (SELECT COUNT(p.netapa)
     FROM Puerto p
     WHERE p.netapa = e.netapa)>1;

## ---------------------------------o--------------------------
SELECT e.netapa, e.salida,e.llegada
FROM Etapa e JOIN Puerto p ON p.netapa = e.netapa
WHERE e.km>190
GROUP BY e.netapa,e.salida,e.llegada
HAVING COUNT(*)>1;

## 40

(SELECT c1.dorsal,c1.nombre
FROM Ciclista c1)
              MINUS
(SELECT c.dorsal,c.nombre
FROM Ciclista c
WHERE    (SELECT COUNT(DISTINCT lle.codigo)
          FROM Llevar lle
          WHERE lle.dorsal = c.dorsal
                      AND
                lle.codigo IN(SELECT ll.codigo
                              FROM Llevar ll
                              WHERE ll.dorsal='20'))
                              
                              =
                              
                              (SELECT COUNT(DISTINCT lle2.codigo)
                              FROM Llevar lle2
                              WHERE lle2.dorsal=2));








## 41
SELECT c.dorsal,c.nombre
FROM Ciclista c
WHERE     EXISTS (SELECT *
                  FROM Llevar ll2
                  WHERE ll2.codigo IN 
                                      (SELECT ll.codigo
                                      FROM llevar ll
                                      WHERE codigo IN (SELECT lle.codigo
                                                      FROM Llevar lle
                                                      WHERE lle.dorsal='20'))
                                AND
                    Ll2.dorsal = c.dorsal)
ORDER BY c.dorsal;

SELECT c.dorsal,c.nombre
FROM Ciclista c
WHERE      EXISTS ( SELECT *
                  FROM (
                          SELECT lle.codigo
                          FROM Llevar lle
                          WHERE lle.dorsal='20')
                                    INTERSECT
                          (SELECT ll.codigo
                          FROM llevar ll
                          WHERE ll.dorsal =c.dorsal  
                          )
                    )                   
ORDER BY c.dorsal;

## 42

SELECT c.dorsal,c.nombre
FROM Ciclista c
WHERE   NOT EXISTS (SELECT *
                      FROM Llevar lle
                      WHERE lle.dorsal = c.dorsal
                                  AND
                            lle.codigo IN(SELECT ll.codigo
                                          FROM Llevar ll
                                          WHERE ll.dorsal='20'))
                                          
                                        ;


## 43
SELECT c.dorsal,c.nombre
FROM Ciclista c
WHERE  c.dorsal <>20
AND
(SELECT COUNT(DISTINCT lle.codigo)
          FROM Llevar lle
          WHERE lle.dorsal = c.dorsal
                      AND
                lle.codigo IN(SELECT ll.codigo
                              FROM Llevar ll
                              WHERE ll.dorsal='20'))
                              
                              =
                              
                              (SELECT COUNT(DISTINCT lle2.codigo)
                              FROM Llevar lle2
                              WHERE lle2.dorsal=2);

## 44

SELECT c.dorsal,c.nombre
FROM Ciclista c
WHERE  c.dorsal <>20 AND
           NOT EXISTS (SELECT *
                      FROM Llevar lle
                      WHERE lle.dorsal = c.dorsal
                                  AND
                            lle.codigo NOT IN(SELECT ll.codigo
                                           FROM Llevar ll
                                           WHERE ll.dorsal='20'))
                    AND
                    (SELECT COUNT(DISTINCT lle.codigo)
          FROM Llevar lle
          WHERE lle.dorsal = c.dorsal
                      AND
                lle.codigo IN(SELECT ll.codigo
                              FROM Llevar ll
                              WHERE ll.dorsal='20'))
                              
                              =
                              
                              (SELECT COUNT(DISTINCT lle2.codigo)
                              FROM Llevar lle2
                              WHERE lle2.dorsal=2);

## 45 

SELECT c.dorsal,c.nombre,ll.codigo,m.color--,--COUNT(e.km)
FROM Ciclista c JOIN Llevar ll ON c.dorsal = ll.dorsal 
           LEFT JOIN Etapa e ON e.netapa = ll.netapa
           LEFT JOIN Maillot m ON ll.codigo = m.codigo
GROUP BY c.dorsal,c.nombre,ll.codigo,m.color
HAVING COUNT(e.km) = (SELECT MAX(COUNT (e.km))
                     FROM Ciclista c JOIN Llevar ll ON c.dorsal = ll.dorsal 
                     LEFT JOIN Etapa e ON e.netapa = ll.netapa
                     GROUP BY c.dorsal,c.nombre,ll.codigo
                     );

## 46

SELECT c.dorsal,c.nombre
FROM Ciclista c
WHERE (SELECT COUNT(DISTINCT m.tipo)
       FROM Maillot m
       WHERE m.codigo IN (SELECT ll.codigo
                          FROM Llevar ll
                          WHERE ll.dorsal = 1))
                          
                          =
                          (SELECT COUNT(DISTINCT m1.tipo)
                           FROM Maillot m1
                           WHERE m1.codigo  IN 
                                                        (SELECT ll.codigo
                                                                  FROM Llevar ll
                                                                  WHERE ll.dorsal = 1)
                                                                  
                                        AND 
                                        
                                        m1.codigo IN (SELECT lle2.codigo
                                                          FROM Llevar lle2
                                                          WHERE lle2.dorsal = c.dorsal))+3;

## 47

SELECT p.netapa, e.km
FROM Puerto p JOIN Etapa e ON e.netapa = p.netapa
GROUP BY p.netapa,e.km
ORDER BY p.netapa