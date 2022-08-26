USE pubs;

--Example 1
--SELECT SOMEDATE, StoreID, OrderNum, Quantity, MainTitle FROM (
--	SELECT ROW_NUMBER() OVER(PARTITION BY stor_id ORDER BY stor_id) SalesRowCount, 
--	GETDATE() SOMEDATE, stor_id StoreID, ord_num OrderNum, qty Quantity, T.title MainTitle
--	FROM sales S
--	INNER JOIN titles T ON T.title_id = S.title_id
--) SubQ
--WHERE SalesRowCount = 1

--Example 2 - RUN THIS QUERY A SINGLE TIME
--SELECT AuthorID, AuthorFName, AuthorLname, Phone , SOMEDATE, StoreID, OrderNum, Quantity, MainTitle 
--INTO TempTable
--FROM (
--	SELECT ROW_NUMBER() OVER(PARTITION BY stor_id ORDER BY stor_id) SalesRowCount, 
--	GETDATE() SOMEDATE, stor_id StoreID, ord_num OrderNum, qty Quantity, T.title MainTitle, T.title_id TitlesID
--	FROM sales S
--	INNER JOIN titles T ON T.title_id = S.title_id
--) SubQ
--INNER JOIN (
--	SELECT ROW_NUMBER() OVER(PARTITION BY A.au_id, au_fname, au_lname ORDER BY A.au_id, au_fname, au_lname) AuthorCount,
--	A.au_id AuthorID, au_fname AuthorFName, au_lname AuthorLname, phone Phone, title_id TitleID
--	from authors A
--	INNER JOIN titleauthor TA ON TA.au_id = A.au_id 
--) AuthSubQ ON TitleID = SubQ.TitlesID
--WHERE SalesRowCount = 1 AND AuthorCount = 1

--Example 3
--INSERT INTO TempTable (AuthorID, AuthorFName, AuthorLname, Phone , SOMEDATE, StoreID, OrderNum, Quantity, MainTitle)
--SELECT AuthSubQ.AuthorID, AuthSubQ.AuthorFName, AuthSubQ.AuthorLname, AuthSubQ.Phone, SubQ.SOMEDATE, SubQ.StoreID, SubQ.OrderNum, SubQ.Quantity, Subq.MainTitle 
--FROM (
--	SELECT ROW_NUMBER() OVER(PARTITION BY stor_id ORDER BY stor_id) SalesRowCount, 
--	GETDATE() SOMEDATE, stor_id StoreID, ord_num OrderNum, qty Quantity, T.title MainTitle, T.title_id TitlesID
--	FROM sales S
--	INNER JOIN titles T ON T.title_id = S.title_id
--) SubQ
--INNER JOIN (
--	SELECT ROW_NUMBER() OVER(PARTITION BY A.au_id, au_fname, au_lname ORDER BY A.au_id, au_fname, au_lname) AuthorCount,
--	A.au_id AuthorID, au_fname AuthorFName, au_lname AuthorLname, phone Phone, title_id TitleID
--	from authors A
--	INNER JOIN titleauthor TA ON TA.au_id = A.au_id 
--) AuthSubQ ON TitleID = SubQ.TitlesID
--LEFT OUTER JOIN TempTable Temp ON 
--Temp.AuthorID = AuthSubQ.AuthorID
--WHERE AuthSubQ.AuthorID IS NULL 

--SELECT * FROM TempTable

--EXAMPLE 4
--SELECT AuthorID, AuthorFName, AuthorLname, Phone , SOMEDATE, StoreID, OrderNum, Quantity, MainTitle FROM (
--SELECT ROW_NUMBER() OVER(PARTITION BY AuthorID, AuthorFName, AuthorLname, Phone ORDER BY AuthorID, AuthorFName, AuthorLname, Phone ) TableKey, AuthorID, AuthorFName, AuthorLname, Phone , SOMEDATE, StoreID, OrderNum, Quantity, MainTitle FROM #TempTable 
--) SUBQUEUE
--WHERE TableKey = 1
--ORDER BY AuthorID

--Example of Subquery on the same table :)
SELECT SUM(BookSubTotal) GrandTotal FROM(
	select title_id MultiTitleID, ytd_sales TotalSales, (price * ytd_sales) BookSubTotal
		from titles
	where ytd_sales is not null
)SubQ
inner join (
	select title, title_id MainTitleID from titles
) GetTitles ON MainTitleID = SubQ.MultiTitleID

