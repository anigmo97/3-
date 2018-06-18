SELECT DISTINCT cod_pais
FROM CS_ACTOR
ORDER BY cod_pais;


SELECT cod_peli,titulo
FROM CS_PELICULA
WHERE ANYO <'1970'
        AND COD_LIB IS NULL;

SELECT cod_act, nombre
FROM CS_ACTOR
WHERE nombre LIKE '%John%';