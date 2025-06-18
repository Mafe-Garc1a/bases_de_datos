-- T08.001: Obtener el precio total por línea para el pedido 1 ,(campos salida: numlinea, artículo, total).
SELECT numPedido ,linea , articulo, precio,cantidad , precio*cantidad AS total FROM linped WHERE numPedido=1;
--se hace la operacion y se le da un nombre con el AS

-- T08.002: Cantidad de provincias distintas de las que hay usuarios registrados.
SELECT COUNT(DISTINCT localidad.provincia) AS cantidad_provincias_sin_usuarios FROM localidad INNER JOIN usuario ON usuario.provincia!=localidad.provincia;
-- T08.003: Cantidad total de usuarios registrados.
SELECT COUNT(*) AS UARIOS_REGISTRADOS FROM usuario;
-- T08.004: Número de artículos cuyo precio de venta es mayor de 200 euros.
SELECT COUNT(*) AS cant_ariculo_mayor_200EU FROM articulo WHERE pvp>200;
-- T08.005: Total en euros de la cesta del usuario "bmm@agwab.com".
SELECT SUM(articulo.pvp) AS total_cesta FROM cesta INNER JOIN articulo ON articulo.cod=cesta.articulo WHERE usuario LIKE '%bmm@agwab.com%';
-- T08.006: Tamaño máximo de pantalla para las televisiones.
SELECT MAX(pantalla) AS pantalla_MAX FROM tv;

-- T08.007: Media de venta al publico disttos de los articulos redondeada a dos decimales
--Media del PVP de artículos, redondeada a dos decimales.
SELECT ROUND(AVG(pvp),2) FROM articulo;
-- T08.008: Nombre y precio de los artículos con el mínimo stock.
SELECT articulo.cod,articulo.nombre, MIN(stock.disponible)AS menor_stock FROM articulo INNER JOIN stock ON articulo.cod=stock.articulo;
-- T08.009: Número de pedido, fecha y nombre y apellidos del usuario con el pedido de mayor total.
SELECT pedido.numPedido,pedido.fecha,usuario.nombre,usuario.Apellidos,linped.articulo,MAX(linped.precio*linped.cantidad) AS Mayor_total FROM pedido INNER JOIN usuario ON usuario.email=pedido.usuario INNER JOIN linped ON linped.numPedido=pedido.numPedido;
-- T08.010: Máximo, mínimo y media del precio de los artículos.
SELECT MAX(pvp) AS maximo , MIN(pvp) AS minimo , AVG(pvp) AS promedio FROM articulo;
-- T08.011: Código, nombre, PVP y fecha de incorporación a la cesta más reciente.
SELECT articulo.cod, articulo.nombre, articulo.pvp, cesta.fecha
FROM  articulo
JOIN cesta  ON cesta.articulo= articulo.cod
ORDER BY cesta.fecha DESC
LIMIT 1;
--lo que hace el order by es  orgaizar on la fecha mas reciente  se le die q solo puede tomar  valor

-- T08.012: Cantidad de artículos que están descatalogados.
SELECT  COUNT(*)AS descatalogados FROM stock     WHERE entrega LIKE 'Descatalogados';
-- T08.013: Precio máximo de artículos en stock cuya entrega es "Próximamente".

-- T08.014: Nombre, código y disponibilidad de artículos cuyo código termina en "3", con el stock más bajo.

-- T08.015: Precio máximo, mínimo y medio de las líneas de pedido que incluyen el artículo "Bravia KDL-32EX402".

-- T08.016: Cantidad total pedida de artículos cuyo nombre empieza por "UE22".

-- T08.017: Precio medio de los artículos incluidos en la línea de pedido número 4 (3 decimales).

-- 🔹 T09. Consultas sobre marcas, sensores, usuarios y repeticiones
-- T09.001: ¿Cuántos artículos tiene cada marca?

-- T09.002: Marcas con menos de 150 artículos.

-- T09.003: Igual que la anterior, pero sin incluir marcas NULL.

-- T09.004: Número de cámaras con sensor CMOS.

-- T09.005: Nombre, apellidos y email de usuarios con más de un pedido.

-- T09.006: Pedidos cuyo total supera los 4000 euros.

-- T09.007: Pedidos hechos por usuarios que han hecho más de 10 pedidos (mostrar esa cantidad).

-- T09.008: Pedidos que contienen más de 4 artículos distintos.

-- T09.009: ¿Hay provincias que se llamen igual (no repetir nombre)?

-- T09.010: ¿Hay algún pueblo con nombre repetido?

-- T09.011: Obtener código y nombre de provincias con más de 100 pueblos.

-- T09.012: Artículos añadidos en la cesta sin estar en pedidos. Mostrar código, nombre y veces que aparece.

-- T09.013: Clientes que han pedido más de 2 televisores.

-- T09.014: ¿Cuántas veces se ha pedido cada artículo? Mostrar incluso los que no se han pedido.

-- T09.015: Código y nombre de provincias con menos de 50 usuarios (provincias de usuarios, no de dirección de envío).

-- T09.016: Artículos con stock = 0.

-- T09.017: Artículos que no son memoria, ni TV, ni objetivo, ni cámara, ni pack.

-- 🔹 T11. Consultas avanzadas con operadores y concatenaciones
-- T11.001: Códigos de artículos "Samsung" que han sido pedidos.

-- T11.002: Artículos que son cámaras compactas o televisores CRT.

-- T11.003: Usuarios cuya localidad y provincia son distintas, pero ambas contengan “San Vicente” y “Valencia”.

-- T11.004: Usuarios de Asturias cuya dirección de envío tenga la misma dirección.

-- T11.005: Objetivos con focales de 500 o 600 mm, marcas que no han vendido ningún artículo en noviembre de 2010.

-- T11.006: Código y PVP de artículos "Samsung" sin pedidos.

-- T11.007: Pedidos con artículos que están en la cesta y en stock.

-- T11.008: Localidades con 2 o más usuarios distintos (producto cartesiano).

-- T11.009: Artículos en stock, cesta y sin pedido.

-- T11.010: Códigos y nombres de artículos que aparecen en un pack y también en una cesta.

-- T11.011: Artículos que están en alguna cesta y en alguna línea de pedido.

-- T11.012: Usuarios que han hecho pedido y que no han hecho ninguno.

-- T11.013: Apellidos que se repiten en más de un usuario (sin usar distinct).

-- T11.014: Provincias con pueblos que se llamen igual, junto con nombre del pueblo.

-- T11.015: Artículos en stock con estado "Descatalogado" y no pedidos.

-- T11.021: Usuarios que han hecho pedidos pero no cámaras.

-- T11.022: Artículo incluido en todos los pedidos.

-- T11.023: Artículos pedidos por todos los pedidos del usuario "acm@colegas.com".

-- T11.024: Si hay alguna fila en tabla marca, mostrar "sí"; si no, "no".

-- T11.025: Igual pero para tabla memoria.

-- T11.026: Pedidos que incluyan cámaras y televisores.

-- T11.027: Pedidos que incluyan cámaras y objetivos.

-- T11.028: Concatenación natural de artículos y memorias.

-- T11.029: Concatenación natural de artículos y memorias (con nombre, pvp, marca y tipo).

-- T11.030: Igual que 29, pero solo tipo "Compact Flash".

-- T11.031: Concatenación natural de pedido y linped, ordenado por fecha.

-- T11.032: Comprobar si la concatenación cesta y pack produce producto cartesiano.

-- T11.034: ¿Por qué usuario y direnvio dan tabla vacía con concatenación natural?