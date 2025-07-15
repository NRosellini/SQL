-- VISTAS --

CREATE VIEW ventas_detalladas AS
SELECT 
  v.id_venta,
  c.nombre_completo_cliente,
  p.descripcion_prenda,
  ven.nombre_completo_vendedor,
  mp.tipo_pago,
  v.fecha_venta,
  v.importe
FROM venta v
JOIN cliente c ON v.id_cliente = c.id_cliente
JOIN prenda p ON v.id_prenda = p.id_prenda
JOIN vendedor ven ON v.id_vendedor = ven.id_vendedor
JOIN metodo_pago mp ON v.id_metodo_pago = mp.id_metodo_pago;

CREATE VIEW prendas_stock_bajo AS
SELECT * FROM prenda
WHERE cantidad < 10;

CREATE VIEW ventas_por_vendedor AS
SELECT 
  v.id_vendedor,
  ve.nombre_completo_vendedor,
  COUNT(*) AS cantidad_ventas,
  SUM(v.importe) AS total_facturado
FROM venta v
JOIN vendedor ve ON v.id_vendedor = ve.id_vendedor
GROUP BY v.id_vendedor, ve.nombre_completo_vendedor;

CREATE VIEW ingresos_por_categoria AS
SELECT 
  p.categoria,
  SUM(v.importe) AS ingresos_totales
FROM venta v
JOIN prenda p ON v.id_prenda = p.id_prenda
GROUP BY p.categoria;

CREATE VIEW clientes_frecuentes AS
SELECT 
  c.id_cliente,
  c.nombre_completo_cliente,
  COUNT(v.id_venta) AS cantidad_compras
FROM cliente c
JOIN venta v ON c.id_cliente = v.id_cliente
GROUP BY c.id_cliente, c.nombre_completo_cliente
HAVING COUNT(v.id_venta) >= 2;

-- FUNCIONES --

DELIMITER //
CREATE FUNCTION calcular_precio_final(precio_base FLOAT, recargo FLOAT)
RETURNS FLOAT
DETERMINISTIC
BEGIN
  RETURN precio_base + (precio_base * recargo / 100);
END //
DELIMITER ;

DELIMITER //
CREATE FUNCTION obtener_nombre_cliente(id INT)
RETURNS VARCHAR(50)
DETERMINISTIC
BEGIN
  DECLARE nombre VARCHAR(50);
  SELECT nombre_completo_cliente INTO nombre
  FROM cliente WHERE id_cliente = id;
  RETURN nombre;
END //
DELIMITER ;

-- STORED PROCEDURES -- 

DELIMITER //
CREATE PROCEDURE registrar_venta(
  IN p_id_prenda INT,
  IN p_id_cliente INT,
  IN p_id_vendedor INT,
  IN p_id_metodo_pago INT,
  IN p_fecha DATE,
  IN p_importe FLOAT
)
BEGIN
  INSERT INTO venta (id_prenda, id_cliente, id_vendedor, id_metodo_pago, fecha_venta, importe)
  VALUES (p_id_prenda, p_id_cliente, p_id_vendedor, p_id_metodo_pago, p_fecha, p_importe);
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE actualizar_stock_prenda(IN p_id_prenda INT, IN p_cantidad_vendida INT)
BEGIN
  UPDATE prenda
  SET cantidad = cantidad - p_cantidad_vendida
  WHERE id_prenda = p_id_prenda;
END //
DELIMITER ;

-- TRIGGERS --

DELIMITER //
CREATE TRIGGER check_stock
BEFORE INSERT ON venta
FOR EACH ROW
BEGIN
  DECLARE stock_actual INT;
  SELECT cantidad INTO stock_actual
  FROM prenda
  WHERE id_prenda = NEW.id_prenda;

  IF stock_actual <= 0 THEN
    SET NEW.id_prenda = NULL;
  END IF;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER descontar_stock
AFTER INSERT ON venta
FOR EACH ROW
BEGIN
  UPDATE prenda
  SET cantidad = cantidad - 1
  WHERE id_prenda = NEW.id_prenda;
END //
DELIMITER ;
