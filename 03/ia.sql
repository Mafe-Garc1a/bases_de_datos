--  T09.007 – Pedidos de usuarios que han hecho más de 10 pedidos
sql
Copiar
Editar
SELECT p.numPedido, p.usuario
FROM pedido p
WHERE p.usuario IN (
    SELECT usuario
    FROM pedido
    GROUP BY usuario
    HAVING COUNT(*) > 10
);
-- ✅ T09.008 – Pedidos con más de 4 artículos distintos
sql
Copiar
Editar
SELECT numPedido
FROM linped
GROUP BY numPedido
HAVING COUNT(DISTINCT articulo) > 4;
-- ✅ T09.009 – Provincias que se llaman igual (sin repetir nombre)
sql
Copiar
Editar
SELECT nombre
FROM provincia
GROUP BY nombre
HAVING COUNT(*) > 1;
-- ✅ T09.010 – Localidades con nombres repetidos
sql
Copiar
Editar
SELECT nombre
FROM localidad
GROUP BY nombre
HAVING COUNT(*) > 1;
-- ✅ T09.011 – Provincias con más de 100 localidades
sql
Copiar
Editar
SELECT p.codP, p.nombre
FROM provincia p
JOIN localidad l ON l.provincia = p.codP
GROUP BY p.codP
HAVING COUNT(*) > 100;
-- ✅ T09.012 – Artículos en la cesta pero no en pedidos
sql
Copiar
Editar
SELECT a.cod, a.nombre, COUNT(*) AS veces_en_cesta
FROM articulo a
JOIN contiene co ON co.articulo = a.cod
WHERE a.cod NOT IN (
    SELECT DISTINCT articulo FROM linped
)
GROUP BY a.cod;
-- ✅ T09.013 – Clientes que han pedido más de 2 televisores
sql
Copiar
Editar
SELECT p.usuario
FROM pedido p
JOIN linped l ON p.numPedido = l.numPedido
JOIN televisor t ON l.articulo = t.cod
GROUP BY p.usuario
HAVING COUNT(*) > 2;
-- ✅ T09.014 – ¿Cuántas veces se ha pedido cada artículo? (incluso los no pedidos)
sql
Copiar
Editar
SELECT a.cod, a.nombre, COUNT(l.articulo) AS veces_pedido
FROM articulo a
LEFT JOIN linped l ON a.cod = l.articulo
GROUP BY a.cod;
-- ✅ T09.015 – Provincias con menos de 50 usuarios (según su provincia, no dirección de envío)
sql
Copiar
Editar
SELECT p.codP, p.nombre
FROM provincia p
JOIN localidad l ON l.provincia = p.codP
JOIN usuario u ON u.localidad = l.codLoc
GROUP BY p.codP
HAVING COUNT(u.email) < 50;
-- ✅ T09.016 – Artículos con stock = 0
sql
Copiar
Editar
SELECT a.cod, a.nombre
FROM articulo a
JOIN stock s ON a.cod = s.articulo
WHERE s.disponible = 0;
-- ✅ T09.017 – Artículos que no son ni memoria, ni TV, ni objetivo, ni cámara, ni pack
sql
Copiar
Editar
SELECT a.cod, a.nombre
FROM articulo a
LEFT JOIN memoria m ON a.cod = m.cod
LEFT JOIN televisor t ON a.cod = t.cod
LEFT JOIN objetivo o ON a.cod = o.cod
LEFT JOIN camara c ON a.cod = c.cod
LEFT JOIN packarticulo p ON a.cod = p.articulo
WHERE m.cod IS NULL AND t.cod IS NULL AND o.cod IS NULL AND c.cod IS NULL AND p.articulo IS NULL;

