CREATE TABLE USERS (
    User_ID INT not null,
    User_Name VARCHAR(255) NOT NULL,
    User_Contact VARCHAR(255),
    User_Address VARCHAR(255),
    User_Status VARCHAR(10) CHECK (User_Status IN ('active', 'inactive')),
    CONSTRAINT PK_Users PRIMARY KEY (User_ID)
);

select * from ticket
CREATE TABLE TICKET (
    Ticket_ID INT,
    Purchase_Date DATE,
    Ticket_Type VARCHAR(255) CHECK (Ticket_Type IN ('Card', 'Pass')),
    Status VARCHAR(10) CHECK (Status IN ('valid', 'expired')),
    User_ID INT,
    CONSTRAINT PK_Ticket PRIMARY KEY (Ticket_ID),
    CONSTRAINT FK_Ticket_User FOREIGN KEY (User_ID) REFERENCES USERS(User_ID)
);

CREATE TABLE RECHARGE (
    Recharge_ID INT,
    Rate DECIMAL(10, 2),
    Recharge_Method VARCHAR(255) CHECK (Recharge_Method IN ('debit', 'credit', 'cash')),
    Renewal_Date DATE,
    Recharge_Type VARCHAR(10) CHECK (Recharge_Type IN ('OneTime', 'Daily', 'Weekly', 'Monthly')),
    Ticket_ID INT,
    CONSTRAINT PK_Recharge PRIMARY KEY (Recharge_ID),
    CONSTRAINT FK_Recharge_Ticket FOREIGN KEY (Ticket_ID) REFERENCES TICKET(Ticket_ID)
);

CREATE TABLE CARD (
    Ticket_ID INT,
    Card_Name VARCHAR(255),
    Card_Amount DECIMAL(10, 2),
    Card_Expiry DATE,
    CONSTRAINT PK_FK_Card_Ticket PRIMARY KEY (Ticket_ID),
    CONSTRAINT FK_Card_Ticket FOREIGN KEY (Ticket_ID) REFERENCES TICKET(Ticket_ID)
);


CREATE TABLE PASS (
    Ticket_ID INT,
    Pass_Name VARCHAR(255),
    Pass_Amount DECIMAL(10, 2),
    Pass_Expiry DATE,
    CONSTRAINT PK_FK_Pass_Ticket PRIMARY KEY (Ticket_ID),
    CONSTRAINT FK_Pass_Ticket FOREIGN KEY (Ticket_ID) REFERENCES TICKET(Ticket_ID)
);


CREATE TABLE OPERATIONS (
    Operation_ID INT,
    Activity_Log varchar(100),
    Op_Description varchar(200),
    OP_User_Status VARCHAR(12) CHECK (OP_User_Status IN ('authorised', 'unauthorised')),
    OP_User_RemainAmount DECIMAL(10, 2),
    User_ID INT,
    Ticket_ID INT,
    CONSTRAINT PK_Operation PRIMARY KEY (Operation_ID),
    CONSTRAINT FK_Operation_User FOREIGN KEY (User_ID) REFERENCES USERS(User_ID),
    CONSTRAINT FK_Operation_Ticket FOREIGN KEY (Ticket_ID) REFERENCES TICKET(Ticket_ID)
);

CREATE TABLE ROUTE(
    Route_ID INT,
    Route_Name VARCHAR(255),
    Route_Frequency INT,
    Route_Origin VARCHAR(255),
    Route_Destination VARCHAR(255),
    Route_Status VARCHAR(7) CHECK (Route_Status IN ('Open', 'Closed')),
    Route_Transport_Count INT,
    Operation_ID INT,
    CONSTRAINT PK_Route PRIMARY KEY (Route_ID),
    CONSTRAINT FK_Route_Operation FOREIGN KEY (Operation_ID) REFERENCES Operations(Operation_ID)
);

CREATE TABLE LINE (
    Line_ID INT,
    Line_Color VARCHAR(255),
    Line_Origin VARCHAR(255),
    Line_Destination VARCHAR(255),
    Line_Transport_Count INT,
    Line_Status VARCHAR(7) CHECK (Line_Status IN ('Open', 'Closed')),
    Line_Frequency INT,
    Operation_ID INT,
    CONSTRAINT PK_Line PRIMARY KEY (Line_ID),
    CONSTRAINT FK_Line_Operation FOREIGN KEY (Operation_ID) REFERENCES Operations(Operation_ID)
);

-- STATION Table (Must be defined to create foreign keys in the associative tables)
-- Assuming the STATION table does not exist yet.
CREATE TABLE STATION (
    Station_ID INT NOT NULL,
    Station_Name VARCHAR(255),
    Station_Type VARCHAR(50),
    CONSTRAINT PK_Station PRIMARY KEY (Station_ID)
);

