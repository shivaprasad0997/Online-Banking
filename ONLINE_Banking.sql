DROP DATABASE IF EXISTS Online_Banking
GO

CREATE DATABASE Online_Banking
GO

USE Online_Banking
GO
----------> To Delete Parent Table We Must Have To Delete Is Foreign Key Constraints From Child Table
IF EXISTS (SELECT * FROM sys.objects WHERE name=N'Fk_ACCOUNT_Number' AND type='F') ALTER TABLE dbo.USER_Details DROP CONSTRAINT Fk_ACCOUNT_Number
GO

IF EXISTS (SELECT * FROM sys.objects WHERE name=N'Fk_SENDER_Account_Number' AND type='F') ALTER TABLE dbo.INTRA_Tran_Details DROP CONSTRAINT Fk_SENDER_Account_Number
GO

IF EXISTS (SELECT * FROM sys.objects WHERE name=N'Fk_RECEIVER_Account_Number' AND type='F') ALTER TABLE dbo.INTRA_Tran_Details DROP CONSTRAINT Fk_RECEIVER_Account_Number
GO

/*^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^*/


/*------------********               Table for Account Details              ----------************/
IF EXISTS (SELECT * FROM sys.objects WHERE name=N'ACCOUNT' AND type='U') DROP TABLE dbo.ACCOUNT
GO

CREATE TABLE dbo.ACCOUNT
(
ACCOUNT_Number BIGINT NOT NULL,
USER_Name NVARCHAR(100) NOT NULL,
PASSWORD NVARCHAR(100) NOT NULL,
AMOUNT MONEY NOT NULL,
ACCOUNT_Type CHARACTER(10) NOT NULL,
IFSC_Code VARCHAR(50) NOT NULL,
IsActive BIT
)
GO
/**********           Primary Key For ACCOUNT_Number field                           *******************/

IF EXISTS (SELECT * FROM sys.objects WHERE name=N'Pk_ACCOUNT_Number' AND type='PK') ALTER TABLE dbo.ACCOUNT DROP CONSTRAINT Pk_ACCOUNT_Number
GO
ALTER TABLE dbo.ACCOUNT ADD CONSTRAINT Pk_ACCOUNT_Number PRIMARY KEY (ACCOUNT_Number)
GO

/**********           Unique Key For ACCOUNT_Number field                 *******************/
IF EXISTS (SELECT * FROM sys.objects WHERE name=N'Uk_ACCOUNT_Number' AND type='UQ') ALTER TABLE dbo.ACCOUNT DROP CONSTRAINT Uk_ACCOUNT_Number
GO
ALTER TABLE dbo.ACCOUNT ADD CONSTRAINT Uk_ACCOUNT_Number UNIQUE (ACCOUNT_Number)
GO


/**********           Check Constraints for ACCOUNT_Number , IFSC_Code and ACCOUNT_Type              *******************/

IF EXISTS (SELECT * FROM sys.objects WHERE name=N'CHECK_ACCOUNT_Number' AND type='C') ALTER TABLE dbo.ACCOUNT DROP CONSTRAINT CHECK_ACCOUNT_Number
GO
ALTER TABLE dbo.ACCOUNT ADD  CONSTRAINT CHECK_ACCOUNT_Number CHECK(ACCOUNT_Number LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]')
GO

IF EXISTS (SELECT * FROM sys.objects WHERE name=N'CHECK_Con_IFSC_Code_1' AND type='C') ALTER TABLE dbo.ACCOUNT DROP CONSTRAINT CHECK_Con_IFSC_Code_1
GO
ALTER TABLE dbo.ACCOUNT ADD  CONSTRAINT CHECK_Con_IFSC_Code_1 CHECK(IFSC_Code LIKE '[M][B][B][N][0-9][0-9][0-9][0-9][0-9][0-9][0-9]')
GO

IF EXISTS (SELECT * FROM sys.objects WHERE name=N'CHECK_Con_ACCOUNT_Type' AND type='C') ALTER TABLE dbo.ACCOUNT DROP CONSTRAINT CHECK_Con_ACCOUNT_Type
GO
ALTER TABLE dbo.ACCOUNT ADD  CONSTRAINT CHECK_Con_ACCOUNT_Type CHECK(ACCOUNT_Type IN ('Savings','Current','Others'))
GO

SELECT * FROM ACCOUNT
GO


