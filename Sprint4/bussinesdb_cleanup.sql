
SELECT * FROM bussines.transaction;

#Primero añadioms las nuevas columnas para los product_ids
ALTER TABLE transaction
ADD COLUMN product_id4 VARCHAR(20);

ALTER TABLE transaction
ADD COLUMN product_id4 VARCHAR(20);

ALTER TABLE transaction
ADD COLUMN product_id4 VARCHAR(20);

ALTER TABLE transaction
ADD COLUMN product_id4 VARCHAR(20);

ALTER TABLE transaction MODIFY product_id1 INT;

#Necesario para que MySQL nos deje hacer UPDATES en las tablas
SET SQL_SAFE_UPDATES = 0;

#Con estos UPDATES separamos los products ids en columnas 
#y nos aseguramos que los valores sean NULL en las columnas que lo necesiten
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

#Una vez separados loss products ids podemos cambiar su formato a INT y añadir las FOREIGN KEYS
ALTER TABLE bussines.transaction
MODIFY product_id1 INT,
MODIFY product_id2 INT,
MODIFY product_id3 INT,
MODIFY product_id4 INT;

#ALTER TABLE bussines.transaction
#ADD FOREIGN KEY (product_id1) REFERENCES product(id),
#ADD FOREIGN KEY (product_id2) REFERENCES product(id),
#ADD FOREIGN KEY (product_id3) REFERENCES product(id),
#ADD FOREIGN KEY (product_id4) REFERENCES product(id);

#Ahora vamos a eliminar el simbolo del dollar de la columna de precios de la tabla de productos
#ya que mas adelante quizas necesitemos realizar operaciones con esos valores
UPDATE bussines.product
SET price = REPLACE (price, '$', '');

ALTER TABLE bussines.product
MODIFY price DECIMAL(10, 2);

#Ahora vamos a pasar el tipo de data de la columna expiring_date a DATE
ALTER TABLE bussines.credit_card
ADD COLUMN new_expiring_date DATE;

UPDATE credit_card
SET new_expiring_date = STR_TO_DATE(expiring_date, '%m/%d/%y');

ALTER TABLE credit_card
DROP COLUMN expiring_date;

ALTER TABLE credit_card
RENAME COLUMN new_expiring_date TO expiring_date;
