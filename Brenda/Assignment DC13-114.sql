use pubs

--You will need to find the total number of titles, books sold, and the total sales monetary amount associated with each publisher id that has sales.  --
use pubs
SELECT Publisher, SUM(bookCnt) 'Books Sold', SUM(TotalAmnt) 'Total Sales Amount' FROM (
SELECT p.pub_name Publisher, COUNT(T.title) bookCnt, t.price TotalAmnt FROM publishers P
INNER JOIN titles T ON T.pub_id = p.pub_id
INNER JOIN sales S ON S.title_id = T.title_id
	GROUP BY T.title, p.pub_name, t.price
)SubQuery
GROUP BY Publisher;