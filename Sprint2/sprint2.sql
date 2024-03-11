#NIVELL 1

#Ex1 MAL
SELECT transaction.*
FROM transaction
LEFT JOIN company ON company.company_id = transaction.bussines_id
WHERE country = 'Germany' AND declined = 0;

#Ex1 CORRECIÓN

SELECT transaction.*
FROM transaction
WHERE declined = 0 AND transaction.bussines_id IN (SELECT company_id FROM company WHERE country = 'Germany');

#Ex2
SELECT DISTINCT(company_name)
FROM company
JOIN transaction ON company.id = transaction.company_id
WHERE declined = 0 AND amount > (SELECT AVG(amount)
									FROM transaction);
                
#Ex3 MAL
SELECT transaction.*, company_name
FROM company, transaction
WHERE company.company_id = transaction.bussines_id AND company_name LIKE 'C%';

#Ex3 CORRECIÓN
SELECT transaction.*, company_name
FROM company, transaction
WHERE company.company_id = transaction.bussines_id AND transaction.bussines_id IN (SELECT company.company_id FROM company WHERE company_name LIKE 'C%');

#Ex4 MAL
SELECT company_name
FROM company
LEFT JOIN transaction ON company.company_id = transaction.bussines_id
WHERE transaction.bussines_id IS NULL;

#Ex4 CORECCIÓN
SELECT company_name
FROM company
WHERE company_id NOT IN (
    SELECT bussines_id
    FROM transaction
);

#NIVELL 2

#Ex1
SELECT transaction.*
FROM transaction, company
WHERE transaction.company_id = company.id AND country = (SELECT country FROM company WHERE company_name = 'Non Institute');

#Ex2
SELECT company_name
FROM company, transaction
WHERE transaction.company_id = company.id AND declined = 0 AND amount = (SELECT MAX(amount) FROM transaction);

#NIVELL 3

#Ex1
SELECT country
FROM transaction, company
WHERE transaction.company_id = company.id
GROUP BY country
HAVING AVG(amount) > (SELECT AVG(amount) FROM transaction);

#Ex2
SELECT company_name, COUNT(transaction.id), SUM(amount),
CASE
	WHEN COUNT(transaction.id) >= 4 THEN 'TRUE'
    WHEN COUNT(transaction.id) < 4 THEN 'FALSE'
    END AS 'Mas de 4 transacciones'
FROM company, transaction
WHERE company.company_id = transaction.bussines_id
GROUP BY company_name
ORDER BY COUNT(transaction.id) DESC;










