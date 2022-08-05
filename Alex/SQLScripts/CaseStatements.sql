use pubs 

/*
	Let's say we want to use conditionals on how our data looks.
	We would use the CASE statement.  CASE statements function like logical if conditionals in other programming languages.
	See below for an example of using case statments in an output set.
*/

--78 ROWS
SELECT au_fname, au_lname, phone, 
		address, city, state, zip,
		CASE WHEN zip IN ('65898','77085') THEN 'Restricted Postal' ELSE 'Allowed Postal' END ZipStatus
		from authors
ORDER BY ZipStatus desc

/*
	You can also use case statements to limit what data you pull back as well.
	The below query allows you to also restrict data using the Where Statement.
*/

SELECT au_fname, au_lname, phone, address, city, state, zip, ZipStatus FROM (
	SELECT au_fname, au_lname, phone, 
			address, city, state, zip,
			CASE WHEN zip IN ('65898','77085') THEN 'Restricted Postal' ELSE 'Allowed Postal' END ZipStatus
	from authors
) SubQuery
WHERE ZipStatus = 
	CASE city 
		WHEN 'Austin' THEN 'Restricted Postal' 
		WHEN 'Boise' THEN 'Restricted Postal'
		ELSE 'Allowed Postal'
	END
ORDER BY ZipStatus desc
