--*
--* 7.2. 다양한 인덱스 만들기
--*


USE IndexBasic
GO


--*
--* 7.2.1. 클러스터형 인덱스 
--*


-- [소스 7-1] 테이블을 스캔하는 쿼리문

SELECT SalesOrderID, OrderDate, DueDate, ShipDate, CustomerID, SalesPersonID
	FROM dbo.SalesOrderHeader
	WHERE SalesOrderID = 1234567 
GO


-- [소스 7-2] 클러스터형 인덱스를 갖는 PRIMARY KEY 만들기

ALTER TABLE dbo.SalesOrderHeader 
	ADD PRIMARY KEY CLUSTERED (SalesOrderID)
GO


-- [소스 7-3] CREATE INDEX 문으로 클러스터형 인덱스 만들기

CREATE UNIQUE CLUSTERED INDEX CL_SalesOrderID
	ON dbo.SalesOrderHeader (SalesOrderID)
GO



--*
--* 7.2.2. 비클러스터형 인덱스
--*


-- [소스 7-4] 클러스터형 인덱스 스캔

SELECT SalesOrderID, OrderDate, DueDate, ShipDate, CustomerID, SalesPersonID
	FROM dbo.SalesOrderHeader
	WHERE CustomerID = 23456
GO


-- [소스 7-5] CREATE INDEX 문으로 비클러스터형 인덱스 만들기

CREATE NONCLUSTERED INDEX NCL_CustomerID
	ON dbo.SalesOrderHeader(CustomerID)
GO



--*
--* 7.2.3. 포함된 인덱스(Included Indexes)
--*


-- [소스 7-6] KEY LOOKUP이 빈번하게 발생하는 쿼리문

SELECT SalesOrderID, CustomerID, SalesPersonID
	FROM dbo.SalesOrderHeader
	WHERE CustomerID = 23456
GO


-- [소스 7-7] 포함된 인덱스 만들기

CREATE NONCLUSTERED INDEX NCL_CustomerID
	ON dbo.SalesOrderHeader(CustomerID)
	INCLUDE(SalesPersonID)
	WITH DROP_EXISTING
GO



--*
--* 7.2.4. 필터된 인덱스(Filtered Indexes)
--*


-- [소스 7-8] 자주 수행되는 쿼리문

SELECT SalesOrderID, OrderDate, DueDate, ShipDate, CustomerID, SalesPersonID
	FROM dbo.SalesOrderHeader
	WHERE OrderDate = '2016-01-01' AND	CurrencyRateID IS NOT NULL
GO


-- [소스 7-9] 필터된 인덱스 만들기

CREATE NONCLUSTERED INDEX NCL_OrderDate
	ON dbo.SalesOrderHeader(OrderDate)
	WHERE CurrencyRateID IS NOT NULL
GO