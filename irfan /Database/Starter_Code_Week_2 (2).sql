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
/* STARTER CODE WEEK 2 */
DROP DATABASE IF EXISTS MRC;
CREATE DATABASE MRC;
USE MRC;

-- Original Reservations table (do not modify)
CREATE TABLE Reservations (
    Date DATE,
    Departure_Time TIME,
    Length_in_Hours DECIMAL(4,2),
    Vessel VARCHAR(50),
    First_Name VARCHAR(50),
    Last_Name VARCHAR(50),
    Street VARCHAR(50),
    City VARCHAR(50),
    State CHAR(2),
    Zip CHAR(5),
    Phone CHAR(12),
    Total_Passengers INT,
    Total_Cost VARCHAR(50)
);

-- INSERT statements (already provided)
-- SELECT * FROM Reservations ORDER BY Date, Departure_Time ASC;

/* YOUR CODE BELOW HERE */

-- 1. Create Vessels table
CREATE TABLE Vessels (
    Vessel_Name VARCHAR(50) PRIMARY KEY,
    Cost_Per_Hour DECIMAL(6,2)
);

-- 2. Create Passengers table
CREATE TABLE Passengers (
    Passenger_ID INT AUTO_INCREMENT PRIMARY KEY,
    First_Name VARCHAR(50),
    Last_Name VARCHAR(50),
    Street VARCHAR(50),
    City VARCHAR(50),
    State CHAR(2),
    Zip CHAR(5),
    Phone CHAR(12)
);

-- 3. Create Trips table
CREATE TABLE Trips (
    Date DATE,
    Departure_Time TIME,
    Length_in_Hours DECIMAL(4,2),
    Vessel_Name VARCHAR(50),
    Passenger_ID INT,
    Total_Passengers INT,
    FOREIGN KEY (Vessel_Name) REFERENCES Vessels(Vessel_Name),
    FOREIGN KEY (Passenger_ID) REFERENCES Passengers(Passenger_ID),
    PRIMARY KEY (Date, Departure_Time, Vessel_Name, Passenger_ID)
);

/*
-- Superkey, Candidate Key, Primary Key Notes:
-- a) Superkeys: 2^7 - 1 = 127 possible combinations of attributes (excluding empty set)
-- b) Candidate Keys: (Date, Departure_Time, Vessel_Name, Passenger_ID), (Date, Vessel_Name, Phone)
-- c) Chosen Primary Key: (Date, Departure_Time, Vessel_Name, Passenger_ID)
--    Reason: This combination uniquely identifies each trip and avoids ambiguity in case of duplicate names or vessels.
*/

-- 4. Create Famous Sea Creatures table (AI bonus)
CREATE TABLE Famous_Sea_Creatures (
    Creature_ID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(50),
    Species VARCHAR(50),
    Known_For VARCHAR(100)
);

-- 5. Calculate Cost_Per_Hour for each vessel
INSERT INTO Vessels (Vessel_Name, Cost_Per_Hour)
SELECT Vessel,
       ROUND(AVG(CAST(REPLACE(Total_Cost, '$', '') AS DECIMAL(6,2)) / Length_in_Hours), 2)
FROM Reservations
GROUP BY Vessel;

-- 6. Insert unique passengers
INSERT INTO Passengers (First_Name, Last_Name, Street, City, State, Zip, Phone)
SELECT DISTINCT First_Name, Last_Name, Street, City, State, Zip, Phone
FROM Reservations;

-- 7. Insert trips
INSERT INTO Trips (Date, Departure_Time, Length_in_Hours, Vessel_Name, Passenger_ID, Total_Passengers)
SELECT r.Date, r.Departure_Time, r.Length_in_Hours, r.Vessel,
       p.Passenger_ID, r.Total_Passengers
FROM Reservations r
JOIN Passengers p
  ON r.First_Name = p.First_Name AND r.Last_Name = p.Last_Name
  AND r.Street = p.Street AND r.City = p.City AND r.State = p.State
  AND r.Zip = p.Zip AND r.Phone = p.Phone;

-- 8. Required Queries
SELECT * FROM Passengers;
SELECT * FROM Vessels;
SELECT * FROM Trips;

-- 9. Join query to match original Reservations output
SELECT t.Date, t.Departure_Time, t.Length_in_Hours, t.Vessel_Name,
       p.First_Name, p.Last_Name, p.Street, p.City, p.State, p.Zip, p.Phone,
       t.Total_Passengers,
       CAST(t.Length_in_Hours * v.Cost_Per_Hour AS DECIMAL(6,2)) AS Total_Cost
FROM Trips t
JOIN Passengers p ON t.Passenger_ID = p.Passenger_ID
JOIN Vessels v ON t.Vessel_Name = v.Vessel_Name
ORDER BY t.Date, t.Departure_Time ASC;
SELECT * FROM Passengers;
SELECT * FROM Vessels;
SELECT * FROM Trips;
SELECT t.Date, t.Departure_Time, t.Length_in_Hours, t.Vessel_Name,
       p.First_Name, p.Last_Name, p.Street, p.City, p.State, p.Zip, p.Phone,
       t.Total_Passengers,
       CAST(t.Length_in_Hours * v.Cost_Per_Hour AS DECIMAL(6,2)) AS Total_Cost
FROM Trips t
JOIN Passengers p ON t.Passenger_ID = p.Passenger_ID
JOIN Vessels v ON t.Vessel_Name = v.Vessel_Name
ORDER BY t.Date, t.Departure_Time ASC;
SELECT * FROM Passengers;
SELECT * FROM Vessels;
SELECT * FROM Trips;
SELECT t.Date, t.Departure_Time, t.Length_in_Hours, t.Vessel_Name,
       p.First_Name, p.Last_Name, p.Street, p.City, p.State, p.Zip, p.Phone,
       t.Total_Passengers,
       CAST(t.Length_in_Hours * v.Cost_Per_Hour AS DECIMAL(6,2)) AS Total_Cost
FROM Trips t
JOIN Passengers p ON t.Passenger_ID = p.Passenger_ID
JOIN Vessels v ON t.Vessel_Name = v.Vessel_Name
ORDER BY t.Date, t.Departure_Time ASC;

