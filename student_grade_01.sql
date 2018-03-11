--
-- Create database
--
DROP DATABASE IF EXISTS student_grade;
CREATE DATABASE student_grade;

--
-- Connect to the database
--
\c student_grade;

--
-- Create tables
--
CREATE TABLE students (
  id serial PRIMARY KEY,
  name varchar(255) NOT NULL,
  address varchar(255)
);

CREATE TABLE professors (
  id serial PRIMARY KEY,
  name varchar(255) NOT NULL
);

CREATE TABLE courses (
  id serial PRIMARY KEY,
  professor_id integer NOT NULL,
  title varchar(255) NOT NULL
);

ALTER TABLE courses
  ADD CONSTRAINT fk_courses_professor_id FOREIGN KEY (professor_id) REFERENCES professors(id) ON UPDATE RESTRICT;

CREATE TABLE terms (
  id serial PRIMARY KEY,
  name varchar(255) NOT NULL
);

CREATE TABLE course_enrollments (
  course_id integer NOT NULL,
  student_id integer NOT NULL,
  term_id integer NOT NULL,
  grade real
);

ALTER TABLE course_enrollments
  ADD CONSTRAINT fk_course_enrollments_course_id FOREIGN KEY (course_id) REFERENCES courses(id) ON UPDATE RESTRICT;

ALTER TABLE course_enrollments
  ADD CONSTRAINT fk_course_enrollments_student_id FOREIGN KEY (student_id) REFERENCES students(id) ON UPDATE RESTRICT;

ALTER TABLE course_enrollments
  ADD CONSTRAINT fk_course_enrollments_term_id FOREIGN KEY (term_id) REFERENCES terms(id) ON UPDATE RESTRICT;
  
