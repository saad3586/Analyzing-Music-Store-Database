Question Set 1 - Easy

Q1: Senior Most Employee Based on Job Title

Query:

SELECT TOP 1 *
FROM employee
ORDER BY levels DESC;

Explanation:
This query selects the most senior employee by ordering the employees in descending order based on their levels and returning only the top record.

Q2: Countries with the Most Invoices

Query:

SELECT COUNT(*) AS c, billing_country
FROM invoice
GROUP BY billing_country
ORDER BY c DESC;

Explanation:
Counts the number of invoices per country and sorts them in descending order to find the countries with the most invoices.

Q3: Top 3 Invoice Totals

Query:

SELECT TOP 3 total  
FROM invoice
ORDER BY total DESC;

Explanation:
Retrieves the top 3 highest invoice totals by sorting invoices in descending order.

Q4: City with the Highest Revenue

Query:

SELECT SUM(total) AS invoice_total, billing_city
FROM invoice
GROUP BY billing_city
ORDER BY invoice_total DESC;

Explanation:
Finds the city generating the most revenue by summing invoice totals grouped by city and sorting in descending order.

Q5: Best Customer (Highest Spending Customer)

Query:

SELECT TOP 1 customer.customer_id, SUM(invoice.total) AS total
FROM customer
JOIN invoice ON customer.customer_id = invoice.customer_id
GROUP BY customer.customer_id
ORDER BY total DESC;

Explanation:
Identifies the customer who spent the most by summing their invoice totals and selecting the top record.

Question Set 2 - Moderate

Q1: Rock Music Listeners

Query:

SELECT DISTINCT email, first_name, last_name
FROM customer
JOIN invoice ON customer.customer_id = invoice.customer_id
JOIN invoice_line ON invoice.invoice_id = invoice_line.invoice_id
WHERE track_id IN (
	SELECT track_id FROM track
	JOIN genre ON track.genre_id = genre.genre_id
	WHERE genre.name LIKE 'Rock'
)
ORDER BY email;

Explanation:
Finds customers who have purchased Rock genre tracks and orders them alphabetically by email.

Q2: Top 10 Rock Music Artists by Song Count

Query:

SELECT TOP 10 artist.artist_id, artist.name, COUNT(artist.artist_id) AS number_of_songs
FROM track
JOIN album ON album.album_id = track.album_id
JOIN artist ON artist.artist_id = album.artist_id
JOIN genre ON genre.genre_id = track.genre_id
WHERE genre.name LIKE 'Rock'
GROUP BY artist.artist_id, artist.name
ORDER BY number_of_songs DESC;

Explanation:
Finds the top 10 artists who have the most rock songs in the dataset.

Q3: Tracks Longer than Average Duration

Query:

SELECT name, milliseconds
FROM track
WHERE milliseconds > (SELECT AVG(milliseconds) FROM track)
ORDER BY milliseconds DESC;

Explanation:
Retrieves all tracks longer than the average track duration and sorts them from longest to shortest.

Question Set 3 - Advanced

Q1: Customer Spending on Artists

Query:

WITH best_selling_artist AS (
	SELECT TOP 1 artist.artist_id, artist.name AS artist_name, SUM(invoice_line.unit_price * invoice_line.quantity) AS total_sales
	FROM invoice_line
	JOIN track ON track.track_id = invoice_line.track_id
	JOIN album ON album.album_id = track.album_id
	JOIN artist ON artist.artist_id = album.artist_id
	GROUP BY artist.artist_id, artist.name
	ORDER BY total_sales DESC
)
SELECT c.customer_id, c.first_name, c.last_name, bsa.artist_name, SUM(il.unit_price * il.quantity) AS total_sales
FROM invoice i
JOIN customer c ON c.customer_id = i.customer_id
JOIN invoice_line il ON il.invoice_id = i.invoice_id
JOIN track t ON t.track_id = il.track_id
JOIN album alb ON alb.album_id = t.album_id
JOIN best_selling_artist bsa ON bsa.artist_id = alb.artist_id
GROUP BY c.customer_id, c.first_name, c.last_name, bsa.artist_name;

Explanation:
Finds how much each customer has spent on the best-selling artist.

Q2: Most Popular Genre for Each Country

Query:

WITH popular_genre AS (
	SELECT COUNT(invoice_line.quantity) AS purchases, customer.country, genre.name, genre.genre_id,
	ROW_NUMBER() OVER (PARTITION BY customer.country ORDER BY COUNT(invoice_line.quantity) DESC) AS RowNo
	FROM invoice_line
	JOIN invoice ON invoice.invoice_id = invoice_line.invoice_id
	JOIN customer ON customer.customer_id = invoice.customer_id
	JOIN track ON track.track_id = invoice_line.track_id
	JOIN genre ON genre.genre_id = track.genre_id
	GROUP BY customer.country, genre.name, genre.genre_id
)
SELECT * FROM popular_genre WHERE RowNo = 1;

Explanation:
Determines the most popular music genre in each country by counting purchases and selecting the top-ranked genre per country.

Conclusion

This report provides SQL queries to analyze a music store database, helping to identify key insights such as top-selling artists, best customers, most popular genres, and customer spending habits. These queries help in business decision-making, such as targeting marketing efforts and planning promotional events based on customer preferences and sales data.

**Summary..**
**SQL Skills & Expertise:**
✔ Writing optimized SQL queries to retrieve, aggregate, and analyze data
✔ Using JOINs (INNER JOIN, LEFT JOIN) to combine data from multiple tables
✔ Implementing GROUP BY and ORDER BY for data aggregation and sorting
✔ Applying subqueries and CTEs (Common Table Expressions) for complex data retrieval
✔ Utilizing window functions (ROW_NUMBER, PARTITION BY) for ranking and filtering
✔ Extracting business insights such as top customers, best-selling artists, and popular genres
✔ Working with aggregate functions (SUM, COUNT, AVG) to analyze customer spending and invoice trends
✔ Using WHERE and HAVING clauses for filtering datasets
✔ Identifying high-value customers and best-selling artists for targeted promotions

