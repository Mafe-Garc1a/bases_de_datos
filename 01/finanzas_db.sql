-- crear base de datos
    CREATE DATABASE finanzas;
    
    USE finanzas;

    CREATE TABLE usuarios(
        id_usuario INT UNSIGNED AUTO_INCREMENT,
        nombre_usuario VARCHAR(70),
        correo VARCHAR(100) UNIQUE,
        pass_hash VARCHAR(140),
        PRIMARY KEY(id_usuario)
    
    );
    CREATE TABLE movimientos(
        id_movimiento INT UNSIGNED AUTO_INCREMENT  PRIMARY KEY, 
        descripcion  VARCHAR(140),
        tipo_movimiento ENUM('ingreso','egreso'),
        valor FLOAT(14,2),
        fecha_hora DATETIME,
        estado BOOLEAN, 
        usuario INT UNSIGNED,
        FOREIGN KEY (usuario) REFERENCES usuarios(id_usuario) );
     
    INSERT INTO usuarios(nombre_usuario,correo,pass_hash)
    VALUES('Hugo Lopez' , 'HUgoLpz@gmal.com',SHA1('123abc'));
    INSERT INTO usuarios(nombre_usuario,correo,pass_hash)
    VALUES('Angelina' , 'AngeOc@gmal.com',SHA1('2244a'));
     INSERT INTO usuarios(nombre_usuario,correo,pass_hash)
    VALUES
    ('valentina' , 'valentina@gmal.com',SHA1('23435a')),
     ('juan' , 'juan@gmal.com',SHA1('25774a')),
      ('santiago ' , 'santiO67@gmal.com',SHA1('santmmm')),
       ('madisn garcia' , 'mg1234@gmal.com',SHA1('44656'));
    INSERT INTO movimientos(descripcion,tipo_movimiento,valor,fecha_hora,estado,usuario)
    VALUES('pago nomina trabajador','ingreso',1300000,'2025-05-05  13:30',1,1);
    INSERT INTO movimientos(descripcion,tipo_movimiento,valor,fecha_hora,estado,usuario)
    VALUES('pago nomina trabajador','ingreso',1350000,'2025-05-05  13:40',1,1),
    ('pago servicio energia','egreso',300000,'2025-05-06  15:30',1,1),
    ('pago casa','ingreso',700000,'2025-05-15  11:30',1,1);

     UPDATE movimientos SET estado  = TRUE;
     /*filtros*/
    SELECT descripcion , tipo_movimiento,valor, estado 
    FROM movimientos
    WHERE tipo_movimiento='egreso' AND  estado = TRUE ; 
   INSERT INTO movimientos(descripcion,tipo_movimiento,valor,fecha_hora,estado,usuario)
   VALUES ('pago nomina','ingreso',4500000,'2023-06-01  10:20',1,11),
    ('pago subsidio','ingreso',400000,'2023-06-01  10:20',1,11),
    ('pago cuota carro','egreso',300000,'2023-06-05  10:20',1,11),
    ('pago gym','egreso',90000,'2023-06-01  10:20',1,11);

    /*fusiones SUM*/
    SELECT SUM(valor) AS total_ingresos FROM movimientos  WHERE tipo_movimiento='egreso' AND estado=TRUE AND usuario=11;

    /*un solo mes*/
    SELECT SUM(valor) AS total_ingresos FROM movimientos  WHERE tipo_movimiento='egreso' AND estado=TRUE AND usuario=1 AND  MONTH(fecha_hora)='02';

    /*cuanto se gasto cada mes  el usuario 1 */
    SELECT MONTH(fecha_hora) AS mes,  SUM(valor) AS total_ingresos FROM movimientos  WHERE tipo_movimiento='egreso' AND estado=TRUE AND usuario=1 GROUP BY   MONTH(fecha_hora);



    -- CUANTOS GASTOS ACTIVOS TINE EL USUARIO 1 N CADA MES 
        SELECT MONTH(fecha_hora) AS mes,  COUNT(tipo_movimiento) AS cantidad_egresos, SUM(valor) AS TOTAL_EGRESOS FROM movimientos  WHERE tipo_movimiento='egreso' AND estado=TRUE AND usuario=1 GROUP BY   MONTH(fecha_hora);

        /* CATEGORIA DE INGRESOS & EGRESOS Y QUE LAS CATEGORIAS ESTEN EN OTRAS TABLAS , SIN AUTOINCREMENTABLE */
        CREATE TABLE categorias(
       nombre_categoria VARCHAR(30) PRIMARY KEY,
     );
     INSERT INTO categorias (nombre_categoria) VALUES
