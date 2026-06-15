/* STARTER CODE WEEK 2 */

DROP DATABASE IF EXISTS MRC;
CREATE DATABASE MRC;
USE MRC;

CREATE TABLE Reservations 
	(Date DATE, 
	Departure_Time TIME, 
    Length_in_Hours DeCiMaL(4,2), 
    Vessel VARCHAR(50), 
    First_Name VARCHAR(50), 
    Last_Name VARCHAR(50), 
    Street VARCHAR(50), 
    City VARCHAR(50), 
    State CHAR(2), 
	Zip CHAR(5), 
    Phone CHAR(12), 
    Total_Passengers INT, 
    Total_Cost VARCHAR(50));

INSERT INTO Reservations
	(Date,Departure_Time,Length_in_Hours,Vessel,First_Name,Last_Name,Street,City,State,ZIP,Phone,Total_Passengers,Total_Cost)
	VALUES ('2025-03-01','8:00','2','Sea Breeze','John','Smith','123 Oak St','Cityville','MA','01234','413-555-1234','5',200.00),
('2025-03-01','9:00','3','Ocean Voyager','Emily','Clark','456 Pine St','Rivertown','MA','23456','978-555-5678','3',600.00),
('2025-03-01','8:30','1.5','The Warrior','John','Smith','123 Oak St','Cityville','MA','01234','413-555-1234','5',225.00),
('2025-03-02','8:30','1.5','The Warrior','John','Smith','123 Oak St','Cityville','MA','01234','413-555-1234','5',225.00),
('2025-03-02','10:00','2','Ocean Voyager','Emily','Clark','456 Pine St','Rivertown','MA','23456','978-555-5678','3',400.00),
('2025-03-03','11:00','4','Ocean Voyager','Michael','Lee','789 Maple Ave','Beachside','MA','34567','978-555-8765','6',800.00),
('2025-03-03','12:30','2.5','Sea Breeze','Sarah','Johnson','321 Elm St','Townsville','MA','45678','978-555-4321','4',250.00),
('2025-03-04','7:45','3','Sea Breeze','Sarah','Johnson','321 Elm St','Townsville','MA','45678','978-555-4321','4',300.00),
('2025-03-04','9:30','2','Ocean Voyager','Michael','Lee','789 Maple Ave','Beachside','MA','34567','978-555-8765','6',400.00),
('2025-03-05','8:15','1','Sea Breeze','John','Smith','123 Oak St','Cityville','MA','01234','413-555-1234','5',100.00),
('2025-03-05','11:30','3.5','Ocean Voyager','Emily','Clark','456 Pine St','Rivertown','MA','23456','978-555-5678','3',700.00),
('2025-03-06','7:00','2','Sea Breeze','Jessica','Adams','654 Birch Rd','Seaside','MA','56789','978-555-8760','2',200.00),
('2025-03-06','9:15','3','Ocean Voyager','William','Hall','789 Cedar St','Hilltop','MA','67890','978-555-9999','7',600.00),
('2025-03-06','10:00','1.5','The Warrior','Jessica','Adams','654 Birch Rd','Seaside','MA','56789','978-555-8760','2',225.00),
('2025-03-07','8:45','2','Ocean Voyager','Sarah','Johnson','321 Elm St','Townsville','MA','45678','978-555-4321','4',400.00),
('2025-03-07','11:00','3.5','Sea Breeze','Emily','Clark','456 Pine St','Rivertown','MA','23456','978-555-5678','3',350.00),
('2025-03-08','8:30','4','Ocean Voyager','John','Smith','123 Oak St','Cityville','MA','01234','413-555-1234','5',800.00),
('2025-03-08','9:30','2','Sea Breeze','Michael','Lee','789 Maple Ave','Beachside','MA','34567','978-555-8765','6',200.00),
('2025-03-08','12:00','2.5','The Warrior','William','Hall','789 Cedar St','Hilltop','MA','67890','978-555-9999','7',375.00),
('2025-03-09','7:00','3','Sea Breeze','Sarah','Johnson','321 Elm St','Townsville','MA','45678','978-555-4321','4',300.00),
('2025-03-09','9:30','1.5','Ocean Voyager','Emily','Clark','456 Pine St','Rivertown','MA','23456','978-555-5678','3',300.00),
('2025-03-10','8:00','2','Sea Breeze','Jessica','Adams','654 Birch Rd','Seaside','MA','56789','978-555-8760','2',200.00),
('2025-03-10','10:30','3','Ocean Voyager','Michael','Lee','789 Maple Ave','Beachside','MA','34567','978-555-8765','6',600.00),
('2025-03-10','12:00','2.5','The Warrior','John','Smith','123 Oak St','Cityville','MA','01234','413-555-1234','5',375.00),
('2025-03-11','7:15','1.5','Ocean Voyager','Sarah','Johnson','321 Elm St','Townsville','MA','45678','978-555-4321','4',300.00),
('2025-03-11','9:30','2','Sea Breeze','Jessica','Adams','654 Birch Rd','Seaside','MA','56789','978-555-8760','2',200.00),
('2025-03-12','8:45','3.5','Ocean Voyager','Michael','Lee','789 Maple Ave','Beachside','MA','34567','978-555-8765','6',700.00),
('2025-03-12','10:00','2','Sea Breeze','William','Hall','789 Cedar St','Hilltop','MA','67890','978-555-9999','7',200.00),
('2025-03-13','8:30','2','Sea Breeze','Emily','Clark','456 Pine St','Rivertown','MA','23456','978-555-5678','3',200.00),
('2025-03-13','9:15','3','Ocean Voyager','John','Smith','123 Oak St','Cityville','MA','01234','413-555-1234','5',600.00),
('2025-03-13','12:00','1.5','The Warrior','Sarah','Johnson','321 Elm St','Townsville','MA','45678','978-555-4321','4',225.00),
('2025-03-14','7:00','3','Ocean Voyager','Michael','Lee','789 Maple Ave','Beachside','MA','34567','978-555-8765','6',600.00),
('2025-03-14','9:30','2.5','Sea Breeze','Emily','Clark','456 Pine St','Rivertown','MA','23456','978-555-5678','3',250.00 ),
('2025-03-15','8:15','1','Ocean Voyager','Jessica','Adams','654 Birch Rd','Seaside','MA','56789','978-555-8760','2',200.00 ),
('2025-03-15','11:30','3.5','Sea Breeze','Sarah','Johnson','321 Elm St','Townsville','MA','45678','978-555-4321','4',350.00),
('2025-03-16','8:00','2','Ocean Voyager','William','Hall','789 Cedar St','Hilltop','MA','67890','978-555-9999','7',400.00);

