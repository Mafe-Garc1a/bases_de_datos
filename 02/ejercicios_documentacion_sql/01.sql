--MATRICULA DOCUMENTACIÓN 01--

--DAMOS ESTRUCTURA A LA BASE DE DATOS--
--Tabla profesores: 
CREATE TABLE profesores (
    dni CHAR(10) PRIMARY KEY, 
    nombre VARCHAR(40), 
    categoria CHAR(4),
    ingreso DATE
) ENGINE=InnoDB;

--Tabla asignaturas: 
CREATE TABLE asignaturas (
    codigo CHAR (5) PRIMARY KEY,
    descripcion VARCHAR(35), 
    creditos FLOAT(3,1), 
    creditosp FLOAT(3,1)
) ENGINE=InnoDB; 

--Tabla imparte: 
CREATE TABLE imparte (
    dni CHAR(10), 
    asignatura CHAR(5), 
    primary key (dni, asignatura), 
    FOREIGN KEY (dni) REFERENCES profesores (dni), 
    FOREIGN KEY (asignatura)REFERENCES asignaturas (codigo)
) ENGINE=InnoDB;
-----------------------------------------------------------------------------------------------------------
--INSERTAMOS DATOS EN LAS ENTIDADES--
INSERT INTO profesores (dni, nombre, categoria, ingreso) VALUES (21111222, 'EVA GOMEZ', 'TEU', '1993-10-01'); 
INSERT INTO asignaturas(codigo, descripcion, creditos, creditosp) VALUES ('DGBD', 'DISEÑO Y GESTIÓN DE BASES DE DATOS', 6.0, 3.0);
INSERT INTO imparte (dni, asignatura) VALUES (21111222, 'DGBD');    
-----------------------------------------------------------------------------------------------------------
--ACTUALIZAMOS DATOS EN LAS ENTIDADES--
UPDATE asignaturas SET codigo ='AAA' WHERE codigo = 'DGBD'; 
UPDATE profesores SET nombre = 'EVA PEREZ' WHERE dni = '21111222'; 

--El UPDATE de la entidad imparte no se puede realizar
--esto porque contiene restricciones como lo es la llave foranea la cual le dice al sistema que 
--los datos de la PK de la entidad asignaturas deben de coincidir con la información de 
--las FK que hay en imparte, en pocas palabras ambos datos deben coincidir, lo que nos diria el MySQL seria
--“La columna asignatura en la tabla imparte debe contener solo valores que ya existen en la columna codigo de la tabla asignaturas.”
--y si cambiamos el dato de la PK no se puede cambiar el dato de la FK porque ya no existiria, ya no la encuentraria y el necesita comparar esos datos. 
--Solo por esto alteramos la entidad imparte para realizar un ON UPDATE CASCADE

ALTER TABLE imparte DROP FOREIGN KEY fk_dni_imparte;
ALTER TABLE imparte 
ADD CONSTRAINT fk_dni_imparte  
FOREIGN KEY (dni) 
REFERENCES profesores(dni) 
ON DELETE CASCADE
ON UPDATE CASCADE;

ALTER TABLE imparte DROP FOREIGN KEY imparte_ibfk_2; --imparte_ibfk_2 es el nombre de la FK que se crea automaticamente al crear la entidad imparte

ALTER TABLE imparte --Alteramos la entidad imparte
ADD CONSTRAINT fk_asignatura_imparte  --le decimos que agregue una restricción con el nombre fk_asignatura_imparte
FOREIGN KEY (asignatura) --Le asignamos un nombre  a la FK 
REFERENCES asignaturas(codigo) -- le decimos que la FK hace referencia a la PK de la entidad asignaturas y cual es el atributo en si
ON UPDATE CASCADE; --Le decimos que si se actualiza la PK de la entidad asignaturas, se actualice la FK de la entidad imparte autoaticamente

-----------------------------------------------------------------------------------------------------------
--ELIMINAMOS DATOS EN LAS ENTIDADES--
DELETE FROM asignaturas WHERE codigo = 'DGBD'; 
DELETE FROM asignaturas WHERE codigo = 'AAA'; 
DELETE FROM profesores WHERE dni = '21111222';
-----------------------------------------------------------------------------------------------------------
--INGRESO DE DATOS NUEVOS EN PROFESORES--
INSERT INTO profesores(dni, nombre, categoria, ingreso) VALUES
(21111222, 'EVA GOMEZ', 'TEU', '1993-10-01'),
(21222333 , 'MANUEL PALOMAR', 'TEU', '1989-06-16'),
(21333444, 'RAFAEL ROMERO', 'ASO6 ', '1992-06-16');

