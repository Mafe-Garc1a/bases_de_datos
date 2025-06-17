---MARIA FERNANDA GARCIA CARVAJAL----
--FICHA:2925889 ANALISIS Y DESARROLLO DE SOFTWARE

CREATE DATABASE colegio;

-- Borrar tablas si ya existen para un entorno limpio
DROP TABLE IF EXISTS actas_cursos;
DROP TABLE IF EXISTS historial_estudiante;
DROP TABLE IF EXISTS inscripciones;
DROP TABLE IF EXISTS cursos;
DROP TABLE IF EXISTS estudiantes;

-- Creación de la tabla de inscripciones (tabla intermedia)
------5------------
CREATE TABLE inscripciones (
    id_inscripcion INT PRIMARY KEY  AUTO_INCREMENT,
    id_estudiante INT ,
    id_curso INT UNSIGNED,
    fecha_inscripcion DATE NOT NULL,
    calificacion_final DECIMAL(4, 2), -- Ej: 9.50, 4.00. Nulo si no está calificado
    FOREIGN KEY (id_estudiante) REFERENCES estudiantes(id_estudiante),
    FOREIGN KEY (id_curso) REFERENCES cursos(id_curso)ON DELETE CASCADE ON UPDATE CASCADE
);
-----esta va 1 --------
-- Creación de la tabla de estudiantes
CREATE TABLE estudiantes (
    id_estudiante INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    estado VARCHAR(20) DEFAULT 'Activo' -- Ej: Activo, Graduado, Suspendido
);
--------2-----

-- Creación de la tabla de cursos
CREATE TABLE cursos (
    id_curso INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    nombre_curso VARCHAR(100) NOT NULL,
    creditos INT NOT NULL,
    cupo_maximo INT NOT NULL,
    cupos_disponibles INT -- Este campo se puede gestionar con un trigger
);
-----3-----
-- Creación de la tabla de historial para registrar cambios de estado de estudiantes
CREATE TABLE historial_estudiante (
    id_historial INT PRIMARY KEY AUTO_INCREMENT,
    id_estudiante INT,
    estado_anterior VARCHAR(20),
    estado_nuevo VARCHAR(20),
    fecha_cambio TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_estudiante) REFERENCES estudiantes(id_estudiante)ON DELETE CASCADE ON UPDATE CASCADE
);
-----4---
-- Creación de la tabla para almacenar actas generadas por procedimientos
CREATE TABLE actas_cursos (
    id_acta INT PRIMARY KEY AUTO_INCREMENT,
    id_curso INT UNSIGNED,
    total_inscritos INT,
    promedio_general DECIMAL(4, 2),
    total_aprobados INT,
    total_reprobados INT,
    fecha_generacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_curso) REFERENCES cursos(id_curso)ON DELETE CASCADE ON UPDATE CASCADE
);

-- Inserción de datos de ejemplo
INSERT INTO estudiantes (nombre, apellido, email) VALUES
('Elena', 'Ríos', 'elena.rios@email.com'),
('Marco', 'Solis', 'marco.solis@email.com'),
('Sofía', 'Vega', 'sofia.vega@email.com');

-- Insertar más estudiantes
INSERT INTO estudiantes (nombre, apellido, email) VALUES
('Carlos', 'Gomez', 'carlos.gomez@email.com'),
('Ana', 'Martinez', 'ana.martinez@email.com'),
('Isabel', 'Jimenez', 'isabel.jimenez@email.com'),
('Ricardo', 'Moreno', 'ricardo.moreno@email.com'),
('Monica', 'Navarro', 'monica.navarro@email.com'),
('David', 'Ruiz', 'david.ruiz@email.com'),
('Valeria', 'Gil', 'valeria.gil@email.com'),
('Sergio', 'Romero', 'sergio.romero@email.com'),
('Paula', 'Alonso', 'paula.alonso@email.com'),
('Adrian', 'Gutierrez', 'adrian.gutierrez@email.com'),
('Beatriz', 'Iglesias', 'beatriz.iglesias@email.com'),
('Luis', 'Hernandez', 'luis.hernandez@email.com'),
('Laura', 'Perez', 'laura.perez@email.com'),
('Javier', 'Diaz', 'javier.diaz@email.com');


INSERT INTO cursos (nombre_curso, creditos, cupo_maximo,cupos_disponibles) VALUES
('Bases de Datos Avanzadas', 4, 4,0),
('Inteligencia Artificial', 4, 8,0),
('Desarrollo Web Full-Stack', 5, 5,0); -- Cupo bajo para poder probar trigger