-- ✅ T11.001 – Códigos de artículos "Samsung" que han sido pedidos
sql
Copiar
Editar
SELECT DISTINCT a.cod
FROM articulo a
JOIN linped l ON a.cod = l.articulo
WHERE a.marca = 'Samsung';
-- ✅ T11.002 – Cámaras compactas o televisores CRT
sql
Copiar
Editar
SELECT a.cod, a.nombre
FROM articulo a
LEFT JOIN camara c ON a.cod = c.cod
LEFT JOIN televisor t ON a.cod = t.cod
WHERE c.tipo = 'Compacta' OR t.tipo = 'CRT';
-- ✅ T11.003 – Usuarios cuya localidad y provincia son distintas, pero ambas contienen "San Vicente" y "Valencia"
sql
Copiar
Editar
SELECT u.email, u.nombre, u.apellidos
FROM usuario u
JOIN localidad l ON u.localidad = l.codLoc
JOIN provincia p ON l.provincia = p.codP
WHERE l.nombre LIKE '%San Vicente%'
  AND p.nombre LIKE '%Valencia%'
  AND l.nombre <> p.nombre;
-- ✅ T11.004 – Usuarios de Asturias cuya dirección de envío repite dirección
sql
Copiar
Editar
SELECT u.email, d.direccion
FROM usuario u
JOIN direccionenvio d ON u.email = d.usuario
JOIN localidad l ON u.localidad = l.codLoc
JOIN provincia p ON l.provincia = p.codP
WHERE p.nombre = 'Asturias'
GROUP BY d.direccion
HAVING COUNT(*) > 1;
-- ✅ T11.005 – Objetivos con focales de 500 o 600 mm, y marcas sin ventas en nov. 2010
sql
Copiar
Editar
SELECT o.cod, o.focal, a.marca
FROM objetivo o
JOIN articulo a ON o.cod = a.cod
WHERE o.focal IN (500, 600)
  AND a.marca NOT IN (
    SELECT DISTINCT a2.marca
    FROM linped l
    JOIN pedido p ON l.numPedido = p.numPedido
    JOIN articulo a2 ON l.articulo = a2.cod
    WHERE MONTH(p.fecha) = 11 AND YEAR(p.fecha) = 2010
  );
-- ✅ T11.006 – Código y PVP de artículos Samsung sin pedidos
sql
Copiar
Editar
SELECT a.cod, a.pvp
FROM articulo a
WHERE a.marca = 'Samsung'
  AND a.cod NOT IN (
    SELECT DISTINCT articulo FROM linped
  );
-- ✅ T11.007 – Pedidos con artículos que están en la cesta y en stock
sql
Copiar
Editar
SELECT DISTINCT p.numPedido
FROM pedido p
JOIN linped l ON p.numPedido = l.numPedido
WHERE l.articulo IN (
    SELECT articulo FROM contiene
    INTERSECT
    SELECT articulo FROM stock
);
Nota: INTERSECT no está disponible en MySQL, se simula con IN (...) AND ... IN (...).

-- ✅ T11.008 – Localidades con 2+ usuarios distintos (producto cartesiano)
sql
Copiar
Editar
SELECT l.nombre
FROM localidad l
JOIN usuario u ON l.codLoc = u.localidad
GROUP BY l.nombre
HAVING COUNT(DISTINCT u.email) >= 2;
-- ✅ T11.009 – Artículos en stock, en cesta y no pedidos
sql
Copiar
Editar
SELECT a.cod, a.nombre
FROM articulo a
JOIN contiene co ON a.cod = co.articulo
JOIN stock s ON a.cod = s.articulo
WHERE a.cod NOT IN (
    SELECT DISTINCT articulo FROM linped
);
-- ✅ T11.010 – Artículos que están en pack y también en una cesta
sql
Copiar
Editar
SELECT a.cod, a.nombre
FROM articulo a
JOIN contiene co ON a.cod = co.articulo
JOIN packarticulo p ON a.cod = p.articulo;
-- ✅ T11.011 – Artículos en alguna cesta y en alguna línea de pedido
sql
Copiar
Editar
SELECT DISTINCT a.cod, a.nombre
FROM articulo a
JOIN contiene co ON a.cod = co.articulo
JOIN linped l ON a.cod = l.articulo;
-- ✅ T11.012 – Usuarios que han hecho pedido y usuarios que no han hecho ninguno
sql
Copiar
Editar
SELECT u.email, 
       CASE 
         WHEN p.usuario IS NULL THEN 'Sin pedido'
         ELSE 'Con pedido'
       END AS estado_pedido