/*------------********               Table for User Details              ----------************/
IF EXISTS (SELECT * FROM sys.objects WHERE name=N'USER_Details' AND type='U') DROP TABLE dbo.USER_Details
GO

CREATE TABLE dbo.USER_Details
(
CUSTOMER_Name NVARCHAR(100) NOT NULL,
CUSTOMER_Mobile_Number BIGINT NOT NULL, 
CUSTOMER_Address NVARCHAR(200) NOT NULL,
GENDER CHAR(10) NOT NULL,
DATE_Of_Birth DATE NOT NULL,
CUSTOMER_Email_Address NVARCHAR(50),
ACCOUNT_Number BIGINT NOT NULL
)
GO

/**********           Candidate Key For CUSTOMER_Name and CUSTOMER_Mobile_Number fields                         *******************/

IF EXISTS (SELECT * FROM sys.objects WHERE name=N'CDk_USER_Details' AND type='PK') ALTER TABLE dbo.USER_Details DROP CONSTRAINT CDk_USER_Details
GO
ALTER TABLE dbo.USER_Details ADD CONSTRAINT CDk_USER_Details PRIMARY KEY (CUSTOMER_Name ,CUSTOMER_Mobile_Number)
GO

/**********           Unique Key For ACCOUNT_Number field                 *******************/
IF EXISTS (SELECT * FROM sys.objects WHERE name=N'Uk_ACCOUNT_Number_1' AND type='UQ') ALTER TABLE dbo.USER_Details DROP CONSTRAINT Uk_ACCOUNT_Number_1
GO
ALTER TABLE dbo.USER_Details ADD CONSTRAINT Uk_ACCOUNT_Number_1 UNIQUE (ACCOUNT_Number)
GO

/**********           Foreign Key For ACCOUNT_Number field                 *******************/
IF EXISTS (SELECT * FROM sys.objects WHERE name=N'Fk_ACCOUNT_Number' AND type='F') ALTER TABLE dbo.USER_Details DROP CONSTRAINT Fk_ACCOUNT_Number
GO
ALTER TABLE dbo.USER_Details ADD CONSTRAINT Fk_ACCOUNT_Number FOREIGN KEY (ACCOUNT_Number) REFERENCES ACCOUNT(ACCOUNT_Number)
GO


/**********           Check Constraints for CUSTOMER_Mobile_Number,ACCOUNT_Number,GENDER and DATE_Of_Birth              *******************/

IF EXISTS (SELECT * FROM sys.objects WHERE name=N'CHECK_Con_ACCOUNT_Number_1' AND type='C') ALTER TABLE dbo.USER_Details DROP CONSTRAINT CHECK_Con_ACCOUNT_Number_1
GO
ALTER TABLE dbo.USER_Details ADD  CONSTRAINT CHECK_Con_ACCOUNT_Number_1 CHECK(ACCOUNT_Number LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]')
GO

IF EXISTS (SELECT * FROM sys.objects WHERE name=N'CHECK_Con_GENDER' AND type='C') ALTER TABLE dbo.USER_Details DROP CONSTRAINT CHECK_Con_GENDER
GO
ALTER TABLE dbo.USER_Details ADD  CONSTRAINT CHECK_Con_GENDER CHECK(gender IN ('Male','Female','Others'))
GO

IF EXISTS (SELECT * FROM sys.objects WHERE name=N'CHECK_Con_CUSTOMER_Mobile_Number' AND type='C') ALTER TABLE dbo.USER_Details DROP CONSTRAINT CHECK_Con_CUSTOMER_Mobile_Number
GO
ALTER TABLE dbo.USER_Details ADD  CONSTRAINT CHECK_Con_CUSTOMER_Mobile_Number CHECK(CUSTOMER_Mobile_Number LIKE '[6-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]')
GO

SELECT * FROM USER_Details
GO



/*          Deleting Foreign key Related Information           */
IF EXISTS (SELECT * FROM sys.objects WHERE name=N'Fk_IFSC_Code' AND type='F') ALTER TABLE dbo.ACCOUNT DROP CONSTRAINT Fk_IFSC_Code
GO

/*------------********               Table for Branch Details              ----------************/
IF EXISTS (SELECT * FROM sys.objects WHERE name=N'BRANCH_Details' AND type='U') DROP TABLE dbo.BRANCH_Details
GO

