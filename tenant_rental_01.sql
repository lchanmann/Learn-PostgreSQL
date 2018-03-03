--
-- Create database
--
CREATE DATABASE tenant_rental;

--
-- Connect to the database
--
\c tenant_rental;

--
-- Create complexes table
--
CREATE TABLE complexes (
  id serial PRIMARY KEY,
  name varchar(255) NOT NULL
);

--
-- Create buildings table
--
CREATE TABLE buildings (
  id serial PRIMARY KEY,
  complex_id integer NOT NULL,
  name varchar(255) NOT NULL,
  address varchar(255)
);

--
-- Add fk_buildings_complex_id foreign key to buildings
--
ALTER TABLE buildings
  ADD CONSTRAINT fk_buildings_complex_id FOREIGN KEY (complex_id) REFERENCES complexes(id) ON UPDATE RESTRICT ON DELETE CASCADE;

--
-- Create apartments table
--
CREATE TABLE apartments (
  id serial PRIMARY KEY,
  building_id integer NOT NULL,
  name varchar(255) NOT NULL,
  address varchar(255)
);

--
-- Add fk_apartments_building_id foreign key to buildings
--
ALTER TABLE apartments
  ADD CONSTRAINT fk_apartments_building_id FOREIGN KEY (building_id) REFERENCES buildings(id) ON UPDATE RESTRICT ON DELETE CASCADE;

--
-- Create tenants table
--
CREATE TABLE tenants (
  id serial PRIMARY KEY,
  name varchar(255) NOT NULL,
  address varchar(255)
);

--
-- Create tenant_apartments table
--
CREATE TABLE tenant_apartments (
  tenant_id integer NOT NULL,
  apartment_id integer NOT NULL,
  PRIMARY KEY (tenant_id, apartment_id)
);

--
-- Add fk_tenant_apartments_tenant_id foreign key to tenant_apartments table
--
ALTER TABLE tenant_apartments
  ADD CONSTRAINT fk_tenant_apartments_tenant_id FOREIGN KEY (tenant_id) REFERENCES tenants(id) ON UPDATE RESTRICT ON DELETE CASCADE;

--
-- Add fk_tenant_apartments_apartment_id foreign key to tenant_apartments table
--
ALTER TABLE tenant_apartments
  ADD CONSTRAINT fk_tenant_apartments_apartment_id FOREIGN KEY (apartment_id) REFERENCES apartments(id) ON UPDATE RESTRICT ON DELETE CASCADE;

--
-- Create requests table
--
CREATE TABLE requests (
  id serial PRIMARY KEY,
  apartment_id integer NOT NULL,
  status varchar(25),
  description varchar(1000)
);

--
-- Add fk_requests_apartment_id foreign key to requests table
--
ALTER TABLE requests
  ADD CONSTRAINT fk_requests_apartment_id FOREIGN KEY (apartment_id) REFERENCES apartments(id) ON UPDATE RESTRICT ON DELETE CASCADE;
