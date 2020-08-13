-- Practice Joins
-- 1 Get all invoices where the unit_price on the invoice_line is greater than $0.99.
SELECT * FROM invoice i JOIN invoice_line il ON il.invoice_id = i.invoice_id WHERE il.unit_price > 0.99;
-- 2 Get the invoice_date, customer first_name and last_name, and total from all invoices.
SELECT i.invoice_date, c.first_name, c.last_name, i.total FROM invoice i
JOIN customer c ON i.customer_id = c.customer_id;
-- 3 Get the customer first_name and last_name and the support rep's first_name and last_name from all customers.
SELECT c.first_name, c.last_name, e.first_name, e.last_name
FROM customer c
JOIN employee e ON c.support_rep_id = e.employee_id;
-- 4 Get the album title and the artist name from all albums.
SELECT al.title, ar.name
FROM album al
JOIN artist ar ON al.artist_id = ar.artist_id;
-- 5 Get all playlist_track track_ids where the playlist name is Music.
SELECT pt.track_id
FROM playlist_track pt
JOIN playlist p ON p.playlist_id = pt.playlist_id
WHERE p.name = 'Music';
-- 6 Get all track names for playlist_id 5.
SELECT t.name
FROM track t
JOIN playlist_track pt ON pt.track_id = t.track_id
WHERE pt.playlist_id = 5;
-- 7 Get all track names and the playlist name that they're on ( 2 joins ).
SELECT t.name, p.name
FROM track t
JOIN playlist_track pt ON t.track_id = pt.track_id
JOIN playlist p ON pt.playlist_id = p.playlist_id;
-- 8 Get all track names and album titles that are the genre Alternative & Punk ( 2 joins ).
SELECT t.name, a.title
FROM track t
JOIN album a ON t.album_id = a.album_id
JOIN genre g ON g.genre_id = t.genre_id
WHERE g.name = 'Alternative & Punk';


-- Practice Nested Queries
-- 1 Get all invoices where the unit_price on the invoice_line is greater than $0.99.
SELECT * FROM invoice WHERE invoice_id IN ( SELECT invoice_id FROM invoice_line WHERE unit_price > .99 );
-- 2 Get all playlist tracks where the playlist name is Music.
SELECT * FROM playlist_track WHERE playlist_id IN ( SELECT playlist_id FROM playlist WHERE name = 'Music');
-- 3 Get all track names for playlist_id 5.
SELECT name FROM track WHERE track_id IN ( SELECT track_id FROM playlist_track WHERE playlist_id = 5);
-- 4 Get all tracks where the genre is Comedy.
SELECT * FROM track WHERE genre_id IN ( SELECT genre_id FROM genre WHERE name = 'Comedy');
-- 5 Get all tracks where the album is Fireball.
SELECT * FROM track WHERE album_id IN ( SELECT album_id FROM album WHERE title = 'Fireball');
-- 6 Get all tracks for the artist Queen ( 2 nested subqueries ).
SELECT * FROM track WHERE album_id IN ( SELECT album_id FROM album WHERE artist_id IN (SELECT artist_id FROM artist WHERE name = 'Queen'));


-- Practice Updating Rows
-- 1 Find all customers with fax numbers and set those numbers to null.
UPDATE customer SET fax = NULL WHERE fax is NOT NULL;
-- 2 Find all customers with no company (null) and set their company to "Self".
UPDATE customer SET company = 'Self' WHERE company is NULL;
-- 3 Find the customer Julia Barnett and change her last name to Thompson.
UPDATE customer SET last_name = 'Thompson' WHERE first_name = 'Julia' AND last_name = 'Barnett';
-- 4 Find the customer with this email luisrojas@yahoo.cl and change his support rep to 4.
UPDATE customer SET support_rep_id = 4 WHERE email = 'luisrojas@yahoo.cl';
-- 5 Find all tracks that are the genre Metal and have no composer. Set the composer to "The darkness around us".
UPDATE track SET composer = 'The darkness around us' WHERE genre_id = ( SELECT genre_id FROM genre WHERE name = 'Metal' ) AND composer IS null;
-- 6 Refresh your page to remove all database changes.
-- DONE!!!!!! I want credit for this problem LOL


-- Group By
-- 1 Find a count of how many tracks there are per genre. Display the genre name with the count.
SELECT COUNT(*), genre.name
FROM track
JOIN genre ON track.genre_id = genre.genre_id
GROUP BY genre.name;
-- 2 Find a count of how many tracks are the "Pop" genre and how many tracks are the "Rock" genre.
SELECT COUNT(*), g.name
FROM track t
JOIN genre g ON g.genre_id = t.genre_id
WHERE g.name IN ('Pop', 'Rock')
GROUP BY g.name;
-- 3 Find a list of all artists and how many albums they have.
SELECT COUNT(*), artist.name
FROM album
JOIN artist ON artist.artist_id = album.artist_id
GROUP BY artist.name;



