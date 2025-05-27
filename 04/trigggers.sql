DELIMITER //   --el fin de linea ya no es el ';'
CREATE TRIGGER actualizarventas BEFORE UPDATE ON ventas
FOR EACH ROW
BEGIN --transaccion , cuando un bloque de cod tiene mas de un punto y coma 
 IF ( SELECT bandera FROM ventas WHERE id = NEW.id ) > 0 THEN
 SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: no se 
 puedo actualizar el registro cantidad en ventas';
 END IF;
END;
//
DELIMITER ; --ahora si deja q el ';' sea el delimitador como siempre

START TRANSACTION;--esto es por si las 3 actualizaciones no se pueden realizar 
UPDATE ventas SET cantidad = cantidad + 9 WHERE id = 2;
COMMIT;--es por si todo sale bien , acualice


--Creamos un nuevo trigger,
DELIMITER //
CREATE TRIGGER marcaVenta AFTER INSERT ON ventas
 FOR EACH ROW
    BEGIN
        UPDATE cliente SET id_ultimo_pedido = NEW.id
    WHERE cliente.id = NEW.id_cliente;
    INSERT INTO registro (evento, nombreusuario, nombretabla, 
        id_tabla)
    VALUES ('Inserto', 'el trigger', 'ventas', NEW.id);
 END
//
DELIMITER ;

CREATE TABLE usuario(
    id_usuario INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nombre_usuario VARCHAR(30)
);

INSERT INTO usuario(nombre_usuario)
VALUES
        ('Hugo'),
        ('Paco'),
        ('Luis');
ALTER TABLE ventas ADD COLUMN usuario INT UNSIGNED DEFAULT NULL;

ALTER TABLE ventas ADD COLUMN usuario INT UNSIGNED DEFAULT 2;
--otra tabla de ventas
DROP TABLE registro;
CREATE TABLE registro( 
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    fecha TIMESTAMP,
    evento VARCHAR(30),
    nombre_tabla VARCHAR(30),
    id_usuario INT UNSIGNED
);

---------------eliminar trigger------------
DROP TRIGGER marcaVenta;
DELIMITER //
--VUELVE Y LO CREA--
CREATE TRIGGER marcaVenta AFTER INSERT ON ventas
    FOR EACH ROW
    BEGIN
        UPDATE cliente SET id_ultimo_pedido = NEW.id
        WHERE cliente.id = NEW.id_cliente;
        
        INSERT INTO registro (evento, nombretabla, id_usuario)
        VALUES ('Inserto', 'ventas', NEW.usuario);
    END
//
DELIMITER ;

DROP DATABASE ejtrigger;