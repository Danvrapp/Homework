#Select the db to use
use sakila;

# HW 1a
select first_name, last_name
from actor;

# HW 1b
SELECT CONCAT(first_name, " ", last_name) AS "Actor Name "
FROM actor;

# HW 2a
SELECT actor_id AS ID, first_name, last_name
FROM actor
WHERE first_name = "Joe";

# HW 2b
SELECT first_name, last_name
FROM actor
WHERE last_name LIKE "%e%";

# HW 2c
SELECT last_name, first_name
FROM actor
WHERE last_name LIKE "%LI%";

# HW 2d
SELECT country, country_ID
FROM country
WHERE country IN ("Afghanistan", "Bangladesh", "China");

# HW 3a
ALTER TABLE actor
ADD description BLOB NULL;

# HW 3b
ALTER TABLE actor
DROP COLUMN description;

# HW 4a
SELECT last_name, count(last_name) AS "Actors with that last name"
FROM actor
GROUP BY last_name;

# HW 4b
SELECT last_name, count(last_name) AS "Actors with that last name"
FROM actor
GROUP BY last_name
HAVING COUNT(last_name) > 1;

# HW 4c
UPDATE actor
SET first_name = "Harpo"
WHERE first_name = "Groucho" AND last_name = "WIlliams";

# HW 4d
UPDATE actor
SET first_name = "Groucho"
WHERE first_name = "Harpo" AND last_name = "WIlliams";

# HW 5a
describe sakila.address;

# HW 6a
SELECT a.first_name, a.last_name, b.address
FROM staff a
INNER JOIN address b
ON a.address_id = b.address_id;

# HW 6b
SELECT a.first_name,  a.last_name, CONCAT("$", FORMAT(sum(b.amount), 2)) AS "Total sales for August 2015"
FROM staff a
INNER JOIN payment b
ON a.staff_id = b.staff_id
WHERE b.payment_date LIKE "2005-08%"
GROUP BY a.last_name;

# HW 6c
SELECT a.title, count(actor_id) AS "Number of actors"
FROM film a
INNER JOIN film_actor b
ON a.film_id = b.film_id
GROUP BY a.title;

# HW 6d
SELECT a.title, count(*) AS "Copies in inventory"
FROM film a
INNER JOIN inventory b
ON a.film_id = b.film_id
WHERE a.title = "Hunchback Impossible";

# HW 6e
SELECT a.last_name, CONCAT("$", FORMAT(sum(b.amount), 2)) AS "Total spent"
FROM customer a
INNER JOIN payment b
on a.customer_id = b.customer_id
GROUP BY a.last_name
ORDER BY a.last_name ASC;

# HW 7a
SELECT title, language_id
FROM film
WHERE language_id IN (
SELECT language_id
FROM language
WHERE name = "English"
AND title LIKE "K%" OR
title LIKE "Q%"
);

# HW 7b
SELECT first_name, last_name
FROM actor
WHERE actor_id IN (
SELECT actor_id
FROM film_actor
WHERE film_id IN (
SELECT film_id
FROM film
WHERE title = "Alone Trip"
));

# HW 7c
SELECT first_name, last_name, email, d.country
FROM customer a
INNER JOIN address b
ON a.address_id = b.address_id
INNER JOIN city c
ON b.city_id = c.city_id
INNER JOIN country d
ON c.country_ID = d.country_id
WHERE d.country = "Canada";

# HW 7d
SELECT a.title, c.name
FROM film a
INNER JOIN film_category b
ON a.film_id = b.film_id
INNER JOIN category c
ON b.category_id = c.category_id
WHERE c.name = "Family";

# HW 7e - return only top 5 rented movies
SELECT c.title, count(c.title) AS "Times Rented"
FROM rental a
INNER JOIN inventory b
ON a.inventory_id = b.inventory_id
INNER JOIN film c
ON b.film_id = c.film_id
GROUP BY c.title
ORDER BY count(c.title) DESC
LIMIT 5;

# HW 7f
SELECT c.store_id AS "Store number", CONCAT("$", FORMAT(sum(a.amount), 2)) AS "Total Sales"
FROM payment a
INNER JOIN staff b
ON a.staff_ID = b.staff_ID
INNER JOIN store c
ON b.store_id = c.store_id
GROUP BY c.store_id;

# HW 7g
SELECT a.store_id AS "Store ID", c.city AS "City", d.country AS "Country"
FROM store a
INNER JOIN address b
ON a.address_id = b.address_id
INNER JOIN city c
ON b.city_id = c.city_id
INNER JOIN country d
on c.country_id = d.country_id;

# HW 7h
SELECT e.name, CONCAT("$", FORMAT(sum(a.amount),2)) AS "Revenue"
FROM payment a
INNER JOIN rental b
ON a.rental_id = b.rental_id
INNER JOIN inventory c
ON b.inventory_id = c.inventory_id
INNER JOIN film_category d
ON c.film_id = d.film_id
INNER JOIN category e
ON d.category_id = e.category_id
GROUP BY e.name 
ORDER BY sum(a.amount) DESC
LIMIT 5;

# HW 8a
CREATE VIEW top_5_genre AS
    SELECT 
        e.name, CONCAT('$', FORMAT(SUM(a.amount), 2)) AS 'Revenue'
    FROM
        payment a
            INNER JOIN
        rental b ON a.rental_id = b.rental_id
            INNER JOIN
        inventory c ON b.inventory_id = c.inventory_id
            INNER JOIN
        film_category d ON c.film_id = d.film_id
            INNER JOIN
        category e ON d.category_id = e.category_id
    GROUP BY e.name
    ORDER BY SUM(a.amount) DESC
    LIMIT 5;

# HW 8b
SELECT *
FROM top_5_genre;

# HW 8c
DROP VIEW IF EXISTS top_5_genre;