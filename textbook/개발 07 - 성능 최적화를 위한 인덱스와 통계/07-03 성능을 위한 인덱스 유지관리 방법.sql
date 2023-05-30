--*
--* 7.3. 성능을 위한 인덱스 유지관리 방법
--*


USE IndexBasic
GO


--*
--* 7.3.1. 인덱스 다시 구성과 다시 작성
--*


-- [소스 7-10] 인덱스 다시 구성

ALTER INDEX NCL_CustomerID 
	ON dbo.SalesOrderHeader
	REORGANIZE
GO


-- [소스 7-11] 인덱스 다시 작성

ALTER INDEX NCL_CustomerID
	ON dbo.SalesOrderHeader
	REBUILD
GO


-- [소스 7-12] 테이블의 모든 인덱스 옵션 지정해 다시 작성

ALTER INDEX ALL 
	ON dbo.SalesOrderHeader
	REBUILD
GO



--*
--* 7.3.2. FILLFACTOR 옵션 사용
--*


-- [소스 7-13] FILLFACTOR 설정

ALTER INDEX NCL_CustomerID
	ON dbo.SalesOrderHeader
	REBUILD WITH (
		PAD_INDEX = ON, 
		FILLFACTOR = 80
	)
GO



--*
--* 7.3.3. 인덱스 제거
--*


-- [소스 7-14] 인덱스 제거

DROP INDEX NCL_CustomerID 
	ON dbo.SalesOrderHeader
GO