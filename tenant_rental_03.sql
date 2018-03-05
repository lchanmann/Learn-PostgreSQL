--
-- Connect to the database
--
\c tenant_rental;

--
-- Nuke all data
--
TRUNCATE tenants RESTART IDENTITY CASCADE;
TRUNCATE complexes RESTART IDENTITY CASCADE;

--
-- Import data
--
INSERT INTO complexes (id, name)
VALUES (1, 'C1'),
       (2, 'C2'),
       (3, 'C3');

INSERT INTO buildings (id, complex_id, name, address)
VALUES (1, 1, 'Building A', NULL),
       (2, 1, 'Building B', NULL),
       (3, 2, 'Building C', NULL),
       (4, 3, 'Building D', NULL),
       (5, 3, 'Building E', NULL);

INSERT INTO apartments (id, building_id, name, address)
VALUES (1, 1, 'Apt A1', NULL),
       (2, 2, 'Apt B1', NULL),
       (3, 2, 'Apt B2', NULL),
       (4, 3, 'Apt C1', NULL),
       (5, 4, 'Apt D1', NULL),
       (6, 4, 'Apt D2', NULL),
       (7, 4, 'Apt D3', NULL),
       (8, 4, 'Apt D4', NULL);

INSERT INTO tenants (id, name, address)
VALUES (1, 'Amy', NULL),
       (2, 'Bill', NULL),
       (3, 'Caroline', NULL),
       (4, 'David', NULL),
       (5, 'Edward', NULL),
       (6, 'Frank', NULL),
       (7, 'Gorge', NULL),
       (8, 'Henry', NULL),
       (9, 'Iezabel', NULL),
       (10, 'John', NULL),
       (11, 'Kelly', NULL),
       (12, 'Luke', NULL),
       (13, 'Matt', NULL),
       (14, 'Nancy', NULL),
       (15, 'Oliver', NULL),
       (16, 'Peter', NULL),
       (17, 'Queen', NULL),
       (18, 'Rose', NULL),
       (19, 'Steve', NULL),
       (20, 'Tim', NULL),
       (21, 'Ursa', NULL),
       (22, 'Victoria', NULL),
       (23, 'Wendy', NULL),
       (24, 'Xray', NULL),
       (25, 'Yankee', NULL),
       (26, 'Zack', NULL);

INSERT INTO tenant_apartments (tenant_id, apartment_id)
VALUES (1, 1),
       (2, 2),
       (3, 3),
       (4, 4),
       (5, 5),
       -- tenants who rent more than one apartments
       (1, 6),
       (2, 7),
       -- tenants who are staying in the same apartments
       (6, 8),
       (7, 8);

INSERT INTO requests (id, apartment_id, status, description)
VALUES (1, 1, 'open', NULL),
       (2, 1, 'open', NULL),
       (3, 1, 'close', NULL),
       (4, 2, 'open', NULL),
       (5, 3, 'open', NULL);

