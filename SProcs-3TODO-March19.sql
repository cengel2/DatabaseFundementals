--IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_TYPE = N'PROCEDURE' AND ROUTINE_NAME = 'SprocName')
--    DROP PROCEDURE SprocName
--GO
--CREATE PROCEDURE SprocName
--    -- Parameters here
--AS
--    -- Body of procedure here
--RETURN
--GO
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_TYPE = N'PROCEDURE' AND ROUTINE_NAME = 'AddClub')
DROP PROCEDURE AddClub
go

--Add a Club
CREATE PROCEDURE AddClub
--Parameters here
--Must start with @
@ClubID varchar(10), @ClubName varchar(50)
AS
--Body of procedure
INSERT INTO Club(ClubID, ClubName)
VALUES (@ClubID, @ClubName)
--execute the procedure
EXEC AddClub 'SQL1', 'SQL DanceClub'
select * from Club
GO
sp_helptext addclub
GO
--Check for parameter values not being passed
--Add a Club
--DEFAULT the parameters to NULL so that they always have a value..
ALTER PROCEDURE AddClub
--Parameters here
--Must start with @
@ClubID varchar(10)=NULL, @ClubName varchar(50)=NULL
AS
--Body of procedure
if @ClubID IS NULL OR @ClubName IS NULL
	BEGIN
	RAISERROR('ClubID and ClubID are Required',16,1) -- 16,1 identify the error level
	END
ELSE
	BEGIN
	INSERT INTO Club(ClubID, ClubName)
	VALUES (@ClubID, @ClubName)
	END
RETURN
GO
EXEC AddClub 'SQL1', 'SQL DanceClub'
select * from Club
GO
sp_helptext addclub
GO
-- 2. Create a stored procedure that will change the mailing address for a student. Call it ChangeMailingAddress.
--    Make sure all the parameter values are supplied before running the UPDATE (ie: no NULLs).
-- sp_help Student
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_TYPE = N'PROCEDURE' AND ROUTINE_NAME = 'ChangeMailingAddress')
    DROP PROCEDURE ChangeMailingAddress
GO
CREATE PROCEDURE ChangeMailingAddress
    -- Parameters here
    @StudentId  int,
    @Street     varchar(35), -- Model the type/size of parameters to match what's needed in the database tables
    @City       varchar(30),
    @Province   char(2),
    @PostalCode char(6)
AS
    -- Body of procedure here
    -- Validate
    IF (@StudentId IS NULL OR @Street IS NULL OR @City IS NULL OR @Province IS NULL or @PostalCode IS NULL)
    BEGIN --  { A...
        RAISERROR('All parameters require a value (NULL is not accepted)', 16, 1)
    END   -- ...A }
    ELSE
    BEGIN -- { B...
        UPDATE  Student
        SET     StreetAddress = @Street
               ,City = @City
               ,Province = @Province
               ,PostalCode = @PostalCode
        WHERE   StudentId = @StudentId 
    END   -- ...B }
RETURN
--execute the procedure

-- 3. Create a stored procedure that will remove a student from a club. Call it RemoveFromClub.

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_TYPE = N'PROCEDURE' AND ROUTINE_NAME = 'RemoveFromClub')
    DROP PROCEDURE RemoveFromClub
GO
CREATE PROCEDURE RemoveFromClub
    -- Parameters here
	@StudentID int=NULL,
	@ClubID varchar(10)=NULL
AS
    -- Body of procedure here
	--Validate
	IF (@StudentID IS NULL OR @ClubID IS NULL)
	BEGIN
		RAISERROR('All parameters require a value (NULL is not accepted)', 16, 1)
	END
	ELSE
	BEGIN
			DELETE FROM Activity 
	WHERE @StudentID = StudentID AND @ClubID = ClubId
	END
GO

EXEC RemoveFromClub 
go

SELECT *
FROM Activity

-- Query-based Stored Procedures
-- 4. Create a stored procedure that will display all the staff and their position in the school.200495500
--    Show the full name of the staff member and the description of their position.
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_TYPE = N'PROCEDURE' AND ROUTINE_NAME = 'DisplayStaffPosition')
    DROP PROCEDURE DisplayStaffPosition
GO
CREATE PROCEDURE DisplayStaffPosition
    -- Parameters here
AS
	SELECT FirstName + ' ' + LastName AS 'Staff Name',
		   P.PositionDescription
	FROM Staff S
	INNER JOIN Position P ON P.PositionID = S.PositionID
    -- Body of procedure here
RETURN
GO
EXEC DisplayStaffPosition
GO
-- 5. Display all the final course marks for a given student. Include the name and number of the course
--    along with the student's mark.

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_TYPE = N'PROCEDURE' AND ROUTINE_NAME = 'DiplayFinalCourseMarks')
    DROP PROCEDURE DiplayFinalCourseMarks
GO
CREATE PROCEDURE DiplayFinalCourseMarks
    -- Parameters here
	@StudentID int=NULL
AS
    -- Body of procedure here
	--Validate
	IF (@StudentID IS NULL)
	BEGIN
		RAISERROR('StudentID is required for procedure',16,1)
	END
	ELSE
	BEGIN
		SELECT R.Mark AS 'Final Mark', C.CourseName
		FROM Registration R
		INNER JOIN Course C ON C.CourseId = R.CourseId
		WHERE @StudentID = R.StudentID
	END
	RETURN
GO

EXEC DiplayFinalCourseMarks 199899200
GO

-- 6. Display the students that are enrolled in a given course on a given semester.
--    Display the course name and the student's full name and mark.
SELECT * FROM Registration

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_TYPE = N'PROCEDURE' AND ROUTINE_NAME = 'StudentsEnrolledInSemester')
    DROP PROCEDURE StudentsEnrolledInSemester
GO
CREATE PROCEDURE StudentsEnrolledInSemester
    -- Parameters here
	@CourseId char(7)=NULL,
	@Semester char(5)=NULL
AS
    -- Body of procedure here
	--Validate
	IF (@CourseId IS NULL OR @Semester IS NULL)
	BEGIN
		RAISERROR('@CourseId AND @Semester is required for this procedure',16,1)
	END
	ELSE
	BEGIN
		SELECT C.CourseName,
		       FirstName + ' ' + LastName AS 'Student Name',
			   Mark AS 'Student Mark',
			   Semester 
		FROM Registration R
		INNER JOIN Course C ON C.CourseId = R.CourseId
		INNER JOIN Student S ON S.StudentID = R.StudentID 
		WHERE @CourseId = R.CourseId AND @Semester = Semester
	END
	RETURN
GO

EXEC StudentsEnrolledInSemester @CourseId = 'DMIT172', @Semester = '2001J'
GO



-- 7. The school is running out of money! Find out who still owes money for the courses they are enrolled in.
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_TYPE = N'PROCEDURE' AND ROUTINE_NAME = 'StudentsOwing')
    DROP PROCEDURE StudentsOwing
GO
CREATE PROCEDURE StudentsOwing
    -- Parameters here
	@StudentID int=NULL
AS
    -- Body of procedure here
	--Validate
	IF (@StudentID IS NULL)
	BEGIN
		RAISERROR('@StudentID is required for this procedure',16,1)
	END
	ELSE
	BEGIN
		SELECT BalanceOwing, CourseId, R.StudentID
		FROM Student S
		inner join Registration R ON R.StudentID = S.StudentID
		WHERE @StudentID = R.StudentID
	END
	RETURN
GO

EXEC StudentsOwing @StudentID = 199899200
GO