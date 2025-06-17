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
    total FLOAT(12,2),
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
CREATE FUNCTION total_ventas(p_id_producto, p_cantidad INT)
RETURN total FLOAT ; 
BEGIN 
   DECLARE v_total FLOAT
   --SE HACE ESTO PARA BUSCAR EL ID QUE INGRESARON Y QUE NO SE CAMBIE OTRO PRODUCTO
   SELECT precio INTO FROM producto WHERE id_producto=p_id_producto;
   SET v_total=v_precio*p_cantidad;
   RETURN v_total
END;
//
DELIMITER ;
-----
DELIMITER //
CREATE PROCEDURE insertar_venta(p_id_empleado INT ,P_id_producto INT ,p_cantidad  INT )
BEGIN
    INSERT INTO ventas(id_empleado, fecha, id_producto, cantidad, total)
    VALUES(p_id_empleado,CURDATE(),p_id_producto,p_cantidad,(SELECT total_ventas(p_id_producto,p_cantidad)));
    UPDATE empleados SET 
    total_ventas_dinero = total_ventas_dinero + (SELECT total_ventas(p_id_producto, p_cantidad)),
    total_cant_productos = total_cant_productos + p_cantidad
    WHERE id_empleado = p_empleado;

END ;
//
DELIMITER ;
DELIMITER //
CREATE PROCEDURE actualizar_venta(p_id_empleado INT ,P_id_producto INT ,p_cantidad  INT )
BEGIN 
    DECLARE V_total_viejo FLOAT UNSIGNED;
    DECLARE V_total_actual FLOAT UNSIGNED;
    DECLARE V_cantidad_actual INT UNSIGNED;
    DECLARE V_cantidad_vieja_empleado INT UNSIGNED;
     SELECT total INTO V_total_viejo FROM ventas WHERE id_producto=p_id_producto;
     UPDATE ventas SET V_cantidad_actual=NEW.p_cantidad , total=(SELECT total_ventas(p_id_producto,V_cantidad_actual));

      SELECT total_cant_productos INTO V_cantidad_vieja_empleado FROM empleados WHERE id_empleado=NEW.p_id_empleado;

    UPDATE empleados SET 
    total_ventas_dinero = total_ventas_dinero-V_total_viejo+  (SELECT total_ventas(p_id_producto, p_cantidad)),
    total_cant_productos = total_cant_productos-V_cantidad_vieja_empleado + p_cantidad
    WHERE id_empleado = p_id_empleado;
    
END;
//
DELIMITER ;


