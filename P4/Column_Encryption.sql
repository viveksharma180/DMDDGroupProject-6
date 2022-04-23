USE [Blood_Bank]
GO
CREATE MASTER KEY ENCRYPTION BY PASSWORD = N'BloodBank@123';

SELECT name KeyName, 
    symmetric_key_id KeyID, 
    key_length KeyLength, 
    algorithm_desc KeyAlgorithm
FROM sys.symmetric_keys;
GO

CREATE CERTIFICATE Certificate_test WITH SUBJECT = 'Protect my data';
GO

SELECT name CertName, 
    certificate_id CertID, 
    pvt_key_encryption_type_desc EncryptType, 
    issuer_name Issuer
FROM sys.certificates;
GO

CREATE SYMMETRIC KEY SymKey_test WITH ALGORITHM = AES_256 ENCRYPTION BY CERTIFICATE Certificate_test;
GO

SELECT name KeyName, 
    symmetric_key_id KeyID, 
    key_length KeyLength, 
    algorithm_desc KeyAlgorithm
FROM sys.symmetric_keys;
GO

---Run before
ALTER TABLE Blood_Bank.dbo.System_Admin
ADD username_encrypt varbinary(MAX)
GO

ALTER TABLE Blood_Bank.dbo.System_Admin
ADD password_encrypt varbinary(MAX)
GO

--Run before

OPEN SYMMETRIC KEY SymKey_test
        DECRYPTION BY CERTIFICATE Certificate_test;
GO

UPDATE Blood_Bank.dbo.System_Admin
        SET username_encrypt = EncryptByKey (Key_GUID('SymKey_test'), username)
        FROM Blood_Bank.dbo.System_Admin;
        GO

UPDATE Blood_Bank.dbo.System_Admin
        SET password_encrypt = EncryptByKey (Key_GUID('SymKey_test'), password)
        FROM Blood_Bank.dbo.System_Admin;
        GO

CLOSE SYMMETRIC KEY SymKey_test;
            GO

--Run before

SELECT * FROM System_Admin;
GO

---Decryption Part

OPEN SYMMETRIC KEY SymKey_test
        DECRYPTION BY CERTIFICATE Certificate_test;
        GO

SELECT username_encrypt AS 'Encrypted data',
            CONVERT(varchar, DecryptByKey(username_encrypt)) AS 'Decrypted username'
            FROM System_Admin;
            GO
SELECT password_encrypt AS 'Encrypted data',
            CONVERT(varchar, DecryptByKey(password_encrypt)) AS 'Decrypted password'
            FROM System_Admin;
            GO
            
CLOSE SYMMETRIC KEY SymKey_test;
            GO
