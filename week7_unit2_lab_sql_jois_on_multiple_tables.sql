USE sakila;

# 1. Write a query to display for each store its store ID, city, and country.
SELECT s.store_id, c.city, co.country
FROM store s
JOIN address a
ON s.address_id = a.address_id
JOIN city c
ON a.city_id = c.city_id
JOIN country co
ON c.country_id = co.country_id;

# 2. Write a query to display how much business, in dollars, each store brought in.
SELECT sto.store_id, SUM(amount) AS total_income
FROM payment
JOIN staff sta
USING (staff_id)
JOIN store sto
USING (store_id)
GROUP BY store_id;

# 3. What is the average running time of films by category?
SELECT fc.category_id, ROUND(AVG(f.length)) AS avg_running_time
FROM film f
JOIN film_category fc ON f.film_id = fc.film_id
GROUP BY fc.category_id
ORDER BY avg_running_time desc;

# 4. Which film categories are longest?
SELECT fc.category_id, AVG(f.length) AS avg_running_time
FROM film f
JOIN film_category fc ON f.film_id = fc.film_id
GROUP BY fc.category_id
ORDER BY avg_running_time desc
LIMIT 3; # Category 15, 10 & 9 are the longest categories

# 5. Display the most frequently rented movies in descending order.
SELECT m.film_id, m.title, COUNT(*) AS rental_count
FROM rental r
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film m ON i.film_id = m.film_id
GROUP BY m.film_id, m.title
ORDER BY rental_count DESC;

# 6. List the top five genres in gross revenue in descending order.
SELECT c.name AS genre, SUM(p.amount) AS total_revenue
FROM film f
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
JOIN payment p ON r.rental_id = p.rental_id
GROUP BY c.name
ORDER BY total_revenue DESC
LIMIT 5;

# 7. Is "Academy Dinosaur" available for rent from Store 1?
SELECT f.title, s.store_id, COUNT(*) AS available_copies
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN store s ON i.store_id = s.store_id
LEFT JOIN rental r ON i.inventory_id = r.inventory_id
LEFT JOIN customer c ON r.customer_id = c.customer_id
WHERE f.title = 'Academy Dinosaur' AND s.store_id = 1 AND (r.return_date IS NULL OR r.return_date > NOW())
GROUP BY f.title, s.store_id
HAVING COUNT(*) > 0; # -> No entries, there are currently no available copies of the movie at that store
