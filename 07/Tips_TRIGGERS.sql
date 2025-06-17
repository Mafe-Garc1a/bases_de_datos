
🧠 GUÍA RÁPIDA: OLD, NEW, BEFORE, AFTER en TRIGGERS

-- 🔁 CUÁNDO USAR OLD Y NEW:  
| Operación SQL | ¿Existe `OLD`? | ¿Existe `NEW`? | ¿Para qué sirve?                                                     |
| ------------- | -------------- | -------------- | -------------------------------------------------------------------- |
| `INSERT`      | ❌ No           | ✅ Sí           | Ver los datos **nuevos** que se insertarán                           |
| `UPDATE`      | ✅ Sí           | ✅ Sí           | `OLD`: valores antes del cambio<br>`NEW`: valores después del cambio |
| `DELETE`      | ✅ Sí           | ❌ No           | Ver los datos que están a punto de eliminarse                        |

--*********************************************************************************************

-- 🔧 CUÁNDO USAR BEFORE o AFTER
--RECUERDA: BEFORE -> Antes 
        --  AFTER ->  Despues 
| Tipo de Trigger | ¿Cuándo se ejecuta?                    | ¿Usos típicos?                                                                                                           |
| --------------- | -------------------------------------- | ------------------------------------------------------------------------------------------------------------------------ |
| `BEFORE`        | Antes de la operación SQL              | ✅ Validaciones<br>✅ Cambiar valores (`NEW`) antes de insertarlos<br>✅ Prevenir errores con `SIGNAL`                      |
| `AFTER`         | Después de que se ejecuta la operación | ✅ Actualizar otras tablas<br>✅ Registrar cambios (logs)<br>✅ Operaciones dependientes del éxito del insert/update/delete |

--*********************************************************************************************
-- 💡 Ejemplos prácticos:
    -- 🔍 BEFORE INSERT: verificar si hay suficiente stock (NEW.cantidad) antes de registrar la venta.
    -- ✅ AFTER INSERT: actualizar el total vendido del vendedor con los datos de NEW.
    -- 🔁 AFTER UPDATE: comparar OLD y NEW para ver si cambió el producto, vendedor o cantidad, y ajustar totales.
    -- 🗑 AFTER DELETE: usar OLD para restar la venta eliminada del total del vendedor.

--*********************************************************************************************
-- 📌 EJEMPLOS PRÁCTICOS

-- 🟢 BEFORE INSERT
-- Verifica que haya stock antes de vender
CREATE TRIGGER verificar_stock BEFORE INSERT ON ventas
FOR EACH ROW
BEGIN
    DECLARE stock_actual INT;
    SELECT cantidad INTO stock_actual FROM productos WHERE id_producto = NEW.id_producto;

    IF stock_actual < NEW.cantidad THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No hay suficiente stock';
    END IF;
END;

-- 🔵 AFTER INSERT
-- Actualiza los totales del vendedor después de insertar una venta
CREATE TRIGGER sumar_venta AFTER INSERT ON ventas
FOR EACH ROW
BEGIN
    -- Aquí usamos NEW para saber lo que se vendió
    UPDATE vendedores
    SET total_dinero_vendido = total_dinero_vendido + (NEW.cantidad * precio),
        total_productos_vendidos = total_productos_vendidos + NEW.cantidad
    WHERE id_vendedor = NEW.id_vendedor;
END;


-- 🔴 AFTER DELETE
-- Devuelve el stock al eliminar una venta
CREATE TRIGGER devolver_stock AFTER DELETE ON ventas
FOR EACH ROW
BEGIN
    UPDATE productos
    SET cantidad = cantidad + OLD.cantidad
    WHERE id_producto = OLD.id_producto;
END;

-- 💡 TIP EXTRA:
    -- En BEFORE INSERT puedes modificar NEW.columna directamente.
    -- En AFTER INSERT ya no puedes modificar NEW, solo usarlo para cálculos.

--EJEMPLITO: 
-- BEFORE: modificar el valor
SET NEW.nombre = UPPER(NEW.nombre);

-- AFTER: solo puedes usarlo, no modificarlo
SELECT NEW.nombre;
💬 Piensa:
"BEFORE = aún puedo corregir"
"AFTER = ya pasó, solo lo uso"