DROP DATABASE IF EXISTS ado;
CREATE DATABASE ado;
USE ado;

CREATE TABLE cliente(
    cliente_id INT PRIMARY KEY NOT NULL,
    nombre VARCHAR(20) NOT NULL,
    paterno VARCHAR(15) NOT NULL,
    materno VARCHAR(15),
    telefono VARCHAR(10) NOT NULL,
    correo VARCHAR(60) NOT NULL,
    contraseña VARCHAR(256) NOT NULL 
);

CREATE TABLE descuento(
    descuento_id INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    tipo VARCHAR(30) NOT NULL,
    cantidad_max INT NOT NULL,
    porcentaje_descuento DECIMAL(2, 2) NOT NULL,
    fin_vigencia DATETIME NOT NULL
);

CREATE TABLE empleado (
    empleado_id INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    rfc CHAR(13) NOT NULL,
    nombres VARCHAR(30) NOT NULL,
    paterno VARCHAR(30) NOT NULL,
    materno VARCHAR(30),
    telefono VARCHAR(10) NOT NULL,
    calle VARCHAR(30),
    numero VARCHAR(10),
    colonia VARCHAR(30),
    cp VARCHAR(5),
    cuenta_bancaria VARCHAR(11) NOT NULL,
    sueldo_diario INT NOT NULL,
    ocupacion VARCHAR(25) NOT NULL
);

CREATE TABLE conductor (
    conductor_id INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    vigencia_licencia DATE NOT NULL,
    numero_licencia VARCHAR(9) NOT NULL, --cambio de 20 a 9
    empleado_id INT NOT NULL,
    FOREIGN KEY (empleado_id) REFERENCES empleado(empleado_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE boleto (
    folio INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    nombre VARCHAR(50) NOT NULL,
    estatus ENUM("activo", "abordado", "cancelado") NOT NULL,
    fecha_hora DATETIME NOT NULL,
    metodo_pago ENUM("efectivo", "tarjeta", "saldo max") NOT NULL,
    corrida_id INT NOT NULL,
    descuento_id INT NOT NULL,
    asiento_id INT NOT NULL,
    FOREIGN KEY (corrida_id) REFERENCES corrida(corrida_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (descuento_id) REFERENCES descuento(descuento_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (asiento_id) REFERENCES asiento(asiento_id)
    	ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE vehiculo (
    vehiculo_id INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    matricula CHAR(7) NOT NULL,
    tipo VARCHAR(15) NOT NULL,
    marca VARCHAR(15) NOT NULL,
    modelo VARCHAR(50) NOT NULL,
    asientos INT NOT NULL,
    estatus ENUM("en servicio", "en mantenimiento", "inhabilitado") NOT NULL,
    marca_id INT NOT NULL,
    FOREIGN KEY(marca_id) REFERENCES marca(marca_id)
    	ON DELETE CASCADE
    	ON UPDATE CASCADE
);

CREATE TABLE asiento (
    asiento_id INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    numero INT NOT NULL,
    corrida_id INT NOT NULL,
    vehiculo_id INT NOT NULL,
    FOREIGN KEY (corrida_id) REFERENCES corrida(corrida_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (vehiculo_id) REFERENCES vehiculo(vehiculo_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE localidad (
    localidad_id INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    nombre VARCHAR(25) NOT NULL,
    clave CHAR(3) NOT NULL,
    estado VARCHAR(25) NOT NULL,
    estado_clave VARCHAR(5) NOT NULL
);

CREATE TABLE terminal (
    terminal_id INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    nombre VARCHAR(30) NOT NULL,
    cp CHAR(5), -- Ajustado para códigos postales
    calle VARCHAR(40),
    telefono VARCHAR(10) NOT NULL, -- Cambiado de CHAR a VARCHAR para mayor flexibilidad
    estatus ENUM('activa', 'inactiva') NOT NULL,
    ciudad VARCHAR(50),
    colonia VARCHAR(50),
    numero VARCHAR(10),
    localidad_id INT NOT NULL, -- llave foránea
    FOREIGN KEY (localidad_id) REFERENCES localidad(localidad_id)
);

CREATE TABLE IF NOT EXISTS ruta (
    ruta_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    origen_id INT NOT NULL,
    destino_id INT NOT NULL,
    distancia VARCHAR(10) NOT NULL,
    tiempo_aprox time NOT NULL,
    estatus ENUM("disponible", "no disponible") NOT NULL,
    FOREIGN KEY (origen_id) REFERENCES terminal(terminal_id),
    FOREIGN KEY (destino_id) REFERENCES terminal(terminal_id)
);

CREATE TABLE IF NOT EXISTS subruta (
    subruta_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    subruta INT,
    ruta_id INT NOT NULL,
    FOREIGN KEY (subruta) REFERENCES ruta(ruta_id),
    FOREIGN KEY (ruta_id) REFERENCES ruta(ruta_id)
);

CREATE TABLE corrida (
    corrida_id INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    fecha_hora_salida DATETIME NOT NULL,
    fecha_hora_llegada DATETIME NOT NULL,
    precio DECIMAL(8,2) NOT NULL,
    estatus ENUM("disponible", "no disponible") NOT NULL,
    tipo ENUM("local", "de paso") NOT NULL,
    ruta_id INT,
    conductor_id INT,
    FOREIGN KEY (ruta_id) REFERENCES ruta(ruta_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (conductor_id) REFERENCES conductor(conductor_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE amenidad (
    amenidad_id INT AUTO_INCREMENT PRIMARY KEY NOT NULL, 
    nombre VARCHAR(30) NOT NULL,
    descripcion VARCHAR(150) NOT NULL 
);

CREATE TABLE marca (
    marca_id INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    marca VARCHAR(30) NOT NULL,
    servicio VARCHAR(15) NOT NULL
);

CREATE TABLE factura (
    folio_fiscal CHAR(36) PRIMARY KEY NOT NULL,
    empleado_id VARCHAR(13) NOT NULL,
    razon_social VARCHAR(100) NOT NULL,
    reg_fiscal VARCHAR(100) NOT NULL,
    domicilio VARCHAR(200) NOT NULL,
    subtotal DECIMAL(5,2) NOT NULL,
    impuestos DECIMAL(5,2) not NULL,
    total DECIMAL(5,2) NOT NULL,
    folio INT NOT NULL,
    FOREIGN KEY(folio) REFERENCES boleto(folio)
    	ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE saldo_max (
    numero_tarjeta CHAR(16) PRIMARY KEY NOT NULL,
    saldo DECIMAL(10, 2) NOT NULL, 
    final_vigencia DATE, 
    estatus ENUM('activa', 'inactiva') NOT NULL,
    cliente_id INT NOT NULL,
    FOREIGN KEY (cliente_id) REFERENCES cliente(cliente_id)
    	ON DELETE CASCADE
        ON UPDATE CASCADE
);