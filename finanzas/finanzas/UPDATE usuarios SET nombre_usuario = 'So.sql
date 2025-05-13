UPDATE usuarios SET nombre_usuario = 'Sofia Luna', correo = 'sofia@gmail.com' WHERE id_usuario = 2;
SELECT * FROM usuarios;

SELECT nombre_usuario, correo FROM usuarios;
SELECT * FROM movimientos WHERE tipo_movimiento = 'Ingreso';
-- Con dos filtros
SELECT descripcion, tipo_movimiento, valor FROM movimientos WHERE tipo_movimiento = 'Ingreso';
SELECT descripcion, tipo_movimiento, valor FROM movimientos WHERE tipo_movimiento = 'Egreso';
-- Con tres filtros
SELECT descripcion, tipo_movimiento, valor, estado FROM movimientos WHERE tipo_movimiento = 'Ingreso' AND estado = TRUE AND usuario = 6;

UPDATE movimientos SET estado = FALSE WHERE id_movimiento = 7;
UPDATE movimientos SET valor = 100000 WHERE id_movimiento = 3;

SELECT * FROM movimientos WHERE usuario = 7;
SELECT * FROM movimientos WHERE usuario = 7 AND estado = FALSE;
SELECT * FROM movimientos WHERE usuario = 7 AND estado = TRUE;

SELECT * FROM movimientos;