-- Route_Station Associative Entity Table
CREATE TABLE Route_Station (
    Route_ID INT NOT NULL,
    Station_ID INT NOT NULL,
    CONSTRAINT PK_Route_Station PRIMARY KEY (Route_ID, Station_ID),
    CONSTRAINT FK_Route_Station_Route FOREIGN KEY (Route_ID) REFERENCES ROUTE(Route_ID),
    CONSTRAINT FK_Route_Station_Station FOREIGN KEY (Station_ID) REFERENCES STATION(Station_ID)
);

-- Line_Station Associative Entity Table
CREATE TABLE Line_Station (
    Line_ID INT NOT NULL,
    Station_ID INT NOT NULL,
    CONSTRAINT PK_Line_Station PRIMARY KEY (Line_ID, Station_ID),
    CONSTRAINT FK_Line_Station_Line FOREIGN KEY (Line_ID) REFERENCES LINE(Line_ID),
    CONSTRAINT FK_Line_Station_Station FOREIGN KEY (Station_ID) REFERENCES STATION(Station_ID)
);

CREATE TABLE BUS (
    Bus_No INT NOT NULL,
    Bus_Company VARCHAR(255),
    Bus_Capacity INT,
    Bus_Duration INT,
    Bus_Amount DECIMAL(10, 2),  -- Assuming the amount is a monetary value, adjust precision and scale as needed
    Route_ID INT,
    CONSTRAINT PK_Bus PRIMARY KEY (Bus_No),
    CONSTRAINT FK_Bus_Route FOREIGN KEY (Route_ID) REFERENCES ROUTE(Route_ID)
);

CREATE TABLE TRAIN (
    Train_No INT NOT NULL,
    Train_Capacity INT,
    Train_Duration INT,
    Train_Amount DECIMAL(10, 2),  -- Assuming the amount is a monetary value; adjust precision and scale as needed
    Line_ID INT,
    CONSTRAINT PK_Train PRIMARY KEY (Train_No),
    CONSTRAINT FK_Train_Line FOREIGN KEY (Line_ID) REFERENCES LINE(Line_ID)
);

--DRIVER Table
CREATE TABLE DRIVER (
    Driver_ID INT NOT NULL,
    Driver_Type VARCHAR(255),
    Driver_Name VARCHAR(255),
    Driver_SSN VARCHAR(255),  -- Assuming SSN is stored as a string; consider encryption for privacy
    CONSTRAINT PK_Driver PRIMARY KEY (Driver_ID)
);

-- Bus_Driver Associative Entity Table
CREATE TABLE Bus_Driver (
    Bus_No INT NOT NULL,
    Driver_ID INT NOT NULL,
    CONSTRAINT PK_Bus_Driver PRIMARY KEY (Bus_No, Driver_ID),
    CONSTRAINT FK_Bus_Driver_Bus FOREIGN KEY (Bus_No) REFERENCES BUS(Bus_No),
    CONSTRAINT FK_Bus_Driver_Driver FOREIGN KEY (Driver_ID) REFERENCES DRIVER(Driver_ID)
);

-- Train_Driver Associative Entity Table
CREATE TABLE Train_Driver (
    Train_No INT NOT NULL,
    Driver_ID INT NOT NULL,
    CONSTRAINT PK_Train_Driver PRIMARY KEY (Train_No, Driver_ID),
    CONSTRAINT FK_Train_Driver_Train FOREIGN KEY (Train_No) REFERENCES TRAIN(Train_No),
    CONSTRAINT FK_Train_Driver_Driver FOREIGN KEY (Driver_ID) REFERENCES DRIVER(Driver_ID)
);



INSERT INTO USERS (User_ID, User_Name, User_Address, User_Contact, User_Status) VALUES
(1, 'Jane Morrison', '214 Ave St, Boston, MA', '555-2665', 'Active'),
(2, 'Jane Smith', '234 Pearl St, Boston, MA', '555-2345', 'Active'),
(3, 'Alice Johnson', '345 Charles St, Boston, MA', '555-3456', 'Active'),
(4, 'Bob Brown', '456 Cambridge St, Boston, MA', '555-4567', 'Inactive'),
(5, 'Carol Davis', '567 Tremont St, Boston, MA', '555-5678', 'Active'),
(6, 'David Evans', '678 Washington St, Boston, MA', '555-6789', 'Active'),
(7, 'Eva Ford', '789 Boylston St, Boston, MA', '555-7890', 'Active'),
(8, 'Frank Green', '890 Commonwealth Ave, Boston, MA', '555-8901', 'Inactive'),
(9, 'Grace Hall', '901 Dorchester Ave, Boston, MA', '555-9012', 'Active'),
(10, 'Henry Irving', '1012 Mass Ave, Boston, MA', '555-0123', 'Active'),
(11, 'Isabel Jackson', '1113 Beacon St, Boston, MA', '555-1314', 'Active'),
(12, 'Jack Keller', '1214 Pearl St, Boston, MA', '555-1415', 'Inactive'),
(13, 'Laura Lane', '1315 Charles St, Boston, MA', '555-1516', 'Active'),
(14, 'Michael Moore', '1416 Cambridge St, Boston, MA', '555-1617', 'Active'),
(15, 'Nancy Nolen', '1527 Cambridge St, Boston, MA', '565-1718', 'Active'),
(16, 'Sean Abott', '1012 Mass Ave, Boston, MA', '565-7723', 'Active'),
(17, 'Isabel Rogers', '1893 Beacon St, Boston, MA', '565-9914', 'Active'),
(18, 'Jackie Chen', '1414 Pearl St, Boston, MA', '558-2215', 'Active'),
(19, 'Danny D', '1775 Charles St, Boston, MA', '575-1576', 'Active'),
(20, 'Albert Seeker', '1006 Cambridge St, Boston, MA', '535-1637', 'Active'),
(21, 'Nicy Nolen', '1997 Tremont St, Boston, MA', '533-1738', 'Active');


