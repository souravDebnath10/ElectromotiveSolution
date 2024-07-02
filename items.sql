CREATE TABLE items(
	id SERIAL PRIMARY KEY, 
	price INTEGER,
	name VARCHAR(45),
	rating FLOAT,
	description TEXT,
	image TEXT
);