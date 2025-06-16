CREATE SCHEMA shop_online;
USE shop_online;

CREATE TABLE prendas (
id_prenda INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
id_proveedor INT NOT NULL,
descripcion_prenda VARCHAR (50) NOT NULL,
categoria VARCHAR (30) NOT NULL,
talle VARCHAR (5) NOT NULL,
cantidad INT NOT NULL,
precio FLOAT NOT NULL
);

CREATE TABLE clientes (
id_cliente INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
nombre_completo_cliente VARCHAR (50) NOT NULL,
email_cliente VARCHAR (20) NOT NULL,
telefono_cliente VARCHAR (15) NOT NULL
);

CREATE TABLE proveedores (
id_proveedor INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
nombre_proveedor VARCHAR (50) NOT NULL,
email_proveedor VARCHAR (20) NOT NULL,
telefono_proveedor VARCHAR (15) NOT NULL,
categoria VARCHAR (30) NOT NULL
);

CREATE TABLE vendedores (
id_vendedor INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
nombre_completo_vendedor VARCHAR (50) NOT NULL,
email_vendedor VARCHAR (20) NOT NULL,
telefono_vendedor VARCHAR (15) NOT NULL,
cantidad_ventas INT NOT NULL,
ventas_totales FLOAT NOT NULL
);

CREATE TABLE metodos_pago (
id_metodo_pago INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
tipo_pago VARCHAR(100) NOT NULL,
cuotas INT,
recargo FLOAT,
moneda VARCHAR(30) NOT NULL
);

CREATE TABLE ventas (
id_venta INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
id_prenda INT NOT NULL,
id_cliente INT NOT NULL,
id_vendedor INT NOT NULL,
id_metodo_pago INT NOT NULL,
fecha_venta DATE NOT NULL,
importe FLOAT,
FOREIGN KEY (id_prenda) REFERENCES prendas (id_prenda),
FOREIGN KEY (id_cliente) REFERENCES clientes (id_cliente),
FOREIGN KEY (id_vendedor) REFERENCES vendedores (id_vendedor),
FOREIGN KEY (id_metodo_pago) REFERENCES metodos_pago (id_metodo_pago)
);

ALTER TABLE prendas ADD CONSTRAINT fk_idProveedor_prendas
FOREIGN KEY (id_proveedor) REFERENCES proveedores (id_proveedor);