INSERT INTO TICKET (Ticket_ID, Purchase_Date, Ticket_Type, Status, User_ID) VALUES
(1, '2023-11-01', 'Card', 'valid', 1),
(2, '2023-10-15', 'Pass', 'valid', 2),
(3, '2020-09-20', 'Card', 'expired', 2),
(4, '2023-11-03', 'Card', 'valid', 3),
(5, '2023-08-11', 'Pass', 'valid', 4),
(6, '2022-11-10', 'Card', 'valid', 5),
(7, '2021-07-07', 'Pass', 'valid', 6),
(8, '2022-11-05', 'Card', 'valid', 7),
(9, '2016-06-15', 'Pass', 'expired', 7),
(10, '2023-11-12', 'Card', 'valid', 8),
(11, '2012-05-21', 'Pass', 'expired', 10),
(12, '2023-11-13', 'Card', 'valid', 11),
(13, '2023-04-30', 'Pass', 'valid', 11),
(14, '2023-11-14', 'Card', 'valid', 9),
(15, '2015-11-29', 'Pass', 'expired', 12),
(16, '2022-10-30', 'Pass', 'valid', 13),
(17, '2023-06-14', 'Card', 'valid', 14),
(18, '2022-03-29', 'Pass', 'valid', 15);


INSERT INTO RECHARGE (Recharge_ID, Rate, Recharge_Method, Renewal_Date, Recharge_Type, Ticket_ID) VALUES
(1, 2.50, 'debit', '2023-11-02', 'OneTime', 1),
(2, 20.00, 'credit', '2023-10-16', 'Weekly', 2),
(3, 5.75, 'cash', '2023-09-21', 'Daily', 3),
(4, 2.50, 'debit', '2023-11-04', 'OneTime', 4),
(5, 45.00, 'credit', '2023-08-12', 'Monthly', 5),
(6, 2.50, 'debit', '2023-11-11', 'OneTime', 6),
(7, 20.00, 'credit', '2023-07-08', 'Weekly', 7),
(8, 5.75, 'cash', '2023-11-06', 'Daily', 8),
(9, 45.00, 'credit', '2023-06-16', 'Monthly', 9),
(10, 2.50, 'debit', '2023-11-13', 'OneTime', 10),
(11, 20.00, 'credit', '2023-05-22', 'Weekly', 11),
(12, 2.50, 'debit', '2023-11-14', 'OneTime', 12),
(13, 5.75, 'cash', '2023-05-01', 'Daily', 13),
(14, 45.00, 'credit', '2023-11-15', 'Monthly', 14),
(15, 2.50, 'debit', '2023-03-30', 'OneTime', 15),
-- Additional recharges for the same Ticket_ID --
(16, 3.00, 'debit', '2023-11-15', 'OneTime', 1),
(17, 22.00, 'credit', '2023-11-17', 'Weekly', 2),
(18, 6.00, 'cash', '2023-11-18', 'Daily', 1),
(19, 50.00, 'credit', '2023-11-19', 'Monthly', 6),
(20, 3.50, 'debit', '2023-11-20', 'OneTime', 6);


INSERT INTO CARD (Ticket_ID, Card_Name, Card_Amount, Card_Expiry) VALUES
(1, 'MBTA Card', 20.00, '2024-11-01'),  -- Future expiry for a valid ticket
(3, 'MBTA Card', 15.00, '2023-09-19'),  -- Past expiry for an expired ticket
(4, 'MBTA Card', 20.00, '2024-11-03'),  -- Future expiry for a valid ticket
(6, 'MBTA Card', 20.00, '2024-11-10'),  -- Future expiry for a valid ticket
(8, 'MBTA Card', 20.00, '2024-11-05'),  -- Future expiry for a valid ticket
(10, 'MBTA Card', 20.00, '2024-11-12'), -- Future expiry for a valid ticket
(12, 'MBTA Card', 20.00, '2024-11-13'), -- Future expiry for a valid ticket
(14, 'MBTA Card', 20.00, '2024-11-14'), -- Future expiry for a valid ticket
(17, 'MBTA Card', 20.00, '2024-11-16'); -- Future expiry for a valid ticket

