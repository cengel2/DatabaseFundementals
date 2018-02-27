USE [A01-School]

--Simple Select Exercise 3
-- This sample set illustrates the GROUP BY syntax and the use of Aggregate functions
-- with GROUP BY.
-- It also demonstrates the HAVING clause to filter on aggregate values.
USE [A01-School]
GO


--1. Select the average mark for each course. Display the CourseID and the average mark
SELECT AVG(Mark) as 'Average Mark'
FROM Registration
GROUP BY CourseId
--2. How many payments where made for each payment type. Display the Payment Type ID and the count
SELECT COUNT(PaymentID)
FROM Payment
GROUP BY PaymentTypeID

--3. Select the average Mark for each studentID. Display the StudentId and their average mark
-- TODO: Student Answer Here....
SELECT AVG(Mark)
FROM Registration
GROUP BY StudentID

--4. Select the same data as question 3 but only show the studentID's and averages that are > 80
SELECT AVG(Mark)
FROM Registration
GROUP BY StudentID
HAVING AVG(Mark) > 80   

--5. How many students are from each city? Display the City and the count.
SELECT Count(StudentID)
FROM Student
GROUP BY City

--6. Which cities have 2 or more students from them? (HINT, remember that fields that we use in the where or having do not need to be selected.....)
SELECT Count(StudentID)
FROM Student
GROUP BY City

--7. What is the highest, lowest and average payment amount for each payment type? 
SELECT MAX(Amount), MIN(Amount), AVG(Amount)
FROM Payment
GROUP BY PaymentTypeID


--8. How many students are there in each club? Show the clubID and the count
-- TODO: Student Answer Here....
SELECT ClubId, COUNT(StudentID)
FROM Activity
GROUP BY ClubId
--9. Which clubs have 3 or more students in them?
-- TODO: Student Answer Here....
SELECT ClubId, COUNT(StudentID)
FROM Activity
GROUP BY ClubId
HAVING COUNT(StudentID) >= 3