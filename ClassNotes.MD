# ***February 5, 2018***

## Creating Constriants 

### **PRIMARY KEY - PK**

-	*The following is a PRIMARY KEY constraint that has a specific name, PK constraints ensure a row of data being added to the table, 
                will have to have a unique value for the PK column(s)*
                            
                            - CustomerNumber int
                                CONSTRAINT PK_Customers_CustomerNumber
                                    PRIMARY KEY 
### **IDENTITY**

- *IDENTITY means the database will generate a unique whole-number value for this column.
The first number is the "SEED" and the last number is the "INCREMENT"*
            
            -  OrderNumber	int
				CONSTRAINT PK_Orders_OrderNumber
					PRIMARY KEY
					IDENTITY(200,1) 
-----------------------------------------
### ***Inserting a few rows of Data into a table***
 
            - PRINT 'Inserting Customer Data'
                 
                 - INSERT INTO Customers(FirstName,LastName,[Address], City, Province, PostalCode)
                	 VALUES('Clark', 'Kent', '344 Clinton Street', 'Metropolis', 'DE', 'S0S0N0')
                 
                 - INSERT INTO Customers(FirstName,LastName,[Address], City, Province, PostalCode)
                	 VALUES('Jimmy', 'Olson', '242 River Close', 'Bakerline', 'DE', 'B4K3R1') 
-----------------------------------------
### ***FORIEGN KEY - FK***
-    *Foreign Key constraints ensure that when a row of data is being inserted or updated, 
    there is a row in the referenced table 
    that has the same value as its primary key*
                            
           - CustomerNumber int
			    CONSTRAINT FK_Orders_CustomerNumber_Customers_CustomerNumber
				    FOREIGN KEY REFERENCES				
		    
           - Customers(CustomerNumber)	NOT NULL,
           - [Date] datetime					NOT NULL,
           - Subtotal money					NOT NULL,
           - GST money						NOT NULL,
           - Total AS Subtotal + GST
    
        - *Use 'AS' to display attributes that are made up by other attribute such as Total*            
-----------------------------------------
### ***CHECK - CK***
            -  Subtotal money
					CONSTRAINT CK_ORDERS_Subtotal
					    CHECK (Subtotal > 0)	    NOT NULL,
                
            -  GST money
				    CONSTRAINT CK_ORDERS_GST
				        CHECK (GST >= 0)			NOT NULL,

            - PostalCode char(6)
				CONSTRAINT CK_Customers_PostalCode
					CHECK (PostalCode LIKE '[A-Z][0-9][A-Z][0-9][A-Z][0-9]')					
                                                    NOT NULL,

           -  PhoneNumber char(13)
				CONSTRAINT CK_Customers_PhoneNumber
					CHECK (PhoneNumber LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]')
												NULL -- NULL means data is optional.

          -  Province char(2)
				CONSTRAINT DF_Customers_Province
					DEFAULT ('AB')
				CONSTRAINT CK_Customers_Province
					CHECK  (Province = 'AB' OR
							Province = 'BC' OR
							Province = 'SK' OR
							Province = 'MB' OR
							Province = 'QC' OR
							Province = 'ON' OR
							Province = 'NT' OR
							Province = 'NB' OR
							Province = 'NL' OR
							Province = 'YK' OR
							Province = 'NU' OR
							Province = 'PE')					
												NOT NULL,                                                                               
-----------------------------------------
### ***DEFAULT - DF***

            - Province char(2)
				CONSTRAINT DF_Customers_Province
				DEFAULT ('AB')					NOT NULL,						













-----------------------------------------
# ***February 1, 2018***
## **SQL** - *Strctured Query Language*
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

