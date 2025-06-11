--OTRO EJEMPLO DE TIGGER

--BD DE CUENTAS

--Creamos bd
CREATE DATABASE cuenta; 
USE cuenta; 

--Creamos tablas y trigger
CREATE TABLE consigna (
    cod INT PRIMARY KEY AUTO_INCREMENT, 
    cantidad DECIMAL(15,2)); 

CREATE TABLE saldo (
    cod INT PRIMARY KEY AUTO_INCREMENT, 
    nuevo_saldo DECIMAL(15,2)); 

--Intento 1
--CREAMOS UN TRIGGER que va a ser la suma del saldo despues de que inserten datos en la tabla consigna
--OJO está mal porque no se suma con el saldo anterior, solo inserta el nuevo
CREATE TRIGGER sum_saldo AFTER INSERT ON consigna 
    FOR EACH ROW  
        INSERT INTO saldo (nuevo_saldo) VALUES (NEW.cantidad); 
        INSERT INTO consigna (cantidad) VALUES (30000); 

--------------------------------------------------------------------------------------------------------
--Intento 2
--Borramos el trigger para poder cambiar la tabla
DROP TRIGGER sum_saldo;
--Creamos nuevamente el tigger como es sumando los saldos NEW AND OLD
--OJO no esta del todo mal pero tampoco esta bien, ¿Y si es mi primer saldo al ingresar? No tendría con que sumarlo
    CREATE TRIGGER sum_saldo AFTER INSERT ON consigna 
    FOR EACH ROW  
        UPDATE saldo SET nuevo_saldo = nuevo_saldo + NEW.cantidad  
        WHERE cod = 1 
        ; 

INSERT INTO consigna (cantidad) VALUES (30000); 
SELECT * FROM saldo;
--------------------------------------------------------------------------------------------------------
--Intento 3
--Borramos el trigger para poder cambiar la tabla
DROP TRIGGER sum_saldo; 

--Creamos el trigger que suma los saldos, solo si ya hay saldos anteriores
--OJO hemos mejorado el trigger pero aun le falta, si bien COUNT * nos sirve como un contador y en este caso nos ayuda a verificar 
--si hay saldos mayores a 0 no serviria para varios usuarios/clientes, no especifica en la condicional si el saldo que desea
--actualizar es del usuario 1 en este caso, entonces cada que encuentre un saldo mayor a 0 SIN IMPORTAR DE QUIEN SEA, lo sumara al usuario 1
DELIMITER // 
CREATE TRIGGER sum_saldo AFTER INSERT ON consigna 
    FOR EACH ROW 
    BEGIN 
        IF ( SELECT COUNT(nuevo_saldo) FROM saldo) > 0 THEN 
            UPDATE saldo SET nuevo_saldo = nuevo_saldo + 
            NEW.cantidad WHERE cod = 1; 
        ELSE 
            INSERT INTO saldo (nuevo_saldo)  
            VALUES ((SELECT SUM(cantidad) FROM consigna)); 
        END IF; 
    END 
// 
DELIMITER ; 
INSERT INTO consigna (cantidad) VALUES (20000); 
SELECT * FROM saldo;

--Quedaria mas bien asi: 
--Si existe significa que ya hay un saldo para ese usuario, entonces actualizamos el saldo sumando la nueva cantidad
--Si no existe, significa que es el primer saldo para ese usuario, entonces insertamos un nuevo registro con la cantidad inicial
IF EXISTS (SELECT 1 FROM saldo WHERE usuario_id = NEW.usuario_id) THEN
    UPDATE saldo 
    SET nuevo_saldo = nuevo_saldo + NEW.cantidad 
    WHERE usuario_id = NEW.usuario_id;
ELSE
    INSERT INTO saldo (usuario_id, nuevo_saldo) 
    VALUES (NEW.usuario_id, NEW.cantidad);
END IF;

--------------------------------------------------------------------------------------------------------
--Parentesis 
--PALABRAS CLAVE OLD & NEW --no son sencibles a mayusculas y nos permiten acceder a columnas en los registros afectados por un 
--disparador. 

