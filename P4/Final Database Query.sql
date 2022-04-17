-- iF DATABASE EXISTS, DROP
IF EXISTS (SELECT name FROM sys.databases WHERE name = N'Blood_Bank')
    DROP DATABASE Blood_Bank
GO

CREATE DATABASE [Blood_Bank]
go
USE [Blood_Bank]
GO

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
[person_bloodGroup] [varchar](3) Not NULL
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

CREATE TABLE [dbo].[Receiver]
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
