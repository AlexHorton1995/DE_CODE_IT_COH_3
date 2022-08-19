use pubs
--first looked at the two tables to find what I am looking for--

select stor_id FROM stores
select stor_id FROM sales

-- find max quanity in sales table from store id 71731--
SELECT count(S.stor_id) FROM sales SA
INNER JOIN stores S on SA.stor_id = S.stor_id
WHERE S.stor_id = '7131'

-- use this to double check there is indeed 6 of the quantity in the sales table for the stor_id 7131--

select stor_id FROM sales 
where stor_id = '7131'