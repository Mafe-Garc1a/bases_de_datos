DROP DATABASE IF EXISTS tallerTriggers;
CREATE DATABASE tallerTriggers;
USE tallerTriggers;

CREATE TABLE empleados(
    id_empleado INT AUTO_INCREMENT PRIMARY KEY,  
    nombre_empleado VARCHAR(50),    
    total_ventas_dinero FLOAT (11,2) DEFAULT 0,
    total_cant_productos_vendidos INT DEFAULT 0
);

CREATE  TABLE productos(
    id_producto INT AUTO_INCREMENT PRIMARY KEY,                             
    nombre_producto VARCHAR(50),   
    precio FLOAT(10,2)                                     
);

CREATE TABLE ventas(
    id_venta INT,       
    id_empleado INT,    
    fecha DATE,
    id_producto INT,
    cantidad INT,
    PRIMARY KEY (id_venta),
    FOREIGN KEY (id_empleado) REFERENCES empleados (id_empleado),
    FOREIGN KEY (id_producto) REFERENCES productos (id_producto)
);

INSERT INTO ventas (id_empleado, fecha, id_producto, cantidad)
VALUES (1, '2023-10-01', 1, 2);

INSERT INTO ventas (id_venta, id_empleado, fecha, id_producto, cantidad)
VALUES (1, 1, '2023-10-01', 1, 5);
-- Insertar 5 empleados
-- Insertar 10 productos 

-- Realizar triggers en la tabla ventas, para insert, update y delete.
-- Los triggers deben tener correctamente actualizados los datos en la tabla empleados
-- en los campos total_ventas_dinero, total_cant_productos_vendidos.

--EMPECEMOS >:3 !
--INSERTAR DATOS EN EMPLEADOS: 
INSERT INTO empleados (nombre_empleado)
VALUES  ('Rodrigo'), 
        ('Martha'), 
        ('Xiaomi'), 
        ('Dante'), 
        ('Estela');

--INSERTAR DATOS EN PRODUCTOS: 
INSERT INTO productos (nombre_producto, precio)
VALUES  ('Arroz', 2500),
        ('Almejas', 5000),
        ('Atún', 8000),
        ('Arena Para Gato', 14000),
        ('Gomitas', 4000),
        ('Uvas', 8000),
        ('Cereal', 7250),
        ('Detergente Liquido', 12000),
        ('Galletas Ducales', 7000),
        ('Leche Liquida Larga Vida', 3800);

--INSPECCIONAMOS TABLAS: 
SELECT * FROM empleados; 
SELECT * FROM productos; 
SELECT * FROM ventas; 

--CREAMOS TRIGGERS: 
--Insert: 
DELIMITER //
CREATE TRIGGER insertar_venta AFTER INSERT ON ventas 
FOR EACH ROW 
    BEGIN
        DECLARE precio_producto FLOAT(11,2); 

        SELECT precio INTO precio_producto FROM productos 
        WHERE id_producto = NEW.id_producto; 

        UPDATE empleados SET total_ventas_dinero = total_ventas_dinero + (NEW.cantidad * precio_producto), 
        total_cant_productos_vendidos = total_cant_productos_vendidos + NEW.cantidad 
        WHERE id_empleado = NEW.id_empleado; 


    END;
//
DELIMITER ; 


DELIMITER //
CREATE TRIGGER insertar_venta AFTER INSERT ON ventas
FOR EACH ROW 
BEGIN
    DECLARE precio_producto FLOAT(11,2);

    -- Obtener el precio del producto vendido
    SELECT precio INTO precio_producto 
    FROM productos 
    WHERE id_producto = NEW.id_producto;

    -- Actualizar los campos del empleado correspondiente
    UPDATE empleados 
    SET total_ventas_dinero = total_ventas_dinero + (precio_producto * NEW.cantidad),
        total_cant_productos_vendidos = total_cant_productos_vendidos + NEW.cantidad
    WHERE id_empleado = NEW.id_empleado;
END;
//
DELIMITER ;



--Alterar tabla porque a la señorita rita le dio pereza ingresar un 0 y solo ingreso los nombres en empleados
ALTER TABLE empleados 
MODIFY total_ventas_dinero FLOAT(11,2) DEFAULT 0,
MODIFY total_cant_productos INT DEFAULT 0;
