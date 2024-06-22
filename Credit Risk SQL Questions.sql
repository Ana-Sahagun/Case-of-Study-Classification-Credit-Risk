-- Crear la base de datos
CREATE DATABASE IF NOT EXISTS credit_card_classification;

-- Usar la base de datos
USE credit_card_classification;

-- Crear la tabla
CREATE TABLE IF NOT EXISTS credit_card_data  (
	`customer_number` INT,
	`bank_accounts_open` INT,
	`credit_cards_held` INT,
	`homes_owned` INT,
	`household_size` INT,
	`average_balance` FLOAT,
	`q1_balance` FLOAT,
	`q2_balance` FLOAT,
	`q3_balance` FLOAT,
	`q4_balance` FLOAT,
	`offer_accepted` INT,
	`reward` INT,
	`mailer_type` INT,
	`overdraft_protection` INT,
	`credit_rating` INT,
	`own_your_home` INT,
	`income_level` INT
);
-- A partir de aqui puedes integrar el fichero de datos

-- 4. Select all the data from table credit_card_data to check if the data was imported correctly.
USE credit_card_classification;
SELECT* FROM credit_card_data;

-- 5. Use the alter table command to drop the column q4_balance from the database, as we would not use it in the analysis with SQL. 
-- Select all the data from the table to verify if the command worked. Limit your returned results to 10.
ALTER TABLE credit_card_data DROP COLUMN q4_balance;
SELECT * FROM credit_card_classification.credit_card_data;

-- 6. Use sql query to find how many rows of data you have.
SELECT COUNT(*) AS total_rows FROM credit_card_data;

-- 7. Now we will try to find the unique values in some of the categorical columns:
	-- 7.1. What are the unique values in the column Offer_accepted?
		SELECT DISTINCT offer_accepted FROM credit_card_data;
        
    -- 7.2. What are the unique values in the column Reward?
		SELECT DISTINCT reward FROM credit_card_data;	
    
    -- 7.3. What are the unique values in the column mailer_type?
   		SELECT DISTINCT mailer_type FROM credit_card_data;	

    -- 7.3. What are the unique values in the column credit_cards_held?
   		SELECT DISTINCT credit_cards_held FROM credit_card_data;
		
    -- 7.4. What are the unique values in the column household_size?
		SELECT DISTINCT household_size FROM credit_card_data;	
    
-- 8. Arrange the data in a decreasing order by the average_balance of the customer. 
-- Return only the customer_number of the top 10 customers with the highest average_balances in your data.
SELECT * FROM credit_card_classification.credit_card_data
ORDER BY average_balance  DESC
LIMIT 10
;

-- 9. What is the average balance of all the customers in your data?
SELECT AVG (Average_Balance) AS balance_average
FROM credit_card_data;

-- 10. In this exercise we will use simple group_by to check the properties of some of the categorical variables in our data. 
-- Note wherever average_balance is asked, please take the average of the column average_balance:
	-- 10.1. What is the average balance of the customers grouped by Income Level? 
    -- The returned result should have only two columns, income level and Average balance of the customers. Use an alias to change the name of the second column.
		SELECT average_Balance AS average_balance_income
		FROM credit_card_data
		GROUP BY income_Level, average_balance;
        
    -- 10.2. What is the average balance of the customers grouped by number_of_bank_accounts_open? 
    -- The returned result should have only two columns, number_of_bank_accounts_open and Average balance of the customers. Use an alias to change the name of the second column.      
        SELECT bank_accounts_open AS number_of_bank_accounts_open, 
				AVG(average_balance) AS average_balance_number_accounts 
		FROM credit_card_data
		GROUP BY bank_accounts_open;
        
    -- 10.3. What is the average number of credit cards held by customers for each of the credit card ratings? 
    -- The returned result should have only two columns, rating and average number of credit cards held. Use an alias to change the name of the second column.
	SELECT credit_rating, AVG(credit_cards_held)
    FROM credit_card_data
	GROUP BY credit_rating;

    
    -- 10.4. Is there any correlation between the columns credit_cards_held and number_of_bank_accounts_open? 
    -- You can analyse this by grouping the data by one of the variables and then aggregating the results of the other column. Visually check if there is a positive correlation or negative correlation or no correlation between the variables.
		SELECT credit_cards_held, 
		COUNT(bank_accounts_open) AS conteo_cuentas_tarjeta
		FROM credit_card_data
		GROUP BY credit_cards_held
		ORDER BY credit_cards_held DESC;


	-- Check de lo opuesto:
		SELECT credit_cards_held, 
		COUNT(Bank_Accounts_Open) AS conteo_cuentas_tarjeta
		FROM credit_card_data
		GROUP BY credit_cards_held
		ORDER BY credit_cards_held DESC;

-- 11. Your managers are only interested in the customers with the following properties:
		-- Credit rating medium or high        
		-- Credit cards held 2 or less        
		-- Owns their own home        
		-- Household size 3 or more        
-- For the rest of the things, they are not too concerned. Write a simple query to find what are the options available for them? 
-- Can you filter the customers who accepted the offers here?
SELECT * FROM credit_card_data;
SELECT * 
FROM credit_card_data
WHERE credit_rating >=2
AND credit_cards_held <= 2
AND homes_owned != 0
AND household_size >= 3
AND offer_accepted = 1;

-- 12. Your managers want to find out the list of customers whose average balance is less than the average balance of all the customers in the database. 
-- Write a query to show them the list of such customers. You might need to use a subquery for this problem.
SELECT * 
FROM credit_card_data
WHERE average_balance < (SELECT AVG (average_balance) FROM credit_card_data);

-- 13. Since this is something that the senior management is regularly interested in, create a view of the same query.
CREATE VIEW customers_below_average_balance AS
SELECT *
FROM credit_card_data
WHERE Average_Balance < (SELECT AVG(Average_Balance) FROM credit_card_data);

-- 15. Your managers are more interested in customers with a credit rating of high or medium. 
-- What is the difference in average balances of the customers with high credit card rating and low credit card rating?
-- Para este calculo voy a tener solo en cuenta que el nivel high es el 2 y el low el 0, obviando asi el 1 como si fuese medium:
SELECT DISTINCT credit_rating FROM credit_card_data;
-- Ahora calculamos:
SELECT 
    AVG(CASE WHEN credit_rating = 2 THEN Average_Balance END) AS avg_high_rating,
    AVG(CASE WHEN credit_rating = 1 THEN Average_Balance END) AS avg_low_rating,
    AVG(CASE WHEN credit_rating = 2 THEN Average_Balance END) -
    AVG(CASE WHEN credit_rating = 1 THEN Average_Balance END) AS difference_in_average_balance
FROM credit_card_data;

-- 16. In the database, which all types of communication (mailer_type) were used and with how many customers?
SELECT DISTINCT mailer_type, COUNT(customer_number)
FROM credit_card_data
GROUP BY mailer_type;

-- 17. Provide the details of the customer that is the 11th least Q1_balance in your database.
SELECT *
FROM credit_card_data
ORDER BY q1_balance ASC
LIMIT 1 OFFSET 10; -- Con el OFFSET te saltas las primeras 10 filas

-