-- Crear un trigger que se active en la tabla inscripciones. Antes de registrar una nueva inscripción, el trigger debe verificar si el curso ya ha alcanzado su cupo_maximo. Si el número de estudiantes ya inscritos es igual o mayor al cupo, el trigger debe cancelar la operación y mostrar un mensaje de error como "El curso ya no tiene cupos disponibles"
DROP TRIGGER insertar_inscripcion;
DELIMITER //
CREATE TRIGGER insertar_inscripcion BEFORE INSERT ON inscripciones 
FOR EACH ROW 
    BEGIN
    DECLARE cupo_viejo INT;
       IF NEW.id_curso=(SELECT id_curso FROM cursos) THEN 
            IF (SELECT cupo_maximo FROM cursos WHERE id_curso=NEW.id_curso)>(SELECT cupos_disponibles FROM cursos WHERE id_curso=NEW.id_curso) THEN 
            SELECT cupos_disponibles INTO cupo_viejo FROM cursos WHERE id_curso=NEW.id_curso;
            UPDATE cursos SET cupos_disponibles=cupo_viejo+1 WHERE id_curso=NEW.id_curso;
            ELSE
                SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: El curso ya no tiene cupos disponibles';
            END IF;
        ELSE
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: No hay ese curso';
        END IF;
    END;
//
DELIMITER ; 
INSERT INTO inscripciones(id_estudiante,id_curso,fecha_inscripcion,calificacion_final)
VALUES (1,2,'25-03-2025',4);

-- Crear un trigger que se active antes de insertar o actualizar una calificación en la tabla inscripciones. El trigger debe verificar que la calificacion_final se encuentre en un rango válido (por ejemplo, entre 0.00 y 10.00). Si la calificación está fuera de este rango, la operación debe ser cancelada.
DELIMITER //
CREATE TRIGGER actualizar_calificacion BEFORE UPDATE ON inscripciones 
FOR EACH ROW 
    BEGIN
        IF NEW.calificacion_final>=0 AND NEW.calificacion_final<=10 THEN
        UPDATE inscripciones SET calificacion_final=NEW.calificacion_final WHERE id_estudiante=NEW.estudiante AND id_curso=NEW.id_curso;
        ELSE
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: calificacion fuera de rango';
        END IF;
    END;
//
DELIMITER ; 


-- Crear un trigger que se active en la tabla estudiantes. Si el campo estado de un estudiante cambia (por ejemplo, de 'Activo' a 'Graduado' o 'Suspendido'), el trigger deberá insertar una fila en la tabla historial_estudiante registrando el estudiante_id, el estado_anterior, el estado_nuevo y la fecha del cambio.
DELIMITER //
CREATE TRIGGER actualizar_estudiante AFTER UPDATE ON estudiantes 
FOR EACH ROW 
    BEGIN
        DECLARE V_estado_viejo VARCHAR;
        DECLARE v_estado_actual VARCHAR;
       IF OLD.estado!=NEW.estado THEN 
            SET v_estado_actual=NEW.estado;
            SET V_estado_viejo=OLD.estado;
             UPDATE historial_estudiante SET estado_anterior=V_estado_viejo ,    estado_nuevo=v_estado_actual , fecha_cambio= CURRENT_TIMESTAMP() WHERE    id_estudiante=NEW.id_estudiante;


            ELSE
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: calificacion fuera de rango';
       END IF;
    END;
//
DELIMITER ; 
-- Crear un procedimiento que reciba el id de un estudiante y devuelva un resumen de su historial académico, mostrando los cursos que ha tomado, los créditos de cada uno y su calificación final.
DELIMITER //
CREATE PROCEDURE resumen_historial(IN p_id_estudiante INT )
BEGIN 
    SELECT inscripciones.id_estudiante , cursos.nombre_curso , cursos.creditos , inscripciones.calificacion_final FROM inscripciones INNER JOIN cursos ON cursos.id_curso=inscripciones.id_curso WHERE id_estudiante=p_id_estudiante;
    END;
//
DELIMITER ;
-- Crear una funcion que formalice el proceso de dar de baja a un estudiante de un curso.  debe recibir el ID del estudiante y el ID del curso, y eliminar el registro correspondiente de la tabla inscripciones. El trigger trg_restaurar_cupos que creaste anteriormente se encargará de liberar el cupo automáticamente.
DELIMITER //
CREATE FUNCTION dar_baja(IN p_id_estudiante INT,IN p_id_curso INT) 
RETURNS INT
BEGIN

   IF (SELECT id_estudiante FROM inscripciones)=p_id_estudiante THEN
    UPDATE cursos SET cupos_disponibles=cupos_disponibles-1;
    DELETE inscripciones WHERE id_estudiante=p_id_estudiante AND id_curso=p_id_curso;
    RETURN;
   END IF;
END;
//
DELIMITER ;

-- Crear una función llamada calcular_promedio_estudiante. Parámetros de entrada: estudiante_id_param (INT). Parámetros de salida: promedio_calculado (DECIMAL).  debe buscar todas las calificacion_final de un estudiante en la tabla inscripciones, calcular el promedio (ignorando los cursos sin calificar o nulos), y devolver el resultado a través del parámetro de salida.
DELIMITER //
CREATE FUNCTION calcular_promedio_estudiante(IN p_id_estudiante INT,OUT promedio_calculado FLOAT) 
RETURNS FLOAT
BEGIN
    
END;
//
DELIMITER ;

-- Crear un procedimiento almacenado llamado generar_acta_curso. Parámetros de entrada: curso_id_param (INT). El procedimiento debe calcular estadísticas finales para un curso determinado: número total de inscritos, promedio general de calificaciones, número de aprobados y número de reprobados (asumiendo que se aprueba con una nota >= 5.0). Finalmente, debe insertar este resumen en la tabla actas_cursos.