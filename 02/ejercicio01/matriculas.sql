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

--CONSULTAS
SELECT nombre FROM profesores WHERE categoria = 'TEU' ;

SELECT nombre FROM profesores WHERE categoria = 'TEU' OR categoria = 'ASO6';

SELECT creditos, descripcion FROM asignaturas
ORDER BY creditos;
--PARA ORDENARLO DE MANERA DESCENDENTE
SELECT creditos, descripcion FROM asignaturas WHERE creditos > 4.5
ORDER BY creditos DESC;

SELECT creditos, descripcion FROM asignaturas ORDER BY creditos, descripcion;

--DATOS NULOS 
SELECT * FROM asignaturas WHERE creditosp IS NULL;

--CONSTANTES
SELECT 'La asignatura ', descripcion, ' tiene ', creditos, ' créditos' FROM asignaturas ORDER BY creditos;

--PARA USO DE MAS DE UNA TABLAA
SELECT nombre, descripcion FROM asignaturas, profesores; --NO ES ASI AUNQ FUNCIONa nunca tilizar porq tiene 2 tablas
SELECT nombre, descripcion FROM asignaturas, profesores, imparte WHERE imparte.dni
= profesores.dni AND asignatura = código;

SELECT * FROM asignaturas, profesores, imparte;

SELECT * FROM asignaturas, profesores, imparte
WHERE profesores.dni = imparte.dni AND asignatura = codigo;

SELECT nombre, descripcion
FROM asignaturas, profesores, imparte
WHERE profesores.dni=imparte.dni AND asignatura=codigo; --VUELVE A COMETER EL ERROR PORQUE SELECCIONA 3 TABLAS

--PARA INDICAR QUE UN VALOR ESTA ENTRE DOS COSAS CON EL BETWEEN
SELECT creditos, descripción FROM asignaturas WHERE creditos BETWEEN 5 AND 8;
--CREA UNA LISTA 
SELECT descripcion FROM asignaturas WHERE codigo in ('FBD', 'DGBD');
SELECT nombre FROM profesores p, imparte i WHERE p.dni = i.dniAND asignatura NOT IN ('HI', 'FBD', 'DGBD');

--NUSCAR AOLGO CON '% %' COMO EN PHP
SELECT * FROM profesores WHERE nombre LIKE '%RAFA%';
SELECT codigo FROM asignaturas WHERE descripcion LIKE '%BASES DE DATOS%';
SELECT codigo FROM asignaturas WHERE codigo LIKE ' '; --SE BUSCA ALGO CON 2 CARACTERTES
SELECT descripcion FROM asignaturas WHERE descripcion LIKE '%INFORMATIC_';


--CONSULTAS ANIDADAS 
SELECT descripcion, creditos FROM asignaturas WHERE creditos = (SELECT MIN(creditos) FROM asignaturas);--CONSULTAS CON MENOS CREDITOS
-- Asignaturas que tienen más créditos que la asignatura HI.
SELECT * FROM asignaturas WHERE creditos >(SELECT creditos FROM asignaturas WHERE codigo = 'HI');






--CONSULTAS DINAMICAS <-MUY IMPORTANTES
--WHERE SOLO COMPARA UN DATO NO VARIOS
--in<- es entre  , este puede buscar varios datos , si puede con una lista