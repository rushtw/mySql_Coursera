DROP DATABASE IF EXISTS travel;
 
CREATE DATABASE travel;
USE travel;
CREATE TABLE manufacturers (
  manufacturer_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  manufacturer VARCHAR(50) NOT NULL,
  -- create_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  -- last_update TIMESTAMP NOT NULL 
  --   DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (manufacturer_id) )
ENGINE=InnoDB AUTO_INCREMENT=1001;
 
CREATE TABLE airplanes (
  plane_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
  plane VARCHAR(50) NOT NULL,
  manufacturer_id INT UNSIGNED NOT NULL,
  engine_type VARCHAR(50) NOT NULL,
  engine_count TINYINT NOT NULL,
  max_weight MEDIUMINT UNSIGNED NOT NULL,
  wingspan DECIMAL(5,2) NOT NULL,
  plane_length DECIMAL(5,2) NOT NULL,
  parking_area INT GENERATED ALWAYS AS ((wingspan * plane_length)) STORED,
  icao_code CHAR(4) NOT NULL,
  -- create_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  -- last_update TIMESTAMP NOT NULL 
  --  DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (plane_id),
  CONSTRAINT fk_manufacturer_id FOREIGN KEY (manufacturer_id) 
    REFERENCES manufacturers (manufacturer_id) ) 
ENGINE=InnoDB AUTO_INCREMENT=101;

INSERT INTO manufacturers (manufacturer)
VALUES ('Airbus'), ('Beagle Aircraft Limited'), ('Beechcraft'), ('Boeing'), 
  ('Bombardier'), ('Cessna'), ('Dassault Aviation'), ('Embraer'), ('Piper');

INSERT INTO airplanes 
  (plane, manufacturer_id, engine_type, engine_count, 
    wingspan, plane_length, max_weight, icao_code)
VALUES
  ('A340-600',1001,'Jet',4,208.17,247.24,837756,'A346'),
  ('A350-800 XWB',1001,'Jet',2,212.42,198.58,546700,'A358'),
  ('A350-900',1001,'Jet',2,212.42,219.16,617295,'A359'),
  ('A380-800',1001,'Jet',4,261.65,238.62,1267658,'A388'),
  ('A380-843F',1001,'Jet',4,261.65,238.62,1300000,'A38F'),
  ('A.109 Airedale',1002,'Piston',1,36.33,26.33,2750,'AIRD'),
  ('A.61 Terrier',1002,'Piston',1,36,23.25,2400,'AUS6'),
  ('B.121 Pup',1002,'Piston',1,31,23.17,1600,'PUP'),
  ('B.206',1002,'Piston',2,55,33.67,7500,'BASS'),
  ('D.5-108 Husky',1002,'Piston',1,36,23.17,2400,'D5'),
  ('Baron 56 TC Turbo Baron',1003,'Piston',2,37.83,28,5990,'BE56'),
  ('Baron 58 (and current G58)',1003,'Piston',2,37.83,29.83,5500,'BE58'),
  ('Beechjet 400 (same as MU-300-10 Diamond II)',1003,'Jet',2,43.5,48.42,15780,'BE40'),
  ('Bonanza 33 (F33A)',1003,'Piston',1,33.5,26.67,3500,'BE33'),
  ('Bonanza 35 (G35)',1003,'Piston',1,32.83,25.17,3125,'BE35'),
  ('747-8F',1004,'Jet',4,224.42,250.17,987000,'B748'),
  ('747-SP',1004,'Jet',4,195.67,184.75,696000,'B74S'),
  ('757-300',1004,'Jet',2,124.83,178.58,270000,'B753'),
  ('767-200',1004,'Jet',2,156.08,159.17,315000,'B762'),
  ('767-200ER',1004,'Jet',2,156.08,159.17,395000,'B762'),
  ('Learjet 24',1005,'Jet',2,35.58,43.25,13000,'LJ24'),
  ('Learjet 24A',1005,'Jet',2,35.58,43.25,12499,'LJ24'),
  ('Challenger (BD-100-1A10) 350',1005,'Jet',2,69,68.75,40600,'CL30'),
  ('Challenger (CL-600-1A11) 600',1005,'Jet',2,64.33,68.42,36000,'CL60'),
  ('Challenger (CL-600-2A12) 601',1005,'Jet',2,64.33,68.42,42100,'CL60'),
  ('414A Chancellor',1006,'Piston',2,44.17,36.42,6750,'C414'),
  ('421C Golden Eagle',1006,'Piston',2,44.17,36.42,7450,'C421'),
  ('425 Corsair-Conquest I',1006,'Turboprop',2,44.17,35.83,8600,'C425'),
  ('441 Conquest II',1006,'Turboprop',2,49.33,39,9850,'C441'),
  ('Citation CJ1 (Model C525)',1006,'Jet',2,46.92,42.58,10600,'C525'),
  ('EMB 175 LR',1008,'Jet',2,85.33,103.92,85517,'E170'),
  ('EMB 175 Standard',1008,'Jet',2,85.33,103.92,82673,'E170'),
  ('EMB 175-E2',1008,'Jet',2,101.67,106,98767,'E170'),
  ('EMB 190 AR',1008,'Jet',2,94.25,118.92,114199,'E190'),
  ('EMB 190 LR',1008,'Jet',2,94.25,118.92,110892,'E190');
  
  -- The subquery in this example retrieves data from a second table, in this case, manufacturers:
  SELECT plane_id, plane
