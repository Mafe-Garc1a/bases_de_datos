---BASE DE DATOS DE UN HOSPITAL-

CREATE  DATABASE hospital;
USE hospital;

-- Tabla: Pacientes
CREATE TABLE pacientes (
    id_paciente INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100),
    apellido VARCHAR(100),
    fecha_nacimiento DATE,
    sexo ENUM('M', 'F'),
    direccion VARCHAR(255),
    telefono VARCHAR(20),
    correo VARCHAR(100),
    tipo_sangre VARCHAR(5)
);

-- Tabla: Doctores
CREATE TABLE doctores (
    id_doctor INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100),
    apellido VARCHAR(100),
    especialidad VARCHAR(100),
    telefono VARCHAR(20),
    correo VARCHAR(100),
    licencia_medica VARCHAR(50)
);

-- Tabla: Citas
CREATE TABLE citas (
    id_cita INT AUTO_INCREMENT PRIMARY KEY,
    id_paciente INT,
    id_doctor INT,
    fecha DATE,
    hora TIME,
    motivo TEXT,
    estado ENUM('programada', 'atendida', 'cancelada'),
    FOREIGN KEY (id_paciente) REFERENCES pacientes(id_paciente),
    FOREIGN KEY (id_doctor) REFERENCES doctores(id_doctor)ON DELETE CASCADE ON UPDATE CASCADE
);

-- Tabla: Consultas
CREATE TABLE consultas (
    id_consulta INT AUTO_INCREMENT PRIMARY KEY,
    id_cita INT,
    diagnostico TEXT,
    tratamiento TEXT,
    observaciones TEXT,
    fecha_consulta DATE,
    FOREIGN KEY (id_cita) REFERENCES citas(id_cita)ON DELETE CASCADE ON UPDATE CASCADE
);

-- Tabla: Habitaciones
CREATE TABLE habitaciones (
    id_habitacion INT AUTO_INCREMENT PRIMARY KEY,
    numero VARCHAR(10),
    tipo ENUM('individual', 'doble', 'uci', 'otro'),
    estado ENUM('disponible', 'ocupada', 'mantenimiento')
);

-- Tabla: Ingresos
CREATE TABLE ingresos (
    id_ingreso INT AUTO_INCREMENT PRIMARY KEY,
    id_paciente INT,
    id_habitacion INT,
    fecha_ingreso DATE,
    fecha_egreso DATE,
    motivo TEXT,
    FOREIGN KEY (id_paciente) REFERENCES pacientes(id_paciente),
    FOREIGN KEY (id_habitacion) REFERENCES habitaciones(id_habitacion)ON DELETE CASCADE ON UPDATE CASCADE
);

-- Tabla: Medicamentos
CREATE TABLE medicamentos (
    id_medicamento INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100),
    descripcion TEXT,
    dosis VARCHAR(50),
    via_administracion VARCHAR(50)
);

-- Tabla: Recetas
CREATE TABLE recetas (
    id_receta INT AUTO_INCREMENT PRIMARY KEY,
    id_consulta INT,
    fecha DATE,
    FOREIGN KEY (id_consulta) REFERENCES consultas(id_consulta)ON DELETE CASCADE ON UPDATE CASCADE
);

-- Tabla intermedia: Detalle de receta
CREATE TABLE receta_detalle (
    id_receta INT,
    id_medicamento INT,
    dosis VARCHAR(50),
    frecuencia VARCHAR(50),
    duracion VARCHAR(50),
    PRIMARY KEY (id_receta, id_medicamento),
    FOREIGN KEY (id_receta) REFERENCES recetas(id_receta),
    FOREIGN KEY (id_medicamento) REFERENCES medicamentos(id_medicamento)ON DELETE CASCADE ON UPDATE CASCADE
);

-- Tabla: Empleados (no médicos)
CREATE TABLE empleados (
    id_empleado INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100),
    apellido VARCHAR(100),
    cargo VARCHAR(50),
    area VARCHAR(100),
    salario DECIMAL(10, 2),
    fecha_contrato DATE
);

