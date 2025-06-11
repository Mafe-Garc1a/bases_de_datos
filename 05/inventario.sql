CREATE DATABASE inventario_triggers CHARACTER SET utf8 COLLATE utf8_spanish_ci;
USE inventario_triggers;

CREATE TABLE productos(
    id_producto INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nom_producto VARCHAR(30), 
    marca VARCHAR(30), 
    stock INT UNSIGNED
); 


CREATE TABLE movimientos(
    id_movimiento INT UNSIGNED AUTO_INCREMENT PRIMARY KEY, 
    id_producto INT UNSIGNED, 
    tipo_movimiento ENUM('Compra', 'Venta'), 
    cantidad SMALLINT UNSIGNED, 
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP, 
    FOREIGN KEY (id_producto) REFERENCES productos(id_producto)
);

INSERT INTO productos(nom_producto, marca, stock) 
VALUES
('iPhone 16', 'Apple', 0),
('Xiaomi 14T Pro', 'Xiaomi', 0),
('Airpods', 'Apple', 0), 
('Rog Strix Series', 'Asus', 0), 
('Play Station 5 pro', 'Sony', 0); 

DELIMITER //
CREATE TRIGGER actualizar_stock_al_insertar BEFORE INSERT ON movimientos
FOR EACH ROW
    BEGIN 
        IF NEW.tipo_movimiento = 'Compra' THEN 
            -- DECLARE suma INT 
            -- SET suma = NEW.cantidad
            -- UPDATE productos SET stock = stock + suma
            -- WHERE id_producto = NEW.id_producto; 
            UPDATE productos SET stock = stock + NEW.cantidad
            WHERE id_producto = NEW.id_producto;
        ELSE
            IF (SELECT stock FROM productos WHERE id_producto = NEW.id_producto) >= NEW.cantidad THEN
                UPDATE productos SET stock = stock - NEW.cantidad
                WHERE id_producto = NEW.id_producto;
            ELSE 
                SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: No tienes inventario suficiente';
            END IF;
        END IF;
    END
//
DELIMITER ; --SIEMPRE VA CON ESPACIO EL ";"

--MOVIMIENTOS INSERT =
INSERT INTO movimientos(id_producto, tipo_movimiento, cantidad)
VALUES (1, 'Compra', 10);

INSERT INTO movimientos(id_producto, tipo_movimiento, cantidad)
VALUES (1, 'Venta', 5);


DROP TRIGGER IF EXISTS actualizar_stock_cuando_modifico;
DELIMITER //
CREATE TRIGGER actualizar_stock_cuando_modifico BEFORE UPDATE ON movimientos
FOR EACH ROW
    BEGIN
        DECLARE stock_viejo INT UNSIGNED;  
        DECLARE stock_actual INT UNSIGNED;
        IF OLD.tipo_movimiento != NEW.tipo_movimiento THEN 
            IF NEW.tipo_movimiento = 'Compra' THEN 
                UPDATE productos SET stock = stock + OLD.cantidad + NEW.cantidad --SE LE SUMA EL DATO VIEJO PORQUE YA EXISTE Y EL NUEVO PORQUE ES UNA COMPRA
                WHERE id_producto = NEW.id_producto;
            ELSE
                SELECT stock INTO stock_viejo FROM productos WHERE id_producto = NEW.id_producto;
                SET  stock_actual = stock_viejo - OLD.cantidad;  --SE LE RESTA RESTA EL DATO VIEJO PORQUE YA NO EXISTE ESA COMPRA, NO SE LE SUMA EL NEW POEQUE NECESITAMOS VER SI EL STOCK ES SUFICIENTE PARA VENDER

                IF stock_actual >= NEW.cantidad THEN --PRIMERO HAYQ  VERIFICAR SI TENEMOS LA CANTIDAD SUFICIENTE PARA VENDER
                    UPDATE productos SET stock = stock - OLD.cantidad - NEW.cantidad 
                    WHERE id_producto = NEW.id_producto;
                ELSE 
                    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: No tienes inventario suficiente';
                END IF;
            END IF; 
        ELSE
            IF OLD.tipo_movimiento = 'Compra' THEN 
                UPDATE productos SET stock = stock - OLD.cantidad + NEW.cantidad
                WHERE id_producto = NEW.id_producto;
            ELSE
                SELECT stock INTO stock_viejo FROM productos WHERE id_producto = NEW.id_producto;
                SET  stock_actual = stock_viejo + OLD.cantidad;

                IF stock_actual >= NEW.cantidad THEN 
                    UPDATE productos SET stock = stock + OLD.cantidad - NEW.cantidad 
                    WHERE id_producto = NEW.id_producto;
                ELSE 
                    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: No tienes inventario suficiente';
                END IF;
            END IF;
        END IF;
    END
//
DELIMITER ;


DELIMITER //
CREATE TRIGGER actualizar_stock_al_eliminar BEFORE DELETE ON movimientos
FOR EACH ROW
    BEGIN
        DECLARE suma_ventas INT UNSIGNED; 8
        DECLARE suma_compras INT UNSIGNED; 14
        DECLARE stock_diferencia INT; -- se le quita el UNSIGNED porque puede ser negativo y necesito que me deje ese tipo de dato para ver si se puede restra o no una compra
        IF OLD.tipo_movimiento = 'Venta' THEN 
            UPDATE productos SET stock = stock + OLD.cantidad
            WHERE id_producto = OLD.id_producto; 
        ELSE
            SELECT SUM(cantidad) INTO suma_ventas FROM movimientos 
            WHERE id_producto = OLD.id_producto AND tipo_movimiento = 'Venta';

            SELECT SUM(cantidad) INTO suma_compras FROM movimientos 
            WHERE id_producto = OLD.id_producto AND tipo_movimiento = 'Compra';

                                        14       -     8
            SET stock_diferencia = (suma_compras - OLD.cantidad) - suma_ventas;

            IF stock_diferencia <=0 THEN
                UPDATE productos SET stock = stock - OLD.cantidad
                WHERE id_producto = OLD.id_producto;
            ELSE
                SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: No puedes borrar esta compra poeque las ventas superan el inventario';
            END IF;
            
        END IF;
    END
//
DELIMITER ;