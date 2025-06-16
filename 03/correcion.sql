-- ------------------------CONSULTAS MYSQL-----------------------------
--T03.001-codigo y nombre de los articulos cn un precion entre 400 y 500 dolares
SELECT cod,nombre FROM articulo WHERE pvp<500 AND pvp>400; -- tambie se puede utilizar between 

-- T03.002- Código	y	nombre	de	los	artículos con	precio	415,	129,	1259	o	3995.
SELECT cod,nombre FROM articulo  WHERE  pvp=415 OR  pvp=129 OR pvp=1259 OR pvp=3995;
-- T03.003- Código	y	nombre	de	las	provincias	que	no	son	Huelva,	Sevilla,	Asturias	ni	Barcelona.
SELECT codp , nombre FROM provincia WHERE nombre!='Huelva' AND nombre!='Sevilla' AND nombre!='Asturias' AND nombre!='Barcelona';
-- T03.004- Código	de	la	provincia	Alicante
SELECT codp FROM provincia WHERE nombre='Alicante'; --NO ESTA EN PROVINCIA
-- T03.005- Obtener	el	código,	nombre	y	pvp	de	los	artículos cuya	marca	comience	por	S.
SELECT cod , nombre , pvp , marca FROM articulo WHERE marca LIKE 's%';
-- T03.006- Información	sobre	los	usuarios	cuyo	email	es	de	la	eps
SELECT dni,nombre, apellidos ,nacido, pueblo, telefono ,email FROM usuario WHERE email LIKE '%@eps%';  
-- T03.007- Código,	nombre	y	resolución	de	los	televisores	cuya	pantalla	no	esté	entre	22	y	42.
SELECT cod,panel,resolucion FROM tv WHERE pantalla>22 AND pantalla<42;
-- T03.008- Código	y	nombre	de	los	televisores	cuyo	panel	sea	tipo	LED	y	su	precio	no	supere	los	1000	euros
SELECT cod ,panel FROM tv WHERE panel LIKE '%LED%' ; --NO TIEN PRECIO
-- T03.009- Email	de	los	usuarios	cuyo	código	postal	no	sea	02012,	02018	o	02032.
SELECT email , nombre FROM usuario WHERE codpos!=02012 OR  codpos!=02018 OR  codpos!=02032;  
-- T03.010- Código	y	nombre	de	los	packs	de	los	que	se	conoce	qué	artículos los	componen
SELECT cod , nombre FROM articulo WHERE cod IN('A0685','A1234');
-- T03.011- ¿Hay	algún	artículo	en	cesta	que	esté	descatalogado?
SELECT cesta.articulo ,cesta.usuario , cesta.fecha  ,stock.entrega FROM cesta INNER JOIN stock WHERE stock.entrega='Descatalogado' ;  --TODOS ESTAN , LO QUE NO ESTE DENTRO DE TAL TABLA
-- T03.012- Código,	nombre	y	pvp	de	las	cámaras	de	tipo	compacta.
SELECT cod , resolucion , factor , tipo FROM camara WHERE tipo LIKE '%compacta%';
-- T03.013- Código,	nombre	y	diferencia	entre	pvp	y	precio	de	los	artículos que	hayan	sido	 solicitados	en algún	pedido	a	un	precio	distinto	de	su	precio	de	venta.
SELECT articulo.cod , articulo.nombre ,articulo.pvp-linped.precio FROM articulo INNER JOIN linped ON articulo.cod=linped.articulo WHERE articulo.pvp!=linped.precio;

