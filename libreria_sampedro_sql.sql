/* Arranco borrando la base si ya existe para evitar errores */
DROP DATABASE IF EXISTS libreria_sampedro;

/* Creo la base desde cero */
CREATE DATABASE libreria_sampedro;

/* Me posiciono dentro de la base */
USE libreria_sampedro;

/* Creo la tabla de sucursales donde se guardan las librerías físicas */
CREATE TABLE sucursal (
    id_sucursal INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100),
    ciudad VARCHAR(100),
    direccion VARCHAR(150)
);

/* Tabla de autores */
CREATE TABLE autor (
    id_autor INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100),
    nacionalidad VARCHAR(100)
);

/* Tabla de libros vinculada con autor */
CREATE TABLE libros (
    isbn VARCHAR(20) PRIMARY KEY,
    titulo VARCHAR(150),
    genero VARCHAR(100),
    precio_actual DECIMAL(10,2),
    id_autor INT,
    FOREIGN KEY (id_autor) REFERENCES autor(id_autor)
);

/* Tabla de vendedores que trabajan en sucursales */
CREATE TABLE vendedor (
    id_vendedor INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100),
    apellido VARCHAR(100),
    dni VARCHAR(20),
    email VARCHAR(150),
    id_sucursal INT,
    FOREIGN KEY (id_sucursal) REFERENCES sucursal(id_sucursal)
);

/* Tabla de ventas */
CREATE TABLE venta (
    id_venta INT PRIMARY KEY AUTO_INCREMENT,
    fecha DATE,
    hora TIME,
    total_venta DECIMAL(10,2),
    id_sucursal INT,
    id_vendedor INT,
    FOREIGN KEY (id_sucursal) REFERENCES sucursal(id_sucursal),
    FOREIGN KEY (id_vendedor) REFERENCES vendedor(id_vendedor)
);

/* Detalle de cada venta */
CREATE TABLE detalle_de_venta (
    id_detalle INT PRIMARY KEY AUTO_INCREMENT,
    cantidad INT,
    precio_unitario DECIMAL(10,2),
    id_venta INT,
    isbn VARCHAR(20),
    FOREIGN KEY (id_venta) REFERENCES venta(id_venta),
    FOREIGN KEY (isbn) REFERENCES libros(isbn)
);

/* Acá ajusto restricciones para que no haya campos vacíos */
ALTER TABLE sucursal
  MODIFY nombre VARCHAR(100) NOT NULL,
  MODIFY ciudad VARCHAR(100) NOT NULL,
  MODIFY direccion VARCHAR(150) NOT NULL;

ALTER TABLE autor
  MODIFY nombre VARCHAR(100) NOT NULL,
  MODIFY nacionalidad VARCHAR(100) NOT NULL;

ALTER TABLE libros
  MODIFY titulo VARCHAR(150) NOT NULL,
  MODIFY genero VARCHAR(100) NOT NULL,
  MODIFY precio_actual DECIMAL(10,2) NOT NULL,
  MODIFY id_autor INT NOT NULL;

ALTER TABLE vendedor
  MODIFY nombre VARCHAR(100) NOT NULL,
  MODIFY apellido VARCHAR(100) NOT NULL,
  MODIFY dni VARCHAR(20) NOT NULL,
  MODIFY email VARCHAR(150) NOT NULL,
  MODIFY id_sucursal INT NOT NULL;

/* Evito duplicados en dni y email */
ALTER TABLE vendedor
  ADD UNIQUE (dni),
  ADD UNIQUE (email);

ALTER TABLE venta
  MODIFY fecha DATE NOT NULL,
  MODIFY hora TIME NOT NULL,
  MODIFY total_venta DECIMAL(10,2) NOT NULL,
  MODIFY id_sucursal INT NOT NULL,
  MODIFY id_vendedor INT NOT NULL;

ALTER TABLE detalle_de_venta
  MODIFY cantidad INT NOT NULL,
  MODIFY precio_unitario DECIMAL(10,2) NOT NULL,
  MODIFY id_venta INT NOT NULL,
  MODIFY isbn VARCHAR(20) NOT NULL;

/* Inserto datos de prueba (esto lo practiqué antes en un borrador y después lo pasé acá) */

INSERT INTO sucursal (nombre, ciudad, direccion) VALUES
('Sucursal El Principito', 'La Plata', 'Calle Falsa 123'),
('Sucursal Maximo Meridio', 'La Plata', 'Calle Decima');

INSERT INTO autor (nombre, nacionalidad) VALUES
('Laura Gallego', 'España'),
('Julia Quinn', 'Estados Unidos');

INSERT INTO libros (isbn, titulo, genero, precio_actual, id_autor) VALUES
('155412315', 'Donde los Arboles Cantan', 'Novela', 50000, 1),
('254854145', 'Bridgerton', 'Novela', 43500, 2);

INSERT INTO vendedor (nombre, apellido, dni, email, id_sucursal) VALUES
('Ariana', 'Sampedro', '43195629', 'sampedroari@gmail.com', 1),
('Carlos', 'Baltazar', '39222333', 'carlosmiapellido@gmail.com', 2);

INSERT INTO venta (fecha, hora, total_venta, id_sucursal, id_vendedor) VALUES
('2026-02-10', '10:15:00', 27400.00, 1, 1),
('2026-02-10', '12:40:00', 14900.00, 2, 2);

INSERT INTO detalle_de_venta (cantidad, precio_unitario, id_venta, isbn) VALUES
(1, 50000.00, 1, '155412315'),
(1, 43500.00, 1, '254854145'),
(1, 43500.00, 2, '254854145');