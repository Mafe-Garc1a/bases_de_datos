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
--T04.004-	Toda	la	información	de	los	pedidos	realizados	el	3	de	marzo	o	el	27	de	octubre	de	2010.
SELECT pedido.numPedido , pedido.usuario , pedido.fecha ,linped.articulo ,linped.cantidad , linped.precio FROM pedido INNER JOIN linped ON linped.numPedido=pedido.numPedido WHERE MONTH(pedido.fecha)='03' AND DAY(pedido.fecha)='03'  OR MONTH(pedido.fecha)='10' AND DAY(pedido.fecha)='27'AND YEAR(pedido.fecha)='2010' ORDER by numPedido ;
--T04.005-	Toda	la	información	de	los	pedidos	realizados	el	3	de	marzo	o	el	27	de	octubre	de	2010,	y	que	han	sido	realizados	por	usuarios	del	dominio	"cazurren"	
SELECT pedido.numPedido , pedido.usuario , pedido.fecha , linped.articulo , linped.cantidad , linped.precio FROM pedido INNER JOIN linped ON linped.numPedido=pedido.numPedido WHERE DAY(pedido.fecha)='03'AND MONTH(pedido.fecha)='03' OR DAY(pedido.fecha)='27' AND MONTH(pedido.fecha)='10' AND YEAR(pedido.fecha)='2010' AND pedido.usuario LIKE '%@cazurren%';
--T04.006-	¿En	qué	día	y	hora	vivimos?	
S

-- T04.007-	21	de	febrero	de	2011	en	formato	dd/mm/aaaa	
SELECT numPedido, DATE_FORMAT(fecha, '%d/%m/%Y') AS fecha
FROM pedido
WHERE DATE(fecha) = '2011-02-21';

-- T04.008-	31	de	febrero	de	2011	en	formato	dd/mm/aaaa	
-- No habrá resultados porque la fecha no es válida.
SELECT numPedido, DATE_FORMAT(fecha, '%d/%m/%Y') AS fecha
FROM pedido
WHERE DATE(fecha) = '2011-02-31';

-- T04.009-	Pedidos	realizados	el	13.9.2010	(este	formato,	obligatorio	en	la	comparación).
SELECT numPedido
FROM pedido
WHERE DATE_FORMAT(fecha, '%e.%c.%Y') = '13.9.2010';

-- T04.010-	Numero	y	fecha	de	los	pedidos	realizados	el	13.9.2010	(este	formato,	obligatorio	tanto	en	la	comparación	como	en	la	salida).	
SELECT numPedido, DATE_FORMAT(fecha, '%e.%c.%Y') AS fecha
FROM pedido
WHERE DATE_FORMAT(fecha, '%e.%c.%Y') = '13.9.2010';

-- T04.011-	Numero,	fecha,	y	email	de	cliente	de	los	pedidos	(formato	dd.mm.aa)	ordenadoDescendente	por	fecha	y	ascendentemente	por	cliente.	
SELECT numPedido, DATE_FORMAT(fecha, '%d.%m.%y') AS fecha, usuario AS email
FROM pedido
ORDER BY fecha DESC, usuario ASC;

-- T04.012-	Códigos	de	artículos	solicitados	en	2010,	eliminando	duplicados	y	ordenado	ascendentemente.
SELECT DISTINCT articulo
FROM linped
JOIN pedido ON linped.numPedido = pedido.numPedido
WHERE YEAR(pedido.fecha) = 2010
ORDER BY articulo ASC;

-- T04.013-	Códigos	de	artículos	solicitados	en	pedidos	de	marzo	de	2010,	eliminando	duplicados	y	ordenado	ascendentemente.	
SELECT DISTINCT articulo
FROM linped
JOIN pedido ON linped.numPedido = pedido.numPedido
WHERE MONTH(pedido.fecha) = 3 AND YEAR(pedido.fecha) = 2010
ORDER BY articulo ASC;

-- T04.014-	Códigos	de	artículos	solicitados	en	pedidos	de	septiembre	de	2010,	y	semana	del	año	(la	semana	comienza	en	lunes)	y	año	del	pedido,	ordenado	por	semana.	
SELECT DISTINCT articulo,
       WEEK(pedido.fecha, 1) AS semana,
       YEAR(pedido.fecha) AS anio
