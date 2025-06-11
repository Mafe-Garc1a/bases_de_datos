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
-- Funciones con ciclos.
-- Realizar una función que acepte un número y una potencia, ejecute la operación usando un ciclo y
-- devuelva el resultado.

DELIMITER //
CREATE FUNCTION res_potencia(numero INT, potencia INT) RETURNS INT
BEGIN
DECLARE contador INT DEFAULT 1;
DECLARE resultado INT DEFAULT 1;
WHILE contador <= potencia DO
 SET resultado = resultado * numero ;
 SET contador = contador + 1;
 END WHILE;
RETURN resultado;
END;
//
DELIMITER ;
Llamamos la función enviando parámetros.
SELECT res_potencia(2,3);
SELECT res_potencia(3,3);
SELECT res_potencia(2,4);


-- Ejercicio, realizar una función que enviado un número, devuelva el
-- resultado de sumar sus 5 primeros múltiplos, usando ciclos.
-- Ejemplo si envió por parámetros el 7
-- Resultado=(7*1)+7*2)+(7*3)+(7*4)+(7*5)
DELIMITER //
CREATE FUNCTION suma_n (numero INT)
RETURN INT 
BEGIN
    DECLARE contador INT DEFAULT 1;
    DECLARE acumulador INT DEFAULT 1;

    WHILE contador=5 DO
     SET acumulador=acumulador+(numero*contador);
     SET contador=contador+1;
    END  WHILE;
    RETURN acumulador;
END;
DELIMITER ;


-- Ejercicio, realizar una función que enviado tres notas de 0.0 a 5.0
-- por parámetros, devuelva el resultado de la nota final, teniendo en
-- cuenta que la nota1 vale el 20% la nota2 vale el 30% la nota3 vale
-- 50]%.
-- Ejemplo si envió por parámetros notas(4.5,3.0,4.7)
-- La NotaFinal= 4.2
-- Luego de Realizar la Función, utilizarla con un INSERT para completar
-- la siguiente Tabla.
DELIMITER //
 CREATE FUNCTION NotaFinal(nota1 ,nota2,nota3)
RETURN DECIMAL 
BEGIN
    DECLARE nota_F DECIMAL ;
    -- SET nota1_p=nota1*0.20;
    -- SET nota2_p=nota2*0.30;
    -- SET nota3_p=nota3*0.50;
    -- SET nota_F=nota1_p+nota2_p+nota3_p;
    SET nota_F=(nota1*0.20)+(nota2*0.30)+(nota3*0.50);
    return nota_F;
END;
DELIMITER ;

 
CREATE TABLE nota (
 id INT(4) PRIMARY KEY AUTO_INCREMENT,
 nota1 FLOAT(2,1) DEFAULT 0,
 nota2 FLOAT(2,1) DEFAULT 0,
 nota3 FLOAT(2,1) DEFAULT 0,
 final FLOAT(2,1) DEFAULT NULL
 );
INSERT INTO nota (nota1, nota2, nota3) VALUES(2.5,3.5,4.0);
INSERT INTO nota (nota1, nota2, nota3) VALUES(4.5,5.0,4.0);
INSERT INTO nota (nota1, nota2, nota3) VALUES(1.5,4.5,3.0);
INSERT INTO nota (nota1, nota2, nota3) VALUES(3.5,3.8,4.4);
INSERT INTO nota (nota1, nota2, nota3) VALUES(3.9,3.7,4.9);

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



------------------------Procedimientos--------------------------
-- Son también bloques de código que a diferencia de las funciones no devuelven ningún valor. Bajo esta
-- premisa su cometido es ligeramente distinto, puesto que no espera un resultado tras finalizar su
-- ejecución, aunque las acciones que haga el procedimiento y las posibles modificaciones de los datos
-- que realice puedan verse como el resultado de su ejecución.
-- Sirven para realizar tareas (agregar, modificar o borrar registros), o devolver resultados en forma de
-- tablas.

-- Primero creamos el procedimiento.
DELIMITER //
CREATE PROCEDURE listar_tabla ()
SELECT * FROM puntos;
//
DELIMITER ;
-- Luego llamamos el procedimiento con el comando CALL
CALL listar_tabla;

-- Procedimiento con parámetros,
DELIMITER //
CREATE PROCEDURE consultar_puntos2 (p_id INT)
SELECT * FROM puntos
WHERE id_participante = p_id OR p_id is NULL;
//
-- DELIMITER ;
-- Hacemos la llamada al procedimiento enviamos parámetros.
CALL consultar(NULL);
CALL consultar(3);
-- Podemos usar cualquier tipo de consulta.
DELIMITER //
CREATE PROCEDURE buscar_puntos(num INT)
SELECT * FROM puntos
WHERE competencia_2 > num;
//
DELIMITER ;
CALL buscar_puntos(8);