CREATE TABLE BRANCH_Details
(
IFSC_Code VARCHAR(50) NOT NULL,
BRANCH_Id INTEGER NOT NULL,
BRANCH_Name NVARCHAR(50) NOT NULL,
BRANCH_Address NVARCHAR(200) NOT NULL,
BRANCH_Manager_Id INTEGER NOT NULL
)
GO
/**********                    Primary Key For IFSC_Code field                           *******************/

IF EXISTS (SELECT * FROM sys.objects WHERE name=N'Pk_IFSC_Code' AND type='PK') ALTER TABLE dbo.BRANCH_Details DROP CONSTRAINT Pk_IFSC_Code
GO
ALTER TABLE dbo.BRANCH_Details ADD CONSTRAINT Pk_IFSC_Code PRIMARY KEY (IFSC_Code)
GO

/**********           Foreign Key For ACCOUNT_Number field In ACCOUNT Table                *******************/
IF EXISTS (SELECT * FROM sys.objects WHERE name=N'Fk_IFSC_Code' AND type='F') ALTER TABLE dbo.ACCOUNT DROP CONSTRAINT Fk_IFSC_Code
GO
ALTER TABLE dbo.ACCOUNT ADD CONSTRAINT Fk_IFSC_Code FOREIGN KEY (IFSC_Code) REFERENCES BRANCH_Details(IFSC_Code)
GO


/**********                    Unique Key For IFSC_Code field                           *******************/
IF EXISTS (SELECT * FROM sys.objects WHERE name =N'Uk_BRANCH_Id' AND type='UQ') ALTER TABLE dbo.BRANCH_Details DROP CONSTRAINT Uk_BRANCH_Id
GO
ALTER TABLE dbo.BRANCH_Details ADD CONSTRAINT Uk_BRANCH_Id UNIQUE (BRANCH_Id)
GO

/**********           Check Constraints for BRANCH_Id,IFSC_Code, and BRANCH_Manager_Id              *******************/

IF EXISTS (SELECT * FROM sys.objects WHERE name=N'CHECK_Con_IFSC_Code' AND type='C') ALTER TABLE dbo.BRANCH_Details DROP CONSTRAINT CHECK_Con_IFSC_Code
GO
ALTER TABLE dbo.BRANCH_Details ADD  CONSTRAINT CHECK_Con_IFSC_Code CHECK(IFSC_Code LIKE '[M][B][B][N][0-9][0-9][0-9][0-9][0-9][0-9][0-9]')
GO

IF EXISTS (SELECT * FROM sys.objects WHERE name=N'CHECK_Con_BRANCH_Id' AND type='C') ALTER TABLE dbo.BRANCH_Details DROP CONSTRAINT CHECK_Con_BRANCH_Id
GO
ALTER TABLE dbo.BRANCH_Details ADD  CONSTRAINT CHECK_Con_BRANCH_Id CHECK(IFSC_Code LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9]')
GO

IF EXISTS (SELECT * FROM sys.objects WHERE name=N'CHECK_Con_BRANCH_Manager_Id' AND type='C') ALTER TABLE dbo.BRANCH_Details DROP CONSTRAINT CHECK_Con_BRANCH_Manager_Id
GO
ALTER TABLE dbo.BRANCH_Details ADD  CONSTRAINT CHECK_Con_BRANCH_Manager_Id CHECK(IFSC_Code LIKE '[A-Z][0-9][0-9][0-9][0-9][0-9][0-9][0-9]')
GO



/*------------********               Table for Admin Details              ----------************/
IF EXISTS (SELECT * FROM sys.objects WHERE name=N'ADMIN_Details' AND type='U') DROP TABLE dbo.ADMIN_Details
GO

CREATE TABLE ADMIN_Details
(
ADMIN_Id INTEGER NOT NULL,
ADMIN_Name NVARCHAR(100),
ADMIN_Mobile_Number BIGINT NOT NULL,
ADMIN_User_Name NVARCHAR(100) NOT NULL,
ADMIN_Password NVARCHAR(100) NOT NULL,
ROLE NVARCHAR(20),
IsActive BIT
)
GO
/**********                    Primary Key For ADMIN_Id field                           *******************/
IF EXISTS (SELECT * FROM sys.objects WHERE name=N'Pk_ADMIN_Id' AND type='PK') ALTER TABLE dbo.ADMIN_Details DROP CONSTRAINT Pk_ADMIN_Id
GO
ALTER TABLE dbo.ADMIN_Details ADD CONSTRAINT Pk_ADMIN_Id PRIMARY KEY (ADMIN_Id)
GO


