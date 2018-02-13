/* **********************************************
 * Simple Table Creation - Columns and Primary Keys
 *
 * Emergency Service & Product
 * Specification Document 1
 * Version 1.0.0
 *
 * Author: Dan Gilleland
 ********************************************** */

-- Select the CREATE DATABASE stement below to create the demo database.
--CREATE DATABASE [ESP-A01]

USE [ESP-A01] -- this is a statement that tells us to switch to a particular database
-- Notice in the database name above, it is "wrapped" in square brackets because 
-- the name had a hypen in it. 
-- For all our other objects (tables, columns, etc), we won't use hypens or spaces, so
-- the use of square brackets are optional.
GO  -- this statement helps to "separate" various DDL statements in our script
    -- so that they are executed as "blocks" of code.

/* DROP TABLE statements (to "clean up" the database for re-creation)  */
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'OrderDetails')
    DROP TABLE OrderDetails
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'InventoryItems')
    DROP TABLE InventoryItems
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Orders')
    DROP TABLE Orders
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Customers')
    DROP TABLE Customers



-- To create a database table, we use the CREATE TABLE statement.
-- Note that the order in which we create/drop tables is important
-- because of how the tables are related via Foreign Keys.
CREATE TABLE Customers



(
    -- The body of a CREATE TABLE will identify a comma-separated list of
    -- Column Declarations and Table Constraints.
    CustomerNumber  int
        -- The following is a PRIMARY KEY constraint that has a specific name
        -- Primary Key constraints ensure a row of data being added to the table
        -- will have to have a unique value for the Primary Key column(s)
        CONSTRAINT PK_Customers_CustomerNumber
            PRIMARY KEY
        -- IDENTITY means the database will generate a unique whole-number
        -- value for this column
        IDENTITY(100, 1) -- The first number is the "seed",
                         -- and the last number is the "increment"
                                        NOT NULL, -- NOT NULL means the data is required
    FirstName       varchar(50)         NOT NULL,
    LastName        varchar(60)         NOT NULL,
    [Address]       varchar(40)         NOT NULL,
    City            varchar(35)         NOT NULL,
    Province        char(2)
        CONSTRAINT DF_Customers_Province
            DEFAULT ('AB')
        CONSTRAINT CK_Customers_Province
            CHECK (Province = 'AB' OR
                   Province = 'BC' OR
                   Province = 'SK' OR
                   Province = 'MB' OR
                   Province = 'QC' OR
                   Province = 'ON' OR
                   Province = 'NT' OR
                   Province = 'NS' OR
                   Province = 'NB' OR
                   Province = 'NL' OR
                   Province = 'YK' OR
                   Province = 'NU' OR
                   Province = 'PE')
                                    NOT NULL,
    PostalCode      char(6)
        CONSTRAINT CK_Customers_PostalCode
            CHECK (PostalCode LIKE '[A-Z][0-9][A-Z][0-9][A-Z][0-9]')
                                    NOT NULL,
    PhoneNumber     char(13)
        CONSTRAINT CK_Customers_PhoneNumber
            CHECK (PhoneNumber LIKE '([0-9][0-9][0-9])[0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]')
                                        NULL  -- NULL means the data is optional
)

CREATE TABLE Orders
(
    OrderNumber     int
        CONSTRAINT PK_Orders_OrderNumber
            PRIMARY KEY
        IDENTITY(200, 1)                NOT NULL,
    CustomerNumber  int
        -- Foreign Key constraints ensure that when a row of data is being
        -- inserted or updated, there is a row in the referenced table
        -- that has the same value as its Primary Key
        CONSTRAINT FK_Orders_CustomerNumber_Customers_CustomerNumber
            FOREIGN KEY REFERENCES
            Customers(CustomerNumber)   NOT NULL,
    [Date]          datetime            NOT NULL,
    Subtotal        money
        CONSTRAINT CK_Orders_Subtotal
            CHECK (Subtotal > 0)        NOT NULL,
    GST             money
        CONSTRAINT CK_Orders_GST
            CHECK (GST >= 0)            NOT NULL,
    Total           AS Subtotal + GST   -- This is now a Computed Column
)

Create TABLE InventoryItems
	(
		ItemNumber		varchar(5)
			CONSTRAINT PK_InventoryItems_ItemNumber
				PRIMARY KEY						NOT NULL,
		ItemDescription		varchar(50)				NULL,
		CurrentSalePrice	money
			CONSTRAINT CK_InventoryItems_CurrentSalePrice
				CHECK (CurrentSalePrice > 0)	NOT NULL,
		InStockCount		int					NOT NULL,
		RecorderLevel		int					NOT NULL
	)

