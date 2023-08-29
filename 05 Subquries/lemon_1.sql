DROP DATABASE IF EXISTS littlelemon_db;
CREATE DATABASE littlelemon_db;
USE littlelemon_db;

CREATE TABLE MenuItems ( 
  ItemID INT, 
  Name VARCHAR(200), 
  Type VARCHAR(100), 
  Price INT, 
  PRIMARY KEY (ItemID) 
); 

CREATE TABLE Menus ( 
  MenuID INT, 
  ItemID INT, 
  Cuisine VARCHAR(100), 
  PRIMARY KEY (MenuID,ItemID)
); 

CREATE TABLE Bookings ( 
  BookingID INT, 
  TableNo INT, 
  GuestFirstName VARCHAR(100), 
  GuestLastName VARCHAR(100), 
  BookingSlot TIME, 
  EmployeeID INT, 
  PRIMARY KEY (BookingID) 
); 

CREATE TABLE TableOrders ( 
  OrderID INT, 
  TableNo INT, 
  MenuID INT, 
  BookingID INT, 
  BillAmount INT, 
  Quantity INT, 
  PRIMARY KEY (OrderID,TableNo) 
); 


INSERT INTO MenuItems VALUES(1,'Olives','Starters', 5), 
(2,'Flatbread','Starters', 5),
(3, 'Minestrone', 'Starters', 8), 
(4, 'Tomato bread','Starters', 8), 
(5, 'Falafel', 'Starters', 7), 
(6, 'Hummus', 'Starters', 5), 
(7, 'Greek salad', 'Main Courses', 15), 
(8, 'Bean soup', 'Main Courses', 12), 
(9, 'Pizza', 'Main Courses', 15), 
(10,'Greek yoghurt','Desserts', 7), 
(11, 'Ice cream', 'Desserts', 6),
(12, 'Cheesecake', 'Desserts', 4), 
(13, 'Athens White wine', 'Drinks', 25), 
(14, 'Corfu Red Wine', 'Drinks', 30), 
(15, 'Turkish Coffee', 'Drinks', 10), 
(16, 'Turkish Coffee', 'Drinks', 10), 
(17, 'Kabasa', 'Main Courses', 17);

INSERT INTO Menus VALUES(1, 1, 'Greek'), (1, 7, 'Greek'), (1, 10, 'Greek'), (1, 13, 'Greek'), (2, 3, 'Italian'), (2, 9, 'Italian'), (2, 12, 'Italian'), (2, 15, 'Italian'), (3, 5, 'Turkish'), (3, 17, 'Turkish'), (3, 11, 'Turkish'), (3, 16, 'Turkish');

INSERT INTO Bookings VALUES(1,12,'Anna','Iversen','19:00:00',1),  
(2, 12, 'Joakim', 'Iversen', '19:00:00', 1), (3, 19, 'Vanessa', 'McCarthy', '15:00:00', 3), 
(4, 15, 'Marcos', 'Romero', '17:30:00', 4), (5, 5, 'Hiroki', 'Yamane', '18:30:00', 2),
(6, 8, 'Diana', 'Pinto', '20:00:00', 5); 

INSERT INTO TableOrders VALUES(1, 12, 1, 1, 2, 86), (2, 19, 2, 2, 1, 37), (3, 15, 2, 3, 1, 37), (4, 5, 3, 4, 1, 40), (5, 8, 1, 5, 1, 43);

-- There are two main objectives in this activity:
-- Working with single row, multiple row and correlated subqueries.
-- Using the comparison operators and the ALL and NOT EXISTS operators with subqueries.

-- Task 1: 
-- Write a SQL SELECT query to find all bookings that are due after the booking of the guest ‘Vanessa McCarthy’.
SELECT * FROM Bookings WHERE BookingSlot > (select BookingSlot from Bookings where GuestFirstName='Vanessa' AND GuestLastName='McCarthy' );

-- Task 2: 
-- Write a SQL SELECT query to find the menu items that are more expensive than all the 'Starters' and 'Desserts' menu item types.
SELECT *  FROM menuitems WHERE price > ALL (SELECT price from menuitems where type='Starters' OR type='Desserts');