/**********                    Unique Key For ADMIN_User_Name field                           *******************/
IF EXISTS (SELECT * FROM sys.objects WHERE name=N'Uk_ADMIN_User_Name' AND type='UQ') ALTER TABLE dbo.ADMIN_Details DROP CONSTRAINT Uk_ADMIN_User_Name
GO
ALTER TABLE dbo.ADMIN_Details ADD CONSTRAINT Uk_ADMIN_User_Name UNIQUE (ADMIN_User_Name)
GO

/**********           Check Constraints for ROLE              *******************/
IF EXISTS (SELECT * FROM sys.objects WHERE name=N'CHECK_Con_ROLE' AND type='C') ALTER TABLE dbo.ADMIN_Details DROP CONSTRAINT CHECK_Con_ROLE
GO
ALTER TABLE dbo.ADMIN_Details ADD  CONSTRAINT CHECK_Con_ROLE CHECK(ROLE IN ('Manager','Employee'))
GO  

SELECT * FROM ADMIN_Details
GO



/*------------********               Table for Transaction Details              ----------************/
--> This is a FACT Table
IF EXISTS (SELECT * FROM sys.objects WHERE name=N'INTRA_Tran_Details' AND type='U') DROP TABLE INTRA_Tran_Details
GO
CREATE TABLE dbo.INTRA_Tran_Details
(
TRANSACTION_Id BIGINT NOT NULL,
TRANSACTION_Date DATE NOT NULL,
TRANSACTION_Time TIME NOT NULL,
AMOUNT MONEY NOT NULL,
SENDER_Account_Number BIGINT NOT NULL,
RECEIVER_Account_Number BIGINT NOT NULL
)
GO

/**********                    Primary Key For TRANSACTION_Id field                           *******************/
IF EXISTS (SELECT * FROM sys.objects WHERE name=N'Pk_TRANSACTION_Id' AND type='PK') ALTER TABLE dbo.INTRA_Tran_Details DROP CONSTRAINT Pk_TRANSACTION_Id
GO
ALTER TABLE dbo.INTRA_Tran_Details ADD CONSTRAINT Pk_TRANSACTION_Id PRIMARY KEY (TRANSACTION_Id)
GO


/**********           Foreign Key For SENDER_Account_Number and RECEIVER_Account_Number field's In INTRA_Tran_Details Table                *******************/
IF EXISTS (SELECT * FROM sys.objects WHERE name=N'Fk_SENDER_Account_Number' AND type='F') ALTER TABLE dbo.INTRA_Tran_Details DROP CONSTRAINT Fk_SENDER_Account_Number
GO
ALTER TABLE dbo.INTRA_Tran_Details ADD CONSTRAINT Fk_SENDER_Account_Number FOREIGN KEY (SENDER_Account_Number) REFERENCES dbo.ACCOUNT(ACCOUNT_Number)
GO

IF EXISTS (SELECT * FROM sys.objects WHERE name=N'Fk_RECEIVER_Account_Number' AND type='F') ALTER TABLE dbo.INTRA_Tran_Details DROP CONSTRAINT Fk_RECEIVER_Account_Number
GO
ALTER TABLE dbo.INTRA_Tran_Details ADD CONSTRAINT Fk_RECEIVER_Account_Number FOREIGN KEY (RECEIVER_Account_Number) REFERENCES dbo.ACCOUNT(ACCOUNT_Number)
GO

/**********           Check Constraints for SENDER_Account_Number and RECEIVER_Account_Number              *******************/
IF EXISTS (SELECT * FROM sys.objects WHERE name=N'CHECK_Con_SENDER_Account_Number' AND type='C') ALTER TABLE dbo.INTRA_Tran_Details DROP CONSTRAINT CHECK_Con_SENDER_Account_Number
GO
ALTER TABLE dbo.INTRA_Tran_Details ADD  CONSTRAINT CHECK_Con_SENDER_Account_Number CHECK(SENDER_Account_Number LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]')
GO

IF EXISTS (SELECT * FROM sys.objects WHERE name=N'CHECK_Con_RECEIVER_Account_Number' AND type='C') ALTER TABLE dbo.INTRA_Tran_Details DROP CONSTRAINT CHECK_Con_RECEIVER_Account_Number
GO
ALTER TABLE dbo.INTRA_Tran_Details ADD  CONSTRAINT CHECK_Con_RECEIVER_Account_Number CHECK(RECEIVER_Account_Number LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]')
GO  