-- Use Distinct
-- 1 From the track table find a unique list of all composers.
SELECT DISTINCT composer FROM track;
-- 2 From the invoice table find a unique list of all billing_postal_codes.
SELECT DISTINCT billing_postal_code FROM invoice;
-- 3 From the customer table find a unique list of all companys.
SELECT DISTINCT company FROM customer;


-- Delete Rows
-- 1 Copy, paste, and run the SQL code from the summary.
CREATE TABLE practice_delete ( name TEXT, type TEXT, value INTEGER );
INSERT INTO practice_delete ( name, type, value ) VALUES ('delete', 'bronze', 50);
INSERT INTO practice_delete ( name, type, value ) VALUES ('delete', 'bronze', 50);
INSERT INTO practice_delete ( name, type, value ) VALUES ('delete', 'bronze', 50);
INSERT INTO practice_delete ( name, type, value ) VALUES ('delete', 'silver', 100);
INSERT INTO practice_delete ( name, type, value ) VALUES ('delete', 'silver', 100);
INSERT INTO practice_delete ( name, type, value ) VALUES ('delete', 'gold', 150);
INSERT INTO practice_delete ( name, type, value ) VALUES ('delete', 'gold', 150);
INSERT INTO practice_delete ( name, type, value ) VALUES ('delete', 'gold', 150);
INSERT INTO practice_delete ( name, type, value ) VALUES ('delete', 'gold', 150);

SELECT * FROM practice_delete;
-- 2 Delete all 'bronze' entries from the table.
DELETE FROM practice_delete WHERE type = 'bronze';
-- 3 Delete all 'silver' entries from the table.
DELETE FROM practice_delete WHERE type = 'silver';
-- 4 Delete all entries whose value is equal to 150.
DELETE FROM practice_delete WHERE value = 150;


-- eCommerce Simulation - No Hints
-- Create users table - id, name, email
CREATE TABLE users(
    id SERIAL PRIMARY KEY NOT NULL,
    user_name VARCHAR(60) NOT NULL,
    user_email VARCHAR(100) NOT NULL
);
-- (Create products table - id, name, price)
CREATE TABLE products(
    id SERIAL PRIMARY KEY NOT NULL,
    product_name VARCHAR(100) NOT NULL,
    product_price FLOAT(2) NOT NULL
);
-- (Create orders table - id, user_id, date )
CREATE TABLE orders(
    id SERIAL PRIMARY KEY NOT NULL,
    user_id INT NOT NULL,
    order_date TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
     CONSTRAINT fk_user
     	FOREIGN KEY(user_id) 
	  		REFERENCES users(id)
);
-- (Create users_orders_products table - id, order_id, product_id, quantity)
CREATE TABLE users_orders_products(
    id SERIAL PRIMARY KEY NOT NULL,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    CONSTRAINT fk_order
     	FOREIGN KEY(order_id) 
	  		REFERENCES orders(id),
    CONSTRAINT fk_product
     	FOREIGN KEY(product_id) 
	  		REFERENCES products(id)          
);
-- Add 3 users
INSERT INTO users (user_name, user_email) 
VALUES 
('John Doe', 'jd@gogo.ex'),
('Hector Zulu', 'hz@stopstop.org'),
('Flex Armstrong', 'jd@flowtech.io');
-- Add 3 products
INSERT INTO products (product_name, product_price) 
VALUES 
('Hatorade', 187.43),
('ROLF MAYO Sandwich Spread', 8.23),
('Audio Interface', 112.44);
-- Add 3 orders
INSERT INTO orders (user_id)
VALUES 
(1),
(2),
(3);
-- Add products/qty to order
INSERT INTO users_orders_products (order_id, product_id, quantity) 
VALUES 
(1, 1, 3),
(1, 2, 1),
(1, 3, 5);

INSERT INTO users_orders_products (order_id, product_id, quantity) 
VALUES 
(2, 1, 3),
(2, 2, 10);

INSERT INTO users_orders_products (order_id, product_id, quantity) 
VALUES 
(3, 1, 13),
(3, 3, 100);
-- Get all products for the first order.
SELECT * FROM users_orders_products WHERE order_id = 1;
-- Get all orders.
SELECT * FROM orders;
-- Get the total cost of an order ( sum the price of all products on an order ).
SELECT SUM (quantity * products.product_price) AS total FROM users_orders_products 
INNER JOIN products ON products.id = users_orders_products.product_id WHERE order_id = 1;


