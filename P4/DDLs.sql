-- iF DATABASE EXISTS, DROP
IF EXISTS (SELECT name FROM sys.databases WHERE name = N'Blood_Bank')
    USE Master
    DROP DATABASE Blood_Bank
GO

CREATE DATABASE [Blood_Bank]
go
USE [Blood_Bank]
GO

------------------------------------------------------------------------------------------------------------------------
------- Computed Column based on UDF - 2
------------------------------------------------------------------------------------------------------------------------
--1 -Returns Age of Person
CREATE FUNCTION dbo.fn_Age (@id int)
  RETURNS INT
  AS
    BEGIN 
       RETURN (SELECT DATEDIFF(YEAR, Person.person_DOB, GETDATE()) as AGE from Person where person_id = @id)
    END
GO

--2 -Returns full name of Person
CREATE FUNCTION dbo.fn_FullName (@id int)
     RETURNS VARCHAR(300)
     AS
        BEGIN
            RETURN (Select person_fname+SPACE(1)+person_lname from Person WHERE person_id = @id)
        END
GO

-- SELECT
--     person_id as ID,
--     dbo.fn_FullName(person_id) as [Name],
--     dbo.fn_Age(person_id) as Age 
-- FROM Person

------------------------------------------------------------------------------------------------------------------------
------- Create tables
------------------------------------------------------------------------------------------------------------------------

CREATE TABLE [dbo].[BloodBank](
[blood_bank_id] INT NOT NULL PRIMARY KEY IDENTITY(1,1),
[blood_bank_name] [varchar](100) NOT NULL,
[blood_bank_street][varchar](100) NOT NULL,
[blood_bank_city] [varchar](25) NOT NULL,
[blood_bank_state] [varchar](25) NOT NULL,
[blood_bank_zipcode] [varchar](25) NOT NULL,
[blood_bank_country] [varchar](25) NOT NULL,
[blood_bank_tele] [char](10) NOT NULL

)
GO

CREATE TABLE [dbo].[System_Admin](
[admin_id] INT NOT NULL PRIMARY KEY IDENTITY(1,1),
[admin_name] [varchar](25) NOT NULL,
[username] [varchar](25) NOT NULL,
[password][varchar](25) NOT Null,
[blood_bank_id] INT Not Null 
)
GO


ALTER TABLE [dbo].[System_Admin] WITH CHECK ADD CONSTRAINT [foreign_bloodbank_id] FOREIGN 
KEY([blood_bank_id])
REFERENCES [dbo].[BloodBank] ([blood_bank_id])
GO
ALTER TABLE [dbo].[System_Admin] CHECK CONSTRAINT [foreign_bloodbank_id]
GO

CREATE TABLE [dbo].[Person](
[person_id] INT NOT NULL PRIMARY KEY IDENTITY(1,1),
[person_fname] [varchar](25) NOT NULL,
[person_lname] [varchar](25) NOT NULL,
[person_street][varchar](100) NOT NULL,
[person_city] [varchar](25) NOT NULL,
[person_state] [varchar](25) NOT NULL,
[person_zipcode] [varchar](25) NOT NULL,
[person_country] [varchar](25) NOT NULL,
[person_teleNo] [char](10) Not Null,
[person_bloodGroup] [varchar](3) Not NULL,
[person_DOB] DATE Not Null,
[person_age] AS dbo.fn_Age([person_id]),
[person_fullName] AS dbo.fn_FullName([person_id]) 
)
GO


CREATE TABLE [dbo].[Donor]( 
[donor_id] INT NOT NULL PRIMARY KEY


)
GO

ALTER TABLE [dbo].[Donor]  WITH CHECK ADD CONSTRAINT [FK_Person_Donor] FOREIGN 
KEY([donor_id])
REFERENCES [dbo].[Person] ([person_id])
GO
ALTER TABLE [dbo].[Donor] CHECK CONSTRAINT [FK_Person_Donor]
GO

CREATE TABLE [dbo].[Collector](
[collector_id]  INT NOT NULL PRIMARY KEY,
[blood_bank_id] INT Not Null
)
GO

