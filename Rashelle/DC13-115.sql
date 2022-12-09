use pubs

select cust_fname Fname, cust_lname Lname, cust_add1 StreetAddress, cust_city City, cust_state, cust_zip, cust_phone Phone, cust_email Email,
s.ord_date OrderDate, s.ord_num OrderNum, p.pub_name
from customers C
inner join sales s on s.ord_num = c.ord_num
inner join titles T on t.title_id = s.title_id
inner join publishers P on p.pub_id = t.pub_id
where p.pub_id != '4462'

SELECT PublisherName, SUM(TotalSales) TotalSales FROM(
	select pub_name PublisherName, t.ytd_sales TotalSales
	from publishers P
	inner join titles T on t.pub_id = p.pub_id
	where p.pub_id != '4462'
) SubQ
group by PublisherName





