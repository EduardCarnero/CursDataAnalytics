
#NIVELL 1
#Ex1
SELECT user.id, COUNT(transaction.id)
FROM user, transaction
WHERE transaction.user_id = user.id AND declined = 0
GROUP BY user.id
HAVING COUNT(transaction.id) > 30;

#Ex2
SELECT (SUM(transaction.amount)/COUNT(transaction.amount)) AS 'Despesa mitja', company.company_name
FROM bussines.transaction, bussines.company
WHERE company.company_id = transaction.bussines_id AND declined = 0
GROUP BY company_name
HAVING company_name = 'Donec Ltd';

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
SELECT transaction.id AS transaction_id, product.id AS product_id
FROM transaction
CROSS JOIN product
);


SELECT COUNT(transaction_product.product_id), transaction_product.product_id
FROM transaction_product
RIGHT JOIN transaction ON transaction.id = transaction_product.transaction_id
GROUP BY transaction_product.product_id;


INSERT INTO TransactionProduct (transaction_id, product_id)
SELECT
    t.transaction_id,
    p.product_id
FROM
    transactions t
CROSS JOIN
    products p;
    

#I have a table that has transaction_id, and another that hasproduct_id.
#I want to create a table that has every transaction_id and every product_id relating one with the other.
#For example if i have 5 transactions and 5 products the table would have 25 rows of transaction_id = 1, product_id = 1, transaction_id = 1, product_id = 2, transaction_id = 1, product_id = 3,  etc...
