-- Sql 
-- ddl estructura de datos
CREATE TABLE personas(
    id_persona INT UNSIGNED AUTO_INCREMENT,
    nom_persona VARCHAR(30),
    ape_persona VARCHAR(30),
    correo VARCHAR(80);
    fecha_nacimiento DATE,
    PRIMARY KEY(id_persona)
);

--DML
-- datos tabla personas

INSERT INTO personas(nom_persona,ape_persona,correo,fecha_nacimiento)
VALUES('pepito','perez', 'pepe@gamil.com', '2005/05/20');

CREATE TABLE roles(
    id_rol CHAR(4),
    nombre_rol VARCHAR(40),
    descripcion VARCHAR(200),
    PRIMARY KEY(id_rol)
);

CREATE TABLE cuenta(
    id_cuenta INT UNSIGNED AUTO_INCREMENT,
    id_persona INT UNSIGNED,
    nick_name VARCHAR(80),
    pass VARCHAR(180),
    estado BOOLEAN,
    PRIMARY KEY(id_cuenta),
    FOREIGN KEY(id_persona) REFERENCES personas(id_persona),
    FOREIGN KEY(rol) REFERENCES roles(id_rol)
);

CREATE TABLE autos(
    placa CHAR(6),
    marca VARCHAR(30),
    modelo VARCHAR(30),
    color VARCHAR(30),
    anio CHAR(4),
    PRIMARY KEY(placa)
);

CREATE TABLE registro_ingreso(
    id_reg_ingreso INT UNSIGNED AUTO_INCREMENT,
    id_persona INT UNSIGNED,
    placa CHAR(6),
    fecha_hora DATETIME,
    responsable INT UNSIGNED,
    PRIMARY KEY(id_reg_ingreso),
    FOREIGN KEY(id_persona) REFERENCES personas(id_persona),
    FOREIGN KEY(placa) REFERENCES autos(placa),
    FOREIGN KEY(responsable) REFERENCES cuenta(id_cuenta)
);