FROM airplanes
WHERE manufacturer_id = 
  (SELECT manufacturer_id FROM manufacturers 
    WHERE manufacturer = 'Beechcraft');
    
-- A subquery can also retrieve data from the same table, 
-- which can be useful if the data must be handled in different ways. 
-- For example, the subquery in the following SELECT statement retrieves the average max_weight value from the airplanes table:  
select * from airplanes where max_weight > (select avg(max_weight) from airplanes);

SET @avg_weight = 
  (SELECT ROUND(AVG(max_weight)) FROM airplanes);
SELECT plane_id, plane, max_weight
FROM airplanes WHERE max_weight > @avg_weight;

-- One of the most valuable features of a subquery is its ability to reference the outer query from within the subquery. 
-- Referred to as a correlated subquery, this type of subquery can return data that is specific to the current row being 
-- evaluated by the outer statement. 
-- Calculate the average weight of the planes for each manufacturer, rather than for all planes:
select manufacturer_id,ROUND(avg(max_weight)) from airplanes group by manufacturer_id; -- this gives a table

select manufacturers.manufacturer, derived_table_name_alias.* from (select manufacturer_id,ROUND(avg(max_weight)) from airplanes group by manufacturer_id) derived_table_name_alias,manufacturers
where derived_table_name_alias.manufacturer_id=manufacturers.manufacturer_id; -- This works ... check solution

select manufacturers.manufacturer,derived_table_name_alias.*
FROM manufacturers INNER JOIN (select manufacturer_id,ROUND(avg(max_weight)) from airplanes group by manufacturer_id) derived_table_name_alias
ON  derived_table_name_alias.manufacturer_id=manufacturers.manufacturer_id; 

-- ---------------------
-- a2 is an alias of a the derived table. Thge "AS" names to new column.
-- the reason the vag(max_weight) works only on the manufacturer_id is 
-- because it is limited by a.manufacturer_id = a2.manufacturer: 
SELECT manufacturer_id, plane_id, plane, max_weight,
  (SELECT ROUND(AVG(max_weight)) FROM airplanes a2
    WHERE a.manufacturer_id = a2.manufacturer_id) AS avg_weight
FROM airplanes a;

SELECT manufacturer_id, plane_id, plane, max_weight,
  (SELECT ROUND(AVG(max_weight)) FROM airplanes a2
    WHERE a.manufacturer_id = a2.manufacturer_id) AS avg_weight -- this is a generated column
