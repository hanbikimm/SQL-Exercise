--*
--* 10.7. ColumnStore 인덱스
--*



--*
--* 10.7.2. Columnstore 인덱스 만들기
--*


-- [소스 10-47] 인덱스 만들기

USE IndexBasic
GO

-- 기존 모든 인덱스 삭제
EXEC dbo.usp_RemoveAllIndexes
GO

-- 클러스터형 인덱스 만들기
CREATE CLUSTERED INDEX CL_SalesOrderHeader
	ON dbo.SalesOrderHeader(SalesOrderID)
GO

-- 비 클러스터형 Columnstore 인덱스 만들기
CREATE COLUMNSTORE INDEX CSI_SalesOrderHeader
	ON dbo.SalesOrderHeader(SalesOrderID, OrderDate, DueDate, ShipDate, 
		CustomerID, SalesPersonID, SubTotal, TotalDue)
GO


-- [소스 10-48] 쿼리 성능 비교

SET STATISTICS IO ON
GO

-- 클러스터형 인덱스 사용
SELECT CustomerID, 
		SUM(SubTotal) AS [SUM_Subtotal], AVG(SubTotal) AS [AVG_Subtotal], 	
		SUM(TotalDue) AS [SUM_TotalDue], AVG(TotalDue) AS [AVG_TotalDue] 
	FROM dbo.SalesOrderHeader
	GROUP BY CustomerID
	ORDER BY CustomerID
	OPTION (IGNORE_NONCLUSTERED_COLUMNSTORE_INDEX) -- Columnstore 인덱스 무시
GO
/*
(19053개 행이 영향을 받음)
테이블 'Worktable'. 검색 수 0, 논리적 읽기 수 0, 물리적 읽기 수 0, 미리 읽기 수 0, LOB 논리적 읽기 수 0, LOB 물리적 읽기 수 0, LOB 미리 읽기 수 0.
테이블 'Workfile'. 검색 수 0, 논리적 읽기 수 0, 물리적 읽기 수 0, 미리 읽기 수 0, LOB 논리적 읽기 수 0, LOB 물리적 읽기 수 0, LOB 미리 읽기 수 0.
테이블 'SalesOrderHeader'. 검색 수 1, 논리적 읽기 수 24944, 물리적 읽기 수 0, 미리 읽기 수 0, LOB 논리적 읽기 수 0, LOB 물리적 읽기 수 0, LOB 미리 읽기 수 0.
*/

-- 비 클러스터형 Columnstore 인덱스 사용
SELECT CustomerID, 
		SUM(SubTotal) AS [SUM_Subtotal], AVG(SubTotal) AS [AVG_Subtotal], 	
		SUM(TotalDue) AS [SUM_TotalDue], AVG(TotalDue) AS [AVG_TotalDue] 
	FROM dbo.SalesOrderHeader
	GROUP BY CustomerID
	ORDER BY CustomerID 
GO
/*
(19053개 행이 영향을 받음)
테이블 'SalesOrderHeader'. 검색 수 2, 논리적 읽기 수 0, 물리적 읽기 수 0, 미리 읽기 수 0, LOB 논리적 읽기 수 1300, LOB 물리적 읽기 수 0, LOB 미리 읽기 수 0.
'SalesOrderHeader' 테이블에서 세그먼트가 1을(를) 읽고 0을(를) 건너뛰었습니다.
테이블 'Worktable'. 검색 수 0, 논리적 읽기 수 0, 물리적 읽기 수 0, 미리 읽기 수 0, LOB 논리적 읽기 수 0, LOB 물리적 읽기 수 0, LOB 미리 읽기 수 0.
*/
SELECT * FROM dbo.SalesOrderHeader

UPDATE dbo.SalesOrderHeader
	SET TotalDue = 40000.
	WHERE SalesOrderID = 333724
GO

-- [소스 10-49] 인덱스 만들기

-- 기존 모든 인덱스 삭제
EXEC dbo.usp_RemoveAllIndexes
GO

-- 기존 테이블에 클러스터형 인덱스 만들기
CREATE CLUSTERED INDEX CL_SalesOrderHeader
	ON dbo.SalesOrderHeader(SalesOrderID)
GO

-- 비교할 새로운 테이블 만들기
SELECT * 
	INTO dbo.New_SalesOrderHeader
	FROM dbo.SalesOrderHeader
GO

-- 새로운 테이블에 클러스터형 Columnstore 인덱스 만들기
CREATE CLUSTERED COLUMNSTORE INDEX CSI_New_SalesOrderHeader
	ON dbo.New_SalesOrderHeader 
GO


-- [소스 10-50] 쿼리 성능 비교

-- 클러스터형 인덱스 사용
SELECT CustomerID, 
		SUM(SubTotal) AS [SUM_Subtotal], AVG(SubTotal) AS [AVG_Subtotal], 	
		SUM(TotalDue) AS [SUM_TotalDue], AVG(TotalDue) AS [AVG_TotalDue] 
	FROM dbo.SalesOrderHeader
	GROUP BY CustomerID
	ORDER BY CustomerID
GO
/*
(19053개 행이 영향을 받음)
테이블 'Worktable'. 검색 수 0, 논리적 읽기 수 0, 물리적 읽기 수 0, 미리 읽기 수 0, LOB 논리적 읽기 수 0, LOB 물리적 읽기 수 0, LOB 미리 읽기 수 0.
테이블 'Workfile'. 검색 수 0, 논리적 읽기 수 0, 물리적 읽기 수 0, 미리 읽기 수 0, LOB 논리적 읽기 수 0, LOB 물리적 읽기 수 0, LOB 미리 읽기 수 0.
테이블 'SalesOrderHeader'. 검색 수 1, 논리적 읽기 수 24944, 물리적 읽기 수 0, 미리 읽기 수 0, LOB 논리적 읽기 수 0, LOB 물리적 읽기 수 0, LOB 미리 읽기 수 0.
*/

-- 클러스터형 Columnstore 인덱스 사용
SELECT CustomerID, 
		SUM(SubTotal) AS [SUM_Subtotal], AVG(SubTotal) AS [AVG_Subtotal], 	
		SUM(TotalDue) AS [SUM_TotalDue], AVG(TotalDue) AS [AVG_TotalDue] 
	FROM dbo.New_SalesOrderHeader
	GROUP BY CustomerID
	ORDER BY CustomerID 
GO
/*
(19053개 행이 영향을 받음)
테이블 'New_SalesOrderHeader'. 검색 수 1, 논리적 읽기 수 0, 물리적 읽기 수 0, 미리 읽기 수 0, LOB 논리적 읽기 수 891, LOB 물리적 읽기 수 0, LOB 미리 읽기 수 0.
'New_SalesOrderHeader' 테이블에서 세그먼트가 2을(를) 읽고 0을(를) 건너뛰었습니다.
테이블 'Worktable'. 검색 수 0, 논리적 읽기 수 0, 물리적 읽기 수 0, 미리 읽기 수 0, LOB 논리적 읽기 수 0, LOB 물리적 읽기 수 0, LOB 미리 읽기 수 0.
*/
