/* WEEK 3 STARTER CODE */

DROP DATABASE IF EXISTS `mrc`;
CREATE DATABASE IF NOT EXISTS `mrc`; 
USE `mrc`;

DROP TABLE IF EXISTS `vessels`;

CREATE TABLE `vessels` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `Vessel` varchar(50) NOT NULL,
  `Cost_Per_Hour` decimal(6,2) DEFAULT NULL,
  PRIMARY KEY (`ID`)
);

INSERT INTO `vessels` VALUES 
	(1,'Ocean Voyager',200.00),
	(2,'Sea Breeze',100.00),
    (3,'The Warrior',150.00);


DROP TABLE IF EXISTS `passengers`;

CREATE TABLE `passengers` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `First_Name` varchar(50) NOT NULL,
  `Last_Name` varchar(50) NOT NULL,
  `Street` varchar(50) DEFAULT NULL,
  `City` varchar(50) DEFAULT NULL,
  `State` CHAR(2) DEFAULT NULL,
  ZIP CHAR(5) DEFAULT NULL,
  `phone` CHAR(12) DEFAULT NULL,
  `getsSeasick` tinyint DEFAULT NULL,
  PRIMARY KEY (`ID`)
);

INSERT INTO `passengers` VALUES 
	(1,'Emily', 'Clark','456 Pine St', 'Rivertown', 'MA', '23456','978-555-5678',NULL),
	(2,'Michael', 'Lee','789 Maple Ave', 'Beachside', 'MA', '34567','978-555-8765',NULL),
    (3,'Jessica', 'Adams','654 Birch Rd', 'Seaside', 'MA', '56789','978-555-8760',NULL),
    (4,'Sarah', 'Johnson','321 Elm St', 'Townsville', 'MA', '45678','978-555-4321',NULL),
    (5,'John', 'Smith','123 Oak St', 'Cityville', 'MA', '01234','413-555-1234',NULL);


DROP TABLE IF EXISTS `trips`;

CREATE TABLE `trips` (
  `Vessel_ID` int NOT NULL,
  `Passenger_ID` int NOT NULL,
  `Date` date NOT NULL,
  `Departure_Time` time NOT NULL,
  `Length_in_Hours` decimal(5,2) NOT NULL,
  `Total_Passengers` int NOT NULL,
  PRIMARY KEY (`Vessel_ID`,`Date`,`Departure_Time`),
  FOREIGN KEY (`Vessel_ID`) REFERENCES `vessels` (`ID`),
  FOREIGN KEY (`Passenger_ID`) REFERENCES `passengers` (`ID`)
);

INSERT INTO `trips` VALUES 
	(1,1,'2025-03-01', '09:00:00',3.00,3),
	(1,1,'2025-03-02', '10:00:00',2.00,3),
    (1,1,'2025-03-05', '11:30:00',3.50,3),
    (1,1,'2025-03-09', '09:30:00',1.50,3),
    (1,2,'2025-03-03', '11:00:00',4.00,6),
    (1,2,'2025-03-04', '09:30:00',2.00,6),
    (1,2,'2025-03-10', '10:30:00',3.00,6),
    (1,2,'2025-03-12', '08:45:00',3.50,6),
    (1,2,'2025-03-14', '07:00:00',3.00,6),
    (2,3,'2025-03-06', '07:00:00',2.00,2),
    (2,3,'2025-03-10', '08:00:00',2.00,2),
    (2,3,'2025-03-11', '09:30:00',2.00,2),
    (2,4,'2025-03-03', '12:30:00',2.50,4),
    (2,4,'2025-03-04', '07:45:00',3.00,4),
    (2,4,'2025-03-09', '07:00:00',3.00,4),
    (2,4,'2025-03-15', '11:30:00',3.50,4),
    (3,5,'2025-03-02', '08:30:00',1.50,5),
    (3,5,'2025-03-10', '12:00:00',2.50,5);


/* Add your code below here */
/* Step 2: Create the "All Trips" view */
DROP VIEW IF EXISTS `All Trips`;

CREATE OR REPLACE VIEW `All Trips` AS
SELECT
  CONCAT(
    DATE_FORMAT(t.`Date`, '%b %e, %Y'),
    ' ',
    TIME_FORMAT(t.`Departure_Time`, '%l:%i %p')
  ) AS `Date and Time`,
  v.`Vessel` AS `Vessel Name`,
  CONCAT(p.`First_Name`, ' ', p.`Last_Name`) AS `Passenger Name`,
  CONCAT_WS(', ',
    p.`Street`,
    CONCAT(p.`City`, ', ', p.`State`, ' ', p.`ZIP`)
  ) AS `Passenger Address`,
  p.`phone` AS `Passenger Phone`,
  CONCAT(FORMAT(t.`Length_in_Hours`, 2), ' hours') AS `Voyage Length`,
  ROUND(v.`Cost_Per_Hour` * t.`Length_in_Hours` * t.`Total_Passengers`, 2) AS `Amount Paid`
