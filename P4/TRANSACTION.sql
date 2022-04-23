BEGIN TRANSACTION trans
    SAVE TRANSACTION sp1
    DECLARE @errors BIT = 0;

    BEGIN TRY
        INSERT INTO Receiver VALUES (2);
        INSERT INTO Receiver VALUES (9);
    END TRY

    BEGIN CATCH
        Set @errors = 1
    END CATCH

    IF(@errors != 0)
        BEGIN
            ROLLBACK TRANSACTION sp1
            PRINT ('ROLLBACK!')
        END
    ELSE
        BEGIN
            COMMIT TRANSACTION trans
        END