ALTER TABLE [dbo].[Collector]  WITH CHECK ADD CONSTRAINT [FK_Person_Collector] FOREIGN 
KEY([collector_id])
REFERENCES [dbo].[Person] ([person_id])
GO
ALTER TABLE [dbo].[Collector] CHECK CONSTRAINT [FK_Person_Collector]
GO

ALTER TABLE [dbo].[Collector]  WITH CHECK ADD  CONSTRAINT [foreign_collector_id] FOREIGN 
KEY([blood_bank_id])
REFERENCES [dbo].[BloodBank] ([blood_bank_id])
GO
ALTER TABLE [dbo].[Collector] CHECK CONSTRAINT [foreign_collector_id]
GO


CREATE TABLE [dbo].[Organization](
[org_id]  INT NOT NULL PRIMARY KEY IDENTITY(1,1),
[org_name] [varchar](100) NOT NULL,
[org_street][varchar](100) NOT NULL,
[org_city] [varchar](25) NOT NULL,
[org_state] [varchar](25) NOT NULL,
[org_zipcode] [varchar](25) NOT NULL,
[org_country] [varchar](25) NOT NULL,
[org_teleNo] [char](10) Not Null,
[org_email] [varchar](50) NOT NULL

)
GO

CREATE TABLE [dbo].[Hospital](
[hospital_id]  INT NOT NULL PRIMARY KEY IDENTITY(1,1),
[hospital_name] [varchar](100) NOT NULL,
[hospital_street][varchar](100) NOT NULL,
[hospital_city] [varchar](50) NOT NULL,
[hospital_state] [varchar](25) NOT NULL,
[hospital_zipcode] [varchar](25) NOT NULL,
[hospital_country] [varchar](25) NOT NULL,
[hospital_teleNo] [char](10) Not Null,

)
GO

CREATE TABLE [dbo].[Receiver](
[receiver_id]  INT NOT NULL PRIMARY KEY
)
GO

ALTER TABLE [dbo].[Receiver]  WITH CHECK ADD CONSTRAINT [FK_Person_Receiver] FOREIGN 
KEY([receiver_id])
REFERENCES [dbo].[Person] ([person_id])
GO
ALTER TABLE [dbo].[Receiver] CHECK CONSTRAINT [FK_Person_Receiver]
GO


CREATE TABLE [dbo].[Order_Request](
[order_request_id]  INT NOT NULL PRIMARY KEY IDENTITY(1,1),
[blood_bank_id] INT Not Null,
[units_required] int ,
[Blood_Group] [char] (5) Not null,
[hospital_id] INT Not Null
)
GO




ALTER TABLE [dbo].[Order_Request]  WITH CHECK ADD  CONSTRAINT [foreign_bloodBank_id_1] FOREIGN 
KEY([blood_bank_id])
REFERENCES [dbo].[BloodBank] ([blood_bank_id])
GO
ALTER TABLE [dbo].[Order_Request] CHECK CONSTRAINT [foreign_bloodBank_id_1]
GO

ALTER TABLE [dbo].[Order_Request]  WITH CHECK ADD  CONSTRAINT [foreign_hospital_id] FOREIGN 
KEY([hospital_id])
REFERENCES [dbo].[Hospital] ([hospital_id])
GO
ALTER TABLE [dbo].[Order_Request] CHECK CONSTRAINT [foreign_hospital_id]
GO



CREATE TABLE [dbo].[Partners](
[partner_id]  INT NOT NULL PRIMARY KEY IDENTITY(1,1),
[org_id] INT Not Null,
[blood_bank_id] INT Not Null,

)
GO


ALTER TABLE [dbo].[Partners]  WITH CHECK ADD  CONSTRAINT [foreign_org_id] FOREIGN 
KEY([org_id])
REFERENCES [dbo].[Organization] ([org_id])
GO
ALTER TABLE [dbo].[Partners] CHECK CONSTRAINT [foreign_org_id]
GO

ALTER TABLE [dbo].[Partners]  WITH CHECK ADD  CONSTRAINT [foreign_bloodBank_id1] FOREIGN 
KEY([blood_bank_id])
REFERENCES [dbo].[BloodBank] ([blood_bank_id])
GO
ALTER TABLE [dbo].[Partners] CHECK CONSTRAINT [foreign_bloodBank_id1]
GO