--INGRESO DE DATOS NUEVOS EN ASIGNATURAS--
INSERT INTO asignaturas(codigo, descripcion, creditos, creditosp) VALUES
('DGBD', 'DISEÑO Y GESTIÓN DE BASES DE DATOS', 6.0, 3.0),
('FBD', 'FUNDAMENTOS DE LAS BASES DE DATOS ', 6.0, 1.5),
('FP', 'FUNDAMENTOS DE LA PROGRAMACION', 9.0, 4.5),
('HI', 'HISTORIA DE LA INFORMATICA', 4.5, NULL),
('PC', 'PROGRAMACION CONCURRENTE', 6.0, 1.5);

--INGRESO DE DATOS NUEVOS EN IMPARTE--
INSERT INTO imparte(dni, asignatura) VALUES
(21111222 , 'DGBD'),
(21111222, 'FBD'),
(21333444, 'PC');
-----------------------------------------------------------------------------------------------------------
--FILTROS EN LAS CONSULTAS--

--DISTINCT
SELECT DISTINCT categoria FROM profesores;

--WHERE 
SELECT nombre FROM profesores WHERE categoria = 'TEU';
--(Se utilizan parentesis para alterar la evaluación, tambien operadores de comparación
-- >, <, >=, <=, =, != y conectivas logicas AND, OR, NOT) como por ejemplo:
SELECT nombre FROM profesores WHERE categoria = 'TEU' OR categoria = 'ASO6';

--ORDER BY (ASC, DESC) Ordenar salida de formato ascendente o descendente sin importar el tipo de dato
/*Ascendente*/ SELECT creditos, descripcion FROM asignaturas ORDER BY creditos; --ASC NO ES NECESARIO
/*Descendente*/ SELECT creditos, descripcion FROM asignaturas WHERE creditos > 4.5 ORDER BY creditos DESC; --DESC en este caso es necesario especificar
/*Ordenar de forma mas compleja (caso= 2 atributos)*/ SELECT creditos, descripcion FROM asignaturas ORDER BY creditos, descripcion;

--NULL = "ignorancia" (IS NULL, IS NOT NULL) no se pueden hacer comparaciones habituales y no es una cadena vacia
SELECT * FROM asignaturas WHERE creditosp = ''; --comilla-simple + comilla-simple = cadena vacía
SELECT * FROM asignaturas WHERE creditosp = ' '; --comilla-simple + espacio + comilla-simple = espacio_en_blanco
SELECT * FROM asignaturas WHERE creditosp = 0; 
SELECT * FROM asignaturas WHERE creditosp = NULL;  
SELECT * FROM asignaturas WHERE creditosp IS NULL; -- COMO SE DEBERIA BUSCAR REALMENTE

--CONSTANTES = EXPLICITAR el orden del select
SELECT 'La asignatura ', descripcion, ' tiene ', creditos, ' créditos'
FROM asignaturas
ORDER BY creditos;

--USO DE MÁS DE UNA TABLA = necesario para trabajar con información que se obtiene de relacionar varias tablas
/*EJEMPLO_01*/ 
SELECT nombre, descripcion FROM asignaturas, profesores; -- Funciona pero es un ERROR producto Cartesiano
--Esto que quiere decir? Que se relacionan todas las filas de una tabla con todas las filas de la otra tabla hasta crear todas las conbinaciones posibles
--Esto  ocurre porque no se ha especificado la relación entre las tablas, por lo que el sistema no sabe como relacionarlas

/*EJEMPLO_02*/
SELECT * FROM asignaturas, profesores, imparte;

/*EJEMPLO_03*/ 
SELECT * FROM asignaturas, profesores, imparte
WHERE profesores.dni = imparte.dni AND asignatura = codigo;


/*EJEMPLO_04*/
SELECT nombre, descripcion 
FROM asignaturas, profesores, imparte 
WHERE imparte.dni = profesores.dni AND asignatura=codigo;

--RESUMEN CONSULTAS: FROM==fuente de datos, WHERE==condicional para filtro de datos SELECT==extracción de datos deseados

-----------------------------------------------------------------------------------------------------------
--FILTROS DE EXPRESIONES DE SELECCIÓN DE FILAS --

--RANGOS se construyen con LOS OPERADORES BETWEEN Y AND
--SINTAXIS= expresión [NOT] BETWEEN expresión AND expresión
--EJEMPLO = Créditos y descripción de las asignaturas cuyo número de créditos está entre 5 y 8.
SELECT creditos, descripcion 
FROM asignaturas 
WHERE creditos BETWEEN 5 AND 8;

