--*
--* 7.5. 물리적인 조인 형태 세 가지
--*



--*
--* 7.5.1. 해시 매치(Hash Match)
--*


-- [소스 7-30] 인덱스가 전혀 없는 상태에서 대량의 데이터 조회

USE IndexBasic
GO

-- 모든 인덱스 제거
EXEC dbo.usp_RemoveAllIndexes
GO

-- 데이터 조회
SELECT sh.SalesOrderID, SUM(sd.LineTotal) AS [Total]
	FROM dbo.SalesOrderHeader AS sh
	INNER JOIN dbo.SalesOrderDetail AS sd
		ON sh.SalesOrderID = sd.SalesOrderID
 	WHERE sh.SalesOrderID BETWEEN 333724 AND 435300
	GROUP BY sh.SalesOrderID, sh.OrderDate
GO



--*
--* 7.5.2. 머지 조인(Merge Join)
--*


-- [소스 7-31] 많은 범위의 데이터 조회

USE IndexBasic
GO

-- 모든 인덱스 제거
EXEC dbo.usp_RemoveAllIndexes
GO

-- 인덱스 만들기
CREATE UNIQUE CLUSTERED INDEX UCL_SalesOrderID
	ON dbo.SalesOrderHeader(SalesOrderID)
	WITH (ONLINE = ON)
GO

CREATE UNIQUE CLUSTERED INDEX UCL_SalesOrderID_SalesOrderDetailID
	ON dbo.SalesOrderDetail(SalesOrderID, SalesOrderDetailID)
	WITH (ONLINE = ON)
GO

-- 데이터 조회
SELECT sh.SalesOrderID, SUM(sd.LineTotal) AS [Total]
	FROM dbo.SalesOrderHeader AS sh
	INNER JOIN dbo.SalesOrderDetail AS sd
		ON sh.SalesOrderID = sd.SalesOrderID
 	WHERE sh.SalesOrderID BETWEEN 333724 AND 435300
	GROUP BY sh.SalesOrderID 
GO



--*
--* 7.5.3. 중첩 루프(Nested Loop)
--*


-- [소스 7-32] 적은 범위의 데이터 조회

USE IndexBasic
GO

SELECT sh.SalesOrderID, SUM(sd.LineTotal) AS [Total]
	FROM dbo.SalesOrderHeader AS sh
	INNER JOIN dbo.SalesOrderDetail AS sd
		ON sh.SalesOrderID = sd.SalesOrderID
 	WHERE sh.SalesOrderID BETWEEN 333724 AND 333730
	GROUP BY sh.SalesOrderID 
GO