USE [Blood_Bank]
GO

CREATE TABLE [dbo].[BloodUnit_Audit](
[blood_id] [char](25) , Inserted_By VARCHAR (100),
[Units_provided] int,
[hospital_id] INT ,
[receiver_id] INT ,
[blood_group] [char](5) 
)
GO


Create TRIGGER Trig_insert_audit
on [dbo].[Blood]
For INSERT
As
BEGIN
    declare @blood_id char(25)
    declare @Units_provided int
    declare @hospital_id INT
    declare @receiver_id INT

    declare @blood_group [char](5)

    select @blood_id = blood_id from inserted
    select @Units_provided = Units_provided  from inserted
    select @hospital_id = hospital_id from inserted
    select @receiver_id = receiver_id  from inserted
    select @blood_group = blood_group  from inserted

    insert into BloodUnit_Audit ([blood_id], Inserted_By, [Units_provided], [hospital_id], [receiver_id], [blood_group])
    values (@blood_id, Original_Login(), @Units_provided, @hospital_id, @receiver_id, @blood_group)

    Print 'insert trigger executed'
End

SELECT  * from [BloodUnit_Audit]

INSERT INTO Blood VALUES (5,91,73,'O-')




