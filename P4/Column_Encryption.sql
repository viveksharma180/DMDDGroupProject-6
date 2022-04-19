USE [Blood_Bank]
GO
CREATE MASTER KEY ENCRYPTION BY PASSWORD = N'BloodBank@123';

SELECT name KeyName, 
    symmetric_key_id KeyID, 
    key_length KeyLength, 
    algorithm_desc KeyAlgorithm
FROM sys.symmetric_keys;

CREATE CERTIFICATE Certificate_test WITH SUBJECT = 'Protect my data';
GO

SELECT name CertName, 
    certificate_id CertID, 
    pvt_key_encryption_type_desc EncryptType, 
    issuer_name Issuer
FROM sys.certificates;

CREATE SYMMETRIC KEY SymKey_test WITH ALGORITHM = AES_256 ENCRYPTION BY CERTIFICATE Certificate_test;

SELECT name KeyName, 
    symmetric_key_id KeyID, 
    key_length KeyLength, 
    algorithm_desc KeyAlgorithm
FROM sys.symmetric_keys;

---Run before
ALTER TABLE Blood_Bank.dbo.Person
ADD person_teleNo_encrypt varbinary(MAX)

--Run before

OPEN SYMMETRIC KEY SymKey_test
        DECRYPTION BY CERTIFICATE Certificate_test;

UPDATE Blood_Bank.dbo.Person
        SET person_teleNo_encrypt = EncryptByKey (Key_GUID('SymKey_test'), person_teleNo)
        FROM Blood_Bank.dbo.Person;
        GO

CLOSE SYMMETRIC KEY SymKey_test;
            GO

--Run before

SELECT * FROM Person;


---Decryption Part

OPEN SYMMETRIC KEY SymKey_test
        DECRYPTION BY CERTIFICATE Certificate_test;

SELECT person_teleNo_encrypt AS 'Encrypted data',
            CONVERT(varchar, DecryptByKey(person_teleNo_encrypt)) AS 'Decrypted tele number'
            FROM Person;