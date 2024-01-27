-- Create a UDF to calculate the remaining amount after deducting $2.40 for train travel
CREATE FUNCTION DeductAmountForTrain(@CardAmount DECIMAL(10, 2))
RETURNS DECIMAL(10, 2)
AS
BEGIN
    DECLARE @DeductAmount DECIMAL(10, 2) = 2.40;
    DECLARE @RemainingAmount DECIMAL(10, 2);

    IF @CardAmount >= @DeductAmount
        SET @RemainingAmount = @CardAmount - @DeductAmount;
    ELSE
        SET @RemainingAmount = 0; -- or another appropriate value if the balance goes negative

    RETURN @RemainingAmount;
END;


-- Test the UDF with different input values
DECLARE @TestAmount DECIMAL(10, 2);

-- Test with an amount greater than $2.40
SET @TestAmount = 5.00;
SELECT dbo.DeductAmountForTrain(@TestAmount) AS RemainingAmount;

-- Test with an amount less than $2.40
SET @TestAmount = 6.00;
SELECT dbo.DeductAmountForTrain(@TestAmount) AS RemainingAmount;

-- Test with an amount equal to $2.40
SET @TestAmount = 3.40;
SELECT dbo.DeductAmountForTrain(@TestAmount) AS RemainingAmount;

-- add

ALTER TABLE OPERATIONS ADD RemainingAmount DECIMAL(10, 2);

UPDATE OPERATIONS
SET RemainingAmount = dbo.DeductAmountForTrain(CARD.Card_Amount)
FROM OPERATIONS
INNER JOIN TICKET ON OPERATIONS.Ticket_ID = TICKET.Ticket_ID
INNER JOIN CARD ON TICKET.Ticket_ID = CARD.Ticket_ID
WHERE (OPERATIONS.Op_Description = 'Bus Travel' or OPERATIONS.Op_Description = 'T Travel') AND OPERATIONS.OP_User_Status = 'authorised';

--Create a UDF to calculate the remaining amount after deducting $1.75 for Bus travel

CREATE FUNCTION DeductAmountForBus(@PassAmount DECIMAL(10, 2))
RETURNS DECIMAL(10, 2)
AS
BEGIN
    DECLARE @DeductAmount DECIMAL(10, 2) = 1.75;
    DECLARE @RemainingAmount DECIMAL(10, 2);

    IF @PassAmount >= @DeductAmount
        SET @RemainingAmount = @PassAmount - @DeductAmount;
    ELSE
        SET @RemainingAmount = 0;  -- Or another appropriate value if the balance goes negative

    RETURN @RemainingAmount;
END;


-- Create a function to get the Pass Amount for a given Ticket_ID

CREATE FUNCTION GetPassAmountForTicket(@TicketID INT)
RETURNS DECIMAL(10, 2)
AS
BEGIN
    DECLARE @PassAmount DECIMAL(10, 2);

    SELECT @PassAmount = ISNULL(Pass_Amount, 0)
    FROM PASS
    WHERE Ticket_ID = @TicketID;

    RETURN @PassAmount;
END;

--Computed Cols. to check remaining amount 

UPDATE OPERATIONS
SET RemainingAmount = dbo.DeductAmountForBus(PASS.Pass_Amount)
FROM OPERATIONS
INNER JOIN TICKET ON OPERATIONS.Ticket_ID = TICKET.Ticket_ID
INNER JOIN PASS ON TICKET.Ticket_ID = PASS.Ticket_ID
WHERE (OPERATIONS.Op_Description = 'Bus Travel' or OPERATIONS.Op_Description = 'T Travel') AND OPERATIONS.OP_User_Status = 'authorised';


