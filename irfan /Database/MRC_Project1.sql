-- CSC 6302 – Project 1 (Merrimack River Cruises)
-- Student: Irfan Ahmed

-- 1) Recreate DB and select it
DROP DATABASE IF EXISTS MRC;
CREATE DATABASE IF NOT EXISTS MRC;
USE MRC;

-- 2) Recreate Reservations with CSV headers EXACTLY + Fibonacci
DROP TABLE IF EXISTS Reservations;
CREATE TABLE IF NOT EXISTS Reservations (
  Date DATE NOT NULL,
  Departure_Time TIME NOT NULL,
  Length_in_Hours DECIMAL(4,2) NOT NULL,
  Vessel VARCHAR(50) NOT NULL,
  First_Name VARCHAR(50) NOT NULL,
  Last_Name VARCHAR(50) NOT NULL,
  Street VARCHAR(50) NOT NULL,
  City VARCHAR(50) NOT NULL,
  State CHAR(2) NOT NULL,
  ZIP CHAR(5) NOT NULL,
  Phone VARCHAR(50) NOT NULL,
  Total_Passengers INT NOT NULL,
  Total_Cost DECIMAL(8,2) NOT NULL,
  Fibonacci INT NOT NULL
);

-- 3) Insert first six rows (ZIP leading zero restored; Fibonacci: 1,1,2,3,5,8)
INSERT INTO Reservations
(Date, Departure_Time, Length_in_Hours, Vessel, First_Name, Last_Name,
 Street, City, State, ZIP, Phone, Total_Passengers, Total_Cost, Fibonacci)
VALUES
('2025-03-01','08:00',2.00,'Sea Breeze','John','Smith','123 Oak St','Cityville','MA','01234','413-555-1234',5,200.00,1),
('2025-03-01','09:00',3.00,'Ocean Voyager','Emily','Clark','456 Pine St','Rivertown','MA','23456','978-555-5678',3,600.00,1),
('2025-03-02','08:30',1.50,'The Warrior','John','Smith','123 Oak St','Cityville','MA','01234','413-555-1234',5,225.00,2),
('2025-03-02','10:00',2.00,'Ocean Voyager','Emily','Clark','456 Pine St','Rivertown','MA','23456','978-555-5678',3,400.00,3),
('2025-03-03','11:00',4.00,'Ocean Voyager','Michael','Lee','789 Maple Ave','Beachside','MA','34567','978-555-8765',6,800.00,5),
('2025-03-03','12:30',2.50,'Sea Breeze','Sarah','Johnson','321 Elm St','Townsville','MA','45678','978-555-4321',4,250.00,8);

-- 4) Required queries
-- 4a) Full result set for screenshot
SELECT * FROM Reservations;

-- 4b) Three WHERE queries (no '*')
SELECT First_Name, Last_Name, Phone, Total_Passengers
FROM Reservations
WHERE Vessel = 'Ocean Voyager';

SELECT Date, Vessel, Total_Cost
FROM Reservations
WHERE Total_Cost >= 300.00;

SELECT First_Name, Last_Name, City, ZIP
FROM Reservations
WHERE ZIP LIKE '0%';