--INSERTAR DATOS---
INSERT INTO pacientes (nombre, apellido, fecha_nacimiento, sexo, direccion, telefono, correo, tipo_sangre) VALUES
('Carlos', 'Gómez', '1990-05-10', 'M', 'Calle 123', '3101234567', 'carlos@gmail.com', 'O+'),
('Laura', 'Martínez', '1985-11-22', 'F', 'Cra 45', '3119876543', 'laura@hotmail.com', 'A-'),
('Pedro', 'López', '2000-03-18', 'M', 'Av. 9 #56', '3125550001', 'pedro@outlook.com', 'B+'),
('Sofía', 'Ramírez', '1995-07-30', 'F', 'Calle 89', '3136789001', 'sofia@gmail.com', 'AB+'),
('Julián', 'Torres', '1982-01-10', 'M', 'Carrera 33', '3109988776', 'julian@hotmail.com', 'O-'),
('Mónica', 'Suárez', '1975-03-25', 'F', 'Av. Siempre Viva', '3147766554', 'moni@gmail.com', 'A+'),
('Andrés', 'Mendoza', '1999-12-12', 'M', 'Cl 10 #23', '3103344556', 'andres@yahoo.com', 'B-'),
('Camila', 'Vargas', '2001-06-01', 'F', 'Cra 66', '3150099887', 'cami@gmail.com', 'AB-'),
('Sebastián', 'Ríos', '1988-08-08', 'M', 'Cl 19 #78', '3101122334', 'sebastian@outlook.com', 'O+'),
('Valentina', 'Navarro', '1993-04-17', 'F', 'Cl 90', '3172233445', 'valen@live.com', 'A+');

INSERT INTO doctores (nombre, apellido, especialidad, telefono, correo, licencia_medica) VALUES
('Ana', 'Ruiz', 'Pediatría', '3001234567', 'ana.ruiz@hospital.com', 'MED1234'),
('Jorge', 'Mejía', 'Cardiología', '3014567890', 'jorge.mejia@hospital.com', 'MED5678'),
('María', 'Santos', 'Ginecología', '3027894561', 'maria.santos@hospital.com', 'MED2345'),
('Daniel', 'García', 'Medicina General', '3031122334', 'daniel.garcia@hospital.com', 'MED6789'),
('Lucía', 'Castro', 'Neurología', '3044455667', 'lucia.castro@hospital.com', 'MED3456'),
('Carlos', 'Vega', 'Dermatología', '3059988776', 'carlos.vega@hospital.com', 'MED9101'),
('Fernanda', 'López', 'Psiquiatría', '3067788990', 'fernanda.lopez@hospital.com', 'MED5432'),
('Hugo', 'Ramírez', 'Ortopedia', '3075566778', 'hugo.ramirez@hospital.com', 'MED8765'),
('Patricia', 'Mora', 'Endocrinología', '3081122445', 'patricia.mora@hospital.com', 'MED1122'),
('Felipe', 'Nieto', 'Urología', '3093344556', 'felipe.nieto@hospital.com', 'MED3344');

INSERT INTO doctores (nombre, apellido, especialidad, telefono, correo, licencia_medica) VALUES
('Ana', 'Gomez', 'Cardiologa', '3001267867', 'ana.gomez23@hospital.com', 'MED1289');


INSERT INTO citas (id_paciente, id_doctor, fecha, hora, motivo, estado) VALUES
(1, 1, '2025-06-20', '09:00:00', 'Control general', 'programada'),
(2, 2, '2025-06-21', '10:30:00', 'Dolor en el pecho', 'atendida'),
(3, 1, '2025-06-22', '08:00:00', 'Fiebre y malestar', 'cancelada'),
(4, 3, '2025-06-23', '11:00:00', 'Chequeo prenatal', 'programada'),
(5, 4, '2025-06-24', '12:00:00', 'Dolor de cabeza', 'atendida'),
(6, 5, '2025-06-25', '09:30:00', 'Problemas de memoria', 'atendida'),
(7, 6, '2025-06-26', '14:00:00', 'Erupción cutánea', 'programada'),
(8, 7, '2025-06-27', '15:00:00', 'Ansiedad', 'programada'),
(9, 8, '2025-06-28', '16:00:00', 'Dolor de rodilla', 'cancelada'),
(10, 9, '2025-06-29', '17:00:00', 'Diabetes tipo II', 'atendida');

INSERT INTO consultas (id_cita, diagnostico, tratamiento, observaciones, fecha_consulta) VALUES
(2, 'Angina leve', 'Reposo y aspirina', 'Paciente estable', '2025-06-21'),
(5, 'Migraña', 'Paracetamol y descanso', 'Mejorando', '2025-06-24'),
(6, 'Pérdida de memoria leve', 'Evaluación neurológica', 'Requiere seguimiento', '2025-06-25'),
(10, 'Diabetes tipo II', 'Metformina', 'Recomendar dieta', '2025-06-29'),
(4, 'Embarazo saludable', 'Vitaminas prenatales', 'Sin complicaciones', '2025-06-23'),
(7, 'Dermatitis', 'Cremas tópicas', 'Evitar alérgenos', '2025-06-26'),
(1, 'Chequeo general', 'Ninguno', 'Paciente sano', '2025-06-20'),
(8, 'Ansiedad leve', 'Terapia y respiración', 'Recomendar psicólogo', '2025-06-27'),
(3, 'Gripe', 'Paracetamol y líquidos', 'Mejorando', '2025-06-22'),
(9, 'Lesión de rodilla', 'Reposo y fisioterapia', 'Molestia persistente', '2025-06-28');

