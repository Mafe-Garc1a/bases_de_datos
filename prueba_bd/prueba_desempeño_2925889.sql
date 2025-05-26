-------------PRUEBA DESEMPEÑO MYSQL-----------
--NOMBRE APRENDIZ : MARIA FERNANDA GARCIA CARVAJAL
-- FICHA : 2925889   TECNOLOGO : ANALISIS Y DESARROLLLO DE SOFTWARE
CREATE DATABASE factura_vehiculos;
USE factura_vehiculos;
----CREAMOS LAS TABLAS----
--1
CREATE TABLE vehiculo(
    placa VARCHAR(6) PRIMARY KEY,
    modelo VARCHAR(80),
    color VARCHAR(30)
);
--2
CREATE TABLE cliente(
    id_cliente VARCHAR(10) PRIMARY KEY,
    nombres VARCHAR(50),
    apellidos VARCHAR(50),
    direccion VARCHAR(150),
    telefono VARCHAR(20)
);
--3
CREATE TABLE mecanico(
    cod_empleado_I VARCHAR(8) PRIMARY KEY,
    nombres VARCHAR(50),
    apellidos VARCHAR(50)
);
--4
CREATE TABLE repuestos(
    id_repuesto VARCHAR(8) PRIMARY KEY,
    nombre VARCHAR(60),
    precio_und DECIMAL(7,2)
);
--6
CREATE TABLE reparacion_repuestos(
    id_reparaciones VARCHAR(10),
    id_repuesto VARCHAR(10),
    cantidad INT,
    PRIMARY KEY (id_reparaciones,id_repuesto),
    FOREIGN KEY (id_reparaciones) REFERENCES reparacion(id_reparacion),
    FOREIGN KEY (id_repuesto) REFERENCES repuestos (id_repuesto)ON DELETE CASCADE ON UPDATE CASCADE
);
--7
CREATE TABLE mecanicos_reparacion(
    id_reparaciones VARCHAR(10),
    cod_empleado_aux VARCHAR(8),
    tipo VARCHAR(50),
    PRIMARY KEY (id_reparaciones,cod_empleado_aux),
    FOREIGN KEY (id_reparaciones) REFERENCES reparacion(id_reparacion),
    FOREIGN KEY (cod_empleado_aux) REFERENCES mecanico (cod_empleado_I)
    ON DELETE CASCADE ON UPDATE CASCADE
);
--5
CREATE TABLE reparacion(
    id_reparacion VARCHAR(10) PRIMARY KEY,
    fecha DATE,
    hora TIME,
    placa VARCHAR(6),
    descripcion VARCHAR(100),
    id_cliente VARCHAR(10),  
    valor_mano_obra DECIMAL(9,2),
    valor_total DECIMAL(9,2),
    FOREIGN KEY (placa) REFERENCES vehiculo (placa),
    FOREIGN KEY (id_cliente) REFERENCES cliente (id_cliente)
);
------INSERTAMOS INFRMACION EN  LAS TABLAS-----------

INSERT INTO vehiculo(placa,modelo,color)
VALUES ('ABC123', 'ferrari', 'Rojo'),
('DEF456', 'toyota', 'Azul'),
('GHI789', 'audi', 'Blanco'),
('JKL012', 'mazda', 'Gris'),
('MNO345', 'meredez', 'Negro');

INSERT INTO cliente(id_cliente,nombres,apellidos,direccion,telefono)
VALUES ('1111111212', 'Angelina',' Ocampo Patino', 'MZ 15 CS 2', '3135308383'),
('1111111303', 'Nicolas',' Galvis', 'MZ 19 CS 9', '3135309983'),
('1111111494', 'Maria Celeste','Garcia Salazar', 'MZ 10 CS 6', '3135308003'),
('1111111585', 'Sara stefania',' Gomez Gomez', 'MZ 39 CS 17', '3155308383'),
('1111111676', 'Pepe',' Perez', 'MZ 9 CS 1', '3138308383');

INSERT INTO mecanico(cod_empleado_I,nombres,apellidos)
VALUES ('12345612', 'Juan', 'yepes'),
('78901234', 'yeferson', 'rios'),
('34567856', 'breiner', 'Rodríguez'),
('90123478', 'camilo', 'bermudez'),
('56789090', 'nayibe', 'gomez');

