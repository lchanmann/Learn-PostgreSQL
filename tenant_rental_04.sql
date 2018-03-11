--
-- Connect to the database
--
\c tenant_rental;

--
-- Get a list of tenants who are renting more than one apartment
--
SELECT 'tenants who are renting more than one apartment' as query;

WITH cte_renting AS (
  SELECT tenant_id, count(*)
  FROM tenant_apartments
  GROUP BY tenant_id
  HAVING count(*) > 1
)
SELECT tenants.name, cte_renting.count as renting
FROM tenants
  INNER JOIN cte_renting on cte_renting.tenant_id = tenants.id
;

-- If we do not need extra field(s) from the CTE besides the joining field
-- we might like to consider using sub-query instead.
SELECT tenants.name
FROM tenants
  INNER JOIN (SELECT tenant_id
              FROM tenant_apartments
              GROUP BY tenant_id
              HAVING count(*) > 1) AS renting
  ON renting.tenant_id = tenants.id
;