('Alimentación'),
('Transporte'),
('Salud'),
('Vivienda'),
('Educación'),
('Entretenimiento'),
('Servicios públicos'),
('Ropa'),
('Tecnología'),
('Ahorros');
    /* agregar un campo tabla  adiccion columna*/
        ALTER TABLE movimientos 
        ADD COLUMN categoria VARCHAR(30)
        AFTER fecha_hora;
    /* ALTERNAR UNA LLAVE FORANEA A LA TABLA  */
    ALTER TABLE movimientos 
    ADD CONSTRAINT fk_movimiento_categoria
    FOREIGN KEY (categoria)
    REFERENCES categorias(nombre_categoria);
    

    ALTER TABLE movimientos
    ADD COLUMN  categoria VARCHAR(30)
    AFTER fecha_hora;

    ALTER TABLE usuarios 
    ADD COLUMN edad VARCHAR(2);
    /* sintaxis */
    ALTER TABLE  nombre_tabla 
    MODIFY COLUMN nombre_columna nuevo _tipo;

    UPDATE movimientos 
    --crear una consulta que tenga la descicion , tipo mpovimiento , valor , fecha, nombre y correo del usuario de todos los movimientos
    SELECT descripcion,tipo_movimiento,valor,DATE(fecha_hora) AS fecha, nombre_usuario , correo FROM usuarios INNER JOIN movimientos ON id_usuario=usuario;






    --CREAR UNA CONSULTA QUE TENGA NOMBRE Y ORREO DEL USUARIO , DE TODOS LOS USUARIO , TENGAN O NO MOVIMIENTO , SI TIENEN MOVIMIENTOS  LA DESCRIPCION TIPO_MOVIMIENT , VALOR Y FECHA

    SELECT nombre_usuario,correo,descripcion,tipo_movimiento,valor, DATE(fecha_hora) AS fecha FROM usuarios LEFT JOIN movimientos ON id_usuario=usuario;

    --CRAR UNA CONSULTA NOMBRE Y CORREO DE LOS USUARIOS QUE NO TENGAN MOVIMIENTOS
    SELECT nombre_usuario,valor, DATEE(fecha_hora) AS tipo_movimiento
 


    --CONSULTAR LOS MOVIMIENTOS Y ASI SUS USUARIOS TENGAN O NO MOVIMIENTOSS
    
    SELECT descripcion,tipo_movimiento,valor DATE(fecha_hora) AS fecha FROM usuarios RIGHT JOIN movimientos ON usuarios.id_usuario=movimientos.usuarios WHERE usuarios.id_usuario IS NULL;

    --SE ONE UNION PARA QUE MUESTRE TODO YA Q MYSQL NO ENTIENDE FULL OUTER JOIN  , TOCA JUNTAR LEFT Y RIGHT
    SELECT nombre_usuario ,correo ,descripcion , tipo_movimiento , valor ,DATE(fecha_hora) AS fecha FROM usuarios LEFT JOIN movimientos ON id_usuario=usuario 
    UNION 
    SELECT nombre_usuario , correo , descripcion , tipo_movimiento , valor, DATE(fecha_hora) AS fecha FROM usuarios RIGHT JOIN movimientos ON usuarios.id_usuario=movimientos.usuario WHERE usuarios.id_usuario IS NULL;
