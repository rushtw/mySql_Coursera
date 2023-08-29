CREATE DATABASE Mangata_Gallo;
USE Mangata_Gallo;
-- Task 1: Write a SQL statement that creates the Staff table with the following columns.
-- StaffID: INT
-- FullName: VARCHAR(100)
-- PhoneNumber: VARCHAR(10)
Create table Staff(StaffID INT,
FullName VARCHAR(100),
PhoneNumber VARCHAR(10));

SHOW columns from Staff;

-- Write a SQL statement to apply the following constraints to the Staff table:
-- StaffID: INT NOT NULL and PRIMARY KEY
-- FullName: VARCHAR(100) and NOT NULL
-- PhoneNumber: INT NOT NULL

alter table Staff 
Modify StaffID int not null primary key,
Modify FullName VARCHAR(100) not null,
Modify PhoneNumber INT NOT NULL;

alter table Staff
add Role VARCHAR(50) NOT NULL;

SHOW columns from Staff;

alter table Staff
drop PhoneNumber;

SHOW columns from Staff;


