--
-- Resource:
-- https://www.dalibo.org/_media/understanding_explain.pdf
--

--
-- Connect to the database
--
\c understand_explain;

--
-- Explain: show query plan
--
EXPLAIN SELECT * from foo;

--
-- Analyze: update table statistics
--
ANALYZE foo;
EXPLAIN SELECT * from foo;

--
-- Get statistics information
--
SELECT sum(avg_width) as width
FROM pg_stats
WHERE tablename = 'foo';

--
-- Get metadata from system catalog. Eg. number of row
--
SELECT reltuples
FROM pg_class
WHERE relname = 'foo';

--
-- Get total cost
--
SELECT relpages * current_setting('seq_page_cost')::float4 as page_cost,
  reltuples * current_setting('cpu_tuple_cost')::float4 as cpu_cost,
  relpages * current_setting('seq_page_cost')::float4 + reltuples * current_setting('cpu_tuple_cost')::float4 as total_cost
FROM pg_class
WHERE relname = 'foo';

--
-- Explain analyze
--
EXPLAIN ANALYZE SELECT * FROM foo;

--
-- Explain buffers: hit [cache block], read [non-cache blocks]
--
EXPLAIN (ANALYZE, BUFFERS) SELECT * FROM foo;

-- Try changing shared_buffers = 320MB, restart postgres
-- then rerun "EXPLAIN (ANALYZE, BUFFERS) SELECT * FROM foo;" twice.
-- The first query would read from disk but the second will hit the cache.

--
-- Explain with WHERE clause
--
EXPLAIN SELECT * FROM foo WHERE c1 > 500;

--
-- WHERE clause results in less row but add more cost to the query
--
SELECT relpages * current_setting('seq_page_cost')::float4 AS page_cost,
  reltuples * current_setting('cpu_tuple_cost')::float4 AS cpu_cost,
  reltuples * current_setting('cpu_operator_cost')::float4 AS operator_cost,
  relpages * current_setting('seq_page_cost')::float4 +
  reltuples * current_setting('cpu_tuple_cost')::float4 +
  reltuples * current_setting('cpu_operator_cost')::float4 AS total_cost
FROM pg_class
WHERE relname = 'foo';

--
-- Index would not help here as we skip only 500 rows. The query planner use CPU
-- instead of index.
--
CREATE INDEX index_foo_on_c1 ON foo (c1);
EXPLAIN ANALYZE SELECT * FROM foo WHERE c1 > 500;

--
-- Force using index would be slower
--
SET enable_seqscan TO off;
EXPLAIN ANALYZE SELECT * FROM foo WHERE c1 > 500;
SET enable_seqscan TO on;

--
-- Change condition in WHERE clause and query planner uses index scan
--
EXPLAIN ANALYZE SELECT * FROM foo WHERE c1 < 500;

--
-- More filtering: using both index and sequential scans
--
EXPLAIN ANALYZE SELECT * FROM foo WHERE c1 < 500 AND c2 LIKE 'abcd%';

--
-- Text column uses UTF8 encoding and it needs specfic operator class (varchar_pattern_ops, text_pattern_ops, etc)
--
CREATE INDEX index_foo_on_c2 foo (c2 text_pattern_ops);
EXPLAIN ANALYZE SELECT * FROM foo WHERE c2 LIKE 'abcd%';

--
-- Covering index (Index Only Scan) is used when there are no other fields in the query
--
EXPLAIN SELECT c1 FROM foo WHERE c1 < 500;

--
-- W/o index ordering records is painful. It either needs more working memory or
-- read/write to disk.
--
DROP INDEX index_foo_on_c1;
EXPLAIN (ANALYZE, BUFFERS) SELECT * FROM foo ORDER BY c1;

SET work_mem TO '200MB';
EXPLAIN ANALYZE SELECT * FROM foo ORDER BY c1;

CREATE INDEX index_foo_on_c1 ON foo (c1);
EXPLAIN ANALYZE SELECT * FROM foo ORDER BY c1;

--
-- Hash Join: hash a table and hash each row of the other table then compare
--
EXPLAIN ANALYZE SELECT * FROM foo INNER JOIN bar on bar.c1 = foo.c1;

--
-- When both tables have indexes on the joining columns, a good way to join two
-- table is to merge two sorted data sets. PostgreSQL would prefer Merge Join.
--
CREATE INDEX index_bar_on_c1 ON bar (c1);
EXPLAIN ANALYZE SELECT * FROM foo INNER JOIN bar on bar.c1 = foo.c1;

--
-- Merge Left Join
--
EXPLAIN ANALYZE SELECT * FROM foo LEFT JOIN bar on bar.c1 = foo.c1;

--
-- When data set is small, Nested Loop is prefer where PostgreSQL does sequential
-- scan on bar, then sort the data with quicksort in-memory then Merge Join with foo.
--
DELETE FROM bar WHERE c1 > 500;
DROP INDEX index_bar_on_c1;
ANALYZE bar;

EXPLAIN ANALYZE SELECT * FROM foo INNER JOIN bar on bar.c1 = foo.c1;

--
-- When both tables are small, Query planner would switch to Nested Loop node.
--
DELETE FROM foo WHERE c1 > 1000;
ANALYZE bar;
EXPLAIN ANALYZE SELECT * FROM foo INNER JOIN bar ON bar.c1 = foo.c1;

--
-- Query plan involves the inherited tables that satisfy the constraint and the master table.
--
EXPLAIN ANALYZE SELECT * FROM baz WHERE c1 BETWEEN '2018-01-01' AND '2018-03-12';

--
-- Aggregation node would do sequential scan
--
EXPLAIN SELECT count(*) FROM foo;

--
-- max() w/o index would also do sequential scan
--
DROP INDEX index_foo_on_c2;
EXPLAIN SELECT max(c2) FROM foo;

--
-- With index on foo.c2 getting max is simple the Index Only Scan backward then
-- picking the first value.
--
CREATE INDEX index_foo_on_c2 ON foo (c2);
EXPLAIN SELECT max(c2) FROM foo;

--
-- GROUP BY: query plan would first sort the data set then group them according to the values.
--
DROP INDEX index_foo_on_c2;
EXPLAIN ANALYZE SELECT c2, count(*) FROM foo GROUP BY c2;

--
-- Adding more memory: planner switches to HashAggregate node
--
SET work_mem TO '200MB';
EXPLAIN ANALYZE SELECT c2, count(*) FROM GROUP BY c2;

--
-- Small work_mem with index, we're back to the GroupAggregate with Index Scan
-- instead of sequential scan
--
RESET work_mem;
CREATE INDEX index_foo_on_c2 ON foo (c2);
EXPLAIN ANALYZE SELECT c2, count(*) FROM foo GROUP BY c2;
