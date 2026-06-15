USE UNIVERSITY;

DROP PROCEDURE IF EXISTS get_all_courses;
DROP PROCEDURE IF EXISTS get_course_by_id;
DROP PROCEDURE IF EXISTS get_courses_by_department;
DROP PROCEDURE IF EXISTS add_course;

delimiter $$

CREATE PROCEDURE get_all_courses()
BEGIN
	SELECT * FROM course
    ORDER BY dept_name;
END$$

CREATE PROCEDURE get_course_by_id(course_number INT)
BEGIN
	SELECT * 
    FROM course
    -- WHERE course_number = course_number;
    WHERE course_id = course_number;
END$$

CREATE PROCEDURE get_courses_by_department(my_dept VARCHAR(50))
BEGIN
	SELECT *
    FROM course
    WHERE dept_name = my_dept;
END$$

CREATE PROCEDURE add_course(IN new_course_id int, IN new_title VARCHAR(50), IN new_dept_name VARCHAR(20), IN new_credits DECIMAL(2,0))
BEGIN
	IF
		(SELECT getCourseID(new_title, new_dept_name)) IS NULL
	THEN 
		INSERT INTO course(course_id, title, dept_name, credits) 
        VALUES (new_course_id, new_title, new_dept_name, new_credits);
        SELECT getCourseID(new_title, new_dept_name);
	ELSE
		SELECT -1;
	END IF;
END;$$

delimiter ;

CALL add_course(1, 'new bio', 'Biology', 2.0);
CALL get_courses_by_department('Biology');

DROP FUNCTION IF EXISTS getCourseID;

delimiter $$

CREATE FUNCTION getCourseID(myCourseName VARCHAR(50), myDept VARCHAR(50)) RETURNS INT DETERMINISTIC
BEGIN
	DECLARE foundID INT;
    SELECT course_id INTO foundID
    FROM course
    WHERE myCourseName = title
    AND myDept = dept_name;
    RETURN foundID;
END$$

delimiter ;


DROP PROCEDURE IF EXISTS Add_to_Test;

delimiter $$

CREATE PROCEDURE Add_to_Test(number1 INT, number2 INT)
BEGIN
	INSERT INTO test_table(id) 
    VALUES (number1), (number2);
END;
$$

delimiter ;

DROP PROCEDURE IF EXISTS example;

delimiter $$
CREATE PROCEDURE example()
BEGIN
SELECT course.course_id, course.title, count(takes.ID)
FROM takes
LEFT JOIN course on course.course_id = takes.course_id
GROUP BY course.course_id;
END;$$

delimiter ;


