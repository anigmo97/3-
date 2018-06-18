CREATE TABLE Departamento (
cod_dep CHAR(4) CONSTRAINT pk_Departamento PRIMARY KEY DEFERRABLE, 
nombre VARCHAR(50) NOT NULL , 
telefono CHAR(8) 
);


CREATE TABLE Profesor (
    dni CHAR(9) CONSTRAINT pk_Profesor PRIMARY KEY DEFERRABLE,
    nombre VARCHAR2(80) NOT NULL ,
    telefono CHAR(8) ,
    cod_dep CHAR(4) NOT NULL CONSTRAINT fk_Profesor_Departamento REFERENCES Departamento (cod_dep) DEFERRABLE,
    provincia CHAR(25) ,
    edad INTEGER
);


ALTER TABLE Departamento
ADD director CHAR(9) CONSTRAINT fk_Departamento_Profesor REFERENCES Profesor (dni) DEFERRABLE;




CREATE TABLE Asignatura (
cod_asg CHAR(5) CONSTRAINT pk_asignatura PRIMARY KEY DEFERRABLE ,
nombre VARCHAR(50) NOT NULL UNIQUE ,
semestre CHAR(2) NOT NULL CHECK (semestre IN ('1A','1B','2A','2B','3A','3B','4A','4B')), 
cod_dep CHAR(4) NOT NULL CONSTRAINT fk_asignatura_departamento REFERENCES Departamento (cod_dep) DEFERRABLE,
teoria FLOAT NOT NULL,
practicas FLOAT NOT NULL,
CHECK(teoria >=practicas)
);





CREATE TABLE Docencia (
    dni CHAR(9) CONSTRAINT fk_Docencia_Profesor REFERENCES Profesor (dni) DEFERRABLE,
    cod_asg CHAR(5) CONSTRAINT fk_Docencia_Asignatura REFERENCES Asignatura (cod_asg) DEFERRABLE,
    gteo INTEGER NOT NULL,
    gpra INTEGER NOT NULL,
    CONSTRAINT pk_Docencia PRIMARY KEY (dni, cod_asg)

);





CREATE OR REPLACE TRIGGER insert_profesor
AFTER INSERT ON Profesor 
FOR EACH ROW
DECLARE
howmany NUMBER; 
BEGIN
SELECT COUNT(*) INTO howmany FROM Docencia WHERE dni = :new.dni;
IF howmany = 0
THEN RAISE_APPLICATION_ERROR(-20000,'No puede existir un profesor sin docencia');
END IF;
END;

---MAL OLD Y NEW SOLO LO PUEDO USAR EN FOR EACH ROW
CREATE OR REPLACE TRIGGER delete_last_one_Docencia_of_Profesor
AFTER DELETE ON Docencia
DECLARE
howmany NUMBER;
BEGIN
SELECT COUNT(*) INTO howmany FROM Docencia D WHERE D.dni = :old.dni;
IF howmany = 0
THEN RAISE_APPLICATION_ERROR(-20001,"No puedes borrar una docencia a un profesor con solo una")
END IF;
END;


---MAL OLD Y NEW SOLO LO PUEDO USAR EN FOR EACH ROW
CREATE OR REPLACE TRIGGER update_dni_of_last_one_Docencia_of_Profesor
AFTER UPDATE ON Docencia
DECLARE howmany NUMBER;
BEGIN
SELECT COUNT(*) INTO howmany FROM Docencia D WHERE D.dni = :old.dni;
IF howmany=0
THEN RAISE_APPLICATION_ERROR(-20002,"No puedes modificar el dni de una docencia si la anterior se queda sin docencias")
END IF;
END; 