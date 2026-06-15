
CREATE DATABASE IF NOT EXISTS mrc;
USE mrc;

-- Passengers Table
CREATE TABLE passengers (
    PassengerID INT AUTO_INCREMENT PRIMARY KEY,
    First_Name VARCHAR(50) NOT NULL,
    Last_Name VARCHAR(50) NOT NULL,
    Phone VARCHAR(15)
);

-- Vessels Table
CREATE TABLE vessels (
    VesselID INT AUTO_INCREMENT PRIMARY KEY,
    Vessel VARCHAR(50) NOT NULL,
    Cost_Per_Hour DECIMAL(10,2) NOT NULL
);

-- Trips Table
CREATE TABLE trips (
    TripID INT AUTO_INCREMENT,
    PassengerID INT NOT NULL,
    VesselID INT NOT NULL,
    TripDate DATE NOT NULL,
    TripTime TIME NOT NULL,
    TripDuration DECIMAL(4,2) NOT NULL,
    TotalPassengers INT NOT NULL,
    Price DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (PassengerID, VesselID, TripDate, TripTime), -- Composite key
    FOREIGN KEY (PassengerID) REFERENCES passengers(PassengerID) ON DELETE CASCADE,
    FOREIGN KEY (VesselID) REFERENCES vessels(VesselID) ON DELETE CASCADE
);

-- Insert Passengers
INSERT INTO passengers (First_Name, Last_Name, Phone) VALUES
('Ada', 'Lovelace', '555-111-2222'),
('Alan', 'Turing', '555-333-4444'),
('Grace', 'Hopper', '555-555-6666'),
('Katherine', 'Johnson', '555-777-8888'),
('Tim', 'Berners-Lee', '555-999-0000'),
('Donald', 'Knuth', '555-123-4567'),
('Barbara', 'Liskov', '555-234-5678'),
('John', 'von Neumann', '555-345-6789'),
('Claude', 'Shannon', '555-456-7890'),
('Margaret', 'Hamilton', '555-567-8901');

-- Insert Vessels
INSERT INTO vessels (Vessel, Cost_Per_Hour) VALUES
('Nautilus', 150.00),
('Beagle', 200.00),
('Sea Breeze', 175.00),
('Azure Leviathan', 220.00),
('Poseidon', 250.00);

-- Insert Trips (30 rows)
INSERT INTO trips (PassengerID, VesselID, TripDate, TripTime, TripDuration, TotalPassengers, Price) VALUES
(1, 1, '2025-06-01', '09:00:00', 2.0, 4, 300.00),
(2, 2, '2025-06-01', '11:00:00', 3.0, 2, 600.00),
(3, 3, '2025-06-02', '10:30:00', 1.5, 3, 262.50),
-- Add 27 more rows with varied dates/times/durations/prices
(4, 4, '2025-06-03', '14:00:00', 2.5, 5, 550.00),
(5, 5, '2025-06-04', '15:00:00', 3.0, 6, 750.00);

INSERT INTO trips (PassengerID, VesselID, TripDate, TripTime, TripDuration, TotalPassengers, Price) VALUES
(1, 1, '2025-06-01', '09:00:00', 2.0, 3, 240.00),
(2, 2, '2025-06-02', '10:30:00', 3.0, 4, 660.00),
(3, 1, '2025-06-03', '14:00:00', 1.5, 2, 180.00),
(4, 2, '2025-06-04', '08:00:00', 4.0, 5, 880.00),
(5, 1, '2025-06-05', '13:30:00', 2.5, 3, 300.00),
(6, 2, '2025-06-06', '15:00:00', 3.5, 4, 770.00),
(7, 1, '2025-06-07', '09:30:00', 2.0, 2, 240.00),
(8, 2, '2025-06-08', '11:00:00', 3.0, 3, 660.00),
(9, 1, '2025-06-09', '14:30:00', 1.5, 2, 180.00),
(10, 2, '2025-06-10', '08:30:00', 4.0, 5, 880.00);

USE mrc;

-- Boolean/TinyInt flag on passengers
ALTER TABLE passengers
  ADD COLUMN IsVIP TINYINT(1) NOT NULL DEFAULT 0;

-- Enum status on trips
ALTER TABLE trips
  ADD COLUMN Status ENUM('Scheduled','Completed','Cancelled') NOT NULL DEFAULT 'Scheduled';

-- Mark some passengers as VIP
UPDATE passengers SET IsVIP = 1 WHERE PassengerID IN (1,3,5);

-- Set statuses on existing trips
UPDATE trips
SET Status = CASE
  WHEN TripDate < CURDATE() THEN 'Completed'
  ELSE 'Scheduled'
END;

CREATE OR REPLACE VIEW `total revenue By vessel` AS
SELECT 
    v.Vessel AS `Vessel Name`,
    CONCAT('$', FORMAT(SUM(t.Price), 2)) AS `Revenue`
FROM trips t
JOIN vessels v ON t.VesselID = v.VesselID
GROUP BY v.Vessel
ORDER BY SUM(t.Price) DESC;

DELIMITER //
CREATE PROCEDURE getTripList()
BEGIN
    SELECT 
        t.TripID AS `TripID`,
        CONCAT(p.First_Name, ' ', p.Last_Name) AS `Passenger Name`,
        v.Vessel AS `Vessel Name`,
        CONCAT(t.TripDate, ' ', t.TripTime) AS `Date and Time`,
        t.TripDuration AS `Trip Duration`,
        CONCAT('$', FORMAT(t.Price, 2)) AS `Total Cost`,
        t.Status AS `Status`
    FROM trips t
    JOIN passengers p ON t.PassengerID = p.PassengerID
    JOIN vessels v ON t.VesselID = v.VesselID
    ORDER BY t.TripDate, t.TripTime;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE addTrip(
    IN vesselName VARCHAR(50),
    IN passengerFirst VARCHAR(50),
    IN passengerLast VARCHAR(50),
    IN tripDate DATE,
    IN tripTime TIME,
    IN tripDuration DECIMAL(4,2),
    IN totalPassengers INT
)
BEGIN
    DECLARE vID INT;
    DECLARE pID INT;

    -- Get VesselID
    SELECT VesselID INTO vID FROM vessels WHERE Vessel = vesselName LIMIT 1;

    -- Get PassengerID
    SELECT PassengerID INTO pID FROM passengers WHERE First_Name = passengerFirst AND Last_Name = passengerLast LIMIT 1;

    -- Insert Trip
    INSERT INTO trips (PassengerID, VesselID, TripDate, TripTime, TripDuration, TotalPassengers, Price)
    VALUES (pID, vID, tripDate, tripTime, tripDuration, totalPassengers, (tripDuration * (SELECT Cost_Per_Hour FROM vessels WHERE VesselID = vID)));
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE updateTrip(
    IN tripID INT,
    IN newDate DATE,
    IN newTime TIME,
    IN newDuration DECIMAL(4,2),
    IN newStatus ENUM('Scheduled','Completed','Cancelled')
)
BEGIN
    UPDATE trips
    SET TripDate = newDate,
        TripTime = newTime,
        TripDuration = newDuration,
        Status = newStatus,
        Price = newDuration * (SELECT Cost_Per_Hour FROM vessels WHERE VesselID = trips.VesselID)
    WHERE TripID = tripID;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE deleteTrip(IN tripID INT)
BEGIN
    DELETE FROM trips WHERE TripID = tripID;
END //
DELIMITER ;

