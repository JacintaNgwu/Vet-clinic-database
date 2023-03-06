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

INSERT INTO vet(name, age, date_of_graduation)
VALUES
('William Tatcher', 45, '2000-04-23'),
('Maisy Smith', 26, '2019-01-17'),
('Stephanie Mendez', 64, '1981-05-04'),
('Jack Harkness', 38, '2008-06-08');

INSERT INTO specializations(vet_id, species_id)
VALUES
(1, (SELECT id FROM species WHERE name = 'Pokemon')),
(3, (SELECT id FROM species WHERE name = 'Digimon')),
(3, (SELECT id FROM species WHERE name = 'Pokemon')),
(4, (SELECT id FROM species WHERE name = 'Digimon'));

  INSERT INTO visits (animal_id, vet_id, visit_date)
  VALUES  
  (1, 1, '2020-05-24'),
  (1, 3, '2020-07-22'),
  (2, 4, '2021-02-02'),
  (3, 2, '2020-01-05'),
  (3, 2, '2020-03-08'),
  (3, 2, '2020-05-14'),
  (4, 3, '2021-05-04'),
  (5, 4, '2021-02-24'),
  (6, 2, '2019-12-21'),
  (6, 1, '2020-08-10'),
  (6, 2, '2021-04-07'),
  (7, 3, '2019-09-29'),
  (8, 4, '2020-10-03'),
  (8, 4, '2020-11-04'),
  (9, 2, '2019-01-24'),
  (9, 2, '2019-05-15'),
  (9, 2, '2020-02-27'),
  (9, 2, '2020-08-03'),
  (10, 3, '2020-05-24'),
  (10, 1, '2021-01-11');

-- This will add 3.594.280 visits considering you have 10 animals, 4 vets, and it will use around ~87.000 timestamps (~4min approx.)
INSERT INTO visits (animal_id, vet_id, visit_date) SELECT * FROM (SELECT id FROM animals) animal_ids,
(SELECT id FROM vet) vet_ids, generate_series('1980-01-01'::timestamp, '2021-01-01', '4 hours') visit_timestamp;

-- This will add 2.500.000 owners with full_name = 'Owner <X>' and email = 'owner_<X>@email.com' (~2min approx.)
INSERT INTO owners (full_name, email) select 'Owner ' || generate_series(1,2500000), 'owner_' || generate_series(1,2500000) || '@mail.com';