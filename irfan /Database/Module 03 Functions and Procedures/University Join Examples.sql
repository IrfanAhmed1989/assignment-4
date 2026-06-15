USE University;

SELECT count(*)
FROM takes;

SELECT count(*)
FROM course;

--

SELECT DISTINCT takes.course_id, course.title
FROM takes
LEFT JOIN course on course.course_id = takes.course_id;

SELECT DISTINCT takes.course_id, course.title
FROM takes
RIGHT JOIN course on course.course_id = takes.course_id;

--

SELECT course.course_id, course.title, count(takes.ID)
FROM course
LEFT JOIN takes on course.course_id = takes.course_id
GROUP BY course.course_id;

SELECT course.course_id, course.title, count(takes.ID)
FROM course
JOIN takes on course.course_id = takes.course_id
GROUP BY course.course_id;


SELECT course.course_id, course.title, count(takes.ID)
FROM course
RIGHT JOIN takes on course.course_id = takes.course_id
GROUP BY course.course_id;

SELECT course.course_id, course.title, count(takes.ID)
FROM takes
LEFT JOIN course on course.course_id = takes.course_id
GROUP BY course.course_id;

SELECT * FROM prereq;


SELECT p.course_id, c1.title AS Course_Title, c1.dept_name AS Course_Dept , p.prereq_id, c2.title AS Prereq_Title, c2.dept_name AS Prereq_Dept
FROM prereq p
LEFT JOIN course c1 on p.course_id = c1.course_id
LEFT JOIN course c2 on p.prereq_id = c2.course_id;

