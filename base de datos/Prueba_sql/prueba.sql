CREATE DATABASE taller_autos_luna;

USE taller_autos_dieguito_luna;

CREATE TABLE vehiculo(
    placa VARCHAR(6) PRIMARY KEY,
    modelo VARCHAR(80),
    color VARCHAR(30)
);

CREATE TABLE cliente(
    id_cliente VARCHAR(6) PRIMARY KEY,
    nombres VARCHAR(50),
    apellidos VARCHAR(50),
    direccion VARCHAR(150),
    telefono VARCHAR(20)
);

CREATE TABLE mecanico(
    cod_empleado_I VARCHAR(8) PRIMARY KEY,
    nombres VARCHAR(50),
    apellidos VARCHAR(50)
);


CREATE TABLE reparacion(
    id_reparacion VARCHAR(10) PRIMARY KEY,
    fecha DATE,
    hora TIME,
    placa CHAR(6),
    descripcion VARCHAR(200),
    id_cliente VARCHAR(6),
    valor_mano_obra INT,
    valor_total INT,
    FOREIGN KEY (placa) REFERENCES vehiculo(placa),
    FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente)
);

CREATE TABLE mecanicos_reparacion(
    id_reparaciones VARCHAR(10),
    cod_empleado_aux VARCHAR(10),
    tipo VARCHAR(70),
    PRIMARY KEY (id_reparaciones,cod_empleado_aux),
    FOREIGN KEY (id_reparaciones) REFERENCES reparacion(id_reparacion),
    FOREIGN KEY (cod_empleado_aux) REFERENCES mecanico(cod_empleado_I)
);

CREATE TABLE repuestos(
    id_repuestos VARCHAR(10) PRIMARY KEY,
    nombre VARCHAR (50),
    precio_und INT
);

CREATE TABLE reparacion_repuestos(
    id_reparaciones VARCHAR(10),
    id_repuestos VARCHAR(10),
    cantidad INT,
    PRIMARY KEY (id_reparaciones,id_repuestos),
    FOREIGN KEY (id_reparaciones) REFERENCES reparacion(id_reparacion),
    FOREIGN KEY (id_repuestos) REFERENCES repuestos (id_repuestos)
);


INSERT INTO vehiculo(placa,modelo,color),
VALUES ('ABC123', 'Ford Fiesta', 'Rojo'),
('DEF456', 'Chevrolet Spark', 'Azul'),
('GHI789', 'Toyota Corolla', 'Blanco'),
('JKL012', 'Nissan Versa', 'Gris'),
('MNO345', 'Honda Civic', 'Negro');

INSERT INTO cliente(id_cliente,nombres,apellidos,direccion,telefono),
VALUES ('111122', 'Luna',' Rave Acosta', 'MZ 19 CS 9', '3135308383'),
('111111', 'Luna',' Rave Acosta', 'MZ 19 CS 9', '3135309983'),
('111112', 'Maria',' Rave Acosta', 'MZ 10 CS 9', '3135308003'),
('111113', 'Sara',' Rave Acosta', 'MZ 39 CS 9', '3155308383'),
('111114', 'Pepe',' Rave Acosta', 'MZ 59 CS 9', '3138308383');

INSERT INTO mecanico(cod_empleado_I,nombres,apellidos),
VALUES ('123456', 'Juan', 'Pérez'),
('789012', 'Pedro', 'González'),
('345678', 'María', 'Rodríguez'),
('901234', 'Luis', 'García'),
('567890', 'Ana', 'Martinez');
 
INSERT INTO mecanicos_reparacion (id_reparaciones, cod_empleado_aux, tipo) 
VALUES ('1', '123456', 'Mecánico principal'),
('2','789012', 'Asistente'),
('3', '345678', 'Mecánico principal'),
('4', '901234', 'Asistente'),
('5', '567890', 'Mecánico principal');

INSERT INTO reparacion_repuestos (id_reparaciones,id_repuestos,cantidad)

INSERT INTO reparacion_repuestos (id_reparaciones, id_repuestos, cantidad) 
VALUES ('1', '123', '2'),
('1', '234', '1'),
('2', '345', '3'),
('2', '456', '1'),
('3', '567', '2');


UPDATE cliente 
SET direccion = 'MZ 19 CS 10', telefono = '3111111111'
WHERE id_cliente = '111122';

UPDATE mecanico 
SET nombres = 'José', apellidos = 'Hernández' 
WHERE cod_empleado_I = '123456';


-- consultas


-- 2
SELECT tv.cod, articulo.nombre, tv.resolucion FROM tv
JOIN articulo ON (articulo.cod = tv.cod)
WHERE tv.pantalla NOT BETWEEN 22 AND 42;

-- 5
SELECT camara.cod, articulo.nombre, camara.tipo, articulo.marca FROM camara
JOIN articulo ON (articulo.cod = camara.cod)
JOIN marca on (articulo.marca = marca.marca)
WHERE marca.marca = 'NIKON' OR articulo.marca = 'LG' OR articulo.marca = 'Sigma';


-- 9

SELECT DATE_FORMAT('2011/02/21', '%d/%m/%Y') AS FECHA;

-- 12

SELECT tv.cod, articulo.nombre, tv.panel, tv.pantalla FROM tv
LEFT JOIN articulo ON (tv.cod = articulo.cod)
LEFT JOIN linped ON (articulo.cod = linped.articulo)
LEFT JOIN pedido ON (linped.numPedido = pedido.numPedido)
WHERE pedido.numPedido IS NULL;


-- 14

SELECT ROUND(AVG(articulo.pvp),2)AS MEDIA_VENTA_AL_PUBLICO FROM articulo;

-- 15

SELECT ROUND(AVG(linped.precio),3) AS PRECIO_MEDIO FROM articulo
JOIN linped ON (articulo.cod = linped.articulo)
JOIN pedido on (linped.numPedido = pedido.numPedido)
WHERE linped.linea = 4;

-- 18

SELECT COUNT(*) FROM camara;
SELECT COUNT(*) FROM objetivo; 
SELECT COUNT(*) FROM tv;