INSERT INTO habitaciones (numero, tipo, estado) VALUES
('101', 'individual', 'ocupada'),
('102', 'doble', 'disponible'),
('103', 'individual', 'disponible'),
('104', 'doble', 'ocupada'),
('UCI-01', 'uci', 'mantenimiento'),
('105', 'individual', 'ocupada'),
('UCI-02', 'uci', 'disponible'),
('106', 'doble', 'mantenimiento'),
('107', 'individual', 'ocupada'),
('108', 'doble', 'disponible');

INSERT INTO ingresos (id_paciente, id_habitacion, fecha_ingreso, fecha_egreso, motivo) VALUES
(1, 1, '2025-06-10', '2025-06-13', 'Cirugía menor'),
(2, 4, '2025-06-11', NULL, 'Observación cardiaca'),
(3, 5, '2025-06-12', '2025-06-14', 'Fiebre alta'),
(4, 3, '2025-06-13', NULL, 'Parto programado'),
(5, 6, '2025-06-14', '2025-06-16', 'Deshidratación'),
(6, 7, '2025-06-15', NULL, 'Evaluación neurológica'),
(7, 8, '2025-06-16', '2025-06-18', 'Infección cutánea'),
(8, 9, '2025-06-17', NULL, 'Evaluación psiquiátrica'),
(9, 10, '2025-06-18', '2025-06-20', 'Lesión deportiva'),
(10, 2, '2025-06-19', NULL, 'Descompensación metabólica');

INSERT INTO medicamentos (nombre, descripcion, dosis, via_administracion) VALUES
('Paracetamol', 'Analgésico y antipirético', '500mg', 'oral'),
('Aspirina', 'Antiinflamatorio', '100mg', 'oral'),
('Amoxicilina', 'Antibiótico', '500mg', 'oral'),
('Ibuprofeno', 'Antiinflamatorio no esteroideo', '400mg', 'oral'),
('Metformina', 'Antidiabético', '850mg', 'oral'),
('Omeprazol', 'Protector gástrico', '20mg', 'oral'),
('Salbutamol', 'Broncodilatador', '100mcg', 'inhalador'),
('Dipirona', 'Analgésico', '1g', 'intravenosa'),
('Loratadina', 'Antialérgico', '10mg', 'oral'),
('Diazepam', 'Ansiolítico', '5mg', 'oral');

INSERT INTO recetas (id_consulta, fecha) VALUES
(1, '2025-06-21'),
(2, '2025-06-24'),
(3, '2025-06-25'),
(4, '2025-06-29'),
(5, '2025-06-23'),
(6, '2025-06-26'),
(7, '2025-06-20'),
(8, '2025-06-27'),
(9, '2025-06-22'),
(10, '2025-06-28');

INSERT INTO receta_detalle (id_receta, id_medicamento, dosis, frecuencia, duracion) VALUES
(1, 2, '100mg', 'cada 12 horas', '7 días'),
(1, 1, '500mg', 'cada 8 horas', '5 días'),
(2, 4, '400mg', 'cada 6 horas', '3 días'),
(3, 5, '850mg', '1 diaria', '30 días'),
(4, 6, '20mg', 'antes del desayuno', '14 días'),
(5, 1, '500mg', 'cada 6 horas', '5 días'),
(6, 9, '10mg', '1 diaria', '10 días'),
(7, 7, '100mcg', 'cuando sea necesario', '7 días'),
(8, 10, '5mg', 'cada noche', '15 días'),
(9, 3, '500mg', 'cada 8 horas', '7 días');

