-- Crear base de datos
CREATE DATABASE finanzas;
-- Cargar la base de datos
USE finanzas;
-- Crear tablas
CREATE TABLE usuarios (
    id_usuario INT UNSIGNED AUTO_INCREMENT,
    nombre_usuario VARCHAR(70),
    correo VARCHAR(100) UNIQUE,
    pass_hash VARCHAR(140),
    PRIMARY KEY (id_usuario)
);
CREATE TABLE movimientos (
    id_movimiento INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    descripcion VARCHAR(140),
    tipo_movimiento ENUM('Ingreso','Egreso'),
    valor FLOAT(14,2),
    fecha_hora DATETIME,
    estado BOOLEAN, -- TRUE=activo  FALSE=borrado
    usuario INT UNSIGNED,
    FOREIGN KEY (usuario) REFERENCES usuarios(id_usuario)
);
CREATE TABLE categorias (
    nombre_categorias VARCHAR(30) PRIMARY KEY
);

--agrgar un campo a una tabla
ALTER TABLE movimientos
ADD COLUMN categoria VARCHAR(30);
AFTER fecha_hora;

--agregar una clave foranea a una tabla
ALTER TABLE movimientos
ADD CONSTRAINT fk_movimiento_categoria
FOREIGN KEY (categoria) 
REFERENCES categorias(nombre_categorias);

--crear campo en usuarios
ALTER TABLE usuarios
ADD COLUMN edad VARCHAR(2); --esta mal 
ALTER TABLE usuarios
MODIFY COLUMN edad TINYINT UNSIGNED; --esta bien

ALTER TABLE nombre_tabla
MODIFY COLUM nombre_columna nuevo_tipo;

UPDATE movimientos SET categoria = 'ninguna';

UPDATE movimientos SET categoria = 'finanzas' 
WHERE descripcion LIKE '%pago%';

-- Insertar datos
INSERT INTO usuarios (nombre_usuario, correo, pass_hash) 
VALUES ('Hugo Lopez', 'hugo@gmail.com ', SHA1('123abc'));

INSERT INTO usuarios (nombre_usuario, correo, pass_hash) 
VALUES ('Paco Luna', 'paco@gmail.com ', SHA1('789xyz'));

INSERT INTO usuarios (nombre_usuario, correo, pass_hash) 
VALUES
('Maria Garcia', 'maria@gmail.com ', SHA1('245hyrt')),
('Luis Orozco', 'luis@gmail.com ', SHA1('345ghj')),
('Zharick Leon', 'zharick@gmail.com ', SHA1('126grd')),
('Fabio Aguirre', 'fabio@gmail.com ', SHA1('675dfv'));

INSERT INTO movimientos (descripcion, tipo_movimiento, valor, fecha_hora, estado, usuario)
VALUES ('Pago mensual de Abril en el trabajo', 'Ingreso', 4000000,'2025-05-07 10:39:01', TRUE, 1);

INSERT INTO movimientos (descripcion, tipo_movimiento, valor, fecha_hora, estado, usuario)
VALUES ('Pago cuota de la casa', 'Egreso', 1000000,'2025-05-07 12:07:01', 1, 1);

INSERT INTO movimientos (descripcion, tipo_movimiento, valor, fecha_hora, estado, usuario)
VALUES ('Pago servicio de internet', 'Egreso', 100000,'2025-05-07 07:30:01', 1, 1);

INSERT INTO movimientos (descripcion, tipo_movimiento, valor, fecha_hora, estado, usuario)
VALUES ('Pago servicio de energia', 'Egreso', 150000,'2025-05-07 13:25:01', 1, 1);


-- Actualizar un campo de una tabla donde se cumpla el filtro
UPDATE movimientos SET estado = FALSE WHERE id_movimiento = 3;

INSERT INTO movimientos (descripcion, tipo_movimiento, valor, fecha_hora, estado, usuario)
VALUES ('Arriendo local comercial', 'Ingreso', 3000000,'2025-05-01 11:00:01', 1, 6);

