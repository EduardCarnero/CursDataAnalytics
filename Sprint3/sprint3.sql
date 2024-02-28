#NIVELL 1

#Ex1
CREATE INDEX idx_credit_card_id ON transaction(credit_card_id);

CREATE TABLE IF NOT EXISTS credit_card (
	id VARCHAR (15) PRIMARY KEY,
    iban VARCHAR (100),
    pan VARCHAR (100),
    pin VARCHAR (15),
    cvv VARCHAR (15),
    expiring_date VARCHAR (15)
    );

ALTER TABLE transaction
ADD FOREIGN KEY (credit_card_id) REFERENCES credit_card(id);

  -- Creamos la tabla user

CREATE INDEX idx_user_id ON transaction(user_id);
 
CREATE TABLE IF NOT EXISTS user (
        id INT PRIMARY KEY,
        name VARCHAR(100),
        surname VARCHAR(100),
        phone VARCHAR(150),
        email VARCHAR(150),
        birth_date VARCHAR(100),
        country VARCHAR(150),
        city VARCHAR(150),
        postal_code VARCHAR(100),
        address VARCHAR(255)    
    );

ALTER TABLE transaction
ADD FOREIGN KEY (user_id) REFERENCES user(id);

#Ex2
UPDATE credit_card
SET iban = 'TR323456312213576817699999'
WHERE id = 'CcU-2938';

SELECT *
FROM credit_card
WHERE id = 'CcU-2938';

#Ex3
INSERT INTO credit_card (id)
VALUES ('CcU-9999');

INSERT INTO company (id)
VALUES ('b-9999');

INSERT INTO user (id)
VALUES (999);

INSERT INTO transaction (id, credit_card_id, company_id, user_id, lat, longitude, amount, declined)
VALUES ('108B1D1D-5B23-A76C-55EF-C568E49A99DD', 'CcU-9999', 'b-9999', 999, 829.999, -117.999, 111.11, 0);

SELECT *
FROM transaction
WHERE id = '108B1D1D-5B23-A76C-55EF-C568E49A99DD';

#Ex4
ALTER TABLE credit_card
DROP COLUMN pan;

SELECT *
FROM credit_card;

#NIVELL 2
#Ex1
DELETE
FROM transaction
WHERE id = '02C6201E-D90A-1859-B4EE-88D2986D3B02';

SELECT *
FROM transaction
WHERE id = '02C6201E-D90A-1859-B4EE-88D2986D3B02';

#Ex2
CREATE VIEW VistaMarketng AS
SELECT company_name, phone, country, AVG(amount)
FROM company, transaction
WHERE transaction.company_id = company.id
GROUP BY company_name, phone, country
ORDER BY AVG(amount) DESC;

#Ex3
SELECT *
FROM VistaMarketng
WHERE country = 'Germany';


#NIVELL 3
#Ex1

#Delete website column from TABLE company

ALTER TABLE company
DROP COLUMN website;

#Change declined FIELD from BOOLEAN to TINYINT (1) in TABLE transaction

ALTER TABLE transaction
MODIFY COLUMN declined TINYINT(1);

#Change name of TABLE user to data_user

ALTER TABLE user
RENAME TO data_user;

#Change name of FIELD email to personal_email on TABLE user

ALTER TABLE data_user
RENAME COLUMN email TO personal_email;

#Change id, iban, pin, expiring_date FIELDS VARCHAR lenght from TABLE credit_card
#Create FIELD fecha_actual DATE on TABLE credit_card

ALTER TABLE credit_card
MODIFY COLUMN id VARCHAR (20);

ALTER TABLE credit_card
MODIFY COLUMN iban VARCHAR (50);

ALTER TABLE credit_card
DROP COLUMN pan;

ALTER TABLE credit_card
MODIFY COLUMN pin VARCHAR (4);

ALTER TABLE credit_card
MODIFY COLUMN cvv INT;

ALTER TABLE credit_card
MODIFY COLUMN expiring_date VARCHAR (10);

ALTER TABLE credit_card
ADD COLUMN fecha_actual TIMESTAMP DEFAULT CURRENT_TIMESTAMP;

#Ex2
CREATE VIEW InformeTecnico AS
SELECT transaction.id, data_user.name, data_user.surname, credit_card.iban, company.company_name, transaction.declined
FROM company, transaction, data_user, credit_card
WHERE transaction.company_id = company.id AND transaction.user_id = data_user.id AND transaction.credit_card_id = credit_card.id;


