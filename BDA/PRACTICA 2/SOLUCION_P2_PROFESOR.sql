/*
#####################
CREACIO DE LES TAULES
#####################
*/


-- si ja estan creades cal esborrar-les

DROP TABLE p2_Docencia CASCADE CONSTRAINT;
DROP TABLE p2_Departamento CASCADE CONSTRAINT;
DROP TABLE p2_Asignatura CASCADE CONSTRAINT;
DROP TABLE p2_Profesor CASCADE CONSTRAINT;



CREATE TABLE p2_Departamento (
	cod_dep CHAR(4) CONSTRAINT pk_departamento PRIMARY KEY DEFERRABLE,
	nombre VARCHAR2(50) NOT NULL,
	telefono CHAR(8),
	director CHAR(9) /* CONSTRAINT fk_departament_profesor REFERENCES p2_Profesor(dni) */
);

CREATE TABLE p2_Asignatura (
	cod_asg CHAR(5) CONSTRAINT pk_asignatura PRIMARY KEY DEFERRABLE,
	nombre VARCHAR2(50) NOT NULL UNIQUE,
	semestre CHAR(2) NOT NULL CHECK (semestre IN ('1A', '1B', '2A', '2B', '3A', '3B', '4A', '4B')),
	cod_dep CHAR(4) NOT NULL CONSTRAINT fk_asignatura_departamento REFERENCES p2_Departamento(cod_dep) DEFERRABLE,
	teoria FLOAT NOT NULL,
	practicas FLOAT NOT NULL,
	CHECK (teoria >= practicas)
);


CREATE TABLE p2_Profesor(
	dni CHAR(9) CONSTRAINT pk_profesor PRIMARY KEY DEFERRABLE,
	nombre VARCHAR2(80) NOT NULL,
	telefono CHAR(8),
	cod_dep CHAR(4) NOT NULL CONSTRAINT fk_profesor_departamento REFERENCES p2_Departamento(cod_dep) DEFERRABLE,
	provincia VARCHAR2(25),
	edad INTEGER
);


CREATE TABLE p2_Docencia(
	dni CHAR(9) CONSTRAINT fk_docencia_profesor REFERENCES p2_Profesor(dni) DEFERRABLE,
	cod_asg CHAR(5) CONSTRAINT fk_docencia_asignatura REFERENCES p2_Asignatura(cod_asg) DEFERRABLE,
	gteo INTEGER NOT NULL,
	gpra INTEGER NOT NULL,
	CONSTRAINT pk_docencia PRIMARY KEY (dni, cod_asg) DEFERRABLE
);

ALTER TABLE p2_Departamento ADD CONSTRAINT fk_departament_profesor FOREIGN KEY (director) REFERENCES p2_Profesor(dni) DEFERRABLE ;




/*
#####################
CREACIO DELS TRIGGERS
#####################

cal crear els triggers un a un

operacions que cal controlar:

- inserir en profesor
- modificar dni en docencia
- esborrar en docencia

- modificar dni en profesor no cal, per integritat referencial

*/


-- for each statement
/*
CREATE OR REPLACE TRIGGER R1_Ins_Profesor
AFTER INSERT ON p2_Profesor
DECLARE
  howmany NUMBER;
BEGIN
  SELECT COUNT(*) INTO howmany
  FROM p2_Profesor
  WHERE dni NOT IN (SELECT dni FROM p2_Docencia);
  IF howmany > 0 THEN
    RAISE_APPLICATION_ERROR (-20000, 'Tot Professor ha d''impartir doc�ncia');
  END IF;
END;
*/



CREATE OR REPLACE TRIGGER R1_Ins_Profesor
AFTER INSERT ON p2_Profesor
FOR EACH ROW
DECLARE
  howmany NUMBER;
BEGIN
  SELECT COUNT(*) INTO howmany
  FROM p2_Docencia
  WHERE dni = :new.dni;
  IF howmany = 0 THEN
    RAISE_APPLICATION_ERROR (-20000, 'Tot Professor ha d''impartir doc�ncia');
  END IF;
END;


CREATE OR REPLACE TRIGGER R1_Del_Up_Docencia
AFTER DELETE OR UPDATE OF dni ON p2_Docencia
DECLARE
  howmany NUMBER;
BEGIN
  SELECT COUNT(*) INTO howmany
  FROM p2_Profesor
  WHERE dni NOT IN (SELECT dni FROM p2_Docencia);
  IF howmany > 0 THEN
    RAISE_APPLICATION_ERROR (-20000, 'Tot Professor ha d''impartir doc�ncia');
  END IF;
END;