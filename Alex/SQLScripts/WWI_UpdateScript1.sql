USE WideWorldImporters
GO

--Script to update Nebraska zip codes from Cali zips.  Update statement is below the query
select CustName, Address1, Address2, City, State, ZipCode, OrderDate, OrderID, PONumber, CityID, PostalCityID, DeliveryCityID
FROM (
SELECT CUST.CustomerName CustName, 
	   DeliveryAddressLine1 Address1, 
	   DeliveryAddressLine2 Address2, 
	   CITY.CityName City, 
	   STATES.StateProvinceName [State], 
	   CUST.DeliveryPostalCode ZipCode, 
	   OrderDate, OrderID, CustomerPurchaseOrderNumber PONumber,
	   CityID, PostalCityID, DeliveryCityID
FROM Sales.Customers CUST
INNER JOIN Sales.Orders ORDS ON  ORDS.CustomerID = CUST.CustomerID
INNER JOIN Application.Cities CITY ON CITY.CityID = CUST.DeliveryCityID 
INNER JOIN Application.StateProvinces STATES on STATES.StateProvinceID = CITY.StateProvinceID
) NACSZInfo
where State = 'NEBRASKA' and ZipCode NOT LIKE '6%'

/*
	City	CityIDCnt	CityID	PostalCnt	PostalCityID	DelCnt	DeliveryCityID
	Chalco	147	5966	147	5966	147	5966
	Hayes Center	110	14977	110	14977	110	14977
	Heartwell	100	15057	100	15057	100	15057
	Howells	94	16090	94	16090	94	16090
	Lisco	129	19586	129	19586	129	19586
	Nehawka	128	23734	128	23734	128	23734
	Tamora	114	33591	114	33591	114	33591
*/

--update sales.Customers set DeliveryPostalCode = '68138' where DeliveryCityID = 5966 or PostalCityID  = 5966
--update sales.Customers set DeliveryPostalCode = '69032' where DeliveryCityID = 14977 or PostalCityID = 14977
--update sales.Customers set DeliveryPostalCode = '68945' where DeliveryCityID = 15057 or PostalCityID  = 15057
--update sales.Customers set DeliveryPostalCode = '68641' where DeliveryCityID = 16090 or PostalCityID  = 16090
--update sales.Customers set DeliveryPostalCode = '69148' where DeliveryCityID = 19586 or PostalCityID  = 19586
--update sales.Customers set DeliveryPostalCode = '68413' where DeliveryCityID = 23734 or PostalCityID  = 23734
--update sales.Customers set DeliveryPostalCode = '68434' where DeliveryCityID = 33591 or PostalCityID  = 33591
