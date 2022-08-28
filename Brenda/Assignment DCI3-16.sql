use pubs
--first looked at the two tables to find what I am looking for--

select stor_id FROM stores
select stor_id FROM sales

-- find max quanity in sales table from store id 71731--
SELECT MAX(qty) FROM sales
WHERE stor_id = '7131'
