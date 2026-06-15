
DROP DATABASE IF EXISTS SCHOOL_MULTI_CLASS;
CREATE DATABASE IF NOT EXISTS SCHOOL_MULTI_CLASS;
USE SCHOOL_MULTI_CLASS;

DROP TABLE IF EXISTS TEACHER;

CREATE TABLE TEACHER(
id int primary key auto_increment,
first_name VARCHAR(50),
last_name VARCHAR(50),
email VARCHAR(100)
);

DROP TABLE IF EXISTS CLASSES;

CREATE TABLE CLASSES(
id int primary key auto_increment,
class_subject VARCHAR(100),
teacher_id int,
foreign key (teacher_id) references TEACHER(id) on delete cascade on update cascade
);


DROP TABLE IF EXISTS STUDENT;

CREATE TABLE STUDENT (
id INT AUTO_INCREMENT PRIMARY KEY,
first_name VARCHAR(50),
last_name VARCHAR(50),
email_address VARCHAR(100),
date_of_birth DATE,
student_grade INT
);

DROP TABLE IF EXISTS STUDENT_CLASSES;

CREATE TABLE STUDENT_CLASSES (
id INT AUTO_INCREMENT PRIMARY KEY,
student_id int,
class_id int,
class_grade VARCHAR(1),
foreign key (student_id) references STUDENT(id) on delete cascade on update cascade,
foreign key (class_id) references CLASSES(id) on delete cascade on update cascade
);


