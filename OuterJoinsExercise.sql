--Think of joining tables as creating a bigger/mega/huge table of data
--INNER JOIN - Data must exist in both of the tables
--OUTER JOIN - Data only has to exist in one of the joined tables
		--LEFT OUTER JOIN --> You can do (almost) everything with LEFT OUTER JOIN
		--RIGHT OUTER JOIN 
		--FULL OUTER JOIN
--Joining tables (almost) always has a multiplying effect... 
		-- on the overall number of rows in the resulting data set... 

--Outer Joins Exercise
USE [A01-School]
GO

--1. Select All position descriptions and the staff ID's that are in those positions
SELECT  PositionDescription, StaffID
FROM    Position P -- Start with the Position table, because I want ALL position descriptions...
    LEFT OUTER JOIN Staff S ON P.PositionID = S.PositionID

--2. Select the Position Description and the count of how many staff are in those positions. Return the count for ALL positions.
--HINT: Count can use either count(*) which means records or a field name. Which gives the correct result in this question?
SELECT  PositionDescription,
        COUNT(StaffID) AS 'Number of Staff'
FROM    Position P
    LEFT OUTER JOIN Staff S ON P.PositionID = S.PositionID
GROUP BY P.PositionDescription
-- but -- The following version gives the WRONG results, so just DON'T USE *  !
SELECT PositionDescription, 
       Count(*) -- this is counting the WHOLE row (not just the Staff info)
FROM   Position P
    LEFT OUTER JOIN Staff S
        ON P.PositionID = S.PositionID
GROUP BY P.PositionDescription

--3. Select the average mark of ALL the students. Show the student names and averages.
SELECT  FirstName  + ' ' + LastName AS 'Student Name',
        AVG(Mark) AS 'Average'
FROM    Student S
    LEFT OUTER JOIN Registration R
        ON S.StudentID  = R.StudentID
GROUP BY FirstName, LastName

--4. Select the highest and lowest mark for each student. 
SELECT  FirstName  + ' ' + LastName AS 'Student Name',
        MAX(Mark) AS 'Highest',
		MIN(Mark) 'Lowest'
FROM    Student S
    LEFT OUTER JOIN Registration R
        ON S.StudentID  = R.StudentID
GROUP BY FirstName, LastName

--5. How many students are in each club? Display club name and count.
 -- TODO: Student Answer Here...

SELECT ClubName, COUNT(StudentID) AS 'Students In Club'
FROM Club C
	LEFT OUTER JOIN Activity A ON A.ClubId = C.ClubId
	GROUP BY COUNT(StudentID)