-------------------------------------------------------------------
    SELECT nombre_usuario ,correo ,descripcion , tipo_movimiento , valor ,DATE(fecha_hora) AS fecha FROM usuarios LEFT JOIN movimientos ON id_usuario=usuario where usuarios.id_usuario IS NULL
    UNION 
    SELECT nombre_usuario , correo , descripcion , tipo_movimiento , valor, DATE(fecha_hora) AS fecha FROM usuarios RIGHT JOIN movimientos ON usuarios.id_usuario=movimientos.usuario WHERE usuarios.id_usuario IS NULL;




 ---------------------------------------------
    -- Insertar movimientos para usuarios 1 y 2
-- Febrero, Marzo, Abril y Mayo
-- 2 ingresos y 5 egresos por mes






































































------------------------------------------------------------------------------------------------------------
-- INSERT INTO movimientos (descripcion, tipo_movimiento, valor, fecha_hora, estado, usuario) VALUES
-- -- Usuario 1 - Febrero
-- ('Ingreso salario febrero', 'ingreso', 3500000, '2025-02-05 08:30:00', 1, 1),
-- ('Ingreso freelance febrero', 'ingreso', 1200000, '2025-02-15 10:00:00', 1, 1),
-- ('Pago arriendo febrero', 'egreso', 900000, '2025-02-03 12:00:00', 1, 1),
-- ('Supermercado febrero', 'egreso', 350000, '2025-02-10 17:00:00', 1, 1),
-- ('Servicios febrero', 'egreso', 200000, '2025-02-12 09:00:00', 1, 1),
-- ('Transporte febrero', 'egreso', 150000, '2025-02-18 08:45:00', 1, 1),
-- ('Cine y ocio febrero', 'egreso', 80000, '2025-02-22 21:00:00', 1, 1),

-- -- Usuario 1 - Marzo
-- ('Ingreso salario marzo', 'ingreso', 3500000, '2025-03-05 08:30:00', 1, 1),
-- ('Ingreso freelance marzo', 'ingreso', 1000000, '2025-03-14 11:00:00', 1, 1),
-- ('Pago arriendo marzo', 'egreso', 900000, '2025-03-03 12:00:00', 1, 1),
-- ('Supermercado marzo', 'egreso', 360000, '2025-03-10 17:00:00', 1, 1),
-- ('Servicios marzo', 'egreso', 210000, '2025-03-12 09:00:00', 1, 1),
-- ('Transporte marzo', 'egreso', 150000, '2025-03-19 08:45:00', 1, 1),
-- ('Comidas marzo', 'egreso', 100000, '2025-03-23 20:00:00', 1, 1),

-- -- Usuario 1 - Abril
-- ('Ingreso salario abril', 'ingreso', 3600000, '2025-04-05 08:30:00', 1, 1),
-- ('Ingreso venta abril', 'ingreso', 950000, '2025-04-16 14:00:00', 1, 1),
-- ('Pago arriendo abril', 'egreso', 900000, '2025-04-03 12:00:00', 1, 1),
-- ('Supermercado abril', 'egreso', 370000, '2025-04-11 17:00:00', 1, 1),
-- ('Servicios abril', 'egreso', 220000, '2025-04-13 09:00:00', 1, 1),
-- ('Transporte abril', 'egreso', 160000, '2025-04-18 08:45:00', 1, 1),
-- ('Salud abril', 'egreso', 250000, '2025-04-25 10:30:00', 1, 1),

