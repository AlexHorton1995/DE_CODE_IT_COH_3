USE WideWorldImporters

/* 
	This is an Example of a subquery with a join to get a total count of orders by customer
*/
SELECT CustomerName, TotalOrders FROM (
	SELECT CustomerName, SUM(OrderCount) TotalOrders FROM (
		SELECT COUNT(OrderID) OrderCount, CustomerName FROM SALES.Customers CUSTS
		INNER JOIN sales.Orders ORDS on ORDS.CustomerID = CUSTS.CustomerID
		group by CustomerName, OrderID  
	) SubQ
GROUP BY CustomerName, OrderCount
HAVING SUM(OrderCount) > 125
) MainSub
order by TotalOrders desc