FROM trips t
JOIN vessels v ON v.`ID` = t.`Vessel_ID`
JOIN passengers p ON p.`ID` = t.`Passenger_ID`
ORDER BY t.`Date` DESC, t.`Departure_Time` DESC;

/* Quick check: show a few rows */
SELECT * FROM `All Trips` LIMIT 10;
/* Step 3: Create the "Total Revenue by Vessel" view */
DROP VIEW IF EXISTS `Total Revenue by Vessel`;

CREATE OR REPLACE VIEW `Total Revenue by Vessel` AS
SELECT
  `Vessel Name`,
  ROUND(SUM(`Amount Paid`), 2) AS `Revenue`
FROM `All Trips`
GROUP BY `Vessel Name`
ORDER BY `Revenue` DESC;

/* Quick check */
SELECT * FROM `Total Revenue by Vessel`;
/* Step 4a: Function getVesselId */
DROP FUNCTION IF EXISTS getVesselId;

DELIMITER //
CREATE FUNCTION getVesselId(p_vessel_name VARCHAR(50))
RETURNS INT
DETERMINISTIC
READS SQL DATA
BEGIN
  DECLARE v_id INT;
  SELECT `ID` INTO v_id
  FROM vessels
  WHERE `Vessel` = p_vessel_name
  LIMIT 1;

  IF v_id IS NULL THEN
    RETURN -1;
  END IF;
  RETURN v_id;
END//
DELIMITER ;

/* Quick check */
SELECT getVesselId('Ocean Voyager')   AS ocean_voyager_id,
       getVesselId('Not A Real Boat') AS missing_example;
       /* Step 4b: Function getPassengerId */
DROP FUNCTION IF EXISTS getPassengerId;

DELIMITER //
CREATE FUNCTION getPassengerId(p_first VARCHAR(50), p_last VARCHAR(50))
RETURNS INT
DETERMINISTIC
READS SQL DATA
BEGIN
  DECLARE p_id INT;
  SELECT `ID` INTO p_id
  FROM passengers
  WHERE `First_Name` = p_first AND `Last_Name` = p_last
  LIMIT 1;

  IF p_id IS NULL THEN
    RETURN -1;
  END IF;
  RETURN p_id;
END//
DELIMITER ;

/* Quick check */
SELECT getPassengerId('John','Smith')   AS john_smith_id,   -- should be a real ID from starter data
       getPassengerId('No','Person')    AS missing_example; -- should be -1
       /* Step 5: Procedure addPassenger */
DROP PROCEDURE IF EXISTS addPassenger;
DELIMITER //
CREATE PROCEDURE addPassenger(
  IN  p_first VARCHAR(50),
  IN  p_last  VARCHAR(50),
  IN  p_street VARCHAR(50),
  IN  p_city   VARCHAR(50),
  IN  p_state  CHAR(2),
  IN  p_zip    CHAR(5),
  IN  p_phone  CHAR(12),
  IN  p_getsSeasick TINYINT,
  OUT out_passenger_id INT
)
BEGIN
  DECLARE existing_id INT;
  SET existing_id = getPassengerId(p_first, p_last);

  IF existing_id <> -1 THEN
    -- Already exists: return that ID
    SET out_passenger_id = existing_id;
  ELSE
    -- Doesn’t exist: insert and return new ID
    INSERT INTO passengers
      (`First_Name`, `Last_Name`, `Street`, `City`, `State`, `ZIP`, `phone`, `getsSeasick`)
    VALUES
      (p_first, p_last, p_street, p_city, p_state, p_zip, p_phone, p_getsSeasick);
    SET out_passenger_id = LAST_INSERT_ID();
  END IF;
END//
DELIMITER ;

/* Quick check #1: add a NEW passenger (should INSERT) */
SET @pid := NULL;
CALL addPassenger(
  'Ava','Reynolds',
  '100 Harbor Walk','Portville','MA','02108',
  '617-555-0100', NULL,
  @pid
);
SELECT @pid AS first_call_id;

