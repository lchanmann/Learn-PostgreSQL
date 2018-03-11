--
-- Connect to the database
--
\c student_grade;

--
-- Resources:
-- ordered-set aggregates: https://github.com/michaelpq/michaelpq.github.io/blob/master/_posts/2014-02-27-postgres-9-4-feature-highlight-within-group.markdown
-- comnon table expression: https://www.postgresql.org/docs/current/static/queries-with.html
--

--
-- Get all students in the top 10 percentile
--

WITH gpa AS (
  SELECT student_id, avg(grade) as grade
  FROM course_enrollments
  GROUP BY student_id
)
SELECT students.name, gpa.grade
FROM students
  INNER JOIN gpa on gpa.student_id = students.id
WHERE gpa.grade >= (SELECT
                      percentile_disc(0.9) WITHIN GROUP (ORDER BY grade)
                    FROM gpa)
;

--
-- Breakdown
--
SELECT 'Create average grade view aka "gpa"' as breakdown_1;
SELECT student_id, avg(grade) as grade
FROM course_enrollments
GROUP BY student_id;

SELECT 'Find the (discrete) value from the gpa that corresponds to the 90 percentile' as breakdown_2;
WITH gpa AS (
  SELECT avg(grade) as grade
  FROM course_enrollments
  GROUP BY student_id
)
SELECT
  percentile_disc(0.9) WITHIN GROUP (ORDER BY grade) as value
FROM gpa;

SELECT 'Construct WHERE clause to match students with higher gpa than the value' as breakdown_3;
