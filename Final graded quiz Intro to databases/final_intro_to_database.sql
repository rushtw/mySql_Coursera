CREATE DATABASE SportsClub;
USE SportsClub;
CREATE TABLE Players (playerID INT, playerName VARCHAR(50), age INT, PRIMARY KEY(playerID));
INSERT INTO Players (playerID, playerName, age) VALUES (1, "Jack", 25);
INSERT INTO Players (playerID, playerName, age) VALUES (2, "Karl", 20), (3, "Mark", 21), (4, "Andrew", 22);
SELECT playerName FROM Players WHERE playerID = 2;

SELECT playerName FROM Players;

-- The following table called "Players", contains four records of data. 
-- Write a SQL statement that updates the age of the player with ID = 3. 
-- The new age value should be '22'.
UPDATE Players SET age=22 WHERE playerID=3;
DELETE from Players WHERE playerID=4;
-- Write an SQL statement that evaluates if the PlayerID in the following "Players" table is odd or even.

SELECT playerID%2 AS odd_even FROM Players;
SELECT playerID%2 FROM Players;

SELECT playerName FROM Players where age>25;

CREATE TABLE Course (
courseID int NOT NULL, 
courseName VARCHAR(50), 
PRIMARY KEY (courseID),
DepartmentID int,
FOREIGN KEY (DepartmentID) REFERENCES Department(DepartmentID));  

SELECT * FROM Players  ORDER BY playerName DESC;

