
#PRIMER PASO: Creacion de la DB y creación de las tablas acorde a los CSV proporcionados.
CREATE DATABASE IF NOT EXISTS bussines;

USE bussines;

#Table company = DIMENSION TABLE
CREATE TABLE IF NOT EXISTS bussines.company (
		company_id VARCHAR(10) PRIMARY KEY,
        company_name VARCHAR(100),
		phone VARCHAR(20),
        email VARCHAR(50),
        country VARCHAR(20),
        website VARCHAR(50)
);

#Table product = DIMENSION TABLE
CREATE TABLE IF NOT EXISTS bussines.product (
		id INT PRIMARY KEY,
        product_name VARCHAR(25),
        price VARCHAR(20),
        colour VARCHAR(20),
        weight VARCHAR(5),
        warehouse_id VARCHAR(10)
);

#Table credit_card = DIMENSION TABLE
CREATE TABLE IF NOT EXISTS bussines.credit_card (
		id VARCHAR(25) PRIMARY KEY,
        user_id INT,
        iban VARCHAR(50),
        pan VARCHAR(50),
        pin VARCHAR(50),
        cvv VARCHAR(50),
        track1 VARCHAR(100),
        track2 VARCHAR(100),
        expiring_date VARCHAR(10)
);


#Table user = DIMENSION TABLE
CREATE TABLE IF NOT EXISTS bussines.user (
		id INT PRIMARY KEY,
		name VARCHAR(50),
		surname VARCHAR(50),
		phone VARCHAR(50),
		email VARCHAR(50),
		birth_date VARCHAR(25),
		country VARCHAR(50),
		city VARCHAR(50),
		postal_code VARCHAR(25),
		address VARCHAR(50)
);

#Table transaction = FACT TABLE
CREATE TABLE IF NOT EXISTS bussines.transaction (
		id VARCHAR(100),
        card_id VARCHAR(10),
        bussines_id VARCHAR(10),
        timestamp TIMESTAMP,
        amount DECIMAL(10, 2),
        declined BOOLEAN,
        product_id VARCHAR(15),
        user_id INT,
        lat VARCHAR(20),
        longitude VARCHAR(20),
        FOREIGN KEY (card_id) REFERENCES credit_card(id),
        FOREIGN KEY (user_id) REFERENCES user(id),
        FOREIGN KEY (bussines_id) REFERENCES company(company_id)
);

#SEGUNDO PASO: Adequaciones en las tablas para el correcto funcinamiento de la DB.

#Separación de la columna product_ids en 4 columnas diferentes product_idn (n = 1 - 4)
#Primero añadimos las nuevas columnas para los product_ids
ALTER TABLE transaction
ADD COLUMN product_id1 VARCHAR(20);

ALTER TABLE transaction
ADD COLUMN product_id2 VARCHAR(20);

ALTER TABLE transaction
ADD COLUMN product_id3 VARCHAR(20);

ALTER TABLE transaction
ADD COLUMN product_id4 VARCHAR(20);

#Necesario para que MySQL nos deje hacer UPDATES en las tablas
SET SQL_SAFE_UPDATES = 0;

#Con estos UPDATES separamos los products ids en columnas 
#y nos aseguramos que los valores sean NULL en las columnas que lo requieran
UPDATE bussines.transaction
SET
	product_id1 = SUBSTRING_INDEX(product_id, ',', 1);

UPDATE bussines.transaction
SET
    product_id2 = SUBSTRING_INDEX(SUBSTRING_INDEX(product_id, ',', 2),',', -1)
    WHERE product_id LIKE '%,%';

UPDATE bussines.transaction
SET
    product_id3 = SUBSTRING_INDEX(SUBSTRING_INDEX(product_id, ',', 3),',', -1)
    WHERE product_id LIKE '%,%,%';

UPDATE bussines.transaction
SET
    product_id4 = SUBSTRING_INDEX(SUBSTRING_INDEX(product_id, ',', -1),',', -1)
    WHERE product_id LIKE '%,%,%,%';

