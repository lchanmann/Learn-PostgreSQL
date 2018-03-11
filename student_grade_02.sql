--
-- Connect to the database
--
\c student_grade;

--
-- Insert some data
--
INSERT INTO students (id, name, address)
VALUES (1, 'Alice', NULL),
       (2, 'Bob', NULL),
       (3, 'Cynthia', NULL),
       (4, 'Dan', NULL),
       (5, 'Elon', NULL);

INSERT INTO professors (id, name)
VALUES (1, 'Dr. Andrew Ng'),
       (2, 'Dr. Geoffrey Hinton'),
       (3, 'Dr. Yann LeCun'),
       (4, 'Dr. Yoshua Bengio'),
       (5, 'Dr. Yunxin Zhao');

INSERT INTO courses (id, professor_id, title)
VALUES (1, 1, 'Introduction to Machine Learning'),
       (2, 2, 'Deep Learning'),
       (3, 3, 'Convolutional Neural Network'),
       (4, 4, 'Learning Algorithm'),
       (5, 5, 'Introduction to Speech Recognition');

INSERT INTO terms (id, name)
VALUES (1, 'Spring 2018');

INSERT INTO course_enrollments (course_id, student_id, term_id, grade)
VALUES (1, 1, 1, 4.0),
       (2, 1, 1, 3.0),
       (2, 2, 1, 2.0),
       (1, 3, 1, 4.0),
       (3, 3, 1, 4.0),
       (4, 4, 1, 3.0),
       (5, 5, 1, 4.0);

