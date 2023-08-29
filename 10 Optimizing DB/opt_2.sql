drop database if exists Lucky_Shrub;
CREATE DATABASE IF NOT EXISTS Lucky_Shrub;
USE Lucky_Shrub;
CREATE TABLE IF NOT EXISTS Orders (OrderID INT NOT NULL PRIMARY KEY, ClientID VARCHAR(10), ProductID VARCHAR(10), Quantity INT, Cost DECIMAL(6,2), Date DATE);
CREATE TABLE IF NOT EXISTS Products (ProductID VARCHAR(10), ProductName VARCHAR(100), BuyPrice DECIMAL(6,2), SellPrice DECIMAL(6,2), NumberOfItems INT);
CREATE TABLE IF NOT EXISTS Activity (ActivityID INT PRIMARY KEY, Properties JSON);

INSERT INTO Orders (OrderID, ClientID, ProductID , Quantity, Cost, Date) VALUES 
(1, "Cl1", "P1", 10, 500, "2020-09-01" ), 
(2, "Cl2", "P2", 5, 100, "2020-09-05"), 
(3, "Cl3", "P3", 20, 800, "2020-09-03"), 
(4, "Cl4", "P4", 15, 150, "2020-09-07"), 
(5, "Cl3", "P3", 10, 450, "2020-09-08"), 
(6, "Cl2", "P2", 5, 800, "2020-09-09"), 
(7, "Cl1", "P4", 22, 1200, "2020-09-10"), 
(8, "Cl3", "P1", 15, 150, "2020-09-10"), 
(9, "Cl1", "P1", 10, 500, "2020-09-12"), 
(10, "Cl2", "P2", 5, 100, "2020-09-13"), 
(11, "Cl4", "P5", 5, 100, "2020-09-15"),
(12, "Cl1", "P1", 10, 500, "2022-09-01"), 
(13, "Cl2", "P2", 5, 100, "2022-09-05"), 
(14, "Cl3", "P3", 20, 800, "2022-09-03"), 
(15, "Cl4", "P4", 15, 150, "2022-09-07"), 
(16, "Cl3", "P3", 10, 450, "2022-09-08"), 
(17, "Cl2", "P2", 5, 800, "2022-09-09"), 
(18, "Cl1", "P4", 22, 1200, "2022-09-10"), 
(19, "Cl3", "P1", 15, 150, "2022-09-10"), 
(20, "Cl1", "P1", 10, 500, "2022-09-12"), 
(21, "Cl2", "P2", 5, 100, "2022-09-13"),  
(22, "Cl2", "P1", 10, 500, "2021-09-01"), 
(23, "Cl2", "P2", 5, 100, "2021-09-05"), 
(24, "Cl3", "P3", 20, 800, "2021-09-03"), 
(25, "Cl4", "P4", 15, 150, "2021-09-07"), 
(26, "Cl1", "P3", 10, 450, "2021-09-08"), 
(27, "Cl2", "P1", 20, 1000, "2022-09-01"), 
(28, "Cl2", "P2", 10, 200, "2022-09-05"), 
(29, "Cl3", "P3", 20, 800, "2021-09-03"), 
(30, "Cl1", "P1", 10, 500, "2022-09-01"); 

INSERT INTO Products (ProductID, ProductName, BuyPrice, SellPrice, NumberOfItems) VALUES 
("P1", "Artificial grass bags ", 40, 50, 100), 
("P2", "Wood panels", 15, 20, 250), 
("P3", "Patio slates",  35, 40, 60), 
("P4", "Sycamore trees ", 7, 10, 50), 
("P5", "Trees and Shrubs", 35, 50, 75), 
("P6", "Water fountain", 65, 80, 15);

INSERT INTO Activity(ActivityID, Properties) VALUES  
(1, '{ "ClientID": "Cl1", "ProductID": "P1", "Order": "True" }' ),  
(2, '{ "ClientID": "Cl2", "ProductID": "P4", "Order": "False" }' ),  
(3, '{ "ClientID": "Cl5", "ProductID": "P5", "Order": "True" }' );

-- There are three main objectives in this activity: 
-- Use common table expressions
-- Create a prepared statement
-- Use JSON to extract relevant data