-- Task 3: 
-- Write a SQL SELECT query to find the menu items that costs the same as the starter menu items that are Italian cuisine.
-- first a few queries to get to the answer:

SELECT ItemID from Menus WHERE Cuisine='Italian' ;
SELECT ItemID FROM menuitems  where type='Starters';

-- the subquery will correspond to an intersection of [1..17] U [1,3,5,7,9,10,11,12,13,15,16,17]
select * from menuitems where exists (select * from menus where Menus.ItemID=Menuitems.itemId);

select * from menus where exists (select * from menuitems where Menus.ItemID=Menuitems.itemId);

select * from menuitems where exists (select * from menus where Menus.ItemID=Menuitems.itemId AND Cuisine='Italian');
select * from menuitems where type='Starters' AND exists (select * from menus where Menus.ItemID=Menuitems.itemId AND Cuisine='Italian');
select price from menuitems where type='Starters' AND exists (select * from menus where Menus.ItemID=Menuitems.itemId AND Cuisine='Italian');
-- The line above will return price of (Starter that is also Italian) = $8.

-- my solution:
select * from menuitems where price=
(select price from menuitems where type='Starters' AND exists (select * from menus where Menus.ItemID=Menuitems.itemId AND Cuisine='Italian'));


-- Class Solution:
SELECT * FROM MenuItems WHERE Price = 
(SELECT Price FROM Menus, MenuItems WHERE Menus.ItemID = MenuItems.ItemID 
AND MenuItems.Type = 'Starters' AND Cuisine = 'Italian'); 

SELECT * FROM Menus, MenuItems WHERE Menus.ItemID = MenuItems.ItemID; -- ???????????????? same as ...
SELECT * FROM Menus, MenuItems WHERE Menus.ItemID = MenuItems.ItemID AND MenuItems.Type = 'Starters' AND Menus.Cuisine = 'Italian' ; -- ????????????????

-- Task 4: Write a SQL SELECT query to find the menu items that were not ordered by the guests who placed bookings.
-- The menus table shows the menuitems that were ordered by guests that made bookings.
select * from menuitems where  not exists (select ItemID from menus where Menus.ItemID=Menuitems.itemId); 

-- practice
select * from menuitems where price= (select max(price) from menuitems); -- need to have "from menuitems". 

-- ----------------------------------------------------
CREATE TABLE LowCostMenuItems
(ItemID INT, Name VARCHAR(200), Price INT, PRIMARY KEY(ItemID));

-- Task 1: Find the minimum and the maximum average prices at which the customers can purchase food and drinks.
-- Your query would find the average prices of menu items by their type.
select type,AVG(price) as avg_price from menuitems group by type; 

SELECT ROUND(MIN(avgPrice),2), ROUND(MAX(avgPrice),2) 
FROM (SELECT Type,AVG(Price) AS avgPrice
FROM MenuItems 
GROUP BY Type) AS aPrice;

-- Task 2: Insert data of menu items with a minimum price based on the 'Type' into the LowCostMenuItems table.
select type,min(price) as min_price from menuitems group by type; -- make this into a derived table

-- before inserting, select all menu items that have Starters AND 5, etc...alter
select itemid, name,menuitems.type,price from menuitems, (select type,min(price) as min_price from menuitems group by type) derived_table 
where menuitems.type=derived_table.type AND menuitems.price=derived_table.min_price;

insert into LowCostMenuItems 
(select itemid, name,price from menuitems, (select type,min(price) as min_price from menuitems group by type) derived_table 
where menuitems.type=derived_table.type AND menuitems.price=derived_table.min_price);

select * from LowCostMenuItems;

-- ANOTHR WAY:
select itemid, name,price from menuitems WHERE price=ANY
(select min(price) as min_price from menuitems group by type);


-- Task 3: Delete all the low-cost menu items whose price is more than the minimum price of menu items that have a price between $5 and $10.
-- First, find the minimum prices of menu items that have a price between $5 and $10
select * from LowCostMenuItems where price between 5 and 10;

SELECT * FROM LowCostMenuItems 
WHERE Price > ALL(SELECT MIN(Price) as p 
FROM MenuItems 
GROUP BY Type 
HAVING p BETWEEN 5 AND 10);

-- easier
DELETE  FROM LowCostMenuItems 
WHERE Price>10;