#Una vez separados los products ids podemos cambiar su formato a INT
ALTER TABLE bussines.transaction
MODIFY product_id1 INT,
MODIFY product_id2 INT,
MODIFY product_id3 INT,
MODIFY product_id4 INT;

#Ahora vamos a eliminar el simbolo del dollar ($) de la columna de precios de la tabla de productos
#ya que mas adelante quizas necesitemos realizar operaciones con esos valores
UPDATE bussines.product
SET price = REPLACE (price, '$', '');

#Cambiamos el DATA TYPE a DECIMAL
ALTER TABLE bussines.product
MODIFY price DECIMAL(10, 2);

#Ahora cambiaremos el DATA TYPE de la columna expiring_date a DATE
#Creamos una nueva columna
ALTER TABLE bussines.credit_card
ADD COLUMN new_expiring_date DATE;

#La llenamos con los datos de expiring_date pasandolo a DATE
UPDATE credit_card
SET new_expiring_date = STR_TO_DATE(expiring_date, '%m/%d/%y');

#Eliminamos la columna anterior
ALTER TABLE credit_card
DROP COLUMN expiring_date;

#Camibamos el nombre de la actual
ALTER TABLE credit_card
RENAME COLUMN new_expiring_date TO expiring_date;

#EJERCICIOS

#NIVELL 1
#Ex1
SELECT user.id, COUNT(transaction.id)
FROM user, transaction
WHERE transaction.user_id = user.id AND declined = 0
GROUP BY user.id
HAVING COUNT(transaction.id) > 30;

#Ex2
SELECT AVG(transaction.amount) AS 'Despesa mitja', company.company_name
FROM bussines.transaction, bussines.company
WHERE company.company_id = transaction.bussines_id AND declined = 0
GROUP BY company_name
HAVING company_name = 'Donec Ltd';

#NIVELL 2
#Ex1
CREATE TABLE estado_tarjeta (
WITH ConteoTransacciones AS (
SELECT *, ROW_NUMBER() OVER(PARTITION BY card_id ORDER BY timestamp DESC) AS numeracion
FROM transaction)
SELECT card_id,
	CASE
		WHEN SUM(declined) = 3 THEN 'inactiva'
        ELSE 'activa'
	END AS estado
FROM ConteoTransacciones
WHERE numeracion <= 3
GROUP BY card_id);

SELECT COUNT(estado) AS 'numero de tarjetas activas'
FROM estado_tarjeta
WHERE estado = 'activa';

#NIVELL 3
#Ex1
CREATE TABLE transaction_product (
		transaction_id VARCHAR(100),
        product_id INT,
        PRIMARY KEY (transaction_id, product_id)
);

INSERT INTO transaction_product (transaction_id, product_id)
SELECT id, product_id
FROM (
		SELECT id, product_id1 AS product_id FROM transaction WHERE product_id1 IS NOT NULL
        UNION
        SELECT id, product_id2 AS product_id FROM transaction WHERE product_id2 IS NOT NULL
        UNION
        SELECT id, product_id3 AS product_id FROM transaction WHERE product_id3 IS NOT NULL
        UNION
        SELECT id, product_id4 AS product_id FROM transaction WHERE product_id4 IS NOT NULL
        ) AS unions;
        
#Intentamos estavlecer una FOREIGN KEY entre tablas transaction_product y product pero no deja
ALTER TABLE transaction_product
ADD FOREIGN KEY (product_id) REFERENCES product(id);

#Comprobamos que existen 
SELECT *
FROM transaction_product
WHERE NOT EXISTS (SELECT * FROM product WHERE transaction_product.product_id = product.id);

INSERT INTO product(id)
VALUES(41);

INSERT INTO product(id)
VALUES(53);

CREATE INDEX idx_transaction_id ON transaction(id);

ALTER TABLE transaction_product
ADD FOREIGN KEY (transaction_id) REFERENCES transaction(id);

SELECT COUNT(product_id), product_id
FROM transaction_product
GROUP BY product_id;