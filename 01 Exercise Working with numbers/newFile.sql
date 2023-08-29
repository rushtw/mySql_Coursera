CREATE DATABASE cm_devices;
USE cm_devices;
CREATE TABLE devices (
  deviceID INT,
  deviceName VARCHAR(50),
  price DECIMAL
);
SHOW tables;
SHOW columns
FROM
  devices;
CREATE TABLE stock (deviceID int, quantity int, totalPrice decimal);
SHOW tables;
SHOW columns
from
  stock;
DESC stock;
SELECT
  *
FROM
  stock;
SELECT
  quantity
from
  stock;
CREATE TABLE Players (
  playerName VARCHAR(50),
  club VARCHAR (10) DEFAULT "Newport FC",
  city VARCHAR (100) DEFAULT "Newport"
);
SHOW tables;
SHOW columns
FROM
  Players;
  
CREATE TABLE Staff( Email VARCHAR(200) NOT NULL, Name varchar(255) NOT NULL, CONSTRAINT PK_Email PRIMARY KEY (Email));