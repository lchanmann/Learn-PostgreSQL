--
-- Connect to the database
--
\c tenant_rental;

--
-- Create index_buildings_on_complex_id
--
CREATE INDEX index_buildings_on_complex_id ON public.buildings USING btree (complex_id);

--
-- Create index_apartments_on_building_id
--
CREATE INDEX index_apartments_on_building_id ON public.apartments USING btree (building_id);

--
-- Create index_requests_on_apartment_id
--
CREATE INDEX index_requests_on_apartment_id ON public.requests USING btree (apartment_id);