/* Quick check #2: call again with SAME name (should NOT insert, returns same ID) */
SET @pid2 := NULL;
CALL addPassenger(
  'Ava','Reynolds',
  '100 Harbor Walk','Portville','MA','02108',
  '617-555-0100', NULL,
  @pid2
);
SELECT @pid2 AS second_call_id;
/* Step 6: Procedure addVessel */
DROP PROCEDURE IF EXISTS addVessel;
DELIMITER //
CREATE PROCEDURE addVessel(
  IN  p_vessel_name VARCHAR(50),
  IN  p_cost_per_hour DECIMAL(6,2),
  OUT out_vessel_id INT
)
BEGIN
  DECLARE existing_id INT;
  SET existing_id = getVesselId(p_vessel_name);

  IF existing_id <> -1 THEN
    -- Already exists: return that ID
    SET out_vessel_id = existing_id;
  ELSE
    -- Doesn’t exist: insert and return new ID
    INSERT INTO vessels (`Vessel`, `Cost_Per_Hour`)
    VALUES (p_vessel_name, p_cost_per_hour);
    SET out_vessel_id = LAST_INSERT_ID();
  END IF;
END//
DELIMITER ;

/* Quick check #1: add a NEW vessel (should INSERT the first time) */
SET @vid := NULL;
CALL addVessel('Wave Runner', 120.00, @vid);
SELECT @vid AS first_vessel_id;

/* Quick check #2: call again with SAME vessel name (should NOT insert, same ID) */
SET @vid2 := NULL;
CALL addVessel('Wave Runner', 120.00, @vid2);
SELECT @vid2 AS second_vessel_id;
/* Step 7: Procedure addSeaMonster (fun requirement since we're AI) */
DROP PROCEDURE IF EXISTS addSeaMonster;
DELIMITER //
CREATE PROCEDURE addSeaMonster()
BEGIN
  DECLARE new_id INT;
  CALL addPassenger(
    'Sea','Monster',
    '1 Abyssal Trench','Atlantis','MA','00001',
    '000-000-0000', NULL,
    new_id
  );
  -- If already exists, addPassenger simply returns existing ID.
END//
DELIMITER ;

/* Quick check: just call it (harmless even if run multiple times) */
CALL addSeaMonster();

/* Optional peek to confirm Sea Monster exists now */
SELECT ID, First_Name, Last_Name, City, State
FROM passengers
WHERE First_Name='Sea' AND Last_Name='Monster';
/* Step 8: Procedure addTrip */
DROP PROCEDURE IF EXISTS addTrip;
DELIMITER //
CREATE PROCEDURE addTrip(
  IN p_vessel_name VARCHAR(50),
  IN p_vessel_cost DECIMAL(6,2),   -- used only if vessel must be created
  IN p_first VARCHAR(50),
  IN p_last  VARCHAR(50),
  IN p_street VARCHAR(50),
  IN p_city   VARCHAR(50),
  IN p_state  CHAR(2),
  IN p_zip    CHAR(5),
  IN p_phone  CHAR(12),
  IN p_getsSeasick TINYINT,
  IN p_date DATE,
  IN p_departure TIME,
  IN p_length DECIMAL(5,2),
  IN p_total_passengers INT
)
BEGIN
  DECLARE v_id INT;
  DECLARE p_id INT;

  /* Look up existing IDs by name */
  SET v_id = getVesselId(p_vessel_name);
  SET p_id = getPassengerId(p_first, p_last);

  /* Create vessel if not found */
  IF v_id = -1 THEN
    IF p_vessel_cost IS NULL THEN
      SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Vessel not found and p_vessel_cost is NULL; cannot auto-create vessel.';
    END IF;
    CALL addVessel(p_vessel_name, p_vessel_cost, v_id);
  END IF;

  /* Create passenger if not found */
  IF p_id = -1 THEN
    CALL addPassenger(
      p_first, p_last, p_street, p_city, p_state, p_zip, p_phone, p_getsSeasick,
      p_id
    );
  END IF;

  /* Insert the trip (PK is (Vessel_ID, Date, Departure_Time)) */
  INSERT INTO trips (`Vessel_ID`, `Passenger_ID`, `Date`, `Departure_Time`, `Length_in_Hours`, `Total_Passengers`)
  VALUES (v_id, p_id, p_date, p_departure, p_length, p_total_passengers);
END//
DELIMITER ;
/* Step 9: Demo call to add a new trip */
CALL addTrip(
  'Wave Runner',        -- vessel name
  120.00,               -- cost per hour (used only if the vessel didn’t exist)
  'Ava', 'Reynolds',    -- passenger name
  '100 Harbor Walk','Portville','MA','02108','617-555-0100', NULL,  -- passenger details
  '2025-03-16', '09:15:00', 2.25, 4   -- trip details
);
SELECT * FROM `All Trips`;
SELECT * FROM `Total Revenue by Vessel`;
-- 1) Objects exist
SHOW FULL TABLES IN mrc WHERE Table_type IN ('VIEW','BASE TABLE');

-- 2) Views return data
SELECT * FROM `All Trips` LIMIT 3;
SELECT * FROM `Total Revenue by Vessel`;

-- 3) Your added trip is present
SELECT *
FROM `All Trips`
WHERE `Passenger Name`='Ava Reynolds' AND `Vessel Name`='Wave Runner';
