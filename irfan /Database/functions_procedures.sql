USE SCHOOL_MULTI_CLASS;

DELIMITER $$

CREATE FUNCTION get_student_id(firstName VARCHAR(50), lastName VARCHAR(50)) 
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE studentId INT;
    
    SELECT id INTO studentId
    FROM STUDENT
    WHERE first_name = firstName AND last_name = lastName
    LIMIT 1;
    
    RETURN studentId;
END $$

DELIMITER ;


DROP PROCEDURE IF EXISTS get_students_grades;

DELIMITER $$

CREATE PROCEDURE get_students_grades()
BEGIN
    SELECT 
        S.first_name AS student_first_name,
        S.last_name AS student_last_name,
        C.class_subject AS class_name,
        SC.class_grade AS grade
    FROM 
        STUDENT S
    JOIN 
        STUDENT_CLASSES SC ON S.id = SC.student_id
    JOIN 
        CLASSES C ON SC.class_id = C.id
    ORDER BY 
        S.last_name, S.first_name, C.class_subject;
END;
 $$

DELIMITER ;



