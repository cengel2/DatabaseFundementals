# **SQL** - *Strctured Query Language*
## **Textual Data Types**
-  **char** - *fixed length string*
    - ***nchar***  
- **varchar** - *variable length string* 
    - ***nvarchar***  
- **text**
    - ***ntext*** 
-----------------------------------------
## **Numeric Data Types**

- **tinyint**
- **smallint**
- **int**
- **bigint**
    - **decimal** - *exact value*
    - **real** - *approximate value*
    - **float** - *approximate value*
    - **numeric** - *exact value*
        - **money**
        - **smallmoney**    
-----------------------------------------
## **Conceptual Data Types** 

- **bit**
- **datetime** - ***datetime2***
- **smalldatetime**
    - **date**
    - **time**     
    - ### *Binary Large Objects*
        - **image**
        - **binary**
        - **varbinary**
-----------------------------------------

## Syntax - Create Table - *use a plural name for your table*
       CREATE TABLE
       (
       --column definitions 
        --> comma separated list of ColumnDefinitions & Table Constraints
       )
       ColumnName datatype [NULL | NOT NULL]
        [Constraints]
-----------------------------------------
## DataBase
- *Where the data & meta-data is stored*
## Database Server
- *Database server is on as long as the computer is on*
- *Computer*
-----------------------------------------
## SQL Server Management Studio SSMS
        /* *************************************************
        *Simple Tble Creation - Columns and Primary Keys
        *
        *Emergency Service & Product
        *Specification Document 1
        *Version 1.0.0
        *
        *Author: Dan Gilleland
        *************************************** */
        -- Select the CREATE DATABASE statement below to create the demo database.
        -- CREATE DATABASE [ESB-Db-A01]

        USE [ESB-Db-A01] -- this is a statement that tells us to switch to a particular database
        --Notice in the database name above, it is wrapped in square brackets 
        --because the name has a hyphen in it.
        --For all our other objects(tables, columns, etc), we won't use hyphens or spaces, so
        --the use of brackets are optional.

        GO -- this statement helps to -separate- various DDL statements in out script 
            --so that they are executed as "blocks" of code

        -- To create a database table, we use the CREATE TABLE statement.
        -- Note that the order in which we create/drop tables is important
        -- because of how the tables are related via Forien Key.

        /* DROP TABLE statements (to "clean up" the database for re-creation) */
        IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Orders')
            DROP TABLE Orders
        IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Customers')
            DROP TABLE Customers

        Create table Customers
        (
            --The body of a CREATE TABLE will identify a comma-separated list of
            --Column Declarations and Table Constraints.
            CustomerNumber int,
            FirstName varchar(50),
            LastName varchar(50),
            Address varchar(40),
            City varchar(35),
            Province char(2),
            PostalCode char(6),
            PhoneNumber char(13)
        )
        CREATE TABLE Orders
        (
            OrderNumber	int,
            CustomerNumber int,
            Date datetime,
            Subtotal money,
            GST money,
            Total money
        )

