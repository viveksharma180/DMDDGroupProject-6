CREATE FUNCTION dbo.storageTime (@ordNo int)
RETURNS Table
AS
RETURN(
    SELECT datediff(day, (
        SELECT Blood_stored_date FROM Record_details WHERE record_id = @ordNo
    ), (
        SELECT Expiry_date_Bloppd FROM Record_details WHERE record_id = @ordNo
    )) AS res
);
GO
---Before 
SELECT * FROM dbo.storageTime(1) -- Blood expiration days

-- Second UDF
-- Details of particular Person with Input PersonID
CREATE FUNCTION dbo.personInfo (@personNo int)
RETURNS Table
AS
RETURN(
    SELECT * FROM Person WHERE person_id = @personNo
);
GO

SELECT * FROM dbo.personInfo(1)

--Before

--Return role of every person with Input PersonID
CREATE FUNCTION dbo.role(@personNo int)
RETURNS varchar(25)
AS
BEGIN
    DECLARE @res varchar(25) = ''
    IF exists (SELECT collector_id FROM Collector WHERE collector_id = @personNo)
    BEGIN
        SELECT @res = 'COLLECTOR'
    END

    IF exists (SELECT donor_id FROM Donor WHERE donor_id = @personNo)
    BEGIN
        IF @res = ''
        BEGIN
            SELECT @res = 'DONOR'
        END
        ELSE
        BEGIN
            SELECT @res = @res + ', DONOR'
        END
    END

    IF exists (SELECT receiver_id FROM Receiver WHERE receiver_id = @personNo)
    BEGIN
        IF @res = ''
        BEGIN
            SELECT @res = 'RECEIVER'
        END
        ELSE
        BEGIN
            SELECT @res = @res + ' and RECEIVER'
        END
    END
    RETURN @res
END;

SELECT dbo.role(111);