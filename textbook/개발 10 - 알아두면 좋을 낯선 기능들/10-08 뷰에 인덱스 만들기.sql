--*
--* 10.8. 인덱싱된 뷰(Indexed Views)
--*



--*
--* 10.8.2. 일반적인 뷰 만들기
--*


-- [소스 10-51] 일반적인 뷰 만들기

USE IndexBasic
GO

-- 모든 인덱스 제거
EXEC dbo.usp_RemoveAllIndexes
GO

-- 뷰가 있으면 제거
IF OBJECT_ID ('dbo.vw_Orders', 'V') IS NOT NULL
	DROP VIEW dbo.vw_Orders
GO

-- 뷰 만들기
CREATE VIEW dbo.vw_Orders
AS
	SELECT SUM(UnitPrice*OrderQty*(1.00-UnitPriceDiscount)) AS [Revenue],
		   OrderDate, ProductID, COUNT_BIG(*) AS [Count]
		FROM dbo.SalesOrderDetail AS od
		INNER JOIN dbo.SalesOrderHeader AS o ON od.SalesOrderID = o.SalesOrderID
		GROUP BY OrderDate, ProductID
GO


-- [소스 10-52] 성능 확인

SET STATISTICS IO ON
GO

SELECT * 
	FROM dbo.vw_Orders
GO

/*

(142113개 행이 영향을 받음)
테이블 'Worktable'. 검색 수 0, 논리적 읽기 수 0, 물리적 읽기 수 0, 미리 읽기 수 0, LOB 논리적 읽기 수 0, LOB 물리적 읽기 수 0, LOB 미리 읽기 수 0.
테이블 'Workfile'. 검색 수 0, 논리적 읽기 수 0, 물리적 읽기 수 0, 미리 읽기 수 0, LOB 논리적 읽기 수 0, LOB 물리적 읽기 수 0, LOB 미리 읽기 수 0.
테이블 'SalesOrderDetail'. 검색 수 1, 논리적 읽기 수 44274, 물리적 읽기 수 0, 미리 읽기 수 0, LOB 논리적 읽기 수 0, LOB 물리적 읽기 수 0, LOB 미리 읽기 수 0.
테이블 'SalesOrderHeader'. 검색 수 1, 논리적 읽기 수 24688, 물리적 읽기 수 0, 미리 읽기 수 0, LOB 논리적 읽기 수 0, LOB 물리적 읽기 수 0, LOB 미리 읽기 수 0.
*/

SET STATISTICS IO OFF
GO



--*
--* 10.8.3. 뷰에 인덱스 만들기
--*


-- [소스 10-53] SCHEMABINDING 옵션을 사용한 뷰 만들기

ALTER VIEW dbo.vw_Orders
	WITH SCHEMABINDING
AS
	SELECT SUM(UnitPrice*OrderQty*(1.00-UnitPriceDiscount)) AS 'Revenue',
		   OrderDate, ProductID, COUNT_BIG(*) AS 'Count'
		FROM dbo.SalesOrderDetail AS od
		INNER JOIN dbo.SalesOrderHeader AS o ON od.SalesOrderID = o.SalesOrderID
		GROUP BY OrderDate, ProductID
GO


-- [소스 10-54] 인덱스 가능 여부 확인

SELECT OBJECTPROPERTY(OBJECT_ID('dbo.vw_Orders'), 'IsIndexable')  -- 결과: 1
GO


-- [소스 10-55] 인덱스 만들기

-- 고유한 클러스터형 인덱스 만들기
CREATE UNIQUE CLUSTERED INDEX UCL_vw_Orders_OrderDate_ProductID
    ON dbo.vw_Orders (OrderDate, ProductID)
GO

-- 비 클러스터형 인덱스 만들기
CREATE NONCLUSTERED INDEX NCL_vw_Orders_Revenue
    ON dbo.vw_Orders (Revenue)
GO


-- [소스 10-56] 성능 확인

SET STATISTICS IO ON
GO

SELECT * 
	FROM dbo.vw_Orders
GO

/*
(142113개 행이 영향을 받음)
테이블 'vw_Orders'. 검색 수 1, 논리적 읽기 수 726, 물리적 읽기 수 0, 미리 읽기 수 0, LOB 논리적 읽기 수 0, LOB 물리적 읽기 수 0, LOB 미리 읽기 수 0.
*/

SET STATISTICS IO OFF
GO


-- [소스 10-57] 다른 쿼리문 성능 확인

SET STATISTICS IO ON
GO

SELECT SUM(UnitPrice*OrderQty*(1.00-UnitPriceDiscount)) AS [Rev], 
			OrderDate, ProductID
	FROM dbo.SalesOrderDetail AS od
	INNER JOIN dbo.SalesOrderHeader AS o ON od.SalesOrderID=o.SalesOrderID
			AND ProductID BETWEEN 700 AND 800
			AND OrderDate >= '2016-05-01'
	GROUP BY OrderDate, ProductID
	ORDER BY Rev DESC
GO

/*
(6975개 행이 영향을 받음)
테이블 'vw_Orders'. 검색 수 1, 논리적 읽기 수 534, 물리적 읽기 수 0, 미리 읽기 수 4, LOB 논리적 읽기 수 0, LOB 물리적 읽기 수 0, LOB 미리 읽기 수 0.
*/

SET STATISTICS IO OFF
GO



--*
--* 10.8.4. 인덱스 제거
--*


-- [소스 10-58] 인덱스 제거

DROP INDEX UCL_vw_Orders_OrderDate_ProductID 
	ON dbo.vw_Orders 
GO