FROM usuario u
LEFT JOIN pedido p ON u.email = p.usuario;
-- ✅ T11.013 – Apellidos repetidos
sql
Copiar
Editar
SELECT apellidos, COUNT(*) AS repeticiones
FROM usuario
GROUP BY apellidos
HAVING COUNT(*) > 1;
-- ✅ T11.014 – Provincias con pueblos que se llaman igual
sql
Copiar
Editar
SELECT l.nombre, COUNT(*)
FROM localidad l
GROUP BY l.nombre
HAVING COUNT(*) > 1;
-- ✅ T11.015 – Artículos en stock con estado "Descatalogado" y sin pedidos
sql
Copiar
Editar
SELECT a.cod, a.nombre
FROM articulo a
JOIN stock s ON a.cod = s.articulo
WHERE a.estado = 'Descatalogado'
  AND a.cod NOT IN (SELECT DISTINCT articulo FROM linped);
-- ✅ T11.021 – Usuarios con pedidos pero que nunca pidieron cámaras
sql
Copiar
Editar
SELECT DISTINCT p.usuario
FROM pedido p
WHERE p.usuario NOT IN (
    SELECT p2.usuario
    FROM pedido p2
    JOIN linped l ON p2.numPedido = l.numPedido
    JOIN camara c ON l.articulo = c.cod
);
-- ✅ T11.022 – Artículos pedidos en todos los pedidos
sql
Copiar
Editar
SELECT l.articulo
FROM linped l
GROUP BY l.articulo
HAVING COUNT(DISTINCT l.numPedido) = (SELECT COUNT(*) FROM pedido);
-- ✅ T11.023 – Artículos pedidos en todos los pedidos de "acm@colegas.com"
sql
Copiar
Editar
SELECT l.articulo
FROM linped l
JOIN pedido p ON l.numPedido = p.numPedido
WHERE p.usuario = 'acm@colegas.com'
GROUP BY l.articulo
HAVING COUNT(DISTINCT l.numPedido) = (
    SELECT COUNT(*) FROM pedido WHERE usuario = 'acm@colegas.com'
);
-- ✅ T11.024 – Si hay registros en la tabla marca
sql
Copiar
Editar
SELECT IF(EXISTS(SELECT * FROM marca), 'sí', 'no') AS hay_marca;
-- ✅ T11.025 – Si hay registros en la tabla memoria
sql
Copiar
Editar
SELECT IF(EXISTS(SELECT * FROM memoria), 'sí', 'no') AS hay_memoria;
-- ✅ T11.026 – Pedidos que contienen cámaras y televisores
sql
Copiar
Editar
SELECT numPedido
FROM linped
WHERE articulo IN (SELECT cod FROM camara)
INTERSECT
SELECT numPedido
FROM linped
WHERE articulo IN (SELECT cod FROM televisor);
⚠ En MySQL reemplazar con GROUP BY HAVING COUNT(DISTINCT tipo) = 2

-- ✅ T11.027 – Pedidos con cámaras y objetivos
sql
Copiar
Editar
SELECT l.numPedido
FROM linped l
JOIN articulo a ON l.articulo = a.cod
LEFT JOIN camara c ON a.cod = c.cod
LEFT JOIN objetivo o ON a.cod = o.cod
GROUP BY l.numPedido
HAVING SUM(c.cod IS NOT NULL) > 0 AND SUM(o.cod IS NOT NULL) > 0;








-- ✅ T08.011 – Código, nombre, PVP y fecha de incorporación a la cesta más reciente
-- 📄 Consulta actual que te envié:
sql
Copiar
Editar
SELECT a.cod, a.nombre, a.pvp, c.fecha
FROM contiene co
JOIN articulo a ON co.articulo = a.cod
JOIN cesta c ON c.id = co.cesta
ORDER BY c.fecha DESC
LIMIT 1;








