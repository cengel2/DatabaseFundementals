--Joins Exercise 1
USE [A01-School]
GO

--1.	Select Student full names and the course ID's they are registered in.
SELECT  FirstName + ' ' + LastName AS 'Full Name',
        CourseId
FROM    Student
    INNER JOIN Registration
        ON Student.StudentID = Registration.StudentID

--1.a. Select Student full names, the course ID and the course name that the students are registered in.
SELECT FirstName + ' ' + LastName AS 'Full Name', 
		C.CourseId, 
		CourseName
FROM Student S
	INNER JOIN Registration R
		ON S.StudentId =
		R.StudentID
	INNER JOIN Course C
		ON R.CourseId = 
		C.CourseId

--2.	Select the Staff full names and the Course ID’s they teach
SELECT DISTINCT -- The DISTINCT keyword will remove duplacate rows from the results
FirstName + ' ' + LastName AS 'Staff Name',
	CourseId
FROM Staff S
 INNER JOIN Registration R
	ON S.StaffID = 
	R.StaffID
	ORDER BY 'Staff Name' 

--3.	Select all the Club ID's and the Student full names that are in them
-- TODO: Student Answer Here...

SELECT FirstName + ' ' + LastName AS 'Student Name',
		ClubID
FROM Student S
	INNER JOIN Activity A
	ON S.StudentID = 
	A.StudentID

--4.	Select the Student full name, courseID's and marks for studentID 199899200.

SELECT S.FirstName + ' ' + S.LastName AS 'Student Name',
	R.CourseId,
	R.Mark
FROM Registration R
	INNER JOIN 
		Student S
		ON S.StudentId =
			R.StudentID
			WHERE S.StudentID = 199899200

--5.	Select the Student full name, course names and marks for studentID 199899200.
-- TODO: Student Answer Here...

SELECT FirstName + ' ' + LastName AS 'Student Name',
	C.CourseName,
	R.Mark
	FROM Student S
	INNER JOIN Registration R
		ON S.StudentId =
		R.StudentID
	INNER JOIN Course C
		ON R.CourseId = 
		C.CourseId
WHERE S.StudentID = 199899200

--6.	Select the CourseID, CourseNames, and the Semesters they have been taught in
-- TODO: Student Answer Here...

SELECT R.CourseId, Semester, 
		C.CourseName	
FROM Registration R
	INNER JOIN Course C
	ON C.CourseId =
	R.CourseId

--7.	What Staff Full Names have taught Networking 1?
-- TODO: Student Answer Here...

SELECT FirstName + ' ' + LastName AS 'Staff Name'
FROM Staff S
	INNER JOIN Registration R
	ON R.StaffID = S.StaffID
	INNER JOIN Course C
	ON C.CourseId = R.CourseId
	WHERE C.CourseName = 'Networking 1'

--8.	What is the course list for student ID 199912010 in semester 2001S. Select the Students Full Name and the CourseNames
-- TODO: Student Answer Here...

SELECT FirstName + ' ' + LastName AS 'Student Name',
	C.CourseName
FROM Student S
	INNER JOIN Registration R
	ON S.StudentID =
		R.StudentID
	INNER JOIN Course C
	ON C.CourseId =
		R.CourseId
WHERE R.Semester = '2001S'

--9. What are the Student Names, courseID's that have Marks >80?
-- TODO: Student Answer Here...

SELECT FirstName + ' ' + LastName AS 'Student Name',
	R.CourseId
FROM Student S
	INNER JOIN Registration R
	ON S.StudentID =
		R.StudentID
WHERE R.Mark >= 80