INSERT INTO repuestos(id_repuesto,nombre,precio_und)
VALUES ('12345649', 'rueda', 50000),
('78901274', 'filtro', 120000),
('34567812', 'bateria', 380000),
('90123401', 'limpia_brisas', 70000),
('56789055', 'frenos', 170000);

INSERT INTO reparacion(id_reparacion,fecha,hora,placa,descripcion,id_cliente,valor_mano_obra,valor_total)
VALUES('1','11-05-2025','14:07','ABC123','problemas con la rueda','1111111212',30000,230000 ),
('2','15-05-2025','18:25','GHI789','bateria mala','1111111494',110000,150000 ),
('3','13-05-2025','9:55','DEF456','frenos malos','1111111676',210000,190000 ),
('4','15-05-2025','18:25','MNO345','limpia brisas defectuoso','1111111303',90000,50000 ),
('5','21-05-2025','11:35','JKL012','filtro tapado','1111111585',110000,150000 );


INSERT INTO reparacion_repuestos (id_reparaciones, id_repuesto, cantidad) 
VALUES ('1', '12345649', '2'),
('2', '34567812', '1'),
('3', '56789055', '3'),
('4', '90123401', '2'),
('5', '78901274', '2');

INSERT INTO mecanicos_reparacion (id_reparaciones, cod_empleado_aux, tipo) 
VALUES ('1', '12345612', 'Mecánico principal'),
('2','78901234', 'Asistente'),
('3', '34567856', 'Mecánico principal'),
('4', '90123478', 'Asistente'),
('5', '56789090', 'Mecánico principal');
-----modificar datos de las tablas------------
UPDATE cliente 
SET direccion = 'MZ 20 CS 10', telefono = '3116527952'
WHERE id_cliente = '1111111585';

UPDATE mecanico 
SET nombres = 'Juan Camilo', apellidos = 'bermudez Giraldo' 
WHERE cod_empleado_I = '90123478';

UPDATE reparacion 
SET mano_valor_obra=170000 ,valor_total=210000
WHERE id_reparacion='5';

-----eliminar datos de las tablas 
DELETE FROM mecanico WHERE cod_empleado_I='12345612';
DELETE FROM reparacion_repuestos WHERE id_reparaciones = '5';


--------------CONSULTAS DE LA BASE DE DATOS DE LA TIENDA ONLINE-------------
--01--
SELECT cod,nombre FROM articulo WHERE pvp<500 AND pvp>400; 
--02--
SELECT cod,panel,resolucion , pantalla FROM tv WHERE pantalla NOT BETWEEN 22 AND 42;
--03--
SELECT articulo.cod , articulo.nombre ,articulo.pvp-linped.precio FROM articulo INNER JOIN linped ON articulo.cod=linped.articulo WHERE articulo.pvp!=linped.precio;
--04--
SELECT cod , nombre , marca , pvp   FROM articulo WHERE  pvp = (SELECT MAX(pvp) FROM articulo);
--05--
SELECT camara.cod, articulo.nombre, camara.tipo, articulo.marca FROM camara
JOIN articulo ON (articulo.cod = camara.cod)
JOIN marca on (articulo.marca = marca.marca)
WHERE marca.marca = 'NIKON' OR articulo.marca = 'LG' OR articulo.marca = 'Sigma';
--06--
 SELECT  articulo.nombre , articulo.marca FROM articulo LEFT JOIN tv ON articulo.cod=tv.cod  WHERE articulo.marca is NULL;
