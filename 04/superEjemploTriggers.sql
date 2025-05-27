DROP DATABASE ejtrigger;

CREATE DATABASE ejtrigger;
USE ejtrigger;

CREATE TABLE cliente( 
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY, 
    nombre VARCHAR(60),
    id_ultimo_pedido INT 
);

INSERT INTO cliente(nombre) VALUES ('Bob');
INSERT INTO cliente(nombre) VALUES ('Sally');
INSERT INTO cliente(nombre) VALUES ('Fred');


CREATE TABLE usuario(
    id_usuario INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nombre_usuario VARCHAR(30)
);

INSERT INTO usuario(nombre_usuario)
VALUES
        ('Hugo'),
        ('Paco'),
        ('Luis');

CREATE TABLE ventas( 
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY, 
    id_articulo BIGINT,
    id_cliente INT UNSIGNED, 
    cantidad INT, 
    precio DECIMAL(9,2),
    usuario INT UNSIGNED,
    FOREIGN KEY (usuario) REFERENCES usuario (id_usuario),
    FOREIGN KEY (id_cliente) REFERENCES cliente (id)
);


DROP TABLE registro;
CREATE TABLE registro( 
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP, 
    evento VARCHAR(30),
    nombre_tabla VARCHAR(30),
    id_usuario INT UNSIGNED
);


DROP TRIGGER marcaVenta;
DELIMITER //
CREATE TRIGGER marcaVenta AFTER INSERT ON ventas
    FOR EACH ROW
    BEGIN
        UPDATE cliente SET id_ultimo_pedido = NEW.id
        WHERE cliente.id = NEW.id_cliente;
        
        INSERT INTO registro (evento, nombre_tabla, id_usuario)
        VALUES ('Inserto', 'ventas', NEW.usuario);
    END
//
DELIMITER ;



DELETE FROM ventas;
INSERT INTO ventas (id_articulo, id_cliente, cantidad, precio, usuario)
VALUES (1, 3, 5, 19.95, 3);
INSERT INTO ventas (id_articulo, id_cliente, cantidad, precio, usuario)
VALUES (2, 2, 3, 14.95, 2);
INSERT INTO ventas (id_articulo, id_cliente, cantidad, precio, usuario)
VALUES (3, 1, 1, 29.95, 2);

DELIMITER //
CREATE TRIGGER updateVenta AFTER UPDATE ON ventas
    FOR EACH ROW
    BEGIN
        INSERT INTO registro (evento, nombre_tabla, id_usuario)
        VALUES ('actualizo', 'ventas', NEW.usuario);
    END
//
DELIMITER ;

UPDATE ventas SET cantidad = 9 , usuario=1
WHERE ventas.id = 2;