CREATE TABLE [dbo].[Blood](
[blood_id]  INT NOT NULL PRIMARY KEY IDENTITY(1,1),
[Units_provided] int,
[hospital_id] INT Not Null,
[receiver_id] INT Not Null,
[blood_group] [char](5) Not Null
 
)
GO

ALTER TABLE [dbo].[Blood]  WITH CHECK ADD  CONSTRAINT [foreign_hospital_id1] FOREIGN 
KEY([hospital_id])
REFERENCES [dbo].[Hospital] ([hospital_id])
GO
ALTER TABLE [dbo].[Blood] CHECK CONSTRAINT [foreign_hospital_id1]
GO

ALTER TABLE [dbo].[Blood]  WITH CHECK ADD  CONSTRAINT [foreign_receiver_id] FOREIGN 
KEY([receiver_id])
REFERENCES [dbo].[Receiver] ([receiver_id])
GO
ALTER TABLE [dbo].[Blood] CHECK CONSTRAINT [foreign_receiver_id]
GO


CREATE TABLE [dbo].[Record_details](
[record_id] INT Not Null PRIMARY KEY IDENTITY(1,1),
[receiver_id] INT Not Null,
[org_id] INT Not Null,
[blood_bank_id] INT Not Null,
[donor_id] INT Not Null,
[collector_id] INT Not Null,
[blood_id] INT Not Null,
[Blood_stored_date] Date,
[NoOfBloodGroupBottle] int,
[Expiry_date_Bloppd] date
)
GO


ALTER TABLE [dbo].[Record_details]  WITH CHECK ADD  CONSTRAINT [foreign_receiver_id1] FOREIGN 
KEY([receiver_id])
REFERENCES [dbo].[Receiver] ([receiver_id])
GO
ALTER TABLE [dbo].[Record_details] CHECK CONSTRAINT [foreign_receiver_id1]
GO


ALTER TABLE [dbo].[Record_details]  WITH CHECK ADD  CONSTRAINT [foreign_bloodBank_id2] FOREIGN 
KEY([blood_bank_id])
REFERENCES [dbo].[BloodBank] ([blood_bank_id])
GO
ALTER TABLE [dbo].[Record_details] CHECK CONSTRAINT [foreign_bloodBank_id2]
GO

ALTER TABLE [dbo].[Record_details]  WITH CHECK ADD  CONSTRAINT [foreign_org_id1] FOREIGN 
KEY([org_id])
REFERENCES [dbo].[Organization] ([org_id])
GO
ALTER TABLE [dbo].[Record_details] CHECK CONSTRAINT [foreign_org_id1]
GO

ALTER TABLE [dbo].[Record_details]  WITH CHECK ADD  CONSTRAINT [foreign_donor_id1] FOREIGN 
KEY([donor_id])
REFERENCES [dbo].[Donor] ([donor_id])
GO
ALTER TABLE [dbo].[Record_details] CHECK CONSTRAINT [foreign_donor_id1]
GO

ALTER TABLE [dbo].[Record_details]  WITH CHECK ADD  CONSTRAINT [foreign_collector_id1] FOREIGN 
KEY([collector_id])
REFERENCES [dbo].[Collector] ([collector_id])
GO
ALTER TABLE [dbo].[Record_details] CHECK CONSTRAINT [foreign_collector_id1]
GO

ALTER TABLE [dbo].[Record_details]  WITH CHECK ADD  CONSTRAINT [foreign_blood_id] FOREIGN 
KEY([blood_id])
REFERENCES [dbo].[Blood] ([blood_id])
GO
ALTER TABLE [dbo].[Record_details] CHECK CONSTRAINT [foreign_blood_id]
GO 


---------------Stored Procedure 1 --- Get Donor Details State Wise
CREATE PROCEDURE GetDonor @state VARCHAR(25)
AS
BEGIN 

SELECT p.person_id, p.person_fname, p.person_lname, p.person_city, p.person_bloodGroup, p.person_state as state
FROM Person p JOIN Donor d ON p.person_id = d.donor_id 
WHERE p.person_state = @state 

END
Go

--Execute it 
-- EXEC GetDonor 'FL'

-------------Stored Procedure 2 -- Get Donors of Particular Blood Group
CREATE PROCEDURE GetDonorBloodGroup @bloodgroup VARCHAR(3)
AS
BEGIN 

