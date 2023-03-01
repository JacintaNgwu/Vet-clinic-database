/* Populate database with sample data. */

INSERT INTO animals (name, date_of_birth, neutered, weight_kg, escape_attempts)
VALUES 
 ('Agumon', '2020-02-3', 'Yes', 10.23, 0),
 ('Gabumon', '2018-11-15', 'Yes', 8, 2),
 ('Pikachu.', '2021-01-7', 'No', 15.04, 1),
 ('Devimon', '2017-05-12', 'Yes', 11, 5);

INSERT INTO animals (name, date_of_birth, neutered, weight_kg, escape_attempts)
VALUES 
('Charmander', '2020-02-08', 'No', -11, 0),
('Plantmon', '2021-11-15', 'Yes', -5.7, 2),
('Squirtle', '1993-04-02', 'No', -12.13, 3),
('Angemon', '2005-06-12', 'Yes', -45, 1),
('Boarmon', '2005-06-07', 'Yes', 20.4, 7),
('Blossom', '1998-10-13', 'Yes', 17, 3),
('Ditto', '2022-05-14', 'Yes', 22, 4);

INSERT INTO owners (full_name, age)
VALUES
('Sam Smith', 34),
('Jennifer Orwell', 19),
('Bob', 45),
('Melody Pond', 77),
('Dean Winchester', 14),
('Jodie Whittaker', 38);

INSERT INTO species (name)
VALUES
('Pokemon'),
('Digimon');

UPDATE animals SET species_id = CASE
  WHEN name LIKE '%mon' THEN (SELECT id FROM species WHERE name = 'Digimon')
  ELSE (SELECT id FROM species WHERE name = 'Pokemon')
END;

UPDATE animals SET owner_id = CASE
WHEN name = 'Agumon' THEN (SELECT id FROM owners WHERE full_name = 'Sam Smith')
WHEN (name = 'Gabumon' OR name = 'Pikachu') THEN (SELECT id FROM owners WHERE full_name = 'Jennifer Orwell')
WHEN (name = 'Devimon' OR name = 'Plantmon') THEN (SELECT id FROM owners WHERE full_name = 'Bob')
WHEN (name = 'Charmander' OR name = 'Squirtle' OR name = 'Blossom') THEN (SELECT id FROM owners WHERE full_name = 'Melody Pond')
WHEN (name = 'Angemon' OR name = 'Boarmon') THEN (SELECT id FROM owners WHERE full_name = 'Dean Winchester')
END;