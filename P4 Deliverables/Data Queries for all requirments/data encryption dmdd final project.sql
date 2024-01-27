-- To encrypt and decrypt the User_Address column in the USERS table

-- Step 1: Create a Master Key

CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'YourMasterKeyPassword!';

-- Step 2: Create a Certificate

CREATE CERTIFICATE UsersCertificate WITH SUBJECT = 'User Address Encryption';

-- Step 3: Create a Symmetric Key

CREATE SYMMETRIC KEY SymmetricKey_UsersAddress
    WITH ALGORITHM = AES_256
    ENCRYPTION BY CERTIFICATE UsersCertificate;

-- Step 4: Add a Column to Store the Encrypted Data

ALTER TABLE USERS
ADD Encrypted_User_Address VARBINARY(MAX);

-- Step 5: Encrypt the Addresses

OPEN SYMMETRIC KEY SymmetricKey_UsersAddress
    DECRYPTION BY CERTIFICATE UsersCertificate;

UPDATE USERS
SET Encrypted_User_Address = EncryptByKey(Key_GUID('SymmetricKey_UsersAddress'), User_Address);

CLOSE SYMMETRIC KEY SymmetricKey_UsersAddress;

-- Step 6: Decrypt an Address

OPEN SYMMETRIC KEY SymmetricKey_UsersAddress
    DECRYPTION BY CERTIFICATE UsersCertificate;

SELECT User_ID, User_Name, CONVERT(VARCHAR(MAX), DecryptByKey(Encrypted_User_Address)) AS Decrypted_User_Address
FROM USERS;

CLOSE SYMMETRIC KEY SymmetricKey_UsersAddress;

select * from USERS