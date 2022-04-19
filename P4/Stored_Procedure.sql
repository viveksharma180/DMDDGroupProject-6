--Stored Procedure 1 --- Get Donor Details State Wise
CREATE PROCEDURE GetDonor @state VARCHAR(25)
AS
BEGIN 

SELECT p.person_id, p.person_fname, p.person_lname, p.person_city, p.person_bloodGroup, p.person_state as state
FROM Person p JOIN Donor d ON p.person_id = d.donor_id 
WHERE p.person_state = @state 

END
Go

--Execute it 
EXEC GetDonor 'FL'

--Stored Procedure 2 -- Get Donors of Particular Blood Group
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
EXEC GetDonorBloodGroup 'B+'

--Stored Procedure 3 ---- Get Organizations parterned with Blood Banks in a particular State.
CREATE PROCEDURE GetPartneredOrganizationsBloodBanks @state VARCHAR(25)
AS
BEGIN 

SELECT p.partner_id, bb.blood_bank_name, o.org_name, bb.blood_bank_state
FROM Partners p RIGHT JOIN Organization o ON p.org_id = o.org_id
JOIN BloodBank bb ON o.org_state = bb.blood_bank_state WHERE bb.blood_bank_state = @state

END
Go

--Execute it 
EXEC GetPartneredOrganizationsBloodBanks 'FL'
