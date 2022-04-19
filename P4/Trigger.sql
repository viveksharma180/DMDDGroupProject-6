CREATE TABLE [dbo].[BloodUnit_Audit](
[blood_id] [char](25) , Inserted_By VARCHAR (100)
)
GO

Create TRIGGER Trig_insert_audit
on [dbo].[Blood]
For INSERT
As
BEGIN
    declare @blood_id char(25)

    select @blood_id = blood_id from inserted
    insert into BloodUnit_Audit ([blood_id], Inserted_By)
    values (@blood_id, Original_Login())

    Print 'insert trigger executed'
End

SELECT  * from [BloodUnit_Audit]


