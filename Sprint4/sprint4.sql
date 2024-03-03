
USE bussines;

#NIVELL 1
#Ex1
SELECT COUNT(transaction.id), user.name
FROM transaction, user
WHERE amount > (SELECT AVG(amount)
					FROM transaction)
GROUP BY user.name
HAVING COUNT(transaction.id) > 30;

#Ex2
SELECT (SUM(transaction.amount)/COUNT(transaction.amount)) AS 'Despesa mitja', company.company_name
FROM bussines.transaction, bussines.company
WHERE company.company_id = transaction.bussines_id
GROUP BY company_name
HAVING company_name = 'Donec Ltd.';

#NIVELL 2
#Ex1
CREATE TABLE credit_card_states AS
SELECT
    credit_card_id,
    CASE
        WHEN SUM(declined) = 0 THEN 'active'
        ELSE 'inactive'
    END AS state
FROM (
    SELECT
        credit_card_id,
        CASE
            WHEN declined = 1 THEN 1
            ELSE 0
        END AS declined
    FROM transactions
    ORDER BY credit_card_id, transaction_date DESC
) AS ordered_transactions
GROUP BY credit_card_id;


SELECT * FROM bussines.transaction;



SELECT * FROM bussines.transaction
ORDER BY timestamp DESC;


















