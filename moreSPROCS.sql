-- Stored Procedures (Sprocs)
/* *******************************************
  Each Stored Procedure has to be the first statement in a batch,
    so place a GO statement in-between each question to execute 
    the previous batch (question) and start another.
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_TYPE = N'PROCEDURE' AND ROUTINE_NAME = 'SprocName')
    DROP PROCEDURE SprocName
GO
CREATE PROCEDURE SprocName
    -- Parameters here
AS
    -- Body of procedure here
RETURN
GO
*/
USE [A01-School]
GO

-- Take the following queries and turn them into stored procedures.

-- 1.   Selects the studentID's, CourseID and mark where the Mark is between 70 and 80
SELECT  StudentID, CourseId, Mark
FROM    Registration
WHERE   Mark BETWEEN 70 AND 80 -- BETWEEN is inclusive
--      Place this in a stored procedure that has two parameters,
--      one for the upper value and one for the lower value.
--      Call the stored procedure ListStudentMarksByRange

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_TYPE = N'PROCEDURE' AND ROUTINE_NAME = 'ListStudentMarksByRange')
    DROP PROCEDURE ListStudentMarksByRange
GO
CREATE PROCEDURE ListStudentMarksByRange
    -- Parameters here
	@UpperValue decimal(5,2), @LowerValue decimal(5,2)
AS
	IF (@UpperValue IS NULL OR @LowerValue IS NULL)
	BEGIN
		RAISERROR('@UpperValue & @LowerValue are Required',16,1)
	END
	ELSE
	BEGIN
		SELECT  StudentID, CourseId, Mark
		FROM    Registration
		WHERE   Mark BETWEEN @UpperValue AND @LowerValue
	END
RETURN
GO
/* ----------------------------------------------------- */

-- 2.	Selects the Staff full names and the Course ID's they teach.
SELECT  DISTINCT -- The DISTINCT keyword will remove duplate rows from the results
        FirstName + ' ' + LastName AS 'Staff Full Name',
        CourseId
FROM    Staff S
    INNER JOIN Registration R
        ON S.StaffID = R.StaffID
ORDER BY 'Staff Full Name', CourseId
--      Place this in a stored procedure called CourseInstructors.

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_TYPE = N'PROCEDURE' AND ROUTINE_NAME = 'CourseInstructors')
    DROP PROCEDURE CourseInstructors
GO
CREATE PROCEDURE CourseInstructors
    -- Parameters here
	@StaffID smallint
AS
IF (@StaffID IS NULL)
BEGIN
	RAISERROR('@StaffID Required',16,1)
END
ELSE
BEGIN
	SELECT  DISTINCT 
			FirstName + ' ' + LastName AS 'Staff Full Name',
			CourseId
	FROM    Staff S
		INNER JOIN Registration R
			ON S.StaffID = R.StaffID
			WHERE S.StaffID = @StaffID AND R.StaffID = @StaffID
	ORDER BY 'Staff Full Name', CourseId
END
RETURN
GO

EXEC CourseInstructors 4
 

/* ----------------------------------------------------- */

-- 3.   Selects the students first and last names who have last names starting with S.
SELECT  FirstName, LastName
FROM    Student
WHERE   LastName LIKE 'S%'
--      Place this in a stored procedure called FindStudentByLastName.
--      The parameter should be called @PartialName.
--      Do NOT assume that the '%' is part of the value in the parameter variable;
--      Your solution should concatenate the @PartialName with the wildcard.
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_TYPE = N'PROCEDURE' AND ROUTINE_NAME = 'FindStudentByLastName')
    DROP PROCEDURE FindStudentByLastName
GO
CREATE PROCEDURE FindStudentByLastName
    -- Parameters here
	@PartialName varchar(35)
	AS 
	IF (@PartialName is null)		
	BEGIN
		RAISERROR('@StaffID Required',16,1)
	END
	ELSE
	BEGIN
		SELECT  FirstName, LastName
		FROM    Student
		WHERE   LastName LIKE @PartialName + '%'
	END
	RETURN
	GO
Exec FindStudentByLastName S
/* ----------------------------------------------------- */

-- 4.   Selects the CourseID's and Coursenames where the CourseName contains the word 'programming'.
SELECT  CourseId, CourseName
FROM    Course
WHERE   CourseName LIKE '%programming%'
--      Place this in a stored procedure called FindCourse.
--      The parameter should be called @PartialName.
--      Do NOT assume that the '%' is part of the value in the parameter variable.

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_TYPE = N'PROCEDURE' AND ROUTINE_NAME = 'FindCourse')
    DROP PROCEDURE FindCourse
GO
CREATE PROCEDURE FindCourse
    -- Parameters here
	@CourseName varchar(35)
	AS 
	IF (@CourseName is null)		
	BEGIN
		RAISERROR('@CourseName Required',16,1)
	END
	ELSE
	BEGIN
SELECT  CourseId, CourseName
FROM    Course
WHERE   CourseName LIKE '%' + @CourseName + '%'
	END
	RETURN
	GO
Exec FindCourse programming

/* ----------------------------------------------------- */

-- 5.   Selects the Payment Type Description(s) that have the highest number of Payments made.
SELECT PaymentTypeDescription
FROM   Payment 
    INNER JOIN PaymentType 
        ON Payment.PaymentTypeID = PaymentType.PaymentTypeID
GROUP BY PaymentType.PaymentTypeID, PaymentTypeDescription 
HAVING COUNT(PaymentType.PaymentTypeID) >= ALL (SELECT COUNT(PaymentTypeID)
                                                FROM Payment 
                                                GROUP BY PaymentTypeID)
--      Place this in a stored procedure called MostFrequentPaymentTypes.
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_TYPE = N'PROCEDURE' AND ROUTINE_NAME = 'MostFrequentPaymentTypes')
    DROP PROCEDURE MostFrequentPaymentTypes
GO
CREATE PROCEDURE MostFrequentPaymentTypes
    -- Parameters here
	@PaymentTypeDescription varchar(35)
	AS 
	IF (@PaymentTypeDescription is null)		
	BEGIN
		RAISERROR('@PaymentTypeDescription Required',16,1)
	END
	ELSE
	BEGIN
		SELECT PaymentTypeDescription
		FROM   Payment 
			INNER JOIN PaymentType 
				ON Payment.PaymentTypeID = PaymentType.PaymentTypeID
		GROUP BY PaymentType.PaymentTypeID, PaymentTypeDescription 
		HAVING COUNT(PaymentType.PaymentTypeID) >= ALL (SELECT COUNT(PaymentTypeID)
														FROM Payment
														WHERE @PaymentTypeDescription = PaymentTypeDescription 
														GROUP BY PaymentTypeID)
	END
	RETURN
	GO
	EXEC MostFrequentPaymentTypes VISA

	SELECT *
	FROM PaymentType