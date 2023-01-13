/* Query 1 */
SELECT MediaType.Name media_type, 
		COUNT(Artist.Name) no_of_artists
FROM Track
JOIN MediaType
ON Track.MediaTypeId = MediaType.MediaTypeId
JOIN Album
ON Track.AlbumId = Album.AlbumId
JOIN Artist
ON Album.ArtistId = Artist.ArtistId
GROUP BY 1;

/* Query 2 */
SELECT artist,
		AVG(total_invoice) avg_monthly_inv
FROM
(
SELECT Artist.Name artist,
		strftime('%Y-%m',Invoice.InvoiceDate) inv_date,
		SUM(InvoiceLine.UnitPrice*InvoiceLine.Quantity) total_invoice
FROM Track
JOIN Album
ON Track.AlbumId = Album.AlbumId
JOIN Artist
ON Album.ArtistId = Artist.ArtistId
JOIN InvoiceLine
ON InvoiceLine.TrackId = Track.TrackId
JOIN Invoice
ON InvoiceLine.InvoiceId = Invoice.InvoiceId
GROUP BY 1,2
) sub
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;

/* Query 3 */
SELECT Customer.Country country,
		COUNT(Genre.Name) rock_count
FROM Track
JOIN Genre
ON Track.GenreId = Genre.GenreId
JOIN InvoiceLine
ON InvoiceLine.TrackId = Track.TrackId
JOIN Invoice
ON InvoiceLine.InvoiceId = Invoice.InvoiceId
JOIN Customer
ON Invoice.CustomerId = Customer.CustomerId
WHERE Track.GenreId = (SELECT DISTINCT Genre.GenreId
					FROM Genre WHERE Genre.Name LIKE '%ROCK%')
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;

/* Query 4 */
SELECT artist, month, MAX(total_inv) total_inv
FROM
(
SELECT ar.name artist, 
		strftime('%Y-%m',inv.InvoiceDate) month,
		SUM(InvoiceLine.UnitPrice*InvoiceLine.Quantity) total_inv
FROM Track
JOIN MediaType
ON Track.MediaTypeId = MediaType.MediaTypeId
JOIN Album
ON Track.AlbumId = Album.AlbumId
JOIN Artist ar
ON Album.ArtistId = ar.ArtistId
JOIN InvoiceLine
ON InvoiceLine.TrackId = Track.TrackId
JOIN Invoice inv
ON InvoiceLine.InvoiceId = inv.InvoiceId
WHERE inv.InvoiceDate LIKE '%2011%'
GROUP BY 1,2)
GROUP BY 2;