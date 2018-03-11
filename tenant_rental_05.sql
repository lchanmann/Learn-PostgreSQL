--
-- Connect to the database
--
\c tenant_rental;

--
-- Get a list of buildings and the number of open requests
--
SELECT 'buildings with the number of open requests' as query;

WITH cte_apartment_requests AS (
  SELECT building_id, count(*)
  FROM requests
    INNER JOIN apartments ON apartments.id = requests.apartment_id
  WHERE status = 'open'
  GROUP BY building_id
)
SELECT buildings.name, coalesce(cte_apartment_requests.count, 0) as requests
FROM buildings
  LEFT JOIN cte_apartment_requests on cte_apartment_requests.building_id = buildings.id
;

-- using sub-query
SELECT 'using sub-query' as query;
SELECT buildings.name, coalesce(request_count.count, 0) as requests
FROM buildings
  LEFT JOIN (SELECT building_id, count(*)
             FROM requests
               INNER JOIN apartments ON apartments.id = requests.apartment_id
             WHERE status = 'open'
             GROUP BY building_id) AS request_count
  ON request_count.building_id = buildings.id
;
