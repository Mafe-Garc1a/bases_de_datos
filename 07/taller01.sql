DROP DATABASE IF EXISTS tallerProcedimientos01;
CREATE DATABASE tallerProcedimientos01;
USE tallerProcedimientos01;

CREATE TABLE empleados(
    id_empleado INT AUTO_INCREMENT PRIMARY KEY,  
    nombre_empleado VARCHAR(50),    
    total_ventas_dinero FLOAT (11,2),
    total_cant_productos INT
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
    totoal FLOAT(12,2),
    PRIMARY KEY (id_venta),
    FOREIGN KEY (id_empleado) REFERENCES empleados (id_empleado),
    FOREIGN KEY (id_producto) REFERENCES productos (id_producto)
);

-- Insertar 5 empleados
-- Insertar 10 productos 
-- Insertar 20 ventas

-- crear un procedimiento almacenado para insertar_ventas.   Antes de inserte una venta de debe tomar el precio del producto
-- calcular el total para poderlo insertar. El procedimiento tambien debe actualizar la tabla empleados en los campos: 
-- total_ventas_dinero, total_cant_productos.

-----crear 
DELIMITER //
CREATE FUNCTION total_ventas(    , cantidad INT)
RETURN total FLOAT , total_cantidad INT ; 
//
DELIMITER ;
DELIMITER //
CREATE PROCEDURE insertar_venta(id_venta INT , id_empleado INT, fecha DATE , id_producto INT , cantidad INT , totoal FLOAT)
BEGIN
    
        
//
DELIMITER ;