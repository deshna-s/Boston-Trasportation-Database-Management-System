--View for User Operations and Ticket Details: This view could join the USERS, OPERATIONS, and TICKET tables to provide a comprehensive 
--look at the operations performed by each user, including the details of the tickets they've purchased.

CREATE VIEW UserOperationsTicketDetails AS
SELECT 
    U.User_ID, U.User_Name, U.User_Contact, 
    O.Activity_Log, O.Op_Description, O.OP_User_Status, 
    T.Ticket_ID, T.Purchase_Date, T.Ticket_Type
FROM 
    USERS U
JOIN 
    OPERATIONS O ON U.User_ID = O.User_ID
JOIN 
    TICKET T ON O.Ticket_ID = T.Ticket_ID;

Select * FROM UserOperationsTicketDetails

--View for Route and Transportation Details: This view could join the ROUTE, LINE, BUS, and TRAIN 
--tables to provide details about each route, including the type of transportation used and their respective capacities.

CREATE VIEW RouteTransportationDetails AS
SELECT 
    R.Route_ID, R.Route_Name, R.Route_Origin, R.Route_Destination, 
    L.Line_Color, L.Line_Status, 
    B.Bus_Capacity, T.Train_Capacity
FROM 
    ROUTE R
LEFT JOIN 
    LINE L ON R.Route_ID = L.Line_ID
LEFT JOIN 
    BUS B ON R.Route_ID = B.Route_ID
LEFT JOIN 
    TRAIN T ON L.Line_ID = T.Line_ID;

Select * FROM RouteTransportationDetails

--Complex View for User Spending Habits: This view will calculate the total amount spent by 
--each user on tickets and recharges, and the total operations performed.

CREATE VIEW UserSpendingHabits AS
SELECT 
    U.User_ID,
    U.User_Name,
    SUM(R.Rate) AS Total_Recharge_Amount,
    COUNT(O.Operation_ID) AS Total_Operations
FROM 
    USERS U
LEFT JOIN 
    TICKET T ON U.User_ID = T.User_ID
LEFT JOIN 
    RECHARGE R ON T.Ticket_ID = R.Ticket_ID
LEFT JOIN 
    OPERATIONS O ON U.User_ID = O.User_ID
GROUP BY 
    U.User_ID, U.User_Name;

SELECT * from UserSpendingHabits

--Complex View for Transport Availability: This view provides a list of routes, 
--the available transport options (bus or train), and checks if both options are available for the route.

CREATE VIEW TransportAvailability1 AS
SELECT 
    R.Route_ID,
    R.Route_Name,
    MAX(CASE WHEN B.Bus_No IS NOT NULL THEN 'Bus Available' ELSE NULL END) AS Bus_Availability,
    MAX(CASE WHEN T.Train_No IS NOT NULL THEN 'Train Available' ELSE NULL END) AS Train_Availability,
    CASE 
        WHEN MAX(B.Bus_No) IS NOT NULL AND MAX(T.Train_No) IS NOT NULL THEN 'Both Modes'
        WHEN MAX(B.Bus_No) IS NOT NULL THEN 'Bus Only'
        WHEN MAX(T.Train_No) IS NOT NULL THEN 'Train Only'
        ELSE 'No Transport'
    END AS Transport_Options
FROM 
    ROUTE R
LEFT JOIN 
    BUS B ON R.Route_ID = B.Route_ID
LEFT JOIN 
    TRAIN T ON R.Route_ID = T.Line_ID
GROUP BY 
    R.Route_ID, R.Route_Name;

SELECT * from TransportAvailability1


--Complex View for Station Traffic Analysis: This view aggregates the number 
--of operations and the frequency of transport to calculate the load on each station.

CREATE VIEW StationTrafficAnalysis1 AS
SELECT 
    S.Station_ID,
    S.Station_Name,
    L.Line_Color,
    
    SUM(L.Line_Frequency) AS Total_Line_Frequency
from
    STATION S
JOIN 
    LINE_STATION LS ON S.Station_ID = LS.Station_ID
JOIN 
    LINE L ON LS.Line_ID = L.Line_ID
JOIN 
    OPERATIONS O ON LS.Station_ID = O.Operation_ID
GROUP BY 
    S.Station_ID, S.Station_Name, L.Line_Color;

SELECT * from StationTrafficAnalysis1

