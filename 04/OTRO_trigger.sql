--EJUEMPLO DE CUENTA------------------
CREATE DATABASE cuenta;
USE cuenta;

CREATE TABLE consigna (
    cod INT PRIMARY KEY AUTO_INCREMENT,
    cantidad DECIMAL(15,2));

CREATE TABLE saldo (
    cod INT PRIMARY KEY AUTO_INCREMENT,
    nuevo_saldo DECIMAL(15,2));

CREATE TRIGGER sum_saldo AFTER INSERT ON consigna -- SE CREA UN TRIGER que va a ser lasuma del saldodespues de que inserten la consigna
 FOR EACH ROW 
    INSERT INTO saldo (nuevo_saldo) VALUES (NEW.cantidad);--se va actualizar el saldo de la cuenta , pero esto esta mal por falta la suma
    INSERT INTO consigna (cantidad) VALUES (30000);

DROP TRIGGER sum_saldo;--borramos pa poder cambiar la tabla
--creamos eltrigger como es sumando los saldos , solo si ya hay saldos anteriores
CREATE TRIGGER sum_saldo AFTER INSERT ON consigna   
FOR EACH ROW 
    UPDATE saldo SET nuevo_saldo = nuevo_saldo + NEW.cantidad 
    WHERE cod = 1
;
INSERT INTO consigna (cantidad) VALUES (30000);--insertamos una consigna(otra)
SELECT * FROM saldo;
--esta es un forma por si no hay saldos anteriores 
DELIMITER //
CREATE TRIGGER sum_saldo AFTER INSERT ON consigna
 FOR EACH ROW
 BEGIN
    IF ( SELECT COUNT(nuevo_saldo) FROM saldo) > 0 THEN /*---le estoy diciendo q si lo que hya en saldo es mayor a 0 pueda ingresar*/
        UPDATE saldo SET nuevo_saldo = nuevo_saldo + 
        NEW.cantidad WHERE cod = 1;
    ELSE                                           /* ---sino q inserte la cantidad de la consigna*/
        INSERT INTO saldo (nuevo_saldo) 
        VALUES ((SELECT SUM(cantidad) FROM consigna));
    END IF;
 END
//
DELIMITER ;
INSERT INTO consigna (cantidad) VALUES (20000);
SELECT * FROM saldo;





----------------Vamos a crear una nueva base de datos con sus respectivas tablas y datos.-------------------
CREATE DATABASE almacen;
USE almacen;
CREATE TABLE factura (
    id_factura INT NOT NULL,
    total_factura FLOAT NOT NULL,
    fecha DATE NOT NULL,
    PRIMARY KEY (id_factura)
);
INSERT INTO factura VALUES(1, 160000, '2013-11-02');
CREATE TABLE detalle_factura (
    id_detalle INT NOT NULL,
    id_factura INT NOT NULL,
    id_articulo INT NOT NULL,
    cantidad INT NOT NULL,
    precio FLOAT NOT NULL,
    total_detalle FLOAT NOT NULL,
    PRIMARY KEY (id_detalle,id_factura) 
);
INSERT INTO detalle_factura VALUES(1, 1, 2, 3, 20000, 60000);
INSERT INTO detalle_factura VALUES(2, 1, 4, 2, 10000, 20000);
INSERT INTO detalle_factura VALUES(3, 1, 3, 4, 20000, 80000);
SHOW TABLES;
SELECT * FROM facture;
SELECT * FROM detalle_factura;

-- Lo que se pretende es actualizar en la tabla factura el campo total_factura con triggers, si se Inserta
-- INSERT, Borra DELETE o actualice UPDATE la información en la tabla detalle_factura.

-- Para INSERT.---
DELIMITER //
    CREATE TRIGGER inserto BEFORE INSERT ON detalle_factura /*--para q se inserte el drtalle factura por si no era la catidad deseada*/
    FOR EACH ROW
    BEGIN
        SET NEW.total_detalle = NEW.precio * NEW.cantidad;
        UPDATE factura 
        SET total_factura = total_factura + NEW.total_detalle
    WHERE id_factura = NEW.id_factura;
    END
//
DELIMITER ;
INSERT INTO detalle_factura VALUES(4, 1, 8, 2, 5000, 10000);
SELECT * FROM factura;
----------PARA DELETE----
DELIMITER //
    CREATE TRIGGER borro AFTER DELETE ON detalle_factura
    FOR EACH ROW
    BEGIN
        UPDATE factura  /*--q modifique la tabla factura*/
        SET total_factura = total_factura - OLD.total_detalle /*-- borrar todo lo q habia antes segun el detalle de la factura para q se actualice y se borre */
    WHERE id_factura = OLD.id_factura; /*-- donde indice de la factura sea igual al q habia antes de actualizar*/
 END
//
DELIMITER ;
DELETE FROM detalle_factura WHERE id_detalle = 3 AND id_factura = 1;
SELECT * FROM factura;

------------Para UPDATE,-------
DELIMITER //
CREATE TRIGGER actualizo BEFORE UPDATE ON detalle_factura
 FOR EACH ROW
 BEGIN
-- declaración de variable
DECLARE v_variacion FLOAT;
-- calculos
SET NEW.total_detalle = NEW.precio * NEW.cantidad; /*--para que se actualice el detalle , (digamos q si la persona comra algo mas)*/
SET v_variacion = NEW.total_detalle - OLD.total_detalle;/*--resta lo q habia antes con lo q hay ahora para q no se genere error en la factura y se cobre mas*/
-- actualizamos el total factura
UPDATE factura 
SET total_factura = total_factura + v_variacion/*--ahora se actualiz el total de la factura */
WHERE id_factura = NEW.id_factura;
 END
//
DELIMITER ;
UPDATE detalle_factura SET precio=7000, total_detalle= 14000
WHERE id_detalle = 2 AND id_factura = 1;
SELECT * FROM factura;


-- Ejercicio:
-- Supongamos que usted gestiona una base de datos de una empresa que distribuye una gran 
-- variedad de productos, por lo que el maestro de productos de esta BD es una gran tabla que 
-- contiene cientos de miles de registros. Para cada producto que cambia de precio debe realizarse un 
-- cálculo un tanto pesado, esto se realiza en un proceso nocturno todos los días.
-- Sabiendo que el programa nocturno procesa solo aquellos registros de la tabla productos cuyo 
-- campo rectangular contiene una “S” y que a su vez finaliza el cálculo actualiza el campo 
-- rectangular con una “N”.
-- Construye un disparador sobre la tabla productos para que cuando cambie el valor del campo 
-- precio marque el registro para su recalculo guardando una “S” en el campo rectangular






