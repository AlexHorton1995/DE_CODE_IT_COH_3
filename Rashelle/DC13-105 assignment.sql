use pubs

select sum(BookSubTotal) GrandTotal from(
select title_id MultiTitleid, ytd_sales TotalSales, (price * ytd_sales) BookSubTotal
	from titles
where ytd_sales is not null
)SubQ
inner join (
select title, title_id MainTitleID from titles
) GetTitles on MainTitleID = SubQ.MultiTitleID 


