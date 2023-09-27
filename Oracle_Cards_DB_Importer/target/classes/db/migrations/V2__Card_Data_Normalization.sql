-- Create rarity table
CREATE TABLE IF NOT EXISTS rarity (
    id SERIAL PRIMARY KEY,
    name TEXT
);

-- Insert unique rarity values into the rarity table
INSERT INTO rarity (name)
SELECT DISTINCT rarity FROM cards;

-- Update rarity_id in the cards table
UPDATE cards c
SET rarity = r.id
FROM rarity r
WHERE c.rarity = r.name;


-- Create artist table
CREATE TABLE IF NOT EXISTS artist (
    id SERIAL PRIMARY KEY,
    name TEXT
);

-- Insert unique artist values into the artist table
INSERT INTO artist (name)
SELECT DISTINCT artist FROM cards;

-- Update artist_id in the cards table
UPDATE cards c
SET artist= a.id
FROM artist a
WHERE c.artist = a.name;



-- Create set_data table
CREATE TABLE IF NOT EXISTS set_data (
    id SERIAL PRIMARY KEY,
    set_name TEXT UNIQUE,
    release_date DATE
);

-- Insert unique set name and release date values into the set_data table
INSERT INTO set_data (set_name, release_date)
SELECT DISTINCT set_name, MIN(release_date) AS release_date FROM cards
GROUP BY set_name;

-- Add set_data_id column to cards table
ALTER TABLE cards
ADD COLUMN set_data_id INTEGER;

-- Update set_data_id in the cards table
UPDATE cards c
SET set_data_id = sd.id
FROM set_data sd
WHERE c.set_name = sd.set_name;

-- Drop the release_date column from the cards table
ALTER TABLE cards
DROP COLUMN release_date;

-- Remove set_name column from cards table
ALTER TABLE cards
DROP COLUMN set_name;

