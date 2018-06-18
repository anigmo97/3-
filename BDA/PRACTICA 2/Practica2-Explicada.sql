
--SI QUIERES CREAR LA TABLA DE NUEVO
-----> DROP TABLE Y LUEGO CREATE 
SELECT * FROM USER_TABLES;

DEBO CREAR LAS TABLAS EN ORDEN CORRECTO, LA TABLA A LA QUE APUNTA UNA CAj debe crearse antes.
Departamento -> Profesor
Profesor ->Departamento
Creo una tabla sin clave ajena ( con o sin la columna)(con columna sin clave ajena),
creo la otra con clave ajena
modifico la primera tabla creada añadiendole la clave ajena.


-- Debo señalar diferible para hacerlo en diferido --> 
-- POR DEFECTO ES NO DIFERIBLE
CREATE TABLE Asignatura (
cod_asg CHAR(5) CONSTRAINT pk_asignatura PRIMARY KEY DEFERRABLE , ---> sin constraint no le pongo nombre
nombre VARCHAR(50) NOT NULL UNIQUE , -->CHAR(50) -> ES UNA CADENA DE LONGITUD FIJA (50) VARCHAR -> LONGITUD VARIABLE CON MAXIMO(50) VARCHAR2 ES MEJOR
semestre CHAR(2) NOT NULL CHECK (semestre IN {'1A','1B','2A','2B','3A','3B','4A','4B'}), --> IN {} RESTRICCION DE BUSQUEDA
cod_dep CHAR(4) NOT NULL CONSTRAINT fk_asignatura_departamento REFERENCES Departamento (cod_dep) DEFERRABLE, -- AL SER CLAVE AJENA LAS DOS TABLAS TIENE K TENER EL ELEMNETO CON EL MISMO TIPO
teoría FLOAT NOT NULL,
prácticas FLOAT NOT NULL,
--RESTRICCIONES DE MAS DE UN ATRIBUTO
-- LO CREO COMO OTRO ELEMENTO
CHECK(teoria >=practicas)
);

--Todo profesor debe impartir docencia de al menos una asignatura
-- todo lo que esta en docencia esta en profesor
-- pero no todo los de profesor en docencia
-- debo asegurarlo
-- casos que lo violan
-------> INSERT PROFESOR
-------> DELETE PROFESOR NO LO VIOLA (VIOLA LA CAj DE DOCENCIA)
-------> UPDATE DNI NO LA VIOLA, EL DNI SE PUEDE MODIFICAR EN CASCADA
-------> DELETE FILA DE DOCENCIA VIOLA ESTA RESTRICCION
-------> DELETE ASIGNATURA NO VIOLA LA RESTRICCION ( EN SI NO, PERO SI PROVOCA BORRAR DOCENCIA SI )
-------> MODIFICAR EL DNI DE DOCENCIA VIOLA ESTA RESTRICCION ( DAR LA DOCENCIA DE UN PROFESOR CON UNA SOLA DOCENCIA A OTRO)

---DEBEMOS DEFINIR UN TRIGGER PARA CADA UNO DE ESTOS TRES CASOS
-------> DELETE FILA DE DOCENCIA VIOLA ESTA RESTRICCION
-------> INSERT PROFESOR
-------> MODIFICAR EL DNI DE DOCENCIA VIOLA ESTA RESTRICCION ( DAR LA DOCENCIA DE UN PROFESOR CON UNA SOLA DOCENCIA A OTRO)

-------> INSERT PROFESOR
---DEFINIR TRIGGER
CREATE OR REPLACE TRIGGER insert_profesor_without_docencia
AFTER INSERT ON Profesor -- ANTES O DESPUES DE LA ACTUALIZACION
DECLARE
howmany NUMBER;
BEGIN
SELECT COUNT(*) INTO howmany FROM Profesor WHERE dni NOT IN (SELECT dni FROM Docencia)
IF howmany > 0
THEN RAISE_APPLICATION_ERROR(-20000,'No puede existir un profesor sin docencia') ---NUMEROS NEGATIVOS A PARTIR DEL 20000 DISPONIBLES (NO ESTANDARIZADOS)
END IF;
END;


---- OPCION MAS EFICIENTE
-- FOREACH ROW PERMITE ACCEDER AL VALOR DE LA FILA QUE ESTOY INTENTANDO AÑADIR
CREATE OR REPLACE TRIGGER insert_profesor_without_docencia
AFTER INSERT ON Profesor -- ANTES O DESPUES DE LA ACTUALIZACION
DECLARE
howmany NUMBER;
FOR EACH ROW -- si la insercion o medificacion fuese en docencia no puedo acceder a la misma tabla
BEGIN
SELECT COUNT(*) INTO howmany FROM Docencia WHERE dni = :new.dni;
IF howmany = 0
THEN RAISE_APPLICATION_ERROR(-20000,'No puede existir un profesor sin docencia') ---NUMEROS NEGATIVOS A PARTIR DEL 20000 DISPONIBLES (NO ESTANDARIZADOS)
END IF;
END;



