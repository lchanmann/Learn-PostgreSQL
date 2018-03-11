--
-- Resource:
-- https://www.dalibo.org/_media/understanding_explain.pdf
--

--
-- Create database
--
DROP DATABASE IF EXISTS understand_explain;
CREATE DATABASE understand_explain;

--
-- Connect to the database
--
\c understand_explain;

--
-- Create tables with fake data
--
CREATE TABLE foo (
  c1 integer,
  c2 text
);

INSERT INTO foo (c1, c2)
  SELECT i, md5(random()::text)
  FROM generate_series(1, 1000000) as i;

CREATE TABLE bar (
  c1 integer,
  c2 boolean
);

INSERT INTO bar (c1, c2)
  SELECT i, i % 2 = 1
  FROM generate_series(1, 500000) AS i;

CREATE TABLE baz (
  c1 timestamp,
  c2 text
);

CREATE TABLE baz_2018 (
  CHECK (c1 BETWEEN '2018-01-01' AND '2018-12-31')
) INHERITS (baz);

INSERT INTO baz_2018 (c1, c2)
  SELECT now() - i * interval '1 day', 'line ' || i
  FROM generate_series(1, 60) AS i;

CREATE TABLE baz_2017 (
  CHECK (c1 BETWEEN '2017-01-01' AND '2017-12-31')
) INHERITS (baz);