FROM linped
JOIN pedido ON linped.numPedido = pedido.numPedido
WHERE MONTH(pedido.fecha) = 9 AND YEAR(pedido.fecha) = 2010
ORDER BY semana;

-- T04.015-	Nombre,	apellidos	y	edad	(aproximada)	de	los	usuarios	del	dominio	"dlsi.ua.es",	ordenado	descendentemente	por	edad.	


--DATEDIFF: es una función de MySQL que calcula la diferencia en días entre dos fechas.

--FLOOR redondea hacia abajo el número resultante.

-- Por ejemplo:

-- Si DATEDIFF da 9125 días → 9125 / 365 = 25.0 → FLOOR(25.0) → 25 años

-- Si da 9110 días → 9110 / 365 ≈ 24.9 → FLOOR(24.9) → 24 años
---EL DATEDIFF RECIBE 2 PARAMETROS DNDE HAY UNA FECHA INICIAL Y UNA FINAL (NUMERO ENTERO)
SELECT nombre, apellidos,
       FLOOR(DATEDIFF(CURDATE(), nacido)/365) AS edad
FROM usuario
WHERE email LIKE '%@dlsi.ua.es'
ORDER BY edad ;

-- T04.016-	Email	y	cantidad	de	días	que	han	pasado	desde	los	pedidos	realizados	por	cada	usuario	hasta	la	fecha	de	cada	cesta	que	también	sea	suya.	Eliminad	duplicados.	
SELECT DISTINCT u.email, DATEDIFF(c.fecha, p.fecha) AS dias_diferencia
FROM usuario u
JOIN pedido p ON u.email = p.usuario
JOIN cesta c ON u.email = c.usuario
WHERE c.fecha >= p.fecha;

-- T04.017-	Información	sobre	los	usuarios	menores	de	25	años.	
SELECT *
FROM usuario
WHERE TIMESTAMPDIFF(YEAR, nacido, CURDATE())= < 25;

-- T04.018-	Número	de	pedido,	usuario	y	fecha	(dd/mm/aaaa)	al	que	se	le	solicitó	para	los	pedidos	que	se	realizaron	durante	la	semana	del	7	de	noviembre	de	2010.	
SELECT numPedido, usuario,
       DATE_FORMAT(fecha, '%d/%m/%Y') AS fecha
FROM pedido
WHERE WEEK(fecha, 1) = WEEK('2010-11-07', 1) AND YEAR(fecha) = 2010;

-- T04.019-	Código,	nombre,	panel	y	pantalla	de	los	televisores	que	no	se	hayan	solicitado	ni	en	lo	que	va	de	año,	ni	en	los	últimos	seis	meses	del	año	pasado.	
SELECT a.cod, a.nombre, t.panel, t.pantalla
FROM articulo a
JOIN tv t ON a.cod = t.cod
WHERE a.cod NOT IN (
  SELECT DISTINCT articulo 
  FROM linped
  JOIN pedido ON linped.numPedido = pedido.numPedido
  WHERE (YEAR(fecha) = YEAR(CURDATE())) 
     OR (fecha BETWEEN DATE_SUB(DATE_FORMAT(CURDATE(), '%Y-01-01'), INTERVAL 6 MONTH)
                  AND LAST_DAY(DATE_SUB(DATE_FORMAT(CURDATE(), '%Y-01-01'), INTERVAL 1 MONTH)))
);

-- T04.020-	Email	y	cantidad	de	días	que	han	pasado	desde	los	pedidos	realizados	por	cada	usuario	hasta	la	fecha	de	cada	artículo	que	ahora	mismo	hay	en	su	cesta.	Eliminad	 duplicados.
SELECT DISTINCT u.email,
       DATEDIFF(c.fecha, p.fecha) AS dias_diferencia
FROM usuario u
JOIN pedido p ON u.email = p.usuario
JOIN cesta c ON u.email = c.usuario
WHERE EXISTS (
  SELECT 1
  FROM contiene
  WHERE contiene.cesta = c.id
);

-- T05.001-	Número	de	pedido	e	identificador,	apellidos	y	nombre	del	usuario	que	realiza	el	 pedido	(usando	join).
SELECT p.numPedido, u.email, u.apellidos, u.nombre
FROM pedido p
JOIN usuario u ON p.usuario = u.email;

