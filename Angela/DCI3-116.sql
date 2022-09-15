use pubs

select count(cust_city), cust_city, cust_state from customers
where cust_state in ('FL','TX','CA')
group by cust_city, cust_state

SELECT SUM(custcnt) totalcity, cust_city, cust_state from (
SELECT COUNT (cust_city) custcnt, cust_city, cust_state from
	customers
WHERE cust_state IN('FL','TX','CA')
GROUP by cust_city, cust_state
)SubQ
GROUP by cust_city, cust_state
ORDER by totalcity