--LISTAS = Se crea una lista de un determinado valor usando el operador IN
--SINTAXIS= expresión [NOT] IN (valor1, valor2, valor3, ...)
--EJEMPLO_01 =Descripción de las asignaturas FBD y DGBD.
SELECT descripcion 
FROM asignaturas 
WHERE codigo in ('FBD', 'DGBD');
--EJEMPLO_02 = Nombre de los profesores que no imparten HI, FBD o DGBD (aqui toca utilizar la entidad imparte)
SELECT nombre
FROM profesores p, imparte
WHERE p.dni = imparte.dni
AND asignatura NOT IN ('HI', 'FBD', 'DGBD');

--SUBCADENAS DE CARACTERES = Se utiliza el operador LIKE(o MATCHES)
--SINTAXIS= expresión [NOT] LIKE cadena
--% -> según donde se encuentre el % se encuentra la parte que buscamos
-- _ -> hace referencua a un carecter cualquiera
--EJEMPLO_01 = Profesores que atiendan al nombre de 'RAFA'.
SELECT * FROM profesores WHERE nombre LIKE 'RAFA%';

--EJEMPLO_02 = Código de las asignaturas de 'Bases de Datos'
SELECT codigo FROM asignaturas WHERE descripcion LIKE '%BASES DE DATOS%';

--EJEMPLO_03 = Código de las asignaturas, siendo tal código de 2 caracteres
SELECT codigo FROM asignaturas WHERE codigo LIKE '__';

--EJEMPLO_04 = Descripción de las asignaturas cuya última palabra contiene 'INFORMATIC' y un caracter adicional.
SELECT descripcion FROM asignaturas WHERE descripcion LIKE '%INFORMATIC_%';

--CONSULTAS ANIDADAS = Se utilzan para crear busquedas mas complejas, con varios selects y no uno 
--EJEMPLO = Descripción y créditos de las asignaturas con menos créditos.
SELECT descripcion, creditos
FROM asignaturas --MIN== valor minimo/menor
WHERE creditos = (SELECT MIN(creditos) FROM asignaturas);

--DE VALOR ESCALAR == función que q devuelve un valor único cada vez que se invoca (SE OPERAM SPBRE DATOS INDIVIDUALES)
--EJEMPLO = Asignaturas que tienen más créditos que la asignatura HI.
SELECT * FROM asignaturas
WHERE creditos >(SELECT creditos FROM asignaturas WHERE codigo = 'HI');

--LISTA DE VALORES 
--SINTAXIS = expr opcompara ALL|[ANY|SOME] (orden select)
--EJEMPLO_01 = Asignaturas que tienen más créditos que las demás (asignaturas que tienen la máxima cantidad de créditos en la base de datos)
SELECT descripcion
FROM asignaturas --ALL==TODO
WHERE creditos >= ALL (SELECT creditos FROM asignaturas);

--TAMBIEN SE PUDE FORMULAR COMO: 
SELECT descripcion
FROM asignaturas
WHERE creditos = (SELECT MAX(creditos) FROM asignaturas);

--EJEMPLO_02= Nombre de las asignaturas que no son las que menos créditos tienen.
SELECT descripcion
FROM asignaturas
WHERE creditos > ANY (SELECT creditos FROM asignaturas);

--TAMBIEN SE PUEDE FORMULAR COMO:
SELECT descripcion
FROM asignaturas
WHERE creditos != (SELECT MIN(creditos) FROM asignaturas);

--EJEMPLO_03=Nombre de los profesores que imparten una asignatura que no sea la máxima en 
--número de créditos
SELECT nombre
FROM profesores p, asignaturas a, imparte i
WHERE p.dni = i.dni AND i.asignatura = a.codigo
AND creditos < ANY ( SELECT creditos FROM asignaturas );

--SINTAXIS=expr [NOT] IN (orden select)
--EJEMPLO_04=Obtener todos los datos de los profesores que imparte alguna asignatura.
SELECT * FROM profesores
WHERE dni IN (SELECT dni FROM imparte);

--EJEMPLO_05= no imparten asignaturas.
SELECT * FROM profesores
WHERE dni NOT IN (SELECT dni FROM imparte)

-- SINTAXIS:
-- expr opcompara ALL|[ANY|SOME] (orden select)
-- expr [NOT] IN (orden select)
-- expr IN (orden select) ≈ expr=ANY(orden select)
-- expr NOT IN (orden select) ≈ expr<>ALL(orden select)