FROM airplanes a
WHERE max_weight > 
(select ROUND(AVG(max_weight)) from airplanes a2 WHERE a.manufacturer_id = a2.manufacturer_id); 


SELECT manufacturer_id, plane_id, plane, max_weight,
  (SELECT ROUND(AVG(max_weight)) FROM airplanes a2
    WHERE a.manufacturer_id = a2.manufacturer_id) AS avg_weight,
  -- subtracts average weight from max weight
  (max_weight - (SELECT ROUND(AVG(max_weight)) FROM airplanes a2
    WHERE a.manufacturer_id = a2.manufacturer_id)) AS amt_over
FROM airplanes a
WHERE max_weight > 
  (SELECT ROUND(AVG(max_weight)) FROM airplanes a2
    WHERE a.manufacturer_id = a2.manufacturer_id);
    
    SELECT manufacturer_id, 
  (SELECT manufacturer FROM manufacturers m 
    WHERE a.manufacturer_id = m.manufacturer_id) MANUFACTURER,
  plane_id, plane, max_weight,
  (SELECT ROUND(AVG(max_weight)) FROM airplanes a2
    WHERE a.manufacturer_id = a2.manufacturer_id) AS avg_weight,
  (max_weight - (SELECT ROUND(AVG(max_weight)) FROM airplanes a2
    WHERE a.manufacturer_id = a2.manufacturer_id)) AS amt_over
FROM airplanes a
WHERE max_weight > 
  (SELECT ROUND(AVG(max_weight)) FROM airplanes a2
    WHERE a.manufacturer_id = a2.manufacturer_id);
  
  
  -- The subquery in this statement is similar to those you’ve seen in other examples, 
  -- except that now you’re dealing with aggregated data, so the subquery must use a column 
  -- that is mentioned in the GROUP BY clause of the outer statement, which it does (the manufacturer_id column).
    SELECT manufacturer_id, 
  (SELECT manufacturer FROM manufacturers m 
    WHERE a.manufacturer_id = m.manufacturer_id) manufacturer,
   COUNT(*) AS plane_amt
FROM airplanes a
WHERE engine_type = 'piston'
GROUP BY manufacturer_id;

-- -------------------
-- Notice that the WHERE clause in the outer statement includes the max_weight and 
-- parking_area columns in parentheses. 
-- In MySQL, this is how you create what is called a row constructor, 
-- a structure that supports simultaneous comparisons of multiple values. 
-- In this case, the row constructor is compared to the results from the subquery, 
-- which returns two corresponding values. The first value is the average weight, 
-- as you saw earlier. The second value returns the average parking area, 
-- which is based on the values in the parking_area column.

-- In both cases, the averages are specific to the current manufacturer_id value in the outer query. 
-- For the outer query to return a row, the two values in the row constructor must be greater than 
-- both corresponding values returned by the subquery. Notice also that the SELECT list now includes 
-- both the max_weight and parking_area columns, along with the average for each one.
SELECT 
  (SELECT manufacturer FROM manufacturers m 
    WHERE a.manufacturer_id = m.manufacturer_id) manufacturer,
	plane_id, plane, max_weight, parking_area,
  (SELECT ROUND(AVG(max_weight)) FROM airplanes a2
    WHERE a.manufacturer_id = a2.manufacturer_id) AS avg_weight,
  (SELECT ROUND(AVG(parking_area)) FROM airplanes a2
    WHERE a.manufacturer_id = a2.manufacturer_id) AS avg_area
FROM airplanes a
WHERE (max_weight, parking_area) > 
  (SELECT ROUND(AVG(max_weight)), ROUND(AVG(parking_area)) 
    FROM airplanes a2
    WHERE a.manufacturer_id = a2.manufacturer_id);

-- ---------------------------------
-- The column data returned by the subquery includes only those manufacturers 
-- that offer planes with piston engines (as reflected in the current data set). 
-- The IN operator determines whether the current manufacturer_id value is included 
-- in that list. If it is, that row is returned