-- T03.014- Número	de	pedido, fecha	y	nombre	y	apellidos	del	usuario	que	solicita	el	pedido,	
-- para	aquellos pedidos	solicitados	por	algún	usuario	de	apellido	MARTINEZ
SELECT pedido.numPedido , pedido.fecha , usuario.nombre , usuario.apellidos FROM pedido INNER JOIN usuario ON pedido.usuario=usuario.email  WHERE usuario.apellidos LIKE '%SANCHEZ%';
--T03.015-	Código,	nombre	y	marca	del	artículo	más	caro.	
SELECT cod , nombre , marca , pvp FROM articulo WHERE  pvp=(SELECT max(pvp) FROM articulo);
--T03.016-	Nombre,	marca	y	resolución	de	las	cámaras	que	nunca	se	han	solicitado.	
SELECT articulo.nombre , articulo.marca , camara.resolucion FROM articulo INNER JOIN camara ON articulo.cod=camara.cod RIGHT JOIN linped ON articulo.cod = linped.articulo WHERE articulo,cod!=linped.articulo;--NO HE ODIDO
--T03.017-	Código,	nombre,	tipo	y	marca	de	las	cámaras	de	marca	Nikon,	LG	o	Sigma.	
SELECT camara.cod , articulo.nombre , camara.tipo , articulo.marca FROM camara INNER JOIN articulo ON articulo.cod=camara.cod  WHERE articulo.marca IN('Nikon' , 'LG' , 'Sigma');
--T03.018-	Código,	nombre	y	pvp	de	la	cámara	más	cara	de	entre	las	de	tipo	réflex.	
SELECT camara.cod , articulo.nombre ,camara.tipo , articulo.pvp FROM camara INNER JOIN articulo ON articulo.cod =camara.cod WHERE pvp=(SELECT MAX(PVP) FROM articulo);-- AND camara.tipo IN('réflex');
--T03.019-	Marcas	de	las	que	no	existe	ningún	televisor	en	nuestra	base	de	datos.
SELECT marca.marca FROM marca  WHERE NOT EXISTS (SELECT 1  FROM articulo INNER JOIN tv ON articulo.cod=tv.cod WHERE articulo.marca =marca.marca);
--T03.020-	Código,	nombre	y	disponibilidad	de	los	artículos	con	menor	disponibilidad	de	entre	los	que	pueden	estar	disponibles	en	24	horas.	
SELECT articulo.cod , articulo.nombre ,stock.entrega FROM articulo INNER JOIN stock ON articulo.cod=stock.articulo WHERE stock.entrega="24 horas";
--T03.021-	Nombre	de	los	artículos	cuyo	nombre	contenga	la	palabra	EOS
SELECT nombre FROM articulo WHERE nombre LIKE '%EOS%';
--T03.022-	Tipo	y	focal	de	los	objetivos	que	se	monten	en	una	cámara	Canon	sea	cual	sea	el	modelo.	
SELECT objetivo.tipo , objetivo.focal FROM objetivo INNER JOIN articulo ON articulo.cod=objetivo.cod  WHERE articulo.marca='canon';
--T03.023-	Nombre	de	los	artículos	cuyo	precio	sea	mayor	de	100	pero	menor	o	igual	que	200.	
SELECT nombre  , pvp FROM articulo WHERE pvp>100 AND pvp<=200;
--T03.024-	Nombre	de	los	artículos	cuyo	precio	sea	mayor	o	igual	que	100	pero	menor	o	igual	que	300.	
SELECT nombre  , pvp FROM articulo WHERE pvp>100 AND pvp<=300;
--T03.025-	Nombre	de	las	cámaras	cuya	marca	no	comience	por	la	letra	S.
SELECT articulo.nombre  FROM articulo INNER JOIN camara ON camara.cod=articulo.cod WHERE articulo.marca NOT LIKE 'S%';
--T04.001-	Toda	la	información	de	los	pedidos	anteriores	a	octubre	de	2010.	
SELECT pedido.numPedido , pedido.usuario , pedido.fecha , linped.articulo , linped.cantidad , linped.precio FROM pedido INNER JOIN linped ON pedido.numPedido=linped.numPedido WHERE  YEAR(pedido.fecha)<='2010' AND MONTH(pedido.fecha)<='10';
--04.002-	Toda	la	información	de	los	pedidos	posteriores	a	agosto	de	2010.
SELECT pedido.numPedido , pedido.usuario , pedido.fecha ,linped.articulo ,linped.cantidad , linped.precio FROM pedido INNER JOIN linped ON pedido.numPedido=linped.numPedido WHERE  YEAR(pedido.fecha)>='2010' AND MONTH(pedido.fecha)>='08';
--T04.003-	Toda	la	información	de	los	pedidos	realizados	entre	agosto	y	octubre	de	2010.
SELECT pedido.numPedido , pedido.usuario , pedido.fecha ,linped.articulo ,linped.cantidad , linped.precio FROM pedido INNER JOIN linped ON linped.numPedido=pedido.numPedido WHERE MONTH(pedido.fecha)>='08' AND MONTH(pedido.fecha)<='10' AND YEAR(pedido.fecha)='2010' ORDER by numPedido ;
