USE libreria_sampedro;

/* Tablas de auditoría para registrar acciones automáticas */
CREATE TABLE auditoria_venta (
    id_auditoria INT PRIMARY KEY AUTO_INCREMENT,
    fecha DATETIME,
    accion VARCHAR(100)
);

CREATE TABLE auditoria_libros (
    id_auditoria INT PRIMARY KEY AUTO_INCREMENT,
    fecha DATETIME,
    accion VARCHAR(100)
);

/* Función que aplica un descuento del 10% */
DELIMITER //
CREATE FUNCTION f_descuento(precio DECIMAL(10,2))
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    RETURN precio * 0.9;
END //
DELIMITER ;

/* Función que calcula total por cantidad */
DELIMITER //
CREATE FUNCTION f_total_item(cantidad INT, precio DECIMAL(10,2))
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    RETURN cantidad * precio;
END //
DELIMITER ;

/* Procedure para listar libros */
DELIMITER //
CREATE PROCEDURE listar_libros()
BEGIN
    SELECT * FROM libros;
END //
DELIMITER ;

/* Procedure para ver ventas por sucursal */
DELIMITER //
CREATE PROCEDURE listar_ventas_por_sucursal(IN p_id_sucursal INT)
BEGIN
    SELECT *
    FROM venta
    WHERE id_sucursal = p_id_sucursal;
END //
DELIMITER ;

/* Trigger que registra cuando se inserta un libro */
DELIMITER //
CREATE TRIGGER tr_registro_libro
AFTER INSERT ON libros
FOR EACH ROW
BEGIN
    INSERT INTO auditoria_libros (fecha, accion)
    VALUES (NOW(), 'Se insertó un libro');
END //
DELIMITER ;

/* Trigger que registra cuando se inserta una venta */
DELIMITER //
CREATE TRIGGER tr_registro_venta
AFTER INSERT ON venta
FOR EACH ROW
BEGIN
    INSERT INTO auditoria_venta (fecha, accion)
    VALUES (NOW(), 'Se insertó una venta');
END //
DELIMITER ;

/* Vista que muestra libros con su autor */
CREATE VIEW vista_libros_autores AS
SELECT libros.titulo, libros.genero, autor.nombre
FROM libros
JOIN autor ON libros.id_autor = autor.id_autor;

/* Vista de ventas con vendedores */
CREATE VIEW vista_ventas_vendedores AS
SELECT venta.id_venta,
       venta.fecha,
       venta.total_venta,
       vendedor.nombre,
       vendedor.apellido
FROM venta
JOIN vendedor ON venta.id_vendedor = vendedor.id_vendedor;

/* Vista de detalle de ventas */
CREATE VIEW vista_detalle_ventas AS
SELECT detalle_de_venta.id_detalle,
       libros.titulo,
       detalle_de_venta.cantidad,
       detalle_de_venta.precio_unitario
FROM detalle_de_venta
JOIN libros ON detalle_de_venta.isbn = libros.isbn;