INSERT INTO PASS (Ticket_ID, Pass_Name, Pass_Amount, Pass_Expiry) VALUES
(2, 'MBTA Pass', 70.00, '2024-10-15'),  -- Future expiry for a valid ticket
(5, 'MBTA Pass', 50.00, '2023-08-10'),  -- Past expiry for an expired ticket
(7, 'MBTA Pass', 70.00, '2023-07-06'),  -- Past expiry for an expired ticket
(9, 'MBTA Pass', 50.00, '2023-06-14'),  -- Past expiry for an expired ticket
(11, 'MBTA Pass', 70.00, '2023-05-20'), -- Past expiry for an expired ticket
(13, 'MBTA Pass', 70.00, '2023-04-29'), -- Past expiry for an expired ticket
(15, 'MBTA Pass', 50.00, '2023-03-28'), -- Past expiry for an expired ticket
(16, 'MBTA Pass', 70.00, '2024-10-30'), -- Future expiry for a valid ticket
(18, 'MBTA Pass', 70.00, '2024-03-30'); -- Future expiry for a valid ticket


INSERT INTO OPERATIONS (Operation_ID, Activity_Log, Op_Description, OP_User_Status, OP_User_RemainAmount, User_ID, Ticket_ID) VALUES
(1, 'Transit Tap', 'T Travel', 'authorised', 50.00, 1, 1),
(2, 'Transit Tap', 'Bus Travel', 'authorised', 30.00, 2, 2),
(3, 'Transit Tap', 'T Travel', 'unauthorised', 0.00, 2, 3),  -- User 2 has an expired ticket
(4, 'Transit Tap', 'Bus Travel', 'authorised', 50.00, 3, 4),
(5, 'Transit Tap', 'T Travel', 'unauthorised', 0.00, 4, 5),  -- User 4 has an expired ticket
(6, 'Transit Tap', 'Bus Travel', 'authorised', 50.00, 5, 6),
(7, 'Transit Tap', 'T Travel', 'unauthorised', 0.00, 5, 7),  -- User 5 has an expired ticket
(8, 'Transit Tap', 'Bus Travel', 'authorised', 50.00, 6, 8),
(9, 'Transit Tap', 'T Travel', 'authorised', 50.00, 7, 9),
(10, 'Transit Tap', 'Bus Travel', 'unauthorised', 0.00, 7, 10), -- User 7 has an expired ticket
(11, 'Transit Tap', 'T Travel', 'authorised', 50.00, 8, 11),
(12, 'Transit Tap', 'Bus Travel', 'authorised', 50.00, 9, 12),
(13, 'Transit Tap', 'T Travel', 'authorised', 50.00, 10, 13),
(14, 'Transit Tap', 'Bus Travel', 'authorised', 50.00, 11, 14),
(15, 'Transit Tap', 'T Travel', 'unauthorised', 0.00, 11, 15), -- User 11 has an expired ticket
-- More entries can be added with Operation_ID incrementing for each new operation
(16, 'Transit Tap', 'Bus Travel', 'authorised', 70.00, 13, 16),
(17, 'Transit Tap', 'T Travel', 'authorised', 70.00, 14, 17),
(18, 'Transit Tap', 'Bus Travel', 'unauthorised', 0.00, 12, 18); -- User 12 has an expired ticket

INSERT INTO ROUTE (Route_ID, Route_Name, Route_Frequency, Route_Origin, Route_Destination, Route_Status, Route_Transport_Count, Operation_ID) VALUES
(1, 'BLR 1', 15, 'Harvard Square', 'Nubian Square', 'Open', 3, 1),
(2, 'BLR 22', 10, 'Ashmont', 'Ruggles', 'Open', 2, 3),
(3, 'BLR 66', 20, 'Harvard Square', 'Dudley Station', 'Open', 4, 5),
(4, 'BLR 47', 12, 'Central Square', 'Broadway Station', 'Open', 3, 7),
(5, 'BLR 57', 8, 'Kenmore', 'Watertown Yard', 'Open', 5, 9),
(6, 'BLR 32', 25, 'Wolcott Square', 'Forest Hills', 'Closed', 1, 10),
(7, 'BLR 39', 10, 'Back Bay', 'Forest Hills', 'Open', 3, 12),
(8, 'BLR 111', 30, 'Woodlawn', 'Haymarket', 'Open', 2, 14),
(9, 'BLR 15', 20, 'Kane Square', 'Ruggles', 'Open', 4, 15),
(10, 'BLR 28', 15, 'Mattapan', 'Ruggles', 'Open', 5, 17);

