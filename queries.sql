/*Queries that provide answers to the questions from all projects.*/

-- Find all animals whose name ends in "mon".
SELECT * FROM animals WHERE name LIKE '%mon%';

-- List the name of all animals born between 2016 and 2019.
SELECT * FROM animals WHERE date_of_birth>= '2016-01-01' AND date_of_birth<='2019-12-31';

-- List the name of all animals that are neutered and have less than 3 escape attempts.
SELECT * FROM animals WHERE neutered = 'Yes' AND escape_attempts < 3;

-- List the date of birth of all animals named either "Agumon" or "Pikachu".
SELECT date_of_birth FROM animals WHERE name IN ('Agumon', 'Pikachu');

-- List name and escape attempts of animals that weigh more than 10.5kg
SELECT name, date_of_birth FROM animals WHERE weight_kg > 10.5;

-- Find all animals that are neutered.
SELECT * FROM animals WHERE neutered = 'Yes';

-- Find all animals not named Gabumon.
SELECT * FROM animals WHERE name <> 'Gabumon';

-- Find all animals with a weight between 10.4kg and 17.3kg (including the animals with the weights that equals precisely 10.4kg or 17.3kg)
SELECT * FROM animals WHERE weight_kg>=10.4 AND weight_kg<=17.3;

-- Inside a transaction update the animals table by setting the species column to unspecified. Verify that change was made. Then roll back the change and verify that the species columns went back to the state before the transaction.
BEGIN;
UPDATE animals SET species = 'unspecified';
SELECT species FROM animals;
ROLLBACK;
SELECT species FROM animals;

-- Update the animals table by setting the species column to digimon for all animals that have a name ending in mon.
-- Update the animals table by setting the species column to pokemon for all animals that don't have species already set.
-- Commit the transaction.
-- Verify that change was made and persists after commit.
BEGIN;
UPDATE animals SET species = 'digimon' WHERE name LIKE '%mon';
UPDATE animals SET species = 'pokemon' WHERE species IS NULL;
COMMIT;
SELECT species FROM animals;

-- Inside a transaction delete all records in the animals table, then roll back the transaction.
-- After the rollback verify if all records in the animals table still exists.
BEGIN;
DELETE FROM animals;
SELECT * FROM animals;
ROLLBACK;
SELECT * FROM animals;

-- Delete all animals born after Jan 1st, 2022.
-- Create a savepoint for the transaction.
-- Update all animals' weight to be their weight multiplied by -1.
-- Rollback to the savepoint
-- Update all animals' weights that are negative to be their weight multiplied by -1.
-- Commit transaction
BEGIN;
DELETE FROM animals WHERE date_of_birth > '2022-01-01';
SAVEPOINT my_savepoint;
UPDATE animals SET weight_kg = weight_kg * -1;
ROLLBACK TO my_savepoint;
UPDATE animals SET weight_kg = weight_kg * -1 WHERE weight_kg < 0;
COMMIT;

-- How many animals are there?
SELECT COUNT(*) FROM animals;

-- How many animals have never tried to escape?
SELECT COUNT(*) FROM animals WHERE escape_attempts = 0;

-- What is the average weight of animals?
SELECT AVG(weight_kg) FROM animals;

-- Who escapes the most, neutered or not neutered animals?
SELECT neutered, AVG(escape_attempts) as avg_escapes FROM animals
GROUP BY neutered
ORDER BY avg_escapes DESC
LIMIT 1;

-- What is the minimum and maximum weight of each type of animal?
SELECT species, MIN(weight_kg), MAX(weight_kg) FROM animals
GROUP BY species;

-- What is the average number of escape attempts per animal type of those born between 1990 and 2000?
SELECT species, AVG(escape_attempts) FROM animals
WHERE date_of_birth >= '1990-01-01' AND date_of_birth <= '2000-12-31'
GROUP BY species;

-- What animals belong to Melody Pond?
SELECT name FROM animals
JOIN owners ON animals.owner_id = owners.id
WHERE owners.full_name = 'Melody Pond';