-------> DELETE FILA DE DOCENCIA VIOLA ESTA RESTRICCION
-- no puedo FOR EACH ROW ( TENGO QUE MIRAR DOCENCIA Y SE ACTUALIZA DOCENCIA)
CREATE OR REPLACE TRIGGER delete_last_one_Docencia_of_Profesor
AFTER DELETE ON Docencia-- ANTES O DESPUES DE LA ACTUALIZACION
DECLARE
howmany NUMBER;
BEGIN
SELECT COUNT(*) INTO howmany FROM Docencia D WHERE D.dni = :old.dni;
IF howmany = 0
THEN RAISE_APPLICATION_ERROR(-20001,"No puedes borrar una docencia a un profesor con solo una")
END IF;
END;


-------> MODIFICAR EL DNI DE DOCENCIA VIOLA ESTA RESTRICCION ( DAR LA DOCENCIA DE UN PROFESOR CON UNA SOLA DOCENCIA A OTRO)
-- no puedo FOR EACH ROW ( TENGO QUE MIRAR DOCENCIA Y SE ACTUALIZA DOCENCIA)
CREATE OR REPLACE TRIGGER update_dni_of_last_one_Docencia_of_Profesor
AFTER UPDATE ON Docencia-- ANTES O DESPUES DE LA ACTUALIZACION
DECLARE howmany NUMBER;
BEGIN
SELECT COUNT(*) INTO howmany FROM Docencia D WHERE D.dni = :old.dni;
IF howmany=0
THEN RAISE_APPLICATION_ERROR(-20002,"No puedes modificar el dni de una docencia si la anterior se queda sin docencias")
END IF;
END; 

-- DEPARTAMENTO
-->NO HE DEFINIDO LA COLUMNA DIRECTOR


---HECHAS POR MI
CREATE TABLE Departamento (
    cod_dep CHAR(4) CONSTRAINT pk_Departamento PRIMARY KEY DEFERRABLE,
--cod_asg CHAR(4) CONSTRAINT fk_departamento REFERENCES Profesor (dni) DEFERRABLE , ---> sin constraint no le pongo nombre

nombre VARCHAR(50) NOT NULL , -->CHAR(50) -> ES UNA CADENA DE LONGITUD FIJA (50) VARCHAR -> LONGITUD VARIABLE CON MAXIMO(50) VARCHAR2 ES MEJOR
telefono CHAR(8) ,
-- no añado director para poder crear departamento sin violar su clave ajena
);

CREATE TABLE Profesor (
    dni CHAR(9) CONSTRAINT pk_Profesor PRIMARY KEY DEFERRABLE,
    nombre VARCHAR2(80) NOT NULL ,
    telefono CHAR(8) ,
    cod_dep CHAR(4) NOT NULL CONSTRAINT fk_Profesor_Departamento REFERENCES Departamento (cod_dep) DEFERRABLE,
    provincia CHAR(25) ,
    edad INTEGER
);

CREATE TABLE Docencia (
    dni CHAR(9) CONSTRAINT fk_Docencia_Profesor REFERENCES Profesor (dni) DEFERRABLE,
    cod_asg CHAR(5) CONSTRAINT fk_Docencia_Asignatura REFERENCES Asignatura (cod_asg) DEFERRABLE,
    gteo INTEGER NOT NULL,
    gpra INTEGER NOT NULL,
    CONSTRAINT pk_Docencia PRIMARY KEY (dni, cod_asg)

);

ALTER TABLE Departamento
ADD director CHAR(9) CONSTRAINT fk_Departamento_Profesor REFERENCES Profesor (dni) DEFERRABLE;



---EN CASO DE ERROR
ALTER TABLE Departamento DROP COLUMN director;
DROP TABLE DOCENCIA;
DROP TABLE ASIGNATURA;
DROP TABLE PROFESOR;
DROP TABLE DEPARTAMENTO;



--SEGUNDA SESION
--
--
--
--HAY QUE DIFERIR LAS CLAVES AJENAS PARA HACER LAS INSERCIONES
-- y aseguarme de que tienen docencia cuando se inserta el profesor
-- solucion docencia antes del profesor --> docencia tiene clave ajena (diferir)
-- docencia a profesor (diferrable)

--BEGIN TRANSACTION;