Create TABLE OrderDetails
(
	OrderNumber		int
		CONSTRAINT FK_OrderDetails_OrderNumber_Orders_OrderNumber
			FOREIGN KEY REFERENCES
			Orders(OrderNumber)		NOT NULL,
	ItemNumber		varchar(5)
		CONSTRAINT FK_Orderdetails_ItemNumber_InventoryItems_ItemNumber
		FOREIGN KEY REFERENCES
		InventoryItems(ItemNumber)	NOT NULL,
		Quantity		int
			CONSTRAINT DF_OrderDetails_Quantity
				DEFAULT	(1)
			CONSTRAINT CK_OrderDetails_Quantity
				CHECK	(Quantity > 0)	NOT NULL,
		SellingPrice	money
			CONSTRAINT CK_OrderDetails_sellingPrice
				CHECK	(SellingPRice >= 0)	NOT NULL,
	--The amount column is a CALCULATED (or "derived") column.
	--It's value is the result of multiplying Quantity by SellingPrice.
		Amount		AS Quantity * SellingPrice							
	-- TODO: Quantity and SellingPrice nd Amount columns
	-- The following is a table Constraint
	-- A composite primary key MUST be dibe as a Table Constraint
	-- because it involves two or more columns
	CONSTRAINT PK_OrderDetails_OrderNumber_ItemNumber
		PRIMARY KEY (OrderNumber, ItemNumber) -- Specify all the columns in the PK
 )

 -- A) Allow Address, City, Province, and PostalCode to be NULL
 --  SQL requires each column to be altered "separately" 
 ALTER TABLE Customers
	ALTER COLUMN [Address] varchar(40) NULL
GO -- This statement helps to separate various ddl staements in out script. It is optional.

ALTER TABLE Customers
	ALTER COLUMN City varchar(35) NULL
GO
ALTER TABLE Customers
	ALTER COLUMN Province char(2) NULL
GO 

ALTER TABLE Customers
	ALTER COLUMN PostalCode char(6) NULL
GO 
-- B) Add a check constraint on the First and LLast name to require at least two letters.
--  % is a wildcard for zero or more charachters (letter, digit, or others)
-- _ IS A WILDCARD FOR A SINGLE CHARACHTER
-- [] are used to represent a range or set of characters that are allowed

IF OBJECT_ID('CK_Customers_FirstName', 'C') IS NOT NULL
	ALTER TABLE Customers DROP CONSTRAINT CK_Customers_FirstName

ALTER TABLE Customers
	ADD CONSTRAINT CK_Customers_FirstName
		CHECK (FirstName LIKE '[A-Z][A-Z]%')
-- C) Add a default constraint on the Orders.Date column to use the current date.
--GETDATE() is a global function in the SQL server database
--GETDATE() will obtail the current date/time on the database server
IF OBJECT_ID('DF_Orders_Date', 'C') IS NOT NULL
	ALTER TABLE Orders DROP CONSTRAINT DF_Orders_Date

ALTER TABLE Orders
	ADD CONSTRAINT DF_Orders_Date
		DEFAULT GETDATE() FOR [Date]

GO
--d) Change the Inventory.ItemDescription Column to be NOT NULL
-- WAIT!! We have described ItemDescription as ALLOWING null VALUES.
--		that maes we might have data in the table where the
--		item description doesn't exist.
--		if we try to make  that column NOT NULL, what will we do about it
--		the existing data on a database where it is empty "EMPTY"??
--		We can fix that by updating the data in the database
--		where the description is missing.
UPDATE		InventoryItems
	SET		ItemDescription = '-missing-'
	WHERE	ItemDescription IS NULL
GO
-- Now we can change the ItemDescription to be required (NOT NULL)

ALTER TABLE InventoryItems
	ALTER COLUMN ItemDescription varchar(50) NOT NULL
GO
-- E) Add indexes to the Cutomers First and Last Name columns
--	as well as to the Item's Description column.
--Indexes improve the performance of the database when retrieving information.
CREATE NONCLUSTERED INDEX IX_Customers_FirstName
	ON Customers (FirstName)
CREATE NONCLUSTERED INDEX IX_Customers_LastName
	ON Customers (LastName)
CREATE NONCLUSTERED INDEX IX_InventoryItems_ItemDescription
	ON InventoryItems (ItemDescription)
GO -- End of a batch of instructions

-- Let's insert a few rows of data for the tables
PRINT 'Inserting customer data'
INSERT INTO Customers(FirstName, LastName, [Address], City, PostalCode)
    VALUES ('Clark', 'Kent', '344 Clinton Street', 'Metropolis', 'S0S0N0')
INSERT INTO Customers(FirstName, LastName, [Address], City, PostalCode)
    VALUES ('Jimmy', 'Olsen', '242 River Close', 'Bakerline', 'B4K3R1')


PRINT 'Inserting an order'
INSERT INTO Orders(CustomerNumber, [Date], Subtotal, GST)
    VALUES (100, GETDATE(), 17.45, 0.87)