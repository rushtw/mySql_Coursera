CREATE DATABASE IF NOT EXISTS little_lemon;
USE little_lemon;

CREATE TABLE Customers(CustomerID INT NOT NULL PRIMARY KEY, FullName VARCHAR(100) NOT NULL, PhoneNumber INT NOT NULL UNIQUE);
INSERT INTO Customers(CustomerID, FullName, PhoneNumber) VALUES (1, "Vanessa McCarthy", 0757536378), (2, "Marcos Romero", 0757536379), (3, "Hiroki Yamane", 0757536376), (4, "Anna Iversen", 0757536375), (5, "Diana Pinto", 0757536374);

CREATE TABLE Bookings (BookingID INT NOT NULL PRIMARY KEY,  BookingDate DATE NOT NULL,  TableNumber INT NOT NULL, NumberOfGuests INT NOT NULL CHECK (NumberOfGuests <= 8), CustomerID INT NOT NULL, FOREIGN KEY (CustomerID) REFERENCES Customers (CustomerID) ON DELETE CASCADE ON UPDATE CASCADE); 
INSERT INTO Bookings (BookingID, BookingDate, TableNumber, NumberOfGuests, CustomerID) VALUES (10, '2021-11-11', 7, 5, 1), (11, '2021-11-10', 5, 2, 2), (12, '2021-11-10', 3, 2, 4);


CREATE TABLE FoodOrders (OrderID INT, Quantity INT, Cost Decimal(4,2));
SHOW COLUMNS FROM FoodOrders;

-- Task 1: Use the ALTER TABLE statement with MODIFY command to make the OrderID the primary key of the 'FoodOrders' table. 
ALTER table FoodOrders
MODIFY column OrderID INT Primary key;
SHOW COLUMNS FROM FoodOrders;
-- Task 2: Apply the NOT NULL constraint to the quantity and cost columns.
Alter table FoodOrders
MODIFY column Quantity INT NOT NULL,
MODIFY column  Cost Decimal(4,2) NOT NULL;
SHOW COLUMNS FROM FoodOrders;
-- Task 3: Create two new columns, OrderDate with a DATE datatype and CustomerID with an INT datatype. Declare both must as NOT NULL. 
Alter table FoodOrders
ADD column OrderDate date NOT NULL,
ADD column CustomerID INT NOT NULL;
SHOW COLUMNS FROM FoodOrders;
-- Declare the CustomerID as a foreign key in the FoodOrders table to reference the CustomerID column existing in the Customers table.
SHOW Tables FROM little_lemon;

Alter table FoodOrders
add foreign key (CustomerID) references customers(CustomerID);
SHOW COLUMNS FROM FoodOrders;

-- Task 4: Use the DROP command with ALTER statement to delete the OrderDate column from the 'FoodOrder' table. 
alter table FoodOrders
drop column OrderDate;
SHOW COLUMNS FROM FoodOrders;

-- Task 5: Use the CHANGE command with ALTER statement to rename the column Order_Status in the OrderStatus table to DeliveryStatus. 
-- Task 6: Use the RENAME command with ALTER statement to change the table name from OrderStatus to OrderDeliveryStatus.