-- T05.002-	Número	de	pedido	e	identificador,	apellidos	y	nombre	del	usuario	que	realiza	el	
-- pedido,	y	nombre	de	la	localidad	del	usuario	(usando	join).	
SELECT p.numPedido, u.email, u.apellidos, u.nombre, l.nombre AS localidad
FROM pedido p
JOIN usuario u ON p.usuario = u.email
JOIN localidad l ON u.localidad = l.codLoc;

-- T05.003-	Número	de	pedido	e	identificador,	apellidos	y	nombre	del	usuario	que	realiza	el	
-- pedido,	nombre	de	la	localidad	y	nombre	de	la	provincia	del	usuario	(usando	join).	
SELECT p.numPedido, u.email, u.apellidos, u.nombre, l.nombre AS localidad, pr.nombre AS provincia
FROM pedido p
JOIN usuario u ON p.usuario = u.email
JOIN localidad l ON u.localidad = l.codLoc
JOIN provincia pr ON l.provincia = pr.codP;

-- T05.004-	Nombre	de	provincia	y	nombre	de	localidad	ordenados	por	provincia	y	localidad	
-- (usando	join)	de	las	provincias	de	Aragón	y	de	localidades	cuyo	nombre	comience	por	"B".
SELECT provincia.nombre ,localidad.pueblo FROM provincia RIGHT JOIN localidad ON provincia.codp=localidad.provincia WHERE provincia.nombre LIKE '$Arag%'	AND  localidad.pueblo LIKE 'b%' ORDER BY provincia.nombre, localidad.pueblo ;
-- T05.005-	Apellidos	y	nombre	de	los	usuarios	y,	si	tienen,	pedido	que	han	realizado.	
  SELECT usuario.nombre ,usuario.apellidos ,pedido.numPedido FROM usuario RIGHT JOIN pedido ON usuario.email=pedido.usuario ORDER BY numPedido ;
-- T05.006-	Código	y	nombre	de	los	artículos,	si	además	es	una	cámara,	mostrar	también	la	
-- resolución	y	el	sensor.	
SELECT articulo.cod , articulo.nombre , camara.resolucion,camara.sensor FROM articulo LEFT JOIN camara ON camara.cod=articulo.cod ;
-- T05.007-	Código,	nombre	y	precio	de	venta	al	público	de	los	artículos,	si	además	se	trata	
-- de	un	objetivo	mostrar	todos	sus	datos.	
-- T05.008-	Muestra	las	cestas	del	año	2010	junto	con	el	nombre	del	artículo	al	que	
-- referencia	y	su	precio	de	venta	al	público.	
-- T05.009-	Muestra	toda	la	información	de	los	artículos.	Si	alguno	aparece	en	una	cesta	del	
-- año	2010	muestra	esta	información.	
-- T05.010-	Disponibilidad	en	el	stock	de	cada	cámara	junto	con	la	resolución	de	todas	las	
-- cámaras.	
-- T05.011-	Código	y	nombre	de	los	artículos	que	no	tienen	marca.	
-- T05.012-	Código,	nombre	y	marca	de	todos	los	artículos,	tengan	o	no	marca.	
-- T05.013-	Código,	nombre,	marca	y	empresa	responsable	de	la	misma	de	todos	los	
-- artículos.	Si	algún	artículo	no	tiene	marca	debe	aparecer	en	el	listado	con	esta	información	
-- vacía.	
-- T05.014-	Información	de	todos	los	usuarios	de	la	comunidad	valenciana	cuyo	nombre	
-- empiece	por	'P'	incluyendo	la	dirección	de	envío	en	caso	de	que	la	tenga.	
-- T05.015-	Código	y	nombre	de	los	artículos,	y	código	de	pack	en	el	caso	de	que	pertenezca	
-- a	alguno.	
-- T05.016-	Usuarios	y	pedidos	que	han	realizado.	
-- T05.017-	Información	de	aquellos	usuarios	de	la	comunidad	valenciana	(códigos	03,	12	y	
-- 46)	cuyo	nombre	empiece	por	'P'	que	tienen	dirección	de	envío	pero	mostrando,	a	la	
-- derecha,	todas	las	direcciones	de	envío	de	la	base	de	datos