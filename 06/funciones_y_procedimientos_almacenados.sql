--FUNCIONES Y PROCEDIMIENTOS ALMACENADOS MYSQL
--¿QUE SON?
-- Un procedimiento almacenado o una función es un conjunto de comandos SQL que pueden almacenarse en el servidor

--¿COMO FUNCIONAN?
-- Los procedimientos almacenados y las funciones se agrupan en un conjunto llamado rutinas (Routines).

--¿EN QUE CAOSS SE PUEDEN EMPLEAR?
-- Cuando múltiples aplicaciones cliente se escriben en distintos lenguajes o funcionan en distintas
-- plataformas, pero necesitan realizar la misma operación en la base de datos.

--FUNCIONES: 
-- Las funciones devuelven un único valor simple: un integer, un string, o algo similar.

-- EJEMPLO 01:
DELIMITER //
    CREATE FUNCTION holaMundo() RETURNS VARCHAR(20)
        RETURN 'HolaMundo';
//
DELIMITER ;
SELECT holamundo(); --imprime con el nombre de la función
SELECT holamundo() as Retorno; --da nombre a la función a la hora de imprimir

--EJEMPLO 02 con variables: 
DELIMITER //
    CREATE FUNCTION holaMundo_var() RETURNS VARCHAR(40)
        BEGIN
            DECLARE var_salida VARCHAR(40);
            SET var_salida = 'Hola Mundo desde una Variable';
        RETURN var_salida;
    END;
//
DELIMITER ;
SELECT holaMundo_var();

--EJEMPLO 03 con parametros:
DELIMITER //
    CREATE FUNCTION saludo (texto CHAR(20))
        RETURNS CHAR(50) -- este return es para la cantidad de caracteres q va tener el texto en total 
        RETURN CONCAT('Hola, ',texto,'!');
//
DELIMITER ;

--Ejecutamos la función enviando parámetros:
SELECT saludo('Mundo');
SELECT saludo('Pepito Perez');

--COMANDOS DE FUNCIONES: 
-- Para eliminar una función se usa DROP FUNCTION nombrefuncion.
DROP FUNCTION holaMundo;

-- Para observar la descripción de una función se usa SHOW CREATE FUNCTION nombrefuncion.
SHOW CREATE FUNCTION saludo\G
SHOW CREATE FUNCTION holaMundo;

-- Detalles de todos las funciones almacenadas:
SHOW FUNCTION STATUS\G
SHOW FUNCTION STATUS\holaMundo; 

-- Funciones con más de un parámetro,
DELIMITER //
CREATE FUNCTION elmayor (num1 INT, num2 INT)
RETURNS INT
    BEGIN
        DECLARE var_retorno INT;
        IF num1 > num2 THEN
            SET var_retorno = num1;
        ELSE
            SET var_retorno = num2;
        END IF;
        RETURN var_retorno;
    END;
//
DELIMITER ;

-- Ejecutamos la función enviando parámetros,
SELECT elmayor(33,25) as elMayor;
SELECT elmayor(12,28);

-- Podemos aplicar esta función dentro de una consulta.
SELECT un_campo, otro_campo, lafuncion(un_campo, otro_campo) --SELECT cantidad, precio, total(cantidad, precio)
as NombreCampo FROM tabla;                                     --AS total_pagar FROM detalle_factura

--EJEMPLO CIN BD rutinas con tabla "puntos"
SELECT competencia_1, competencia_2, elmayor(competencia_1, competencia_2)
as Mayor_Puntaje FROM puntos;


--Función con CASO o CASE,
DELIMITER //
CREATE FUNCTION prioridad (cliente_prioridad VARCHAR(1)) 
RETURNS VARCHAR(20)
    BEGIN
        CASE cliente_prioridad
            WHEN 'A' THEN --Cuando variable = 'A' entonces... RETORNE SOCIAAAAAAA
                RETURN 'Alto';
            WHEN 'M' THEN
                RETURN 'Medio';
            WHEN 'B' THEN
                RETURN 'Bajo';
            ELSE
                RETURN 'Dato no Valido';
        END CASE;
    END
//
DELIMITER ;

SELECT prioridad('M');
SELECT prioridad('B');
SELECT prioridad('S');

--Aqui vamos, las funciones anteriores eran mas que todo para entender porque se imprime y luego como hacer operaciones
--retornarlas y crear condicionales con una función CASE que las hace mas legible y son SOLO para comparar cosas simples, 
--Ahora vamos es a ver como podemos hacer consultas con o sin operaciones dentro de funciones, ejemplo claro: 

-- Función con acceso a datos

DELIMITER //
CREATE FUNCTION sumas (p_genero CHAR(1))
RETURNS INT -- devuelve la suma de una columna numérica
    BEGIN
        DECLARE var_suma INT;
        SELECT SUM(competencia_1)
        INTO var_suma
        FROM puntos
        WHERE genero = p_genero OR p_genero is NULL;
        RETURN var_suma;
    END;
//
DELIMITER ;

SELECT sumas('M');
SELECT 'Hombres' as Genero, sumas('M') as Total_Compe1;
SELECT 'Mujeres' as Genero, sumas('F') as Total_Compe1;
SELECT 'Todos' as Genero, sumas(NULL) as Total_Compe1;

-- Mostramos una sola tabla con todos los datos.
SELECT 'Hombres' as Genero, sumas('M') as Total_Compe1
UNION
SELECT 'Mujeres' as Genero, sumas('F') as Total_Compe1
UNION
SELECT 'Todos' as Genero, sumas(NULL) as Total_Compe1;


-- Ejercicio, realizar una función que calcule el total de puntos de las
-- dos competencias para cada uno de los registros y mostrarlos en una
-- nueva consulta.

DELIMITER //
CREATE FUNCTION suma_de_competencias(comp1 INT, comp2 INT)
RETURNS INT
    BEGIN 
        DECLARE suma INT; 
        SET suma = comp1 + comp2; 
        RETURN suma; 
    END; 
//
DELIMITER;

SELECT competencia_1, competencia_2, suma_de_competencias(competencia_1, competencia_2) AS sumaComp 
FROM puntos WHERE id_participante = 1;

SELECT competencia_1, competencia_2, suma_de_competencias(competencia_1, competencia_2) AS sumaComp 
FROM puntos;

--BD EJEMPLO: 
CREATE DATABASE rutinas1;
USE rutinas1;
CREATE TABLE puntos (
    id_participante INT NOT NULL,
    genero CHAR(1) NOT NULL,
    competencia_1 INT NOT NULL,
    competencia_2 INT NOT NULL,
    PRIMARY KEY (id_participante)
);
INSERT INTO puntos VALUES(1,'M', 9, 7);
INSERT INTO puntos VALUES(2,'F', 6, 8);
INSERT INTO puntos VALUES(3,'M', 9, 9);
INSERT INTO puntos VALUES(4,'F', 10, 7);
INSERT INTO puntos VALUES(5,'M', 9, 10);