SET CONSTRAINT FK_Docencia_Asignatura DEFERRED;
DELETE FROM ASIGNATURA;
SET CONSTRAINT FK_Docencia_Profesor DEFERRED;
SET CONSTRAINT FK_Profesor_Departamento DEFERRED;
DELETE FROM DEPARTAMENTO;
DELETE FROM Profesor;
DELETE FROM Docencia;
COMMIT;

SET CONSTRAINT FK_Docencia_Profesor DEFERRED;
SET CONSTRAINT FK_Docencia_Asignatura DEFERRED;
SET CONSTRAINT FK_Departamento_Profesor DEFERRED;
INSERT INTO Departamento VALUES ('DLA', 'Ling��stica Aplicada', 2255, 111);
INSERT INTO Departamento VALUES ('DMA', 'Matem�tica Aplicada', 1256, NULL);
INSERT INTO Departamento VALUES ('DSIC', 'Sistemas Inform�ticos y Computaci�n', 1542, 453);
INSERT INTO Docencia VALUES (111, '11547', 1, 3);
INSERT INTO Docencia VALUES (123, '11545', 0, 2);
INSERT INTO Docencia VALUES (123, '11547', 1, 1);
INSERT INTO Docencia VALUES (453, '11547', 2, 1);
INSERT INTO Docencia VALUES (564, '11545', 2, 2);
INSERT INTO Profesor VALUES (111, 'Luisa Bos P�rez', NULL, 'DMA', 'Alicante', 33);
INSERT INTO Profesor VALUES (123, 'Juana Cerd� P�rez', 3222, 'DMA', 'Valencia', 50);
INSERT INTO Profesor VALUES (453, 'Elisa Rojo Amando', 7859, 'DSIC', 'Valencia', 26);
INSERT INTO Profesor VALUES (564, 'Pedro Mart� Garc�a', 3412, 'DMA', 'Castell�n', 27);
INSERT INTO Asignatura VALUES ('11545', 'An�lisis Matem�tico', '1A', 'DMA', 4.5, 1.5);
INSERT INTO Asignatura VALUES ('11546', '�lgebra', '1B', 'DMA', 4.5, 1.5);
INSERT INTO Asignatura VALUES ('11547', 'Matem�tica Discreta', '1A', 'DMA', 4.5, 1.5);
INSERT INTO Asignatura VALUES ('11548', 'Bases de Datos y Sistemas de Informaci�n', '3A', 'DSIC', 4.5, 1.5);
COMMIT; 




--CREATE VIEW

DROP VIEW ASIGNATURAS_PRIMER_CURSO;


CREATE VIEW Asignaturas_primer_curso AS
SELECT * FROM Asignatura 
WHERE semestre IN('1A','1B');


Select * from ASIGNATURAS_PRIMER_CURSO;

Select * from ABISRES.ASIGNATURAS_PRIMER_CURSO;

--GRANT
GRANT
{ ALL |
 SELECT |
 INSERT [(nom_atr1,…, nom_atrn)] |
 DELETE |
 UPDATE [(nom_atr1,…, nom_atrn)]}
ON nom_relación TO {usuario1,…, usuariom | PUBLIC}
[WITH GRANT OPTION]



GRANT SELECT, INSERT, UPDATE, DELETE ON ASIGNATURAS_PRIMER_CURSO TO ABISRES;
GRANT SELECT, INSERT, UPDATE, DELETE ON ASIGNATURAS_PRIMER_CURSO TO AKPUN;


--ORACLE GARANTIZA TODO MENOS LA ATOMICIDAD SI SOLO SE VIOLAN EN DIFERIDO SE GARANTIZA ATOMICIDAD


CREATE VIEW ASIGS_SELECT AS
SELECT * FROM Asignatura 
WHERE semestre IN('1A','1B');

CREATE VIEW ASIGS_INSERT AS
SELECT * FROM Asignatura 
WHERE semestre IN('1A','1B');

CREATE VIEW ASIGS_DELETE AS
SELECT * FROM Asignatura 
WHERE semestre IN('1A','1B');

CREATE VIEW ASIGS_UPDATE AS
SELECT * FROM Asignatura 
WHERE semestre IN('1A','1B');

GRANT SELECT ON sys.sql_logins TO Sylvester1;  
--GRANT VIEW SERVER STATE to Sylvester1; 

GRANT SELECT ON ASIGS_SELECT TO AKPUN;
GRANT INSERT ON ASIGS_INSERT TO AKPUN;
GRANT UPDATE ON ASIGS_UPDATE TO AKPUN;
GRANT DELETE ON ASIGS_DELETE TO AKPUN;


GRANT INSERT, UPDATE, DELETE ON employees TO smithj;