-- Task 1
-- Lucky Shrub need to find out how many orders were placed by clients 
-- with the following Client IDs in 2022; Cl1, Cl2 and Cl3. 
-- They have created the following query to extract this information.  
select count(*)  from orders where clientID IN("cl1","cl2","cl3") and date <'2023-01-01' and date>'2021-12-30';
-- select clientID,count(*),concat(clientID,": ",count(*)," orders") as "Total number of order"  from orders where clientID IN("cl1","cl2","cl3") and date <'2023-01-01' and date>'2021-12-30' group by clientID; -- this is how I would do it
select clientID,count(*),concat(clientID,": ",count(*)," orders") as "Total number of order"  from orders where clientID IN("cl1","cl2","cl3") and YEAR(Date)=2022 group by clientID; -- this is how I would do it

SELECT CONCAT("Cl1: ", COUNT(OrderID), "orders") AS "Total number of orders" FROM Orders WHERE YEAR(Date) = 2022 AND ClientID = "Cl1" 
UNION 
SELECT CONCAT("Cl2: ", COUNT(OrderID), "orders") FROM Orders WHERE YEAR(Date) = 2022 AND ClientID = "Cl2" 
UNION 
SELECT CONCAT("Cl3: ", COUNT(OrderID), "orders") FROM Orders WHERE YEAR(Date) = 2022 AND ClientID = "Cl3"; 

-- Help Lucky Shrub to optimize this query by recreating it as a common table expression (CTE).

with 
cte1 as (SELECT CONCAT("Cl1: ", COUNT(OrderID), "orders") AS "Total number of orders" FROM Orders WHERE YEAR(Date) = 2022 AND ClientID = "Cl1"),
cte2 as (SELECT CONCAT("Cl2: ", COUNT(OrderID), "orders") FROM Orders WHERE YEAR(Date) = 2022 AND ClientID = "Cl2"),
cte3 as (SELECT CONCAT("Cl3: ", COUNT(OrderID), "orders") FROM Orders WHERE YEAR(Date) = 2022 AND ClientID = "Cl3")
select * from cte1
union 
select * from cte2
union 
select * from cte3;

-- Task 2 
-- Lucky Shrub need you to help them to create a prepared statement called GetOrderDetail. 
-- The prepared statement should accept two input arguments: 
-- a ClientID value and a year value. 
-- The statement should return the
--  order id, the quantity, the order cost and the order date from the Orders table.
select orderid, quantity, cost, date from orders where clientID='cl1' and YEAR(date)=2022;

prepare GetOrderDetail from 'select orderid, quantity, cost, date from orders where clientID=? and YEAR(date)=?';
SET @clientID = 'cl1';
SET @year=2020;
execute GetOrderDetail using @clientID, @year;

-- Task 3
-- The Lucky Shrub system logs the ClientID of each client, 
-- and the ProductID of the products they order, in a JSON Properties column in the Activity table.

-- You need to utilize the Properties column data to output 
-- the product id, name, buy price and sell price of the product where the Order value in the Activity table is True.

-- Tips:
-- The product name, buy price and sell price data must be extracted from the Products table.
-- Use the following code to access the property value with double quotations from the JSON datatype: ->'$.PropertyName 
-- Use the following code to access the property value without double quotations from JSON datatype: ->>'$. PropertyName  

select Properties->'$.ProductID' AS test from activity where  Properties->'$.Order'="True" ; -- upper/lower case matters
select Properties->>'$. ProductID' from activity where  Properties->'$.Order'="True"; -- upper/lower case matters and UNQUOTE

-- select productname from products where productid = ANY (select Properties->'$.ProductID' from activity where  Properties->'$.Order'="True"); -- why is this not working ??? forgot what all,extsts etc. means

-- select productname from products inner join Activity on exists (select Properties->>'$. ProductID' from activity where  Properties->'$.Order'="True") = products.productid; -- why is this not working ??? forgot what all,extsts etc. means

SELECT Activity.Properties ->>'$.ProductID' AS ProductID, 
Products.ProductName, Products.BuyPrice, Products.SellPrice 
FROM Products INNER JOIN Activity 
ON Products.ProductID = Activity.Properties ->>'$.ProductID' 
WHERE Activity.Properties ->>'$.Order' = "True";