SELECT p.person_fname,p.person_lname, p.person_city, p.person_state, bg.blood_group FROM Person p
INNER JOIN
(SELECT RP.Donor_ID,B.Blood_Group FROM RECORD_DETAILS RP
INNER JOIN BLOOD B ON RP.Blood_ID = B.Blood_ID and B.Blood_Group = @bloodgroup) bg
ON P.Person_ID = bg.Donor_ID

END
Go

--Execute it 
-- EXEC GetDonorBloodGroup 'B+'

------------Stored Procedure 3 ---- Get Organizations parterned with Blood Banks in a particular State.
CREATE PROCEDURE GetPartneredOrganizationsBloodBanks @state VARCHAR(25)
AS
BEGIN 

SELECT p.partner_id, bb.blood_bank_name, o.org_name, bb.blood_bank_state
FROM Partners p RIGHT JOIN Organization o ON p.org_id = o.org_id
JOIN BloodBank bb ON o.org_state = bb.blood_bank_state WHERE bb.blood_bank_state = @state

END
Go

--Execute it 
-- EXEC GetPartneredOrganizationsBloodBanks 'FL'

------------------------------------------------------------------------------------------------------------------------
------- VIEWS STATEMENTS ------- at least 2 views (often used for reporting purposes).
------------------------------------------------------------------------------------------------------------------------
---View 1  Donor List
Go
CREATE VIEW [DONOR_LIST] AS
SELECT M.person_fname,M.person_lname, COUNT(M.DONOR_ID) AS Donation_Count
FROM
(SELECT P.person_fname,P.person_lname, RP.DONOR_ID FROM PERSON P
INNER JOIN RECORD_DETAILS RP
ON P.PERSON_ID = RP.DONOR_ID) M
GROUP BY M.person_fname,M.person_lname
Go


-- SELECT * FROM DONOR_LIST
-- Go


--View 2  o-
CREATE VIEW [DONOR_LIST_ONegative] AS
SELECT P.person_fname,P.person_lname,BB.Blood_Group FROM PERSON P
INNER JOIN
(SELECT RP.DONOR_ID,B.Blood_Group FROM RECORD_DETAILS RP
INNER JOIN BLOOD B ON RP.Blood_ID = B.Blood_ID and B.Blood_Group = 'O-') BB
ON P.Person_ID = BB.Donor_ID
Go

-- SELECT * FROM DONOR_LIST_ONegative

--View 3  ---Total Units of blood

CREATE VIEW [REQUESTED_BLOOD_GROUP] AS
SELECT B.Receiver_ID, B.Blood_Group,SUM(B.Units_Provided) AS Total_Units FROM BLOOD B
WHERE B.Receiver_ID is not NULL
GROUP BY B.Receiver_ID, B.Blood_Group
Go

-- SELECT * FROM REQUESTED_BLOOD_GROUP
-- ORDER BY Total_Units DESC


------------------------------------------------------------------------------------------------------------------------
------- TRIGGERS STATEMENTS ------- At least 1 trigger
------------------------------------------------------------------------------------------------------------------------

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
GO


------------------------------------------------------------------------------------------------------------------------
------- Non Clustered Index -------
------------------------------------------------------------------------------------------------------------------------
---1
CREATE NONCLUSTERED INDEX idx_BloodBankName
ON BloodBank (blood_bank_name);
GO
---2
CREATE NONCLUSTERED INDEX idx_OrgName
ON Organization (org_name);
GO
---3
CREATE NONCLUSTERED INDEX idx_HospitalName
ON Hospital (hospital_name);
GO


------------------------------------------------------------------------------------------------------------------------
------- UDFs - 3
------------------------------------------------------------------------------------------------------------------------

-- 1 
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
-- SELECT * FROM dbo.storageTime(1) -- Blood expiration days

---2 - Details of particular Person with Input PersonID
CREATE FUNCTION dbo.personInfo (@personNo int)
RETURNS Table
AS
RETURN(
    SELECT * FROM Person WHERE person_id = @personNo
);
GO

-- SELECT * FROM dbo.personInfo(1)

--Before

--3 --Return role of every person with Input PersonID
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
GO

-- SELECT dbo.role(111);
