

DROP DATABASE IF EXISTS ado;
CREATE DATABASE ado;
USE ado;

CREATE TABLE cliente(
    cliente_id INT PRIMARY KEY NOT NULL,
    nombre VARCHAR(40) NOT NULL,
    paterno VARCHAR(40) NOT NULL,
    materno VARCHAR(40),
    telefono VARCHAR(10) NOT NULL,
    correo VARCHAR(70) NOT NULL,
    contraseña VARCHAR(256) NOT NULL 
);

CREATE TABLE descuento(
    descuento_id INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    tipo VARCHAR(30) NOT NULL,
    cantidad_max INT NOT NULL,
    porcentaje_descuento INT NOT NULL,
    fin_vigencia DATETIME NOT NULL
);

CREATE TABLE empleado (
    empleado_id VARCHAR(5) PRIMARY KEY NOT NULL,
    rfc CHAR(13) NOT NULL,
    nombres VARCHAR(40) NOT NULL,
    paterno VARCHAR(40) NOT NULL,
    materno VARCHAR(40),
    telefono VARCHAR(10) NOT NULL,
    calle VARCHAR(80),
    numero VARCHAR(5),
    colonia VARCHAR(80),
    cp VARCHAR(5),
    cuenta_bancaria VARCHAR(11) NOT NULL,
    sueldo_diario INT NOT NULL,
    ocupacion VARCHAR(35) NOT NULL
);

CREATE TABLE conductor (
    conductor_id INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    vigencia_licencia DATE NOT NULL,
    numero_licencia VARCHAR(9) NOT NULL, --cambio de 20 a 9
    empleado_id VARCHAR(5) NOT NULL,
    FOREIGN KEY (empleado_id) REFERENCES empleado(empleado_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE boleto (
    folio INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    nombre VARCHAR(50) NOT NULL,
    estatus ENUM("Activo", "Abordado", "Cancelado") NOT NULL,
    fecha_hora DATETIME NOT NULL,
    metodo_pago ENUM("Efectivo", "Tarjeta", "Saldo MAX") NOT NULL,
    corrida_id INT NOT NULL,
    FOREIGN KEY (corrida_id) REFERENCES corrida(corrida_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (descuento_id) REFERENCES descuento(descuento_id),
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY ()
);

CREATE TABLE autobus (
    autobus_id INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    matricula CHAR(7) NOT NULL,
    tipo VARCHAR(15) NOT NULL,
    marca VARCHAR(15) NOT NULL,
    modelo VARCHAR(50) NOT NULL,
    total_asiento INT NOT NULL,
    num_columna INT NOT NULL,
    num_fila INT NOT NULL
);

CREATE TABLE asiento (
    asiento_id INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    numero INT NOT NULL,
    corrida_id INT NOT NULL,
    folio INT NOT NULL,
    autobus_id INT NOT NULL,
    FOREIGN KEY (corrida_id) REFERENCES corrida(corrida_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (folio) REFERENCES boleto(folio)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (autobus_id) REFERENCES autobus(autobus_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE localidad (
    localidad_id INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    nombre VARCHAR(25) NOT NULL,
    clave CHAR(3) NOT NULL,
    estado VARCHAR(25) NOT NULL
);

CREATE TABLE terminal (
    terminal_id INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    nombre VARCHAR(30) NOT NULL,
    cp CHAR(5) NOT NULL, -- Ajustado para códigos postales
    calle VARCHAR(40) NOT NULL,
    telefono VARCHAR(10) NOT NULL, -- Cambiado de CHAR a VARCHAR para mayor flexibilidad
    estatus ENUM('Activa', 'Inactiva') NOT NULL,
    localidad_id INT NOT NULL, -- llave foránea
    FOREIGN KEY (localidad_id) REFERENCES localidad(localidad_id)
);

CREATE TABLE ruta (
    ruta_id INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    origen INT NOT NULL,
    destino VARCHAR(30) NOT NULL,
    estatus ENUM("Disponible", "No disponible") NOT NULL,
    terminal_id INT NOT NULL,
    FOREIGN KEY (terminal_id) REFERENCES terminal(terminal_id)
);

CREATE TABLE subruta (
    subruta_id INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    origen VARCHAR(30) NOT NULL,
    destino VARCHAR(30) NOT NULL,
    distancia INT NOT NULL,
    tiempo_aprox TIME NOT NULL,
    estatus ENUM("Disponible", "No disponible") NOT NULL,
    ruta_id INT NOT NULL,
    FOREIGN KEY (ruta_id) REFERENCES ruta(ruta_id)
);

CREATE TABLE corrida (
    corrida_id INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    fecha_hora_salida DATETIME NOT NULL,
    fecha_hora_llegada DATETIME NOT NULL,
    precio DECIMAL(8,2) NOT NULL,
    estatus ENUM("Disponible", "No disponible") NOT NULL,
    tipo ENUM("Local", "De paso") NOT NULL,
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
    amenidad_id INT AUTO_INCREMENT PRIMARY KEY NOT NULL, -- Se agregó AUTO_INCREMENT para generar automáticamente los IDs
    nombre VARCHAR(30) NOT NULL,
    descripcion TEXT NOT NULL -- Cambiado de VARCHAR sin longitud a TEXT para mayor flexibilidad
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
    subtotal INT NOT NULL,
    impuestos INT not NULL,
    total INT NOT NULL
);

CREATE TABLE saldo_max (
    numero_tarjeta CHAR(16) PRIMARY KEY NOT NULL, -- Cambiado de INT(16) a CHAR(16)
    nombre_titular VARCHAR(60) NOT NULL,
    saldo DECIMAL(10, 2) NOT NULL, -- Usado DECIMAL para valores monetarios
    ultimo_movimiento DATETIME NOT NULL, -- Ajustado para fechas
    final_vigencia DATE, -- Eliminado el tamaño (10), que no es válido
    estatus ENUM('Activa', 'Inactiva') NOT NULL
);