INSERT INTO LINE (Line_ID, Line_Color, Line_Origin, Line_Destination, Line_Transport_Count, Line_Status, Line_Frequency, Operation_ID) VALUES
(1, 'Red', 'Alewife', 'Braintree', 5, 'Open', 12, 2),
(2, 'Green', 'Lechmere', 'Boston College', 4, 'Open', 10, 4),
(3, 'Blue', 'Bowdoin', 'Wonderland', 3, 'Open', 8, 6),
(4, 'Orange', 'Oak Grove', 'Forest Hills', 5, 'Open', 10, 8),
(5, 'Silver', 'South Station', 'Logan Airport', 2, 'Open', 15, 11),
(6, 'Red', 'Alewife', 'Ashmont', 4, 'Open', 12, 13),
(7, 'Green', 'North Station', 'Heath Street', 3, 'Open', 10, 16),
(8, 'Blue', 'Government Center', 'Wonderland', 5, 'Open', 8, 18);

INSERT INTO BUS (Bus_No, Bus_Company, Bus_Capacity, Bus_Duration, Bus_Amount, Route_ID) VALUES
(1234, 'New Flyer', 50, 45, 1.75, 1),
(5678, 'Nova Bus', 50, 45, 1.75, 1),
(9101, 'Gillig', 50, 45, 1.75, 1),
(1121, 'Prevost', 50, 30, 1.75, 2),
(3141, 'MCI', 50, 30, 1.75, 2),
(5161, 'New Flyer', 50, 35, 1.75, 3),
(7181, 'Nova Bus', 50, 35, 1.75, 3),
(1920, 'Gillig', 50, 35, 1.75, 3),
(2122, 'Prevost', 50, 35, 1.75, 3),
(2324, 'MCI', 50, 25, 1.75, 4),
(2526, 'New Flyer', 50, 25, 1.75, 4),
(2728, 'Nova Bus', 50, 25, 1.75, 4),
(2930, 'Gillig', 50, 40, 1.75, 5),
(3132, 'Prevost', 50, 40, 1.75, 5),
(3334, 'MCI', 50, 40, 1.75, 5),
(3536, 'New Flyer', 50, 40, 1.75, 5),
(3738, 'Nova Bus', 50, 40, 1.75, 5),
-- BLR32 has a count of 1 and is closed, assuming no buses are assigned
(3940, 'Gillig', 50, 30, 1.75, 7),
(4142, 'Prevost', 50, 30, 1.75, 7),
(4344, 'MCI', 50, 30, 1.75, 7),
(4546, 'New Flyer', 50, 50, 1.75, 8),
(4748, 'Nova Bus', 50, 50, 1.75, 8),
(4950, 'Gillig', 50, 45, 1.75, 9),
(5152, 'Prevost', 50, 45, 1.75, 9),
(5354, 'MCI', 50, 45, 1.75, 9),
(5556, 'New Flyer', 50, 45, 1.75, 9),
(5758, 'Nova Bus', 50, 40, 1.75, 10),
(5960, 'Gillig', 50, 40, 1.75, 10),
(6162, 'Prevost', 50, 40, 1.75, 10),
(6364, 'MCI', 50, 40, 1.75, 10),
(6566, 'New Flyer', 50, 40, 1.75, 10);

INSERT INTO DRIVER (Driver_ID, Driver_Type, Driver_Name, Driver_SSN) VALUES
(1, 'Bus', 'John Doe', '123-45-6789'),
(2, 'Train', 'Jane Smith', '234-56-7890'),
(3, 'Bus', 'Michael Johnson', '345-67-8901'),
(4, 'Train', 'Patricia Brown', '456-78-9012'),
(5, 'Bus', 'Linda Davis', '567-89-0123'),
(6, 'Train', 'Robert Miller', '678-90-1234'),
(7, 'Bus', 'Elizabeth Garcia', '789-01-2345'),
(8, 'Train', 'William Martinez', '890-12-3456'),
(9, 'Bus', 'Barbara Rodriguez', '901-23-4567'),
(10, 'Train', 'James Hernandez', '012-34-5678'),
(11, 'Bus', 'Maria Clark', '123-45-6789'),
(12, 'Train', 'Brian Lewis', '234-56-7890'),
(13, 'Bus', 'Nancy Lee', '345-67-8901'),
(14, 'Train', 'Richard Walker', '456-78-9012'),
(15, 'Bus', 'Karen Hall', '567-89-0123'),
(16, 'Train', 'Daniel Allen', '678-90-1234'),
(17, 'Bus', 'Lisa Young', '789-01-2345'),
(18, 'Train', 'Mark King', '890-12-3456'),
(19, 'Bus', 'Patricia Scott', '901-23-4567'),
(20, 'Train', 'Charles Wright', '012-34-5678');


