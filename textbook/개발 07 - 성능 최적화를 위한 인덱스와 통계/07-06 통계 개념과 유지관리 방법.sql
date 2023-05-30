--*
--* 7.6. 통계 개념과 유지관리 방법
--*



--*
--* 7.6.1. 통계 이해하기
--*


-- [소스 7-33] 특정 테이블 통계 확인

USE HRDB2
GO

EXEC sp_helpstats 'dbo.Vacation', 'ALL'
GO
 

-- [소스 7-34] 쿼리가 수행될 때 자동으로 만들어지는 통계

SELECT VacationID, EmpID, BeginDate, EndDate, Reason, Duration
	FROM dbo.Vacation
	WHERE EmpID = 'S0001'
GO

EXEC sp_helpstats 'dbo.Vacation', 'ALL'
GO


--[소스 7-35] 인덱스를 만들 때 만들어지는 통계

CREATE NONCLUSTERED INDEX NCL_BeginDate 
	ON dbo.Vacation(BeginDate)
GO
 
EXEC sp_helpstats 'dbo.Vacation', 'ALL'
GO


-- [소스 7-36] 수동으로 통계 만들기

CREATE STATISTICS ST_EndDate 
	ON dbo.Vacation(EndDate)
GO

EXEC sp_helpstats 'dbo.Vacation', 'ALL'
GO


-- [소스 7-37] EmpID 열에 대한 통계 정보 보기

DBCC SHOW_STATISTICS ('dbo.Vacation', EmpID)
GO
-- 또는
DBCC SHOW_STATISTICS ('dbo.Vacation', _WA_Sys_00000002_2B3F6F97)
GO



--*
--* 7.6.2. 통계에 의지하는 SQL Server
--*


-- [소스 7-38] 모든 인덱스 삭제

USE IndexBasic
GO

EXEC dbo.usp_RemoveAllIndexes
GO


-- [소스 7-39] 인덱스 만들기

-- 인덱스 만들기
CREATE NONCLUSTERED INDEX NCL_OrderDate
	ON dbo.SalesOrderHeader(OrderDate)
GO

-- 통계 정보 보기
DBCC SHOW_STATISTICS('dbo.SalesOrderHeader', NCL_OrderDate)
GO


-- [소스 7-40] 예상 행의 수와 실제 행의 수 비교 #1

-- 플랜 캐시 삭제
DBCC FREEPROCCACHE
GO

-- 쿼리 수행
SELECT SalesOrderID, SalesOrderNumber, OrderDate, DueDate, ShipDate 
	FROM dbo.SalesOrderHeader
	WHERE OrderDate = '2014-06-20'
GO


-- [소스 7-41] 예상 행의 수와 실제 행의 수 비교 #2

-- 플랜 캐시 삭제
DBCC FREEPROCCACHE
GO

-- 쿼리 수행
SELECT SalesOrderID, SalesOrderNumber, OrderDate, DueDate, ShipDate 
	FROM dbo.SalesOrderHeader
	WHERE OrderDate = '2014-06-10'
GO



--*
--* 7.6.3. 수동 통계 갱신
--*


-- [소스 7-42] 기본 샘플링으로 통계 갱신

-- 기본 샘플링으로 통계 갱신
UPDATE STATISTICS dbo.SalesOrderHeader(NCL_OrderDate) 
GO

-- 통계 정보 확인
DBCC SHOW_STATISTICS('dbo.SalesOrderHeader', NCL_OrderDate)
GO


-- [소스 7-43] 샘플링 퍼센트 지정

-- 샘플링 20 퍼센트로 통계 갱신
UPDATE STATISTICS dbo.SalesOrderHeader(NCL_OrderDate) 
	WITH SAMPLE 20 PERCENT
GO

-- 통계 정보 확인
DBCC SHOW_STATISTICS('dbo.SalesOrderHeader', NCL_OrderDate)
GO


-- [소스 7-44] 풀 스캔 지정

-- 풀 스캔으로 통계 갱신
UPDATE STATISTICS dbo.SalesOrderHeader(NCL_OrderDate)
	 WITH FULLSCAN
GO

-- 통계 정보 확인
DBCC SHOW_STATISTICS('dbo.SalesOrderHeader', NCL_OrderDate)
GO


-- [소스 7-45] 특정 테이블의 모든 통계 갱신

UPDATE STATISTICS dbo.SalesOrderHeader
GO


-- [소스 7-46] 특정 데이터베이스의 모든 통계 갱신

USE IndexBasic
GO

EXEC sp_updatestats
GO
