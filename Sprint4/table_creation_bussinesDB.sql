CREATE DATABASE IF NOT EXISTS bussines;

USE bussines;

#Table company DIMENSION TABLE
CREATE TABLE IF NOT EXISTS bussines.company (
		company_id VARCHAR(10) PRIMARY KEY,
        company_name VARCHAR(100),
		phone VARCHAR(20),
        email VARCHAR(50),
        country VARCHAR(20),
        website VARCHAR(50)
);

#Table product DIMENSION TABLE
CREATE TABLE IF NOT EXISTS bussines.product (
		id INT PRIMARY KEY,
        product_name VARCHAR(25),
        price VARCHAR(20),
        colour VARCHAR(20),
        weight VARCHAR(5),
        warehouse_id VARCHAR(10)
);

#Table credit_card DIMENSION TABLE
CREATE TABLE IF NOT EXISTS bussines.credit_card (
		id VARCHAR(25) PRIMARY KEY,
        user_id INT,
        iban VARCHAR(50),
        pan INT,
        pin INT,
        cvv INT,
        track1 VARCHAR(100),
        track2 VARCHAR(100),
        expiring_date VARCHAR(10)
);


#Table user DIMENSION TABLE
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

#Table transaction FACT TABLE
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