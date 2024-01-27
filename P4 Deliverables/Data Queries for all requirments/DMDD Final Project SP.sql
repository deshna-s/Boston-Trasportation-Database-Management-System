-- Store Procedure

--Automated Recharge and Low Balance Alert:
/*
Automated Recharge and Low Balance Alert:

Logic: When a card's balance falls below a certain threshold, an alert is triggered, notifying the user of the low balance. Optionally, the system could automatically recharge the card if the user has opted for automatic recharge.
Implementation: A stored procedure that monitors card balances, compares them with a predefined threshold, and triggers an alert or automatic recharge process. This involves querying and updating the Card and Recharge entities, 
and possibly integrating with an external payment system for the recharge process.
*/

CREATE PROCEDURE CheckBalanceAndRecharge
@TicketID INT,
@Threshold DECIMAL(10, 2),
@AutoRecharge BIT,
@RechargeAmount DECIMAL(10, 2),
@NewBalance DECIMAL(10, 2) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @CurrentBalance DECIMAL(10, 2);
    SELECT @CurrentBalance = Card_Amount FROM CARD WHERE Ticket_ID = @TicketID;

    IF @CurrentBalance < @Threshold
    BEGIN
        IF @AutoRecharge = 1
        BEGIN
            SET @NewBalance = @CurrentBalance + @RechargeAmount;
            UPDATE CARD SET Card_Amount = @NewBalance WHERE Ticket_ID = @TicketID;
            INSERT INTO RECHARGE (Rate, Recharge_Method, Renewal_Date, Recharge_Type, Ticket_ID) VALUES (@RechargeAmount, 'auto', GETDATE(), 'OneTime', @TicketID);
        END
        ELSE
        BEGIN
            SET @NewBalance = @CurrentBalance; -- Send a low balance alert to user
        END
    END
    ELSE
    BEGIN
        SET @NewBalance = @CurrentBalance; -- Balance is sufficient
    END
END
GO

-- execution

DECLARE @NewBalance DECIMAL(10, 2);

EXEC CheckBalanceAndRecharge 
    @TicketID = 8,            -- example ticket ID
    @Threshold = 20.00,        -- example threshold amount
    @AutoRecharge = 1,        -- 1 for true, 0 for false
    @RechargeAmount = 19.00,  -- example recharge amount
    @NewBalance = @NewBalance OUTPUT;

SELECT @NewBalance as NewBalance;

-- Revenue per line

CREATE PROCEDURE GetTotalRevenueByLine
AS
BEGIN
    SELECT L.Line_Color, SUM(T.Train_Amount) AS TotalRevenue
    FROM LINE L
    INNER JOIN TRAIN T ON L.Line_ID = T.Line_ID
    GROUP BY L.Line_Color;
END;
GO

EXEC GetTotalRevenueByLine;

--Count Passenger Trips by Line

CREATE PROCEDURE CountTripsByLine
AS
BEGIN
    SET NOCOUNT ON;

    SELECT L.Line_ID, L.Line_Color, COUNT(*) AS Total_Trips
    FROM OPERATIONS O
    JOIN ROUTE R ON O.Operation_ID = R.Operation_ID
    JOIN LINE L ON R.Route_ID = L.Line_ID
    GROUP BY L.Line_ID, L.Line_Color;
END
GO

-- execution

EXEC CountTripsByLine;

--Stored Procedure for Counting Train Trips by Line:

CREATE PROCEDURE CountTrainTripsByLine
AS
BEGIN
    SELECT L.Line_ID, L.Line_Color, COUNT(T.Train_No) AS TrainTripCount
    FROM LINE L
    JOIN TRAIN T ON L.Line_ID = T.Line_ID
    GROUP BY L.Line_ID, L.Line_Color;
END;

EXEC CountTrainTripsByLine;

--Stored Procedure for Counting Bus Trips by Route:

CREATE PROCEDURE CountBusTripsByRoute
AS
BEGIN
    SELECT R.Route_ID, R.Route_Name, COUNT(B.Bus_No) AS BusTripCount
    FROM ROUTE R
    JOIN BUS B ON R.Route_ID = B.Route_ID
    GROUP BY R.Route_ID, R.Route_Name;
END;

EXEC CountBusTripsByRoute;

/*
Stored Procedure: OptimizeRoutesAndLinesUtilization
Business Logic:
Identify High and Low Demand Routes and Lines: Based on ticket sales and operations data, identify which routes 
and lines have the highest and lowest demand.
*/

CREATE PROCEDURE OptimizeRoutesAndLinesUtilization
AS
BEGIN
    SET NOCOUNT ON;

    -- High and Low Demand Routes
    SELECT 
        R.Route_Name, 
        COUNT(O.Operation_ID) AS NumberOfTrips,
        SUM(CASE WHEN O.OP_User_Status = 'authorised' THEN 1 ELSE 0 END) AS AuthorizedTrips,
        SUM(CASE WHEN O.OP_User_Status = 'unauthorised' THEN 1 ELSE 0 END) AS UnauthorizedTrips
    FROM ROUTE R
    JOIN OPERATIONS O ON R.Operation_ID = O.Operation_ID
    GROUP BY R.Route_Name
    ORDER BY NumberOfTrips DESC;

    -- High and Low Demand Lines
    SELECT 
        L.Line_Color, 
        COUNT(O.Operation_ID) AS NumberOfTrips,
        SUM(CASE WHEN O.OP_User_Status = 'authorised' THEN 1 ELSE 0 END) AS AuthorizedTrips,
        SUM(CASE WHEN O.OP_User_Status = 'unauthorised' THEN 1 ELSE 0 END) AS UnauthorizedTrips
    FROM LINE L
    JOIN OPERATIONS O ON L.Operation_ID = O.Operation_ID
    GROUP BY L.Line_Color
    ORDER BY NumberOfTrips DESC;

END;
GO

EXEC OptimizeRoutesAndLinesUtilization;


