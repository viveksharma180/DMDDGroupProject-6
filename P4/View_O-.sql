CREATE VIEW [DONOR_LIST_ONegative] AS
SELECT P.person_fname,P.person_lname,BB.Blood_Group FROM PERSON P
INNER JOIN
(SELECT RP.DONOR_ID,B.Blood_Group FROM RECORD_DETAILS RP
INNER JOIN BLOOD B ON RP.Blood_ID = B.Blood_ID and B.Blood_Group = 'O-') BB
ON P.Person_ID = BB.Donor_ID

SELECT * FROM DONOR_LIST_ONegative