CREATE TABLE roles(
    id_rol CHAR (10) PRIMARY KEY,
    nombre VARCHAR (40),
    descripcion VARCHAR(300);
)

CREATE TABLE usuarios(
    id_user CHAR (10) PRIMARY KEY,
    name_user VARCHAR (40),
    last_name VARCHAR (40),
    email VARCHAR (50), 
    pass CHAR (15),
    permission VARCHAR (50),
    states BOOLEAN,
    id_rol CHAR(5),
    FOREIGN KEY (id_rol) REFERENCES roles(id_rol);
)

CREATE TABLE taxi(
    id_taxi CHAR (10) PRIMARY KEY,
    model VARCHAR (20),
    año int, 
    state_taxi BOOLEAN;
)

CREATE TABLE turnos(
    id_turnos CHAR(6) PRIMARY KEY,
    asignado_por CHAR (40), 
    FOREIGN KEY (asignado_por) REFERENCES usuarios(id_user),
    driver CHAR(40),
    FOREIGN KEY (driver) REFERENCES usuarios(id_user),
    id_taxi CHAR(10),
    FOREIGN KEY (id_taxi) REFERENCES taxi(id_taxi);
)

CREATE TABLE carrera(
    id_carrera CHAR(6) PRIMARY KEY,
    id_turnos CHAR (6),
    FOREIGN kEY id_turnos REFERENCES turnos(id_turnos),
    fecha_hora DATE,
    taximetro int,
    valor_carrera int,
    dir_origen VARCHAR(200),
    dir_destino VARCHAR (200)


);

CREATE TABLE carrera solicitada(
    id_carrera_solicitada CHAR(6) PRIMARY KEY,
    id_pasajero CHAR(30)
    FOREIGN KEY id_pasajero REFERENCES usuarios(id_user),
    id_carrera CHAR(6),
    FOREIGN KEY id_carrera REFERENCES carrera(id_carrera);
)

ALTER TABLE usuarios ADD iNDEX (last_name);





-------------------

SELECT pvp AS mayor
FROM articulo
WHERE pvp = (SELECT MAX(pvp) FROM articulo);

SELECT pvp AS menor
FROM articulo
WHERE pvp = (SELECT MIN(pvp) FROM articulo);

SELECT AVG (pvp) AS promedio
FROM articulo;

-------------------

SELECT usuario.nombre, localidad.pueblo, provincia.nombre
FROM usuario
JOIN localidad on (localidad.codm = usuario.pueblo)
JOIN provincia on (provincia.codp = usuario.provincia )
WHERE localidad.pueblo LIKE '%San Vicente%' or provincia.nombre like '%Valencia%';

--------------------------

SELECT COUNT(tv.cod), COUNT