--07--
SELECT nombre , pvp FROM articulo WHERE pvp>100 AND pvp<=200;
--08--
SELECT numPedido , usuario , fecha FROM pedido WHERE MONTH(fecha) IN ('08','09','10') AND YEAR(fecha)='2010';
--09--
SELECT DATE_FORMAT('2011/02/21', '%d/%m/%Y') AS FECHA_FORMATO;
--10--
SELECT articulo.cod , articulo.nombre , pedido.fecha FROM articulo INNER JOIN linped ON linped.articulo=articulo.cod   INNER JOIN pedido ON linped.numPedido=pedido.numPedido
WHERE MONTH(pedido.fecha)='03' AND YEAR(pedido.fecha)='2010'ORDER BY cod; 
--11-- NO SABIA COMO HACERLA :(
SELECT nombre , apellidos , 
--12--COD , NOMBRE , PANEL  , PNTALA DE TV Q NO SE HAYAN PEDIDO NUNCA
SELECT tv.cod, articulo.nombre, tv.panel, tv.pantalla FROM tv
LEFT JOIN articulo ON tv.cod = articulo.cod
LEFT JOIN linped ON articulo.cod = linped.articulo
LEFT JOIN pedido ON linped.numPedido = pedido.numPedido
WHERE pedido.numPedido IS NULL;
--13--
SELECT articulo.cod , SUM(articulo.pvp) AS total_euros , cesta.usuario FROM articulo INNER JOIN cesta ON (articulo.cod=cesta.articulo) WHERE cesta.usuario='bmm@agwab.com';
--14--
SELECT ROUND(AVG(articulo.pvp),2)AS MEDIA_VENTA_AL_PUBLICO FROM articulo;
--15--
SELECT ROUND(AVG(linped.precio),3) AS PRECIO_MEDIO FROM articulo
JOIN linped ON (articulo.cod = linped.articulo)
JOIN pedido on (linped.numPedido = pedido.numPedido)
WHERE linped.linea = 4;
--16--diferencia entre precio max y min de los articulos del pedido  numero 20 pedido , linped y articulo
SELECT pvp AS mayor
FROM articulo
WHERE pvp = (SELECT MAX(pvp) FROM articulo);
SELECT pvp AS menor
FROM articulo
WHERE pvp = (SELECT MIN(pvp) FROM articulo);
--forma correcta--
SELECT MAX(pvp) - MIN(pvp) AS diferencia FROM articulo INNER JOIN linped ON articulo.cod = linped.articulo WHERE linped.numPedido = 30;
--17-- 
-- Fecha de nacimiento del usuario más viejo.
SELECT MIN(nacido) AS fecha FROM usuario;
--18---- ¿Cuántos artículos de cada marca hay?
SELECT marca, COUNT(*) FROM articulo GROUP BY marca;
--19-- ¿Cuáles son las marcas que tienen menos de 150 artículos (eliminar las marcas que sean null)?
SELECT marca, COUNT(*) FROM articulo WHERE marca IS NOT NULL GROUP BY marca HAVING COUNT(*) < 150;

--20-- Pedidos (número de pedido y usuario) con más de 10 artículos en un solo pedido, mostrando esta cantidad de artículos
SELECT pedido.numPedido, pedido.usuario, COUNT(*) FROM linped INNER JOIN pedido ON linped.numPedido = pedido.numPedido GROUP BY pedido.numPedido, pedido.usuario HAVING COUNT(*) > 10;

--21-- ¿Hay dos provincias que se llamen igual (con nombre repetido)?
SELECT COUNT(DISTINCT nombre) FROM provincia WHERE nombre IN (SELECT nombre FROM provincia GROUP BY nombre HAVING COUNT(*) > 1);

--22-- Clientes que hayan adquirido (pedido) más de 2 tv
SELECT usuario.nombre, usuario.apellidos FROM usuario INNER JOIN pedido ON usuario.email = pedido.usuario INNER JOIN linped ON pedido.numPedido = linped.numPedido INNER JOIN tv ON linped.articulo = tv.cod WHERE tv.cod IS NOT NULL GROUP BY usuario.nombre HAVING COUNT(DISTINCT tv.cod) > 2;

--23-- Código y nombre de las provincias que tienen más de 50 usuarios (provincia del usuario, no de la dirección de envío).
SELECT usuario.provincia, provincia.nombre, COUNT(*) AS usuarios FROM usuario INNER JOIN provincia ON usuario.provincia = provincia.codp GROUP BY usuario.provincia, provincia.nombre HAVING COUNT(*) > 50;

--24-- Código, nombre y marca de los objetivos con focales de 500 o 600 mm para las marcas de las que no se ha solicitó ningún artículo.
SELECT objetivo.cod, articulo.nombre, articulo.marca FROM objetivo INNER JOIN articulo ON objetivo.cod = articulo.cod WHERE objetivo.focal IN (500, 600) AND articulo.cod NOT IN (SELECT articulo FROM linped);

--25-- Código, nombre y marca de los artículos que tengan stock en cero o NULL y estén pedidos.
SELECT articulo.cod, articulo.nombre, articulo.marca, stock.disponible FROM articulo INNER JOIN linped ON articulo.cod = linped.articulo INNER JOIN stock ON articulo.cod = stock.articulo WHERE sto
ck.disponible = 0 OR stock.disponible IS NULL;



