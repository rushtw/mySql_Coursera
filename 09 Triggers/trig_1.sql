drop database  if exists Lucky_Shrub;
CREATE DATABASE Lucky_Shrub;
USE Lucky_Shrub;
CREATE TABLE Products (ProductID VARCHAR(10), ProductName VARCHAR(100),BuyPrice DECIMAL(6,2), SellPrice DECIMAL(6,2), NumberOfItems INT);

INSERT INTO Products (ProductID, ProductName, BuyPrice, SellPrice, NumberOfITems)

VALUES ("P1", "Artificial grass bags ", 40, 50, 100),  
("P2", "Wood panels", 15, 20, 250),  
("P3", "Patio slates",35, 40, 60),  
("P4", "Sycamore trees ", 7, 10, 50),  
("P5", "Trees and Shrubs", 35, 50, 75),  
("P6", "Water fountain", 65, 80, 15);

CREATE TABLE Notifications (NotificationID INT AUTO_INCREMENT, Notification VARCHAR(255), DateTime TIMESTAMP NOT NULL, PRIMARY KEY(NotificationID));

drop trigger if exists ProductSellPriceInsertCheck;

-- Develop INSERT, UPDATE and DELETE triggers.
delimiter // 
create trigger ProductSellPriceInsertCheck after INSERT
on Products for each row
begin
	if new.sellprice<=new.buyprice then
    insert into Notifications(Notification,DateTime)
    values(concat(new.sellprice-new.buyprice," ",new.productID), NOW());
    end if ;
end
//

delimiter ;

-- test ProductSellPriceInsertCheck
insert into Products (ProductID, ProductName, BuyPrice, SellPrice, NumberOfItems)
values  ("P7", "product P7", 40, 40, 100);

-- Task 2:
-- Create an UPDATE trigger called ProductSellPriceUpdateCheck. 
-- This trigger must check that products are not updated 
-- with a SellPrice that is less than or equal to the BuyPrice. 
-- If this occurs, add a notification to the Notifications table 
-- for the sales department so they can ensure that product prices 
-- were not updated with the incorrect values. This trigger sends a 
-- notification to the Notifications table that warns the sales department of the issue.
-- The notification message should be in the following format: 
-- ProductID + was updated with a SellPrice of  + SellPrice + which is the same or less than the BuyPrice

drop trigger if exists ProductSellPriceUpdateCheck;

delimiter // 
create trigger ProductSellPriceUpdateCheck after UPDATE 
on products for each row
begin
	if new.sellprice<=new.buyprice then
	insert into Notifications(Notification,DateTime)
    values(concat(new.productID," ",new.sellprice), NOW());
	end if ;
end
//

delimiter ;

UPDATE Products
SET sellPrice = 60
where productID="P6"; 

-- Task 3:
-- Create a DELETE trigger called NotifyProductDelete. 
-- This trigger must insert a notification in the 
-- Notifications table for the sales department after a product has been deleted from the Products table.
-- The notification message should be in the following format: The product with a ProductID  + ProductID + was deleted

drop trigger if exists NotifyProductDelete;

DELIMITER //
CREATE TRIGGER NotifyProductDelete 
    AFTER DELETE   
    ON Products FOR EACH ROW   
	INSERT INTO Notifications(Notification, DateTime) 
    VALUES(CONCAT('The product with a ProductID ', OLD.ProductID,' was deleted'), NOW())
    //  -- don't forget the '//'
DELIMITER ;



DELETE FROM Products WHERE productID="P7";