SELECT DISTINCT manufacturer_id FROM airplanes
    WHERE engine_type = 'piston';
    
SELECT manufacturer_id, manufacturer 
FROM manufacturers;    

SELECT manufacturer_id, manufacturer 
FROM manufacturers
WHERE manufacturer_id IN 
  (SELECT DISTINCT manufacturer_id FROM airplanes
    WHERE engine_type = 'piston');

-- As with many operations in MySQL, you can take different approaches 
-- to achieve the same results. For example, you can replace the IN operator 
-- with an equal comparison operator, followed by the ANY keyword, as shown in the following example:
SELECT manufacturer_id, manufacturer 
FROM manufacturers
WHERE manufacturer_id = ANY 
  (SELECT DISTINCT manufacturer_id FROM airplanes
    WHERE engine_type = 'piston');
    
-- Or use INNER JOIN:
SELECT DISTINCT m.manufacturer_id, m.manufacturer
FROM manufacturers m INNER JOIN airplanes a
  ON m.manufacturer_id = a.manufacturer_id
WHERE a.engine_type = 'piston';

-- you can also use the NOT keyword with some operators to return different results. 
-- For example, the WHERE clause in the following SELECT statement uses the NOT IN operator 
-- ensure the current manufacturer_id value is not in the list of values returned by the subquery.
-- Be very careful when using NOT IN with your subqueries. 
-- If the subquery returns a NULL value, your WHERE expression will never evaluate to true.

SELECT manufacturer_id, manufacturer 
FROM manufacturers
WHERE manufacturer_id NOT IN 
  (SELECT DISTINCT manufacturer_id FROM airplanes);
  
  -- EXISTS
  SELECT manufacturer_id, manufacturer 
FROM manufacturers m
WHERE EXISTS
  (SELECT * FROM airplanes A
    WHERE a.manufacturer_id = m.manufacturer_id);
    
-- DERIVED TABLES
-- Notice that the outer statement does not specify a table other than the derived table returned by the subquery. The subquery itself groups the data in the airplanes table by the manufacturer_id values and then returns the ID and total number of planes in each group. The outer statement then finds the average number of planes across all groups. In this case, the statement returns a value of 5.00.
 SELECT ROUND(AVG(amount), 2) avg_amt
FROM 
  (SELECT manufacturer_id, COUNT(*) AS amount 
  FROM airplanes
  GROUP BY manufacturer_id) AS total_planes;
  
  
  -- outer SELECT calculates average count across all categories
  -- he innermost subquery—the one with the CASE expression—assigns 
  -- one of five category values (A, B, C, D, E, and F) to each range of parking area values. 
  -- The subquery returns a derived table named plane_size, which contains a single column named category. 
  -- The column contains a category value for each plane in the airplanes table.
-- The data from the plane_size table is then passed to the outer subquery. 
-- This subquery groups the plane_size data based on the category values and generates a second column named amount, 
-- which provides the total number of planes in each category. 
-- The outer subquery returns a derived table named plane_cnt. 
-- The outer statement then finds the average number of planes across all groups in the derived table, returning a value of 5.83.

SELECT
  ROUND(AVG(amount), 2) AS avg_amt
FROM
  -- outer subquery aggregates categories and calculates count for each one
  (SELECT category, COUNT(*) amount 
  FROM 
    -- inner subquery categorizes planes based on parking area
    (SELECT CASE
      WHEN parking_area > 50000 THEN 'A'
      WHEN parking_area >= 20000 THEN 'B'
      WHEN parking_area >= 10000 THEN 'C'
      WHEN parking_area >= 5000 THEN 'D'
      WHEN parking_area >= 1000 THEN 'E'
      ELSE 'F'
    END AS category
    FROM airplanes) AS plane_size
  GROUP BY category
  ORDER BY category) AS plane_cnt;