--¿COMO SE PUEDE UTILIZAR EN SENTENCIAS?
--INSERT:  solamente puede utilizarse NEW.nom_col; ya que no hay una versión anterior del registro. 
--DELETE:sólo puede emplearse OLD.nom_col, porque no hay un nuevo registro.  
--UPDATE:  se puede emplear OLD.nom_col para referirse a las columnas de un  registro antes de que sea actualizado, y 
    --NEW.nom_col para referirse a las columnas del registro luego de actualizarlo.

--------------------------------------------------------------------------------------------------------
--OTRO EJEMPLO DE TIGGER

--Creamos bd de un almacen
CREATE DATABASE almacen; 
USE almacen; 

--Creamos tabla factura con sus respectivos campos 
CREATE TABLE factura ( 
    id_factura INT NOT NULL, 
    total_factura FLOAT NOT NULL, 
    fecha DATE NOT NULL, 
    PRIMARY KEY (id_factura) 
); 
--Ingresamos un registro a la tabla factura
INSERT INTO factura VALUES(1, 160000, '2013-11-02'); 

--Creamos la tabla detalle_factura con sus respectivos campos
CREATE TABLE detalle_factura ( 
    id_detalle INT NOT NULL, 
    id_factura INT NOT NULL, 
    id_articulo INT NOT NULL, 
    cantidad INT NOT NULL, 
    precio FLOAT NOT NULL, 
    total_detalle FLOAT NOT NULL, 
    PRIMARY KEY (id_detalle,id_factura)   
);
--Ingresamos registros a la tabla detalle_factura
INSERT INTO detalle_factura VALUES(1, 1, 2, 3, 20000, 60000); 
INSERT INTO detalle_factura VALUES(2, 1, 4, 2, 10000, 20000); 
INSERT INTO detalle_factura VALUES(3, 1, 3, 4, 20000, 80000);

SHOW TABLES: 
SELECT * FROM facture; 
SELECT * FROM detalle_factura; 

--Lo que queremos lograr es actualizar en la tabla factura el campo total_factura con triggers,  si se Inserta 
--INSERT, Borra DELETE o actualice UPDATE la información en la tabla detalle_factura. 

--Aqui vamos...
--Para INSERT.---
DELIMITER // 
    CREATE TRIGGER inserto BEFORE INSERT ON detalle_factura 
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

--Para DELETE----
DELIMITER // 
    CREATE TRIGGER borro AFTER DELETE ON detalle_factura 
    FOR EACH ROW 
        BEGIN 
            UPDATE factura  
            SET total_factura = total_factura - OLD.total_detalle 
            WHERE id_factura = OLD.id_factura; 
        END 
    //  
DELIMITER ; 
DELETE FROM detalle_factura WHERE id_detalle = 3 AND id_factura = 1; 
SELECT * FROM factura; 

--Para UPDATE,-------
DELIMITER // 
CREATE TRIGGER actualizo BEFORE UPDATE ON detalle_factura 
    FOR EACH ROW 
        BEGIN 
            -- declaración de variable 
            DECLARE v_variacion FLOAT; -- calculos, esto no se podria hacer con un UPDATE CASCADE

            SET NEW.total_detalle = NEW.precio * NEW.cantidad; 
            SET v_variacion = NEW.total_detalle - OLD.total_detalle; --Tenemos que restar el dato nuevo con el viejo para poder tenr un calculo preciso en factura
            --si yo cambio datos en el detalle factura, en el factura no lo hara y seguira con el valor anterior del detalle factura
            -- al hacer la opreción de resta en v_variacion, nos da el valor que se debe sumar o restar al total de la factura
            --en este caso resta por ley de signos, queda -6000
            
            -- actualizamos el total factura 
            UPDATE factura  
            SET total_factura = total_factura + v_variacion 
            WHERE id_factura = NEW.id_factura; 
        END 
    //  
DELIMITER ; 
UPDATE detalle_factura SET precio=7000, total_detalle= 14000 
WHERE id_detalle = 2 AND id_factura = 1; 
SELECT * FROM factura;

