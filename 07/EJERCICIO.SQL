----TRIGGERS-> QUE PERMITA insertar , modifcar y eliminar datos <-manipular datos que dependan de un EVENTO cuando pase algo e la tabla , no mporta q (actualizae inventario cuando se venda algo)
---FUNCTION->CODIGO QUE SE VA A UTILÑIZAR EN VARIAS PARTES -trozos de codigo que necesite reutilizar
---PROCEDIMIENTOS->CODIGO QUE REQUIERE PROCESOS ADICIONALES ANTES DE MANIPULAR LOS DATOS
--parametros in->son los que entran      out->


DELIMITER //
CREATE FUNCTION calcular_total_producto(p_id_producto INT, p_cantidad INT) RETURNS FLOAT
BEGIN
    DECLARE v_precio FLOAT (10,2);
    DECLARE v_total FLOAT (10,2);

    SELECT precio INTO v_precio FROM productos WHERE id_producto = p_id_producto;
    SET v_total = v_precio * p_cantidad;

    RETURN v_total;

END;
//
DELIMITER ;


DELIMITER //
CREATE PROCEDURE insertar_venta (IN p_empleado INT, IN p_producto INT, IN p_cantidad INT)
BEGIN
    INSERT INTO ventas(id_empleado, fecha, id_producto, cantidad, total)
    VALUES(p_empleado, CURDATE(), p_producto, p_cantidad, (SELECT calcular_total_producto(p_producto, p_cantidad)));

    UPDATE empleados SET 
    total_ventas_dinero = total_ventas_dinero + (SELECT calcular_total_producto(p_producto, p_cantidad)),
    total_cant_productos = total_cant_productos + p_cantidad
    WHERE id_empleado = p_empleado;

END;
//
DELIMITER ;