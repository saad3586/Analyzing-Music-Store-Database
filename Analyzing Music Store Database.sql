-- Question Set 1 - Easy

-- Q1. Who is the senior most employee based on job title?

select top 1 * 
from employee
order by levels desc

-- Q2. Which countries have the most Invoices?

select count(*) as c, billing_country 
from invoice
group by billing_country
order by c desc

-- Q3. What are top 3 values of total Invoice?

select top 3 total  
from invoice
order by total desc

-- Q4. Which City has the best Customers? 
-- We would like to throw a Promotional Music Festival in the City we made the mostmoney. 
-- Write a query that return one city that has the highest sum of money Write a Return 
-- both the City name & sum of all Invoice totals.

select * from invoice

select sum(total) as invoice_total, billing_city 
from invoice
group by billing_city
order by billing_city desc

-- Q5. Who is the best customer? 
-- The customer who has spent the most money will be declared the best csutomer.
-- Write a query that return the person who has spent the most money.

select * from customer

select top 1 customer.customer_id, sum(invoice.total) as total
from customer
join invoice on customer.customer_id = invoice.customer_id
group by customer.customer_id
order  by total desc


-- Question Set2 - Moderate 
-- Q1. Write query to return the email, first name, last name & Genre of all Rock Music Listeners. 
-- Return your list ordered alphabetically by email starting with A.

select * from customer
select * from invoice
select * from invoice_line
select * from genre

select distinct email, first_name, last_name 
from customer
join invoice on customer.customer_id = invoice.customer_id
join invoice_line on invoice.invoice_id = invoice_line.invoice_line_id

where track_id in(
	select track_id from track
	join genre on track.genre_id = genre.genre_id
	where genre.name like 'Rock'
)
order by email



-- Q2. Let's invite the artists who have written the most rock music in our dataset. 
-- Write a query that returns the Artist name and total track count of the 10 top bands. 

select top 10 artist.artist_id,artist.name, count(artist.artist_id) as number_of_songs 
from track
join album on album.album_id = track.track_id
join artist on artist.artist_id = album.artist_id
join genre on genre.genre_id = track.genre_id
where genre.name like 'Rock'
group by artist.artist_id,artist.name 
order by number_of_songs desc 

 -- Q3. Return all the track names that have a song length longer than the average song length.
 -- Return the Name and Milliseconds for each track.
 -- Order by the song length with the longest listed first.

 select * from track

 select name, milliseconds 
 from track
 where milliseconds> (select avg(milliseconds) as avg_length from track)
order by milliseconds desc


-- Question Set-3 - Advance
-- Q1. Find how much amount spent by each customer on artists?
-- Write a query to return customer name, artist anme and total spent.

with best_selling_artist as(
	select top 1 artist.artist_id as artist_id, artist.name as artist_name, sum(invoice_line.unit_price*invoice_line.quantity) as total_sales
	from invoice_line
	join track on track.track_id =invoice_line.track_id
	join album on album.album_id = track.album_id
	join artist on artist.artist_id = album.artist_id
	group by artist.artist_id, artist.name
	order by 3 desc 
)
select c.customer_id, c.first_name, c.last_name, bsa.artist_name, avg(il.unit_price*il.quantity) as total_sales
from invoice i
join customer c on c.customer_id = i.customer_id
join invoice_line il on il.invoice_id = i.invoice_id
join track t on t.track_id = il.track_id
join album alb on alb.album_id = t.album_id
join best_selling_artist bsa on bsa.artist_id = alb.album_id
group by c.customer_id,c.first_name,c.last_name,bsa.artist_name


-- Q2. We want to find out most popular music Gerne for each country.
-- We determine the most popular gerne as the with the highest amount of purchases.
-- Write a query that return each country along with the top shere return all Gernes.

with popular_genre as
(

	select count(invoice_line.quantity) as purchases, customer.country, genre.name, genre.genre_id,
	ROW_NUMBER() over(partition by customer.country order by count(invoice_line.quantity) desc) as RowNo
	from invoice_line
	join invoice on invoice.invoice_id =invoice_line.invoice_id
	join customer on customer.customer_id = invoice.customer_id
	join track on track.track_id = invoice_line.track_id
	join genre on genre.genre_id = track.genre_id
	group by invoice_line.quantity, customer.country,genre.name,genre.genre_id
)
select * from popular_genre where RowNo <=1