-- List of all animals that are pokemon (their type is Pokemon).
SELECT animals.name FROM animals
JOIN species ON animals.species_id = species.id
WHERE species.name = 'Pokemon';

-- List all owners and their animals, remember to include those that don't own any animal.
SELECT owners.full_name, animals.name FROM owners
LEFT JOIN animals ON owners.id = animals.owner_id;

-- How many animals are there per species?
SELECT species.name, COUNT(animals.species_id) as count FROM species
LEFT JOIN animals ON species.id = animals.species_id
GROUP BY species.id;

-- List all Digimon owned by Jennifer Orwell.
SELECT animals.name FROM animals
JOIN species ON animals.species_id = species.id
JOIN owners ON animals.owner_id = owners.id
WHERE species.name = 'Digimon' AND owners.full_name = 'Jennifer Orwell';

-- List all animals owned by Dean Winchester that haven't tried to escape.
SELECT animals.name FROM animals
JOIN owners ON animals.owner_id = owners.id
WHERE escape_attempts = 0 AND owners.full_name = 'Dean Winchester';

-- Who owns the most animals?
SELECT owners.full_name, COUNT(animals.species_id) as count FROM owners
LEFT JOIN animals ON owners.id = animals.owner_id
GROUP BY owners.id ORDER BY count DESC
LIMIT 1;

-- Who was the last animal seen by William Tatcher?
SELECT animals.name, vet.name, visits.visit_date FROM animals
JOIN visits on animals.id = visits.animal_id
JOIN vet on visits.vet_id = vet.id
WHERE vet.name = 'William Tatcher'
ORDER BY visits.visit_date DESC lIMIT 1;
  
--   How many different animals did Stephanie Mendez see?
SELECT vet.name, count(animals.name) FROM animals
JOIN visits on visits.animal_id = animals.id
JOIN vet on vet.id = visits.vet_id
WHERE vet.name = 'Stephanie Mendez'
GROUP BY vet.name;

--  List all vets and their specialties, including vets with no specialties. 
SELECT vet.name, species.name FROM vet
LEFT JOIN specializations on specializations.vet_id = vet.id
LEFT JOIN species on specializations.species_id = species.id;

-- List all animals that visited Stephanie Mendez between April 1st and August 30th, 2020.
SELECT animals.name, vet.name, visits.visit_date FROM animals
JOIN visits on visits.animal_id = animals.id
JOIN vet on vet.id = visits.vet_id
WHERE vet.name = 'Stephanie Mendez' AND visits.visit_date
BETWEEN '2020-04-01' AND '2020-08-30'

-- What animal has the most visits to vets?
SELECT animals.name, count(*) FROM animals
JOIN visits on visits.animal_id = animals.id
GROUP BY animals.name
ORDER BY count desc limit 1;

-- Who was Maisy Smith's first visit?
SELECT animals.name, vet.name, visits.visit_date FROM animals
JOIN visits on animals.id = visits.animal_id
JOIN vet on visits.vet_id = vet.id
WHERE vet.name = 'Maisy Smith'
ORDER BY visits.visit_date ASC lIMIT 1;

-- Details for most recent visit: animal information, vet information, and date of visit.
SELECT animals.name, vet.name, visits.visit_date FROM animals
JOIN visits on animals.id = visits.animal_id
JOIN vet on visits.vet_id = vet.id
ORDER BY visits.visit_date DESC lIMIT 1;

-- How many visits were with a vet that did not specialize in that animal's species?
SELECT COUNT(*) FROM vet
JOIN visits ON visits.vet_id = vet.id
JOIN animals ON visits.animal_id = animals.id
JOIN specializations ON vet.id = specializations.vet_id
WHERE NOT specializations.species_id = animals.species_id;

-- What specialty should Maisy Smith consider getting? Look for the species she gets the most.
SELECT vet.name, species.name, count(species.name) from vet
JOIN visits on visits.vet_id = vet.id
JOIN animals on visits.animal_id = animals.id
JOIN species on animals.species_id = species.id
WHERE vet.name = 'Maisy Smith'
GROUP BY species.name, vet.name
ORDER BY count DESC lIMIT 1;