INSERT INTO empleados (nombre, apellido, cargo, area, salario, fecha_contrato) VALUES
('María', 'Quintero', 'Enfermera', 'Urgencias', 2500000, '2022-01-15'),
('Luis', 'Salazar', 'Administrador', 'Oficinas', 3200000, '2021-09-10'),
('Diana', 'Moreno', 'Limpieza', 'Pisos', 1500000, '2023-04-20'),
('Javier', 'Peña', 'Enfermero', 'Cirugía', 2600000, '2022-05-10'),
('Andrea', 'Lara', 'Recepcionista', 'Admisiones', 1800000, '2023-01-05'),
('Miguel', 'Torres', 'Técnico', 'Radiología', 2700000, '2022-11-22'),
('Nicolás', 'Ríos', 'Seguridad', 'Accesos', 1600000, '2021-06-01'),
('Sandra', 'González', 'Fisioterapeuta', 'Rehabilitación', 2800000, '2022-08-14'),
('Paula', 'Pérez', 'Archivista', 'Registros', 1700000, '2023-03-30'),
('Camilo', 'Ortiz', 'Mantenimiento', 'Infraestructura', 1900000, '2023-05-12');

-----------------CONSULTAS.------------------------------------------

--Obtener los nombres de pacientes y los doctores con los que tienen citas:
SELECT pacientes.nombre AS nombre_paciente ,pacientes.apellido AS apellido_paciente, doctores.nombre AS nombre_doctor ,doctores.apellido AS apellido_doctor , Citas.fecha , citas.hora FROM citas INNER JOIN Pacientes ON pacientes.id_paciente=citas.id_cita INNER JOIN Doctores ON doctores.id_doctor=citas.id_cita;

--doctores que no tienen citas
SELECT doctores.nombre ,doctores.apellido ,doctores.especialidad FROM doctores LEFT  JOIN citas ON citas.id_cita=doctores.id_doctor WHERE citas.id_doctor IS NULL;
--informacion de los pacientes  que habitacin  esta  ,que  aun no han salido de hospitaizacion
SELECT pacientes.nombre , pacientes.apellido, habitaciones.id_habitacion ,ingresos.fecha_ingreso FROM ingresos INNER JOIN pacientes ON  ingresos.id_paciente=pacientes.id_paciente INNER JOIN  Habitaciones ON habitaciones.id_habitacion=ingresos.id_habitacion WHERE ingresos.fecha_egreso IS NULL;
--total pacientes registrados y numero de  citas por estado y el total
SELECT COUNT(pacientes.id_paciente) AS total_pacientes ,  COUNT(*) AS Citas FROM Citas RIGHT JOIN pacientes ON pacientes.id_paciente=citas.id_paciente ;

--promedio salario , max salario y min salario y numero de empleados 
SELECT ROuND(AVG(salario),2) AS promedio , MAX(salario) AS maximo , MIN(salario) AS minimo , COUNT(*) AS cantidad_empleados FROM empleados ;

--pacientes que tienen mas de una cita
SELECT pacientes.nombre , pacientes.apellido , COUNT(citas.id_cita) AS cantidad_cita FROM pacientes INNER JOIN citas ON citas.id_paciente=pacientes.id_paciente  ORDER BY citas.id_paciente HAVING COUNT(citas.id_cita)>1;

-- Total de citas por mes y estado, mostrando solo los meses con más de 5 citas
SELECT MONTH(fecha) AS Mes ,estado , COUNT(id_cita)  FROM citas GROUP BY MONTH(fecha) estado HAVING COUNT(id_cita)>5 ;
--Pacientes que han sido internados más de una vez y cuántos días ha estado en total , Y informacion de la habitacion en que estuvo
SELECT pacientes.nombre , pacientes.apellido.Habitaciones.Numero,Habitaciones.tipo , COUNT(DATEDIFF(ingresos.fecha_ingreso,ingresos.fecha_egreso)/365) AS dias FROM ingresos INNER JOIN pacientes ON pacientes.id_paciente=ingresos.id_paciente INNER JOIN habitaciones ON habitaciones.id_habitacion=ingresos.id_habitacion GROUP BY ingresos.id_ingreso HAVING COUNT(DATEDIFF(ingresos.fecha_ingreso,ingresos.fecha_egreso)/365) >1 ;

-- Doctores que han recetado más de 5 medicamentos distintos

--Pacientes con más de 2 citas atendidas, y el total de medicamentos que han recibido

--nombres de los doctores que han atendido más de 3 consultas y el total de medicamentos diferentes que han recetado.

--Por cada especialidad médica, muestra el número total de consultas realizadas, el número de medicamentos recetados en total en esas consultas, y el promedio de medicamentos por consulta.

--Para cada receta, muestra el nombre del paciente, el doctor que la prescribió, el número de medicamentos en esa receta y el total de días que durarán todos los medicamentos juntos (suma de duración).

--Muestra los doctores que nunca han hecho una consulta, pero que tienen citas programadas o canceladas.

--Doctores que han atendido a pacientes que sí han sido internados

-- Recetas que contienen al medicamento más recetado