SELECT * FROM Reservations ORDER BY Date, Departure_Time ASC;

/* YOUR CODE BELOW HERE */
/* STEP 0 — RESET JUST OUR TABLES */
DROP TABLE IF EXISTS Trips;
DROP TABLE IF EXISTS Vessels;
DROP TABLE IF EXISTS Passengers;
DROP TABLE IF EXISTS Famous_Sea_Creatures;
/* STEP 1 — CREATE TABLES (do NOT touch Reservations) */

-- Passengers: one row per person
CREATE TABLE IF NOT EXISTS Passengers (
    PassengerID  INT AUTO_INCREMENT PRIMARY KEY,
    First_Name   VARCHAR(50) NOT NULL,
    Last_Name    VARCHAR(50) NOT NULL,
    Street       VARCHAR(50) NOT NULL,
    City         VARCHAR(50) NOT NULL,
    State        CHAR(2)     NOT NULL,
    Zip          CHAR(5)     NOT NULL,
    Phone        CHAR(12)    NOT NULL,
    CONSTRAINT uq_passenger_natural
      UNIQUE (First_Name, Last_Name, Street, City, State, Zip, Phone)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Vessels: boat info (Cost_Per_Hour will be computed later)
CREATE TABLE IF NOT EXISTS Vessels (
    VesselID       INT AUTO_INCREMENT PRIMARY KEY,
    Vessel         VARCHAR(50) NOT NULL,
    Cost_Per_Hour  DECIMAL(10,2) NULL,
    CONSTRAINT uq_vessel UNIQUE (Vessel)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Trips: NO integer id; composite primary key
CREATE TABLE IF NOT EXISTS Trips (
    Date                DATE         NOT NULL,
    Departure_Time      TIME         NOT NULL,
    VesselID            INT          NOT NULL,
    PassengerID         INT          NOT NULL,
    Phone               CHAR(12)     NOT NULL,
    Length_in_Hours     DECIMAL(4,2) NOT NULL,
    Total_Passengers    INT          NOT NULL,

    /* ==== KEY EXPLANATION (for your rubric) ====
       Attributes: {Date, Departure_Time, VesselID, PassengerID, Phone, Length_in_Hours, Total_Passengers}
       a) Superkeys: any superset of a candidate key.
          With two 4-attr candidate keys below on a 7-attr set:
         supersets(K1)=2^(7-4)=8, supersets(K2)=8, overlap=2^(7-5)=4 → total=12 superkeys.
       b) Two candidate keys:
          K1 (chosen PK): {Date, Departure_Time, VesselID, PassengerID}
          K2 (alternate):  {Date, Departure_Time, VesselID, Phone}
       c) Chosen PK & why: K1 uses stable IDs (PassengerID, VesselID) + schedule;
          phones can change, IDs don't.
    */
    CONSTRAINT pk_trips PRIMARY KEY (Date, Departure_Time, VesselID, PassengerID),
    CONSTRAINT uq_trips_alt UNIQUE (Date, Departure_Time, VesselID, Phone),

    CONSTRAINT fk_trips_vessel FOREIGN KEY (VesselID)
      REFERENCES Vessels(VesselID),
    CONSTRAINT fk_trips_pass FOREIGN KEY (PassengerID)
      REFERENCES Passengers(PassengerID)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Because we’re AI: Famous Sea Creatures
CREATE TABLE IF NOT EXISTS Famous_Sea_Creatures (
    CreatureID INT AUTO_INCREMENT PRIMARY KEY,
    Name       VARCHAR(50) NOT NULL,
    Fun_Fact   VARCHAR(255)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO Famous_Sea_Creatures (Name, Fun_Fact)
VALUES ('Dory','Just keep swimming!'),
       ('Nemo','Clownfish with big adventures.'),
       ('Moby Dick','A very famous white whale.');
SHOW TABLES;
SELECT * FROM Famous_Sea_Creatures;
/* STEP 2 — FILL PASSENGERS */
INSERT INTO Passengers (First_Name, Last_Name, Street, City, State, Zip, Phone)
SELECT DISTINCT
       r.First_Name, r.Last_Name, r.Street, r.City, r.State, r.Zip, r.Phone
FROM Reservations r;
SELECT COUNT(*) AS passengers_cnt FROM Passengers;
SELECT * FROM Passengers ORDER BY Last_Name, First_Name LIMIT 10;
/* STEP 3 — FILL VESSELS (names) */
INSERT INTO Vessels (Vessel)
SELECT DISTINCT r.Vessel
FROM Reservations r;
SELECT * FROM Vessels ORDER BY Vessel;

/* STEP 4 — COMPUTE COST_PER_HOUR */
SET SQL_SAFE_UPDATES = 0;
UPDATE Vessels v
JOIN (
    SELECT
        r.Vessel,
        (SUM(CAST(r.Total_Cost AS DECIMAL(10,2))) / NULLIF(SUM(r.Length_in_Hours),0)) AS cph
    FROM Reservations r
    GROUP BY r.Vessel
) x ON x.Vessel = v.Vessel
SET v.Cost_Per_Hour = x.cph;
SELECT Vessel, Cost_Per_Hour FROM Vessels ORDER BY Vessel;
SET SQL_SAFE_UPDATES = 1;
/* STEP 5 — FILL TRIPS */
INSERT INTO Trips (Date, Departure_Time, VesselID, PassengerID, Phone, Length_in_Hours, Total_Passengers)
SELECT
    r.Date,
    r.Departure_Time,
    v.VesselID,
    p.PassengerID,
    p.Phone,
    r.Length_in_Hours,
    r.Total_Passengers
FROM Reservations r
JOIN Passengers p
  ON p.First_Name = r.First_Name
 AND p.Last_Name  = r.Last_Name
 AND p.Street     = r.Street
 AND p.City       = r.City
 AND p.State      = r.State
 AND p.Zip        = r.Zip
 AND p.Phone      = r.Phone
JOIN Vessels v
  ON v.Vessel = r.Vessel;
  SELECT COUNT(*) AS reservations_cnt FROM Reservations;
SELECT COUNT(*) AS trips_cnt FROM Trips;
/* STEP 6 — THREE REQUIRED QUERIES */
SELECT * FROM Passengers;
SELECT * FROM Vessels;
SELECT * FROM Trips;
/* STEP 7 — JOIN THAT MATCHES RESERVATIONS */
SELECT
    t.Date,
    t.Departure_Time,
    t.Length_in_Hours,
    v.Vessel,
    p.First_Name,
    p.Last_Name,
    p.Street,
    p.City,
    p.State,
    p.Zip,
    p.Phone,
    t.Total_Passengers,
    CAST(v.Cost_Per_Hour * t.Length_in_Hours AS DECIMAL(10,2)) AS Total_Cost
FROM Trips t
JOIN Vessels v    ON t.VesselID    = v.VesselID
JOIN Passengers p ON t.PassengerID = p.PassengerID
ORDER BY t.Date, t.Departure_Time ASC;
SELECT * FROM Reservations ORDER BY Date, Departure_Time ASC;
SELECT COUNT(*) FROM Reservations;
SELECT COUNT(*) FROM Trips;
SELECT * FROM Reservations
ORDER BY Date, Departure_Time ASC;