CREATE TABLE CR (
buyer_address VARCHAR(255),
eth_price decimal,
usd_price INT,
seller_address VARCHAR(255),
day date,
utc_timestamp date,
token_id INT,
transaction_hash VARCHAR(255),
name VARCHAR(255),
wrapped_punk VARCHAR(50)

)

DROP TABLE CR;

SELECT * FROM CR;

COPY CR FROM 'D:\SQL\SQL ( project )\cryptopunkdata_1.csv' DELIMITER ',' CSV HEADER;

------------------------------------------------------
-- 1. How many sales occurred during this time period?
------------------------------------------------------ 
-- 19920
SELECT COUNT(*) FROM CR;


--------------------------------------------------------------------------------------
-- 2. Return the top 5 most expensive transactions (by USD price) for this data set.
--    Return the name, ETH price, and USD price, as well as the date.
--------------------------------------------------------------------------------------

SELECT name , eth_price , usd_price , day FROM CR
WHERE seller_address NOTNULL
ORDER BY usd_price DESC
LIMIT 5;


--
-- "CryptoPunk #4156"	2500.00	11102350	"2021-12-09"
-- "CryptoPunk #3100"	4200.00	7541310	    "2021-03-11"
-- "CryptoPunk #7804"	4200.00	7541310	    "2021-03-11"
-- "CryptoPunk #8857"	2000.00	6418580	    "2021-09-11"
-- "CryptoPunk #5217"	2250.00	5362808	    "2021-07-30"


---------------------------------------------------------------------------------------
-- 3. Return a table with a row for each transaction with an event column, a USD price 
-- column, and a moving average of USD price that averages the last 50 transactions.
---------------------------------------------------------------------------------------

SELECT day , usd_price , AVG( usd_price ) OVER ( ORDER BY day DESC ROWS BETWEEN 49 PRECEDING AND CURRENT ROW ) AS moving_avg FROM CR
ORDER BY day;


---------------------------------------------------------------------------------------
-- 4. Return all the NFT names and their average sale price in USD. Sort descending.
-- Name the average column as average_price.

---------------------------------------------------------------------------------------

SELECT name , AVG ( usd_price ) AS average_price
FROM CR 
GROUP BY 1
ORDER BY average_price DESC;


---------------------------------------------------------------------------------------

-- 5. Return each day of the week and the number of sales that occurred on that day
-- of the week, as well as the average price in ETH. Order by the count of
-- transactions in ascending order.
---------------------------------------------------------------------------------------

-- DOW = DATE OF WEEK 
SELECT EXTRACT ( DOW FROM day ) , AVG( eth_price ) AS average_price, COUNT ( transaction_hash )
FROM CR
GROUP BY 1
ORDER BY 1;

---------------------------------------------------------------------------------------
-- 6. Construct a column that describes each sale and is called summary. The
-- sentence should include who sold the NFT name, who bought the NFT, who sold
-- the NFT, the date, and what price it was sold for in USD rounded to the nearest
-- thousandth.

-- Here’s an example summary:
-- “CryptoPunk #1139 was sold for $194000 to
-- 0x91338ccfb8c0adb7756034a82008531d7713009d from
-- 0x1593110441ab4c5f2c133f21b0743b2b43e297cb on 2022-01-14”

---------------------------------------------------------------------------------------


SELECT 
CONCAT(name , ' was sold for $ ' , CEILING(usd_price/1000) , ' to ' , buyer_address , ' from ' , seller_address , ' on ' , day ) AS summary
FROM CR;

--

-- 7. Create a view called “1919_purchases” and contains any sales where
-- “0x1919db36ca2fa2e15f9000fd9cdc2edcf863e685” was the buyer.

CREATE VIEW "1919_purchases" AS
SELECT * FROM CR
WHERE buyer_address = '0x1919db36ca2fa2e15f9000fd9cdc2edcf863e685';

SELECT * FROM "1919_purchases";

-- 8. Return a unioned query that contains the highest price each NFT was bought for
-- and a new column called status saying “highest” with a query that has the lowest
-- price each NFT was bought for and the status column saying “lowest”. The table
-- should have a name column, a price column called price, and a status column.
-- Order the result set by the name of the NFT, and the status, in ascending order.



SELECT name, MAX(eth_price) AS price, 'Highest' AS status
FROM CR
GROUP BY 1 
UNION 
SELECT name, MIN(eth_price) AS price, 'Lowest' AS status
FROM CR
GROUP BY 1
ORDER BY 1;
--


SELECT eth_price , COUNT (*) , MIN(eth_price), MAX(eth_price), AVG(eth_price) FROM CR
GROUP BY 1
ORDER BY eth_price DESC , COUNT (*) DESC;



-----------------------------------------------------------------------------------
-- 9. Create a histogram of ETH price ranges. Round to the nearest hundred value.
-----------------------------------------------------------------------------------

SELECT CASE WHEN eth_price BETWEEN 0 AND 500 THEN '0-500'

WHEN eth_price BETWEEN 501 AND 1000 THEN '501-1000'
WHEN eth_price BETWEEN 1001 AND 1500 THEN '1001-1500'
WHEN eth_price BETWEEN 1501 AND 2000 THEN '1501-2000'
WHEN eth_price BETWEEN 2001 AND 2500 THEN '2001-2500'
WHEN eth_price BETWEEN 2501 AND 3000 THEN '2501-3000'
WHEN eth_price BETWEEN 3001 AND 3500 THEN '3001-3500'
WHEN eth_price BETWEEN 3501 AND 4000 THEN '3501-4000'
WHEN eth_price BETWEEN 4001 AND 4500 THEN '4001-4500'
ELSE '4500 - 5000' END AS Range , COUNT(*) AS Frequency
FROM CR

GROUP BY Range

--
-- select floor(eth_price/500)*500 as eth_price_range,
-- count(*) from CR
-- group by 1
-- order by 1





























































































































































