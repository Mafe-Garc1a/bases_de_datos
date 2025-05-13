CREATE TABLE profesores ( 
dni CHAR(10) PRIMARY KEY, 
nombre VARCHAR(40), 
categoria CHAR(4),
ingreso DATE
) ENGINE=InnoDB;
CREATE TABLE asignaturas ( 
codigo CHAR(5) PRIMARY KEY, 
descripcion VARCHAR(35), 
creditos FLOAT(3,1),
creditosp FLOAT(3,1)
) ENGINE=InnoDB;
CREATE TABLE imparte ( 
dni CHAR(10), 
asignatura CHAR(5),
PRIMARY KEY (dni, asignatura),
FOREIGN KEY (dni) REFERENCES profesores (dni),
FOREIGN KEY (asignatura) REFERENCES asignaturas (codigo)
) ENGINE=InnoDB;


/* INSRTAMOS INFORMACION */
INSERT INTO profesores(dni,nombre,categoria,ingreso)
VALUES(21111222,'Eva Gomez','TEU','1993-10-01');
INSERT INTO asignaturas(codigo,descripcion,creditos,creditosp)
VALUES('DGBD','Diseño y gestion de bases de datos',6.0,3.0);
INSERT INTO imparte(dni,asignatura)
VALUES(21111222,'DGBD');


/* MODIFICAR DATOS */
UPDATE asignaturas SET codigo ='AAA' WHERE codigo='DGBD'; /* ES DIFICIL MODIFICAR LAS LLAVES PRIMARIAS  */
UPDATE profesores SET nombre = 'EVA PEREZ' WHERE dni = '21111222';

/* ELIINAR SENTENCIAS */
DELETE FROM asignaturas WHERE codigo='DGBD';
DELETE FROM asignaturas WHERE codigo = 'AAA';
DELETE FROM profesores WHERE dni = '21111222';


/* INSERTAR NFORMACION */
INSERT INTO profesores(dni,nombre,categoria,ingreso)
VALUES (21111223,'Manuel Palomar','TEU','1989-06-16'),
      (21111444,'Rafael Romero','ADSO','1992-06-16');
UPDATE profesores SET nombre='Eva Gomez' WHERE ingreso=1993-10-01;

INSERT INTO asignaturas(codigo,descripcion,creditos,creditosp)
VALUES('FBD','Fundamentos de las bases de datos',6.0,1.5),
('FP','Fundamentos de la programacion',9.0,4.5),
('HI','Historia de la informatica',4.5,' ' ),
('PC','Programacion concurrente',6.0,1.5);

INSERT INTO imparte(dni,asignatura)
VALUES(21115226,'DGBD'),
      (21114484,'PC');