INSERT INTO Bus_Driver (Bus_No, Driver_ID) VALUES (1234, 1);
INSERT INTO Bus_Driver (Bus_No, Driver_ID) VALUES (5678, 3);
INSERT INTO Bus_Driver (Bus_No, Driver_ID) VALUES (9101, 5);
INSERT INTO Bus_Driver (Bus_No, Driver_ID) VALUES (1121, 7);
INSERT INTO Bus_Driver (Bus_No, Driver_ID) VALUES (3141, 9);
INSERT INTO Bus_Driver (Bus_No, Driver_ID) VALUES (5161, 11);
INSERT INTO Bus_Driver (Bus_No, Driver_ID) VALUES (7181, 13);
INSERT INTO Bus_Driver (Bus_No, Driver_ID) VALUES (1920, 15);
INSERT INTO Bus_Driver (Bus_No, Driver_ID) VALUES (2122, 17);
INSERT INTO Bus_Driver (Bus_No, Driver_ID) VALUES (2324, 19);
INSERT INTO Bus_Driver (Bus_No, Driver_ID) VALUES (2526, 1);
INSERT INTO Bus_Driver (Bus_No, Driver_ID) VALUES (2728, 3);
INSERT INTO Bus_Driver (Bus_No, Driver_ID) VALUES (2930, 5);
INSERT INTO Bus_Driver (Bus_No, Driver_ID) VALUES (3132, 7);
INSERT INTO Bus_Driver (Bus_No, Driver_ID) VALUES (3334, 9);
INSERT INTO Bus_Driver (Bus_No, Driver_ID) VALUES (3536, 11);
INSERT INTO Bus_Driver (Bus_No, Driver_ID) VALUES (3738, 13);
INSERT INTO Bus_Driver (Bus_No, Driver_ID) VALUES (3940, 15);
INSERT INTO Bus_Driver (Bus_No, Driver_ID) VALUES (4142, 17);
INSERT INTO Bus_Driver (Bus_No, Driver_ID) VALUES (4344, 19);
INSERT INTO Bus_Driver (Bus_No, Driver_ID) VALUES (4546, 1);
INSERT INTO Bus_Driver (Bus_No, Driver_ID) VALUES (4748, 3);
INSERT INTO Bus_Driver (Bus_No, Driver_ID) VALUES (4950, 5);
INSERT INTO Bus_Driver (Bus_No, Driver_ID) VALUES (5152, 7);
INSERT INTO Bus_Driver (Bus_No, Driver_ID) VALUES (5354, 9);
INSERT INTO Bus_Driver (Bus_No, Driver_ID) VALUES (5556, 11);
INSERT INTO Bus_Driver (Bus_No, Driver_ID) VALUES (5758, 13);
INSERT INTO Bus_Driver (Bus_No, Driver_ID) VALUES (5960, 15);
INSERT INTO Bus_Driver (Bus_No, Driver_ID) VALUES (6162, 17);
INSERT INTO Bus_Driver (Bus_No, Driver_ID) VALUES (6364, 19);

INSERT INTO STATION (Station_ID, Station_Name, Station_Type) VALUES (1, 'Harvard Square Red', 'Train');
INSERT INTO STATION (Station_ID, Station_Name, Station_Type) VALUES (2, 'Copley Green', 'Train');
INSERT INTO STATION (Station_ID, Station_Name, Station_Type) VALUES (3, 'North Station Orange', 'Train');
INSERT INTO STATION (Station_ID, Station_Name, Station_Type) VALUES (4, 'South Station Silver', 'Bus');
INSERT INTO STATION (Station_ID, Station_Name, Station_Type) VALUES (5, 'Bowdoin Blue', 'Train');
INSERT INTO STATION (Station_ID, Station_Name, Station_Type) VALUES (6, 'Alewife Red', 'Train');
INSERT INTO STATION (Station_ID, Station_Name, Station_Type) VALUES (7, 'Kenmore Green', 'Train');
INSERT INTO STATION (Station_ID, Station_Name, Station_Type) VALUES (8, 'Back Bay Orange', 'Train');
INSERT INTO STATION (Station_ID, Station_Name, Station_Type) VALUES (9, 'Dudley Square Silver', 'Bus');
INSERT INTO STATION (Station_ID, Station_Name, Station_Type) VALUES (10, 'Wonderland Blue', 'Train');
INSERT INTO STATION (Station_ID, Station_Name, Station_Type) VALUES (11, 'Savin Hill Red', 'Train');
INSERT INTO STATION (Station_ID, Station_Name, Station_Type) VALUES (12, 'Downtown Crossing Orange', 'Train');
INSERT INTO STATION (Station_ID, Station_Name, Station_Type) VALUES (13, 'Tufts Medical Center Silver', 'Bus');
INSERT INTO STATION (Station_ID, Station_Name, Station_Type) VALUES (14, 'Prudential Green', 'Train');
INSERT INTO STATION (Station_ID, Station_Name, Station_Type) VALUES (15, 'Broadway Red', 'Bus');
INSERT INTO STATION (Station_ID, Station_Name, Station_Type) VALUES (16, 'Lechmere Green', 'Train');
INSERT INTO STATION (Station_ID, Station_Name, Station_Type) VALUES (17, 'Mass Ave Orange', 'Train');
INSERT INTO STATION (Station_ID, Station_Name, Station_Type) VALUES (18, 'Washington Street Silver', 'Bus');
INSERT INTO STATION (Station_ID, Station_Name, Station_Type) VALUES (19, 'Beacon Hill Red', 'Train');
INSERT INTO STATION (Station_ID, Station_Name, Station_Type) VALUES (20, 'State Street Blue', 'Bus');


