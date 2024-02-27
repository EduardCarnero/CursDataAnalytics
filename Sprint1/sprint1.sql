#NIVELL 1

#Ex2
SELECT company_name, email, country FROM transactions.company
ORDER BY company_name;

#Ex3
SELECT DISTINCT country FROM company
INNER JOIN transaction
ON company.id = transaction.company_id;

#Ex4
SELECT COUNT(DISTINCT country) FROM company
INNER JOIN transaction
ON company.id = transaction.company_id;

#Ex5
SELECT company_name, country FROM company
WHERE id = 'b-2354';

#Ex6
SELECT AVG(amount), company_name FROM transaction, company
WHERE company.id = transaction.company_id
GROUP BY company_name
ORDER BY AVG(amount) DESC;

#NIVELL 2

#Ex1
SELECT COUNT(id) FROM transactions.company
GROUP BY id
HAVING COUNT(id) > 1;

#Ex2
SELECT DATE(timestamp), SUM(amount) FROM transaction
GROUP BY DATE(timestamp)
ORDER BY SUM(amount) DESC
LIMIT 5;

#Ex3

SELECT DATE(timestamp), SUM(amount) FROM transaction
GROUP BY DATE(timestamp)
ORDER BY SUM(amount) ASC
LIMIT 5;

#Ex4
SELECT AVG(amount), country FROM transaction, company
WHERE company.id = transaction.company_id
GROUP BY company.country
ORDER BY AVG(amount) DESC;

#NIVELL 3

#Ex1
SELECT company_name, SUM(amount) 
FROM company, (SELECT * FROM transaction
				WHERE amount BETWEEN 100 AND 200) AS transaction100200
WHERE transaction100200.company_id = company.id
GROUP BY company_name
ORDER BY SUM(amount) DESC;

#Ex2
SELECT DISTINCT(company_name) FROM company, transaction
WHERE company.id = transaction.company_id 
AND (timestamp LIKE ('2022-03-16%') OR timestamp LIKE ('2022-02-28%') OR timestamp LIKE ('2022-02-13%'));