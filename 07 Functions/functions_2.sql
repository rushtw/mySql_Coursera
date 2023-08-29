drop database  if exists jewelrystore_db;
CREATE DATABASE jewelrystore_db; 

USE jewelrystore_db; 

CREATE TABLE clients 
(ClientID int NOT NULL, 
ClientName varchar(255) DEFAULT NULL, 
Address varchar(255) DEFAULT NULL, 
ContactNo varchar(10) DEFAULT NULL, 
PRIMARY KEY (ClientID));

CREATE TABLE client_orders 
(OrderID INT NOT NULL, 
ClientID INT DEFAULT NULL, 
ItemID INT DEFAULT NULL, 
Cost INT DEFAULT NULL, 
PRIMARY KEY (OrderID));

CREATE TABLE item 
(ItemID INT NOT NULL, 
Name varchar(150) DEFAULT NULL, 
Cost INT DEFAULT NULL, 
PRIMARY KEY (ItemID));

CREATE TABLE mg_orders 
(OrderID INT NOT NULL, 
ItemID INT DEFAULT NULL, 
Quantity INT DEFAULT NULL, 
Cost INT DEFAULT NULL, 
OrderDate DATE DEFAULT NULL, 
DeliveryDate DATE DEFAULT NULL, 
OrderStatus VARCHAR(50) DEFAULT NULL, 
PRIMARY KEY (OrderID));

INSERT INTO clients VALUES 
(1, 'Kishan Hughes','223 Golden Hills, North Austin, TX','387986345'), 
(2, 'Indira Moncada','119 Silver Street, Bouldin Creek, TX','334567243'), 
(3, 'Mosha Setsile','785 Bronze Lane, East Austin, TX','315642597'), 
(4, 'Laura Mills','908 Diamond Crescent, South Lamar, TX','300842509'), 
(5, 'Henrik Kreida','345, Golden Hills, North Austin, TX','358208983'), 
(6, 'Millicent Blou','812, Diamond Crescent, North Burnet, TX','347898755');

INSERT INTO item VALUES 
(1,'Engagement ring',2500), 
(2,'Silver brooch',400), 
(3,'Earrings',350), 
(4,'Luxury watch',1250), 
(5,'Golden bracelet',800), 
(6,'Gemstone',1500); 

INSERT INTO client_orders VALUES 
(1,1,1,2500), 
(2,2,2,400), 
(3,3,3,350), 
(4,4,4,1250), 
(5,5,5,800), 
(6,6,6,1500), 
(7,2,4,400), 
(8,3,4,1250), 
(9,4,2,400), 
(10,1,3,350); 

INSERT INTO mg_orders VALUES 
(1,1,50,122000,'2022-04-05','2022-05-25', 'Delivered'), 
(2,2,75,28000,'2022-03-08',NULL, 'In progress'), 
(3,3,80,25000,'2022-05-19','2022-06-08', 'Delivered'), 
(4,4,45,100000,'2022-01-10',NULL, 'In progress'), 
(5,5,70,56000,'2022-05-19',NULL, 'In progress'), 
(6,6,60,90000,'2022-06-10','2022-06-18', 'Delivered'); 

-- Task 1: Use the MySQL CEIL function to express the cost after the discount in the form of the smallest integer as follows:
-- Give a 5% discount to the clients who have ordered luxury watches. 
-- Express the cost after the discount in the form of the smallest integer, 
-- which is not less than the value shown in the afterDiscount column in the 
-- result table given below. Use the MySQL CEIL function to do this.

-- create a table that shows cliendID, itemID where itemID corresponds to luxuary watches.
select itemID from item where name="luxury watch"; -- SUBQUESY -- typo on luxury

select clientID, orderID, FORMAT(CEIL(0.95*cost),2) as afterDiscount 
from client_orders 
where itemID=(select itemID from item where name="luxury watch");

-- Task 3: Find the expected delivery dates for their orders. 
-- The scheduled delivery date is 30 days after the order date. 
-- Use the ADDDATE function.
SELECT ADDDATE(OrderDate,INTERVAL 30 DAY) AS ExpectedDelDate 
FROM mg_orders;

-- if DeliveryDate=NULL it will be replaced by 'NOT DELIVERED'
SELECT OrderID, ItemID, Quantity, OrderDate,Cost,COALESCE (DeliveryDate,'NOT DELIVERED') as _deliveryDate, OrderStatus 
FROM mg_orders;