INSERT INTO TRAIN (Train_No, Train_Capacity, Train_Duration, Train_Amount, Line_ID) VALUES
(1001, 1200, 60, 2.40, 1),
(1002, 1200, 60, 2.40, 1),
(1003, 1200, 60, 2.40, 1),
(1004, 1200, 60, 2.40, 1),
(1005, 1200, 60, 2.40, 1),
(2001, 1000, 45, 2.40, 2),
(2002, 1000, 45, 2.40, 2),
(2003, 1000, 45, 2.40, 2),
(2004, 1000, 45, 2.40, 2),
(3001, 900, 50, 2.40, 3),
(3002, 900, 50, 2.40, 3),
(3003, 900, 50, 2.40, 3),
(4001, 1100, 55, 2.40, 4),
(4002, 1100, 55, 2.40, 4),
(4003, 1100, 55, 2.40, 4),
(4004, 1100, 55, 2.40, 4),
(4005, 1100, 55, 2.40, 4),
(5001, 800, 30, 2.40, 5),
(5002, 800, 30, 2.40, 5),
(6001, 1000, 60, 2.40, 6),
(6002, 1000, 60, 2.40, 6),
(6003, 1000, 60, 2.40, 6),
(6004, 1000, 60, 2.40, 6),
(7001, 950, 50, 2.40, 7),
(7002, 950, 50, 2.40, 7),
(7003, 950, 50, 2.40, 7),
(8001, 900, 40, 2.40, 8),
(8002, 900, 40, 2.40, 8),
(8003, 900, 40, 2.40, 8),
(8004, 900, 40, 2.40, 8),
(8005, 900, 40, 2.40, 8);


INSERT INTO Train_Driver (Train_No, Driver_ID) VALUES
(1001, 2), (1002, 4), (1003, 6), (1004, 8), (1005, 10),
(2001, 12), (2002, 14), (2003, 16), (2004, 18), (3001, 20),
(3002, 2), (3003, 4), (4001, 6), (4002, 8), (4003, 10),
(4004, 12), (4005, 14), (5001, 16), (5002, 18), (6001, 20),
(6002, 2), (6003, 4), (6004, 6), (7001, 8), (7002, 10),
(7003, 12), (8001, 14), (8002, 16), (8003, 18), (8004, 20),
(8005, 2);


-- Assuming each route stops at 3 sequential stations based on Station_ID
INSERT INTO Route_Station (Route_ID, Station_ID) VALUES (1, 1);
INSERT INTO Route_Station (Route_ID, Station_ID) VALUES (1, 2);
INSERT INTO Route_Station (Route_ID, Station_ID) VALUES (1, 3);

INSERT INTO Route_Station (Route_ID, Station_ID) VALUES (2, 6);
INSERT INTO Route_Station (Route_ID, Station_ID) VALUES (2, 7);
INSERT INTO Route_Station (Route_ID, Station_ID) VALUES (2, 8);

INSERT INTO Route_Station (Route_ID, Station_ID) VALUES (3, 1);
INSERT INTO Route_Station (Route_ID, Station_ID) VALUES (3, 9);
INSERT INTO Route_Station (Route_ID, Station_ID) VALUES (3, 10);

INSERT INTO Route_Station (Route_ID, Station_ID) VALUES (4, 4);
INSERT INTO Route_Station (Route_ID, Station_ID) VALUES (4, 5);
INSERT INTO Route_Station (Route_ID, Station_ID) VALUES (4, 6);

INSERT INTO Route_Station (Route_ID, Station_ID) VALUES (5, 7);
INSERT INTO Route_Station (Route_ID, Station_ID) VALUES (5, 11);
INSERT INTO Route_Station (Route_ID, Station_ID) VALUES (5, 12);

INSERT INTO Route_Station (Route_ID, Station_ID) VALUES (7, 8);
INSERT INTO Route_Station (Route_ID, Station_ID) VALUES (7, 13);
INSERT INTO Route_Station (Route_ID, Station_ID) VALUES (7, 14);