--------------------------------------------------------------------------------------------------------
SET NEW.total_detalle = NEW.precio * NEW.cantidad; 
SET v_variacion = NEW.total_detalle - OLD.total_detalle;
--¿POR QUE RESTAR DATOS NUEVOS Y VIEJOS?
--Restamos el valor nuevo (NEW.total_detalle) menos el valor anterior (OLD.total_detalle) para calcular cuánto cambió el detalle.
-- Esto nos permite obtener la variación real, es decir, la diferencia que se debe sumar o restar en el total de la factura.
-- Sin esta resta, la factura no se ajustaría correctamente y seguiría con un valor desactualizado.
-- Por ejemplo: si el nuevo total es menor que el anterior, la variación será negativa (como en este caso, -6000), y al sumarla al total_factura, se estará realmente restando, como debe ser.
-- Esto asegura que el total de la factura siempre refleje con precisión los detalles actuales.
--------------------------------------------------------------------------------------------------------

EXPLICACIÓN DEL UPDATE: 
-- antes de actualizar el dato en la tabla "detalle factura", se declare una variable llamada "v_variacion" de tipo FLOAR
-- gracias al FOR EACH ROW sabemos en que fila estamos situados (segun el update que se hace mas abajo q dice q el id_detalle es el dos y el de la factura es 1)
-- le decimos que al dato nuevo (el q se le esta actualizando) sea iggual a la cantidad del producto * el precio
-- al tener ese total le decimos q la v_variacion es igual al detalle NEW q acabamos de calcular menos el  dato OLD(el que estaba antes de ser actualizdo)
-- hacemos el update dentro del trigger con el valor nuevo del detalle que fue actualizado y se le dice q el id factura sea igual al id factura del detalle que se esta actualizando

-------------------------------------------------------------------------------------------------------- 

--DATO ADICIONAL: 
-- ✅ CASCADE es bueno para mantener claves sincronizadas.
-- ✅ Pero si querés que el sistema entienda “si cambia el precio, cambia el total” → necesitás lógica personalizada (triggers).

--------------------------------------------------------------------------------------------------------

EJERCICIO A DESARROLLAR: 
-- Supongamos que usted gestiona una base de datos de una empresa que distribuye una gran 
-- variedad de productos, por lo que el maestro de productos de esta BD es una gran tabla que 
-- contiene cientos de miles de registros. 

-- Para cada producto que cambia de precio debe realizarse un 
-- cálculo un tanto pesado, esto se realiza en un proceso nocturno todos los días. 

-- Sabiendo que el programa nocturno procesa solo aquellos registros de la tabla productos cuyo 
-- campo rectangular contiene una “S”  y que a su vez finaliza el cálculo actualiza el campo 
-- rectangular con una “N”. 

-- Construye un disparador sobre la tabla productos para que cuando cambie el valor del campo 
-- precio marque el registro para su recalculo guardando una “S” en el campo rectangular.

En pocas palabras... --debo de crear una tabla de articulos con sus atributos (id_incrementable, nombre, valor_unitario, cantidad, rectangular) y 
--de eso crear un trigger upddate que si el precio OLD cambia q el dato N del campo rectangular pase a S y asi 
--los del recorrido nocturno puedan ir solo  a esos articulos y hacer los cambios pesados 

DROP DATABASE IF EXISTS ejercicio_triggers_articulos;
CREATE DATABASE ejercicio_triggers_articulos;
USE ejercicio_triggers_articulos;

-- Creamos la tabla articulos con sus respectivos campos
CREATE TABLE articulos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    valor_unitario DECIMAL(10,2) NOT NULL,
    cantidad INT NOT NULL,
    rectangular VARCHAR(1) NOT NULL DEFAULT 'N'
);

--Ingresamos datos a la tabla articulos
INSERT INTO articulos (nombre, valor_unitario, cantidad) VALUES
('Arroz', 2000, 10),
('Frijoles', 4000, 5),
('Chicharron', 15000, 20);

--Creamos trigger
DELIMITER //
CREATE TRIGGER update_rectangular BEFORE UPDATE ON articulos
    FOR EACH ROW 
        BEGIN 
            IF OLD.valor_unitario <> NEW.valor_unitario THEN 
                SET NEW.rectangular = 'S';
            END IF;
        END
    //
DELIMITER;

--Actualizamos el valor unitario de un articulo para que se active el trigger
UPDATE articulos SET valor_unitario = 2500 WHERE id = 1;

--Verificamos que el trigger haya actualizado el campo rectangular a 'S'
SELECT * FROM articulos;

