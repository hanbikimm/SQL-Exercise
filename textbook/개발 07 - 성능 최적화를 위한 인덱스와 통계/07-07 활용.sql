--*
--* 7.7. 활용
--*



--*
--* 7.7.1 인덱스 현황 조회
--*


-- [소스 7-47] 인덱스 현황

USE HRDB2
GO

SELECT OBJECT_NAME(object_id) AS [테이블이름], 
		[HEAP] AS [힙(Heap)], 
		[CLUSTERED] AS [클러스터형], 
		[NONCLUSTERED] AS [비클러스터형], 
		[XML] AS [XML], 
		[SPATIAL] AS [공간], 
		[CLUSTERED COLUMNSTORE] AS [컬럼스토어],
		CASE WHEN [HEAP] = 1 AND [NONCLUSTERED] = 0 THEN 'Y' ELSE 'N' END AS [인덱스없음]
	FROM (
		SELECT object_id, type_desc
			FROM sys.indexes
			WHERE object_id IN (
				SELECT object_id 
					FROM sys.objects 
					WHERE type = 'U')
			) AS p
	PIVOT (
		COUNT(type_desc) FOR type_desc IN ([HEAP], [CLUSTERED], [NONCLUSTERED], 
			[XML], [SPATIAL], [CLUSTERED COLUMNSTORE], [NONCLUSTERED COLUMNSTORE])
	) AS pvt
	ORDER BY [테이블이름]
GO



--*
--* 7.7.2 인덱스 단편화 정도 확인
--*


-- [소스 7-48] 인덱스 단편화 정도 확인

SELECT	DB_NAME(database_id) AS [데이터베이스], 
		OBJECT_NAME(ps.OBJECT_ID) AS [개체], 
		i.name AS [인덱스], 
		ps.index_id AS [인덱스ID], 
		index_type_desc AS [인덱스유형],
		avg_fragmentation_in_percent AS [단편화정도], 
		fragment_count AS [단편화수], 
		page_count AS [페이지수]
	FROM sys.dm_db_index_physical_stats(DB_ID(),NULL, NULL, NULL ,'LIMITED') AS ps 
	INNER JOIN sys.indexes AS i WITH (NOLOCK)
		ON ps.[object_id] = i.[object_id] AND ps.index_id = i.index_id
	WHERE database_id = DB_ID()	AND page_count > 1500
	ORDER BY avg_fragmentation_in_percent DESC OPTION (RECOMPILE)
GO 



--*
--* 7.7.3. ONLINE = ON 옵션
--*


-- [소스 7-49] ONLINE = ON 옵션 사용

-- 예1
CREATE NONCLUSTERED INDEX NCL_CustomerID
	ON dbo.SalesOrderHeader(CustomerID)
	INCLUDE(SalesPersonID)
	WITH (DROP_EXISTING = ON, ONLINE = ON) 
GO

-- 예2
ALTER INDEX NCL_CustomerID
	ON dbo.SalesOrderHeader
	REBUILD WITH (
		PAD_INDEX = ON, 
		FILLFACTOR = 80,
		ONLINE = ON
	)
GO



--*
--* 7.7.4. 인덱스 비활성화와 활성화
--*


-- [소스 7-50] 인덱스 만들기

USE IndexBasic
GO

-- 모든 인덱스 삭제
EXEC usp_RemoveAllIndexes
GO

-- 인덱스 만들기
CREATE NONCLUSTERED INDEX NCL_OrderDate 
	ON dbo.SalesOrderHeader(OrderDate)
GO


-- [소스 7-51] 2일간의 주문 현황 조회

SELECT SalesOrderID, OrderDate, DueDate, ShipDate, TotalDue 
	FROM dbo.SalesOrderHeader
	WHERE OrderDate BETWEEN '2015-07-01' AND '2015-07-02'
GO


-- [소스 7-52] 인덱스 비활성화

ALTER INDEX	NCL_OrderDate
	ON dbo.SalesOrderHeader DISABLE
GO


-- [소스 7-53] 2일간의 주문 현황 조회

SELECT SalesOrderID, OrderDate, DueDate, ShipDate, TotalDue 
	FROM dbo.SalesOrderHeader
	WHERE OrderDate BETWEEN '2015-07-01' AND '2015-07-02'
GO


-- [소스 7-54] 인덱스 활성화

ALTER INDEX	NCL_OrderDate
	ON dbo.SalesOrderHeader REBUILD
GO