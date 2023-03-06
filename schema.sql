/* Database schema to keep the structure of entire database. */

CREATE TABLE animals (
id INT,
name VARCHAR(255),
date_of_birth DATE,
escape_attempts INT,
neutered BOOLEAN,
weight_kg DECIMAL(6, 2)
);

ALTER TABLE animals
ADD species VARCHAR(255);

CREATE TABLE owners(
id SERIAL PRIMARY KEY,
full_name TEXT	,
age INT
);

CREATE TABLE species(
id SERIAL PRIMARY KEY,
name TEXT
);

ALTER TABLE animals DROP COLUMN species;

ALTER TABLE animals ADD COLUMN species_id INTEGER;
ALTER TABLE animals ADD FOREIGN KEY (species_id) REFERENCES species(id);

ALTER TABLE animals ADD COLUMN owner_id INTEGER;
ALTER TABLE animals ADD FOREIGN KEY (owner_id) REFERENCES owners(id);

CREATE TABLE vet(
id SERIAL PRIMARY KEY,
name VARCHAR(255),
age INT,
date_of_graduation DATE
);

CREATE TABLE specializations(
vet_id INT REFERENCES vet(id),
species_id INT REFERENCES species(id),
PRIMARY KEY (vet_id, species_id)
);

CREATE TABLE visits(
animal_id INT REFERENCES animals(id),
vet_id INT REFERENCES vet(id),
visit_date DATE 
);

ALTER TABLE owners ADD COLUMN email VARCHAR(120);