INSERT INTO movimientos (descripcion, tipo_movimiento, valor, fecha_hora, estado, usuario)
VALUES ('Arriendo de apartamento conjunto Palmas de VillaVerde', 'Ingreso', 1400000,'2025-05-01 12:00:01', 1, 6);

INSERT INTO movimientos (descripcion, tipo_movimiento, valor, fecha_hora, estado, usuario)
VALUES ('Mercado pa la casita', 'Egreso', 600000,'2025-05-03 14:00:01', 1, 6);

UPDATE usuarios SET nombre_usuario = 'Sofia Luna', correo = 'sofia@gmail.com' WHERE id_usuario = 2;
SELECT * FROM usuarios;
SELECT nombre_usuario, correo FROM usuarios;

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



--insertar un usuario nuevo, hacer 4 movimientos a ese usuario modificar 2 de ellos y hacer 3 consultas diferentes
INSERT INTO usuarios (nombre_usuario, correo, pass_hash)
VALUES ('Juanito Wick', 'juanitoSSY@gmail.com', SHA1('123abc'));
INSERT INTO movimientos (descripcion, tipo_movimiento, valor, fecha_hora, estado, usuario)
VALUES ('compra XBOX', 'Egreso', 1500000, '2025-04-07 20:00:00', 1, 7);
INSERT INTO movimientos (descripcion, tipo_movimiento, valor, fecha_hora, estado, usuario)
VALUES ('Almuerzo', 'Egreso', 50000, '2025-05-07 12:35:07', 1, 7);
INSERT INTO movimientos (descripcion, tipo_movimiento, valor, fecha_hora, estado, usuario)
VALUES ('compra de un celular', 'Egreso', 800000, '2025-05-07 16:48:07', 1, 7);
INSERT INTO movimientos (descripcion, tipo_movimiento, valor, fecha_hora, estado, usuario)
VALUES ('Pago por Administracion de Servidores', 'Ingreso', 800000, '2025-06-01 23:00:07', 1, 7);

UPDATE movimientos SET estado = FALSE WHERE id_movimiento = 7;
UPDATE movimientos SET valor = 100000 WHERE id_movimiento = 3;

SELECT * FROM movimientos WHERE usuario = 7;
SELECT * FROM movimientos WHERE usuario = 7 AND estado = FALSE;
SELECT * FROM movimientos WHERE usuario = 7 AND estado = TRUE;

--funcion sum
SELECT SUM(valor) AS total_egreso FROM movimientos 
WHERE tipo_movimiento = 'Egreso' AND estado = TRUE AND usuario = 7;

SELECT SUM(valor) AS total_ingreso FROM movimientos
WHERE tipo_movimiento = 'Ingreso' AND estado = TRUE AND usuario = 6;

SELECT SUM(valor) AS total_ingreso FROM movimientos
WHERE tipo_movimiento = 'Egreso' AND estado = TRUE AND usuario = 1 AND MONTH(fecha_hora) ='03';

SELECT MONTH(fecha_hora) AS mes, SUM(valor) AS total_egresos FROM movimientos
WHERE tipo_movimiento = 'Egreso' AND estado = TRUE AND usuario = 1 GROUP BY MONTH(fecha_hora);

--Cuantos gastos tiene el usuario uno en cada mes
SELECT MONTH(fecha_hora) AS mes, COUNT(id_movimiento) AS cuantos_egresos, SUM(valor) AS total_egresos FROM movimientos
WHERE tipo_movimiento = 'Egreso' AND estado = TRUE AND usuario = 1 GROUP BY MONTH(fecha_hora)

SELECT MONTH(fecha_hora) AS mes, COUNT(id_movimiento) AS cuantos_ingresos, SUM(valor) AS total_ingresos FROM movimientos
WHERE tipo_movimiento = 'Ingreso' AND estado = TRUE AND usuario = 2 GROUP BY MONTH(fecha_hora);