INSERT INTO Route_Station (Route_ID, Station_ID) VALUES (8, 15);
INSERT INTO Route_Station (Route_ID, Station_ID) VALUES (8, 16);
INSERT INTO Route_Station (Route_ID, Station_ID) VALUES (8, 17);

INSERT INTO Route_Station (Route_ID, Station_ID) VALUES (9, 18);
INSERT INTO Route_Station (Route_ID, Station_ID) VALUES (9, 19);
INSERT INTO Route_Station (Route_ID, Station_ID) VALUES (9, 20);

INSERT INTO Route_Station (Route_ID, Station_ID) VALUES (10, 2);
INSERT INTO Route_Station (Route_ID, Station_ID) VALUES (10, 3);
INSERT INTO Route_Station (Route_ID, Station_ID) VALUES (10, 4);

INSERT INTO Route_Station (Route_ID, Station_ID) VALUES (6, 10);
INSERT INTO Route_Station (Route_ID, Station_ID) VALUES (6, 14);
INSERT INTO Route_Station (Route_ID, Station_ID) VALUES (6, 18);

--Line_Station


-- Red Line (Line_IDs 1 and 6)
INSERT INTO Line_Station (Line_ID, Station_ID) VALUES (1, 1);  -- Harvard Square Red
INSERT INTO Line_Station (Line_ID, Station_ID) VALUES (1, 6);  -- Alewife Red
INSERT INTO Line_Station (Line_ID, Station_ID) VALUES (1, 11); -- Savin Hill Red
INSERT INTO Line_Station (Line_ID, Station_ID) VALUES (1, 15); -- Broadway Red
INSERT INTO Line_Station (Line_ID, Station_ID) VALUES (1, 19); -- Beacon Hill Red

INSERT INTO Line_Station (Line_ID, Station_ID) VALUES (6, 1);  -- Harvard Square Red
INSERT INTO Line_Station (Line_ID, Station_ID) VALUES (6, 6);  -- Alewife Red
INSERT INTO Line_Station (Line_ID, Station_ID) VALUES (6, 11); -- Savin Hill Red
INSERT INTO Line_Station (Line_ID, Station_ID) VALUES (6, 15); -- Broadway Red
INSERT INTO Line_Station (Line_ID, Station_ID) VALUES (6, 19); -- Beacon Hill Red

-- Green Line
INSERT INTO Line_Station (Line_ID, Station_ID) VALUES (2, 2);  -- Copley Green
INSERT INTO Line_Station (Line_ID, Station_ID) VALUES (2, 7);  -- Kenmore Green
INSERT INTO Line_Station (Line_ID, Station_ID) VALUES (2, 16); -- Lechmere Green

-- Blue Line
INSERT INTO Line_Station (Line_ID, Station_ID) VALUES (3, 5);  -- Bowdoin Blue
INSERT INTO Line_Station (Line_ID, Station_ID) VALUES (3, 10); -- Wonderland Blue
INSERT INTO Line_Station (Line_ID, Station_ID) VALUES (3, 20); -- State Street Blue

-- Orange Line
INSERT INTO Line_Station (Line_ID, Station_ID) VALUES (4, 3);  -- North Station Orange
INSERT INTO Line_Station (Line_ID, Station_ID) VALUES (4, 8);  -- Back Bay Orange
INSERT INTO Line_Station (Line_ID, Station_ID) VALUES (4, 12); -- Downtown Crossing Orange
INSERT INTO Line_Station (Line_ID, Station_ID) VALUES (4, 17); -- Mass Ave Orange

-- Silver Line
INSERT INTO Line_Station (Line_ID, Station_ID) VALUES (5, 4);  -- South Station Silver
INSERT INTO Line_Station (Line_ID, Station_ID) VALUES (5, 9);  -- Dudley Square Silver
INSERT INTO Line_Station (Line_ID, Station_ID) VALUES (5, 13); -- Tufts Medical Center Silver
INSERT INTO Line_Station (Line_ID, Station_ID) VALUES (5, 18); -- Washington Street Silver


-- More Green Line (for Line_ID 7)
INSERT INTO Line_Station (Line_ID, Station_ID) VALUES (7, 2);  -- Copley Green
INSERT INTO Line_Station (Line_ID, Station_ID) VALUES (7, 7);  -- Kenmore Green
INSERT INTO Line_Station (Line_ID, Station_ID) VALUES (7, 16); -- Lechmere Green

-- More Blue Line (for Line_ID 8)
INSERT INTO Line_Station (Line_ID, Station_ID) VALUES (8, 5);  -- Bowdoin Blue
INSERT INTO Line_Station (Line_ID, Station_ID) VALUES (8, 10); -- Wonderland Blue
INSERT INTO Line_Station (Line_ID, Station_ID) VALUES (8, 20); -- State Street Blue