-- -- Usuario 1 - Mayo
-- ('Ingreso salario mayo', 'ingreso', 3600000, '2025-05-05 08:30:00', 1, 1),
-- ('Ingreso freelance mayo', 'ingreso', 1100000, '2025-05-15 14:00:00', 1, 1),
-- ('Pago arriendo mayo', 'egreso', 900000, '2025-05-03 12:00:00', 1, 1),
-- ('Supermercado mayo', 'egreso', 380000, '2025-05-10 17:00:00', 1, 1),
-- ('Servicios mayo', 'egreso', 230000, '2025-05-12 09:00:00', 1, 1),
-- ('Transporte mayo', 'egreso', 160000, '2025-05-18 08:45:00', 1, 1),
-- ('Ropa mayo', 'egreso', 300000, '2025-05-26 16:00:00', 1, 1),

-- -- Usuario 2 - Febrero
-- ('Ingreso salario febrero', 'ingreso', 3200000, '2025-02-06 09:00:00', 1, 2),
-- ('Ingreso bonus febrero', 'ingreso', 800000, '2025-02-20 10:00:00', 1, 2),
-- ('Pago arriendo febrero', 'egreso', 850000, '2025-02-04 12:00:00', 1, 2),
-- ('Supermercado febrero', 'egreso', 340000, '2025-02-09 18:00:00', 1, 2),
-- ('Servicios febrero', 'egreso', 190000, '2025-02-11 09:00:00', 1, 2),
-- ('Transporte febrero', 'egreso', 130000, '2025-02-16 08:45:00', 1, 2),
-- ('Cine y ocio febrero', 'egreso', 75000, '2025-02-24 21:00:00', 1, 2),

-- -- Usuario 2 - Marzo
-- ('Ingreso salario marzo', 'ingreso', 3200000, '2025-03-06 09:00:00', 1, 2),
-- ('Ingreso venta marzo', 'ingreso', 950000, '2025-03-22 11:00:00', 1, 2),
-- ('Pago arriendo marzo', 'egreso', 850000, '2025-03-03 12:00:00', 1, 2),
-- ('Supermercado marzo', 'egreso', 330000, '2025-03-08 17:00:00', 1, 2),
-- ('Servicios marzo', 'egreso', 200000, '2025-03-12 09:00:00', 1, 2),
-- ('Transporte marzo', 'egreso', 140000, '2025-03-19 08:45:00', 1, 2),
-- ('Comidas marzo', 'egreso', 95000, '2025-03-25 19:00:00', 1, 2),

-- -- Usuario 2 - Abril
-- ('Ingreso salario abril', 'ingreso', 3300000, '2025-04-06 09:00:00', 1, 2),
-- ('Ingreso freelance abril', 'ingreso', 900000, '2025-04-18 13:00:00', 1, 2),
-- ('Pago arriendo abril', 'egreso', 850000, '2025-04-03 12:00:00', 1, 2),
-- ('Supermercado abril', 'egreso', 320000, '2025-04-09 17:00:00', 1, 2),
-- ('Servicios abril', 'egreso', 210000, '2025-04-13 09:00:00', 1, 2),
-- ('Transporte abril', 'egreso', 140000, '2025-04-20 08:45:00', 1, 2),
-- ('Salud abril', 'egreso', 200000, '2025-04-26 10:30:00', 1, 2),

-- -- Usuario 2 - Mayo
-- ('Ingreso salario mayo', 'ingreso', 3300000, '2025-05-06 09:00:00', 1, 2),
-- ('Ingreso bonus mayo', 'ingreso', 850000, '2025-05-17 14:00:00', 1, 2),
-- ('Pago arriendo mayo', 'egreso', 850000, '2025-05-03 12:00:00', 1, 2),
-- ('Supermercado mayo', 'egreso', 340000, '2025-05-08 17:00:00', 1, 2),
-- ('Servicios mayo', 'egreso', 210000, '2025-05-12 09:00:00', 1, 2),
-- ('Transporte mayo', 'egreso', 140000, '2025-05-20 08:45:00', 1, 2),
-- ('Ropa mayo', 'egreso', 280000, '2025-05-28 16:00:00', 1, 2);
