/* WEEK 4 & 5 STARTER CODE */

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
  FOREIGN KEY (`Vessel_ID`) REFERENCES `vessels` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (`Passenger_ID`) REFERENCES `passengers` (`ID`) ON DELETE CASCADE ON UPDATE CASCADE
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

SET SQL_SAFE_UPDATES = 0;

/* Views */

CREATE VIEW `all trips` AS
	SELECT 
    concat(DATE_FORMAT(t.date,'%m/%d/%Y'), ' @ ', TIME_FORMAT(t.Departure_Time,'%h:%i %p')) AS `Date and Time`,
    v.Vessel as `Vessel Name`,
    concat(p.first_name, ' ', p.last_name) AS `Passenger Name`,
    concat(p.street, ', ', p.city, ', ', p.state, ' ', p.ZIP) AS `Passenger Address`,
    p.Phone AS `Passenger Phone`,
    t.Length_in_hours AS `Trip Duration`,
    CONCAT('$',FORMAT(t.Length_in_hours * v.Cost_Per_Hour,2)) AS `Total Cost`
    FROM trips t
    LEFT JOIN vessels v on v.ID = t.Vessel_ID
    LEFT JOIN passengers p on p.ID = t.Passenger_ID
    ORDER BY t.date DESC, t.departure_time DESC;
    
-- SELECT * FROM `all trips`;

CREATE VIEW `total revenue By vessel` AS
SELECT `Vessel Name`,
		CONCAT('$',FORMAT(SUM(CAST(SUBSTRING(`Total Cost`,2) AS DECIMAL(10,2))),2)) AS Revenue
FROM `all trips`
GROUP BY `Vessel Name`;

-- SELECT * FROM `total revenue by vessel`;

/* Functions */

DROP FUNCTION IF EXISTS getVesselID;    
Delimiter $$

CREATE FUNCTION getVesselID(myVesselName VARCHAR(50))
RETURNS INT DETERMINISTIC
BEGIN
	DECLARE foundVesselID INT;
    SELECT ID INTO foundVesselID 
    FROM Vessels
    WHERE Vessel = myVesselName;
	
    IF foundVesselID is null
    THEN SET foundVesselID = -1;
    END IF;

    RETURN foundVesselID;
END$$

Delimiter ; 


DROP FUNCTION IF EXISTS getPassengerID;    
Delimiter $$

CREATE FUNCTION getPassengerID(myPassengerFName VARCHAR(50), myPassengerLName VARCHAR(50))
RETURNS INT DETERMINISTIC
BEGIN
	DECLARE foundPassengerID INT;
    SELECT ID INTO foundPassengerID 
    FROM Passengers
    WHERE First_Name = myPassengerFName
    AND Last_Name = myPassengerLName;
	
    IF foundPassengerID is null
    THEN SET foundPassengerID = -1;
    END IF;

    RETURN foundPassengerID;
END$$

Delimiter ;

-- SELECT getVesselID('Sea Breeze');
-- SELECT getVesselID('Sea Bream');

-- SELECT getPassengerID('John', 'Smith');
-- SELECT getPassengerID('Jim', 'Smith');

/* Procedures */
	
    /* Gets */

DROP PROCEDURE IF EXISTS getPassengerList;
DROP PROCEDURE IF EXISTS getVesselList;
DROP PROCEDURE IF EXISTS getTripList;


DELIMITER $$

CREATE PROCEDURE getPassengerList()
BEGIN
	SELECT * FROM passengers;
END$$

CREATE PROCEDURE getVesselList()
BEGIN
	SELECT * FROM vessels;
END$$

CREATE PROCEDURE getTripList()
BEGIN
	SELECT * FROM `All Trips`;
END$$

Delimiter ;

-- CALL getPassengerList();
-- CALL getVesselList();
-- CALL getTripList();
	
    /* Additions */

DROP PROCEDURE IF EXISTS addPassenger;

DELIMITER $$

CREATE PROCEDURE addPassenger(IN passFName VARCHAR(50), passLName VARCHAR(50), passPhone VARCHAR(50))

BEGIN
	DECLARE foundPassengerID INT;
    
	SELECT getPassengerID(passFName, passLName) INTO foundPassengerID;
    
    IF foundPassengerID = -1
    THEN INSERT INTO Passengers (First_Name, Last_name, phone)
    VALUES (passFName, passLName, passPhone);
    END IF;
    
    SELECT getPassengerID(passFName, passLName) AS PassengerID;
    
