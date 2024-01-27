-- Trigger for updating the status of tickets when a card expires

CREATE TRIGGER UpdateTicketStatusOnCardExpiry
ON CARD
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    -- Check for updated cards that have expired
    UPDATE TICKET
    SET Status = 'expired'
    FROM TICKET T
    INNER JOIN INSERTED I ON T.Ticket_ID = I.Ticket_ID
    WHERE I.Card_Expiry < GETDATE() AND T.Status <> 'expired';
END;
GO

-- Trigger for updating the status of tickets when a pass expires
CREATE TRIGGER UpdateTicketStatusOnPassExpiry
ON PASS
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

 -- Check for updated passes that have expired
    UPDATE TICKET
    SET Status = 'expired'
    FROM TICKET T
    INNER JOIN INSERTED I ON T.Ticket_ID = I.Ticket_ID
    WHERE I.Pass_Expiry < GETDATE() AND T.Status <> 'expired';
END;
GO

UPDATE CARD
SET Card_Expiry = '2023-11-27'
WHERE Ticket_ID = 1;

