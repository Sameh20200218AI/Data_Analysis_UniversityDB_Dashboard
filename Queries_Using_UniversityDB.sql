USE UniversityDB;


-- Retrieve all student details
SELECT * FROM Students;

SELECT * FROM Departments;

SELECT * FROM Courses;

SELECT * FROM Professors;

SELECT * FROM Enrollments;

SELECT * FROM Attendance;


-- Retrieve the first name, last name, and department ID for each student
SELECT FirstName, LastName, DepartmentID FROM Students;

-- Retrieve all details of courses worth 3 credits
SELECT * FROM Courses WHERE Credits = 3;

-- List the names of all professors in alphabetical order
SELECT FirstName, LastName FROM Professors ORDER BY LastName;

-- Find all students who enrolled after 2021
SELECT * FROM Students WHERE EnrollmentYear > 2021;

-- Retrieve all students in the "Computer Science" department
SELECT * FROM Students 
WHERE DepartmentID = (SELECT DepartmentID FROM Departments WHERE DepartmentName = 'Computer Science');

-- Another Query
SELECT * FROM Students , Departments
WHERE Students.DepartmentID = Departments.DepartmentID AND Departments.DepartmentName ='Computer Science';

-- List students who were enrolled earliest and StudentID
SELECT * FROM Students ORDER BY EnrollmentYear,StudentID ;

-- Count the number of students in each department
SELECT DepartmentID, COUNT(StudentID) AS StudentCount
FROM Students
GROUP BY DepartmentID;

-- Find the count of students in the Mathematics department
SELECT COUNT(Students.StudentID) AS Number_OF_Students
FROM Students 
WHERE Students.DepartmentID = (SELECT Departments.DepartmentID FROM Departments WHERE Departments.DepartmentName='Mathematics');

-- Show total courses taught by each professor
SELECT ProfessorID , COUNT(Courses.CourseID) AS Number_Of_Courses
FROM Courses
GROUP BY ProfessorID ;

-- List all students with the courses they are enrolled in
SELECT Students.StudentID, Students.FirstName, Courses.CourseName
FROM Students
JOIN Enrollments ON Students.StudentID = Enrollments.StudentID
JOIN Courses ON Enrollments.CourseID = Courses.CourseID;

-- List each professor with the courses they teach
SELECT Professors.FirstName, Professors.LastName, Courses.CourseName
FROM Professors
JOIN Courses ON Professors.ProfessorID = Courses.ProfessorID;

-- Find departments for each student by joining Students and Departments
SELECT Students.FirstName, Students.LastName, Departments.DepartmentName
FROM Students
JOIN Departments ON Students.DepartmentID = Departments.DepartmentID;


-- List students enrolled in courses taught by a specific professor
SELECT * FROM Students
WHERE StudentID IN (
    SELECT StudentID FROM Enrollments 
    WHERE CourseID IN (SELECT CourseID FROM Courses WHERE ProfessorID = 1));


-- Find departments with more than 50 students
SELECT DepartmentID
FROM Students
GROUP BY DepartmentID
HAVING COUNT(StudentID) > 50;


-- List students who attended all classes for a specific course
SELECT * FROM Students
WHERE StudentID IN (
    SELECT StudentID FROM Attendance WHERE CourseID = 1 AND Status = 'Present'
);

-- Update a student's department
UPDATE Students
SET DepartmentID = 2
WHERE StudentID = 1;

-- Delete an enrollment record
DELETE FROM Enrollments
WHERE StudentID = 1 AND CourseID = 2;

-- Display students with Enrollment Year categories 
SELECT FirstName, LastName,
CASE 
    WHEN EnrollmentYear = 2018 THEN '2018'
    WHEN EnrollmentYear = 2020 THEN '2020'
    ELSE '2019| 2021| 2022| 2023 '
END AS EnrollmentYear_Category
FROM Students;

-- Display courses with enrollment categories
SELECT CourseName,
CASE 
    WHEN (SELECT COUNT(*) FROM Enrollments WHERE Enrollments.CourseID = Courses.CourseID) > 50 THEN 'High Enrollment'
    ELSE 'Low Enrollment'
END AS EnrollmentCategory
FROM Courses;

-- Find students who are not enrolled in any course
SELECT * FROM Students
LEFT JOIN Enrollments ON Students.StudentID = Enrollments.StudentID
WHERE Enrollments.CourseID IS NULL;

-- List courses that have no professor assigned
SELECT * FROM Courses WHERE ProfessorID IS NULL;

-- Ensure all enrollments have valid students and courses (orphan check)
SELECT * FROM Enrollments
WHERE StudentID NOT IN (SELECT StudentID FROM Students)
   OR CourseID NOT IN (SELECT CourseID FROM Courses);



-- Combine students and professors into a single list (name only)
SELECT FirstName, LastName FROM Students
UNION
SELECT FirstName, LastName FROM Professors;


-- Find common courses between two students
SELECT CourseID FROM Enrollments WHERE StudentID = 1
INTERSECT
SELECT CourseID FROM Enrollments WHERE StudentID = 2;


-- List professors with the number of unique courses they have taught and the number of students they have taught across all courses
SELECT p.ProfessorID, p.FirstName, p.LastName,
       COUNT(DISTINCT c.CourseID) AS CoursesTaught,
       COUNT(DISTINCT e.StudentID) AS StudentsTaught
FROM Professors AS p
JOIN Courses AS c ON p.ProfessorID = c.ProfessorID
JOIN Enrollments AS e ON c.CourseID = e.CourseID
GROUP BY p.ProfessorID, p.FirstName, p.LastName;



-- Count students by enrollment year, categorizing them as "Recent" (2021+), "Mid" (2015-2020), and "Old" (before 2015)
SELECT
    CASE 
        WHEN EnrollmentYear >= 2021 THEN 'Recent'
        WHEN EnrollmentYear BETWEEN 2015 AND 2020 THEN 'Mid'
        ELSE 'Old'
    END AS EnrollmentCategory,
    COUNT(StudentID) AS StudentCount
FROM Students
GROUP BY EnrollmentYear;


SELECT ProfessorID, COUNT(DISTINCT CourseID) AS UniqueCourses FROM Courses
GROUP BY ProfessorID;


--Retrieve the course name and the number of students enrolled in each course
SELECT c.CourseName, COUNT(e.StudentID) AS Enrollments FROM Courses AS c
LEFT JOIN Enrollments AS e ON c.CourseID = e.CourseID
GROUP BY c.CourseName;