END$$

DELIMITER ;


DROP PROCEDURE IF EXISTS addVessel;

DELIMITER $$

CREATE PROCEDURE addVessel(IN myVesselName VARCHAR(50), myVesselCPH DECIMAL(6,2))

BEGIN
	DECLARE foundVesselID INT;
    
	SELECT getVesselID(myVesselName) INTO foundVesselID;
    
    IF foundVesselID = -1
    THEN INSERT INTO Vessels (vessel, Cost_Per_Hour)
    VALUES (myVesselName, myVesselCPH);
    END IF;
    
    SELECT getVesselID(myVesselName) AS VesselID;
    
END$$

DELIMITER ;


DROP PROCEDURE IF EXISTS addTrip;

DELIMITER $$

CREATE PROCEDURE addTrip(myVesselName VARCHAR(50), myPassengerFName VARCHAR(50), myPassengerLName VARCHAR(50), myDate DATE, myTime TIME,
						 myLengthofTrip decimal(5,2), myTotalPassengers INT)

BEGIN
	DECLARE foundVesselID INT;
    DECLARE foundPassengerID INT;
    DECLARE missingData INT;
    DECLARE duplicate INT;
        
	SELECT GETVESSELID(myVesselName) INTO foundVesselID;
	SELECT GETPASSENGERID(myPassengerFName, myPassengerLName) INTO foundPassengerID;
    
	SELECT count(*)
    FROM trips
    WHERE Vessel_ID = foundVesselID
    AND Passenger_ID = foundPassengerID
    AND Date = myDate
    AND Departure_Time = myTime
    INTO duplicate;
    
    IF duplicate > 0
		THEN SELECT 0 as DuplicateTrip;
    ELSEIF foundVesselID = -1 AND foundPassengerID = -1
		THEN SELECT -3 AS NotFound;
    ELSEIF foundPassengerID = -1
		THEN SELECT -2 AS NotFound;
    ELSEIF foundVesselID = -1
		THEN SELECT -1 AS NotFound;
    ELSE INSERT INTO trips
		VALUES(foundVesselID, foundPassengerID, myDate, myTime, myLengthofTrip, myTotalPassengers);
	END IF;
    
END;$$

DELIMITER ;


-- CALL addPassenger('John','Smith', '123-456-1900');
-- CALL addPassenger('Jim','Smith', '123-456-1900');
-- SELECT * FROM Passengers;

-- CALL addVessel('Sea Breeze', 100);
-- CALL addVessel('Sea Bream', 250);
-- SELECT * FROM Vessels;

-- CALL addTrip('Sea Breeze', 'John', 'Smith', '2025-06-30', '12:00:00', 3, 5);
-- CALL addTrip('Sea Bread', 'John', 'Smith', '2025-06-30', '12:00:00', 3, 5);
-- CALL addTrip('Sea Breeze', 'Jen', 'Smith', '2025-06-30', '12:00:00', 3, 5);

	/* Deletions */ 
    
DROP PROCEDURE IF EXISTS deletePassenger;

DELIMITER $$

CREATE PROCEDURE deletePassenger(IN passID INT)

BEGIN
	DECLARE foundPassengerID INT;
    
    SELECT count(ID) FROM Passengers WHERE ID = passID INTO foundPassengerID;
    
    IF foundPassengerID > 0
    THEN DELETE FROM Passengers WHERE ID = passID;
    ELSE SELECT -1 AS NotFound;
    END IF;
    
    
END$$

DELIMITER ;

-- CALL deletePassenger(1);
-- SELECT * FROM Passengers;


DROP PROCEDURE IF EXISTS deleteVessel;

DELIMITER $$

CREATE PROCEDURE deleteVessel(IN vesselID INT)

BEGIN
	DECLARE foundVesselID INT;
    
    SELECT count(ID) FROM Vessels WHERE ID = vesselID INTO foundVesselID;
    
    IF foundVesselID > 0
    THEN DELETE FROM Vessels WHERE ID = vesselID;
    ELSE SELECT -1 AS NotFound;
    END IF;
    
    
END$$

DELIMITER ;

-- CALL deleteVessel(1);
-- SELECT * FROM Vessels;
-- CALL getTripList();
