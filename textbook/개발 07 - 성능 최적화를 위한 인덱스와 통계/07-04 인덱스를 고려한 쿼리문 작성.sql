--*
--* 7.4. 인덱스를 고려한 쿼리문 작성
--*



--*
--* 7.4.1. 열 변경하지 않기
--*


-- [소스 7-15] 인덱스 만들기

USE IndexBasic
GO

-- 모든 인덱스 제거
EXEC dbo.usp_RemoveAllIndexes
GO

-- 인덱스 만들기
CREATE NONCLUSTERED INDEX NCL_OrderDate_DueDate_ShipDate
	ON dbo.SalesOrderHeader(OrderDate, DueDate, ShipDate)
	WITH (ONLINE = ON)
GO


-- [소스 7-16] 열을 변형한 경우 쿼리 성능 확인

-- 페이지 I/O 정보 표시
SET STATISTICS IO ON
GO

-- 쿼리 수행
SELECT SalesOrderID, Status, SalesOrderNumber, AccountNumber, 
	   CreditCardApprovalCode, TotalDue
	FROM dbo.SalesOrderHeader
	WHERE CONVERT(char(8), OrderDate, 112) = '20140602'
GO

-- 페이지 I/O 정보 표시 취소
SET STATISTICS IO ON
GO

/*
(912개 행이 영향을 받음)
테이블 'SalesOrderHeader'. 검색 수 5, 논리적 읽기 수 24693, 물리적 읽기 수 0, 미리 읽기 수 0, LOB 논리적 읽기 수 0, LOB 물리적 읽기 수 0, LOB 미리 읽기 수 0.
*/

-- [소스 7-17] 열을 변형하지 않은 경우 쿼리 성능 확인

-- 페이지 I/O 정보 표시
SET STATISTICS IO ON
GO

-- 쿼리 수행
SELECT SalesOrderID, Status, SalesOrderNumber, AccountNumber, CreditCardApprovalCode, TotalDue
	FROM dbo.SalesOrderHeader
	WHERE OrderDate = '20140602'
GO

-- 페이지 I/O 정보 표시 취소
SET STATISTICS IO OFF
GO

/*
(912개 행이 영향을 받음)
테이블 'SalesOrderHeader'. 검색 수 1, 논리적 읽기 수 919, 물리적 읽기 수 0, 미리 읽기 수 0, LOB 논리적 읽기 수 0, LOB 물리적 읽기 수 0, LOB 미리 읽기 수 0.
*/



--*
--* 7.4.2. 서로 비교되는 데이터 형식 일치시키기
--*


-- [소스 7-18] 인덱스 만들기

USE IndexBasic
GO

-- 모든 인덱스 제거
EXEC dbo.usp_RemoveAllIndexes
GO

-- 인덱스 만들기
CREATE NONCLUSTERED INDEX NCL_CreditCardApprovalCode
	ON dbo.SalesOrderHeader(CreditCardApprovalCode)
	WITH (ONLINE = ON)
GO


-- [소스 7-19] 데이터 형식이 일치하지 않은 경우 성능 확인

-- 페이지 I/O 정보 표시
SET STATISTICS IO ON
GO

-- 쿼리 실행
SELECT SalesOrderID, Status, SalesOrderNumber, OrderDate, AccountNumber, TotalDue 
	FROM dbo.SalesOrderHeader
	WHERE CreditCardApprovalCode = N'88031Vi9920'
GO

-- 페이지 I/O 정보 표시 취소
SET STATISTICS IO OFF
GO

/*
(17개 행이 영향을 받음)
테이블 'SalesOrderHeader'. 검색 수 1, 논리적 읽기 수 3933, 물리적 읽기 수 0, 미리 읽기 수 0, LOB 논리적 읽기 수 0, LOB 물리적 읽기 수 0, LOB 미리 읽기 수 0.
*/


-- [소스 7-20] 데이터 형식이 일지하는 경우 성능 확인

-- 페이지 I/O 정보 표시
SET STATISTICS IO ON
GO

-- 쿼리 실행
SELECT SalesOrderID, Status, SalesOrderNumber, OrderDate, AccountNumber, TotalDue 
	FROM dbo.SalesOrderHeader
	WHERE CreditCardApprovalCode = '88031Vi9920'
GO

-- 페이지 I/O 정보 표시 취소
SET STATISTICS IO OFF
GO

/*
(17개 행이 영향을 받음)
테이블 'SalesOrderHeader'. 검색 수 1, 논리적 읽기 수 20, 물리적 읽기 수 0, 미리 읽기 수 0, LOB 논리적 읽기 수 0, LOB 물리적 읽기 수 0, LOB 미리 읽기 수 0.
*/



--*
--* 7.4.3. 불필요한 구문 삭제하기
--*


-- [소스 7-21] 인덱스 만들기

USE IndexBasic
GO

-- 모든 인덱스 제거
EXEC dbo.usp_RemoveAllIndexes
GO

-- 인덱스 만들기
CREATE NONCLUSTERED INDEX NCL_PurchaseOrderNumber
	ON dbo.SalesOrderHeader(PurchaseOrderNumber)
	WITH (ONLINE = ON)
GO


-- [소스 7-22] 불필요한 함수를 포함한 경우 성능 확인

-- 페이지 I/O 정보 표시
SET STATISTICS IO ON
GO

-- 쿼리 수행
SELECT SalesOrderID, Status, SalesOrderNumber, OrderDate, AccountNumber, TotalDue
	FROM dbo.SalesOrderHeader
	WHERE ISNULL(PurchaseOrderNumber, '') = 'PO3828168588'
GO

-- 페이지 I/O 정보 표시 취소
SET STATISTICS IO OFF
GO

/*
(17개 행이 영향을 받음)
테이블 'SalesOrderHeader'. 검색 수 1, 논리적 읽기 수 2220, 물리적 읽기 수 0, 미리 읽기 수 0, LOB 논리적 읽기 수 0, LOB 물리적 읽기 수 0, LOB 미리 읽기 수 0.
*/


-- [소스 7-23] 불필요한 함수를 제외한 경우 성능 확인

-- 페이지 I/O 정보 표시
SET STATISTICS IO ON
GO

-- 쿼리 수행
SELECT SalesOrderID, Status, SalesOrderNumber, OrderDate, AccountNumber, TotalDue
	FROM dbo.SalesOrderHeader
	WHERE PurchaseOrderNumber = 'PO3828168588'
GO

-- 페이지 I/O 정보 표시 취소
SET STATISTICS IO OFF
GO

/*
(17개 행이 영향을 받음)
테이블 'SalesOrderHeader'. 검색 수 1, 논리적 읽기 수 20, 물리적 읽기 수 0, 미리 읽기 수 0, LOB 논리적 읽기 수 0, LOB 물리적 읽기 수 0, LOB 미리 읽기 수 0.
*/



--*
--* 7.4.4. 첫 번째 인덱스 키 열 고려하기
--*


-- [소스 7-24] 인덱스 만들기

USE IndexBasic
GO

-- 모든 인덱스 제거
EXEC dbo.usp_RemoveAllIndexes
GO

-- 인덱스 만들기
CREATE UNIQUE CLUSTERED INDEX CL_SalesOrderDetail
	ON dbo.SalesOrderDetail(SalesOrderID, SalesOrderDetailID)
	WITH (ONLINE = ON)
GO


-- [소스 7-25] 첫 번째 인덱스 키 열을 제외한 경우 성능 확인

-- 페이지 I/O 정보 표시
SET STATISTICS IO ON
GO

-- 쿼리 수행
SELECT SalesOrderID, SalesOrderDetailID, ProductID, OrderQty, LineTotal
	FROM dbo.SalesOrderDetail
	WHERE SalesOrderDetailID = 887788
GO

-- 페이지 I/O 정보 표시 취소
SET STATISTICS IO OFF
GO

/*
(1개 행이 영향을 받음)
테이블 'SalesOrderDetail'. 검색 수 5, 논리적 읽기 수 44833, 물리적 읽기 수 0, 미리 읽기 수 0, LOB 논리적 읽기 수 0, LOB 물리적 읽기 수 0, LOB 미리 읽기 수 0.
*/


-- [소스 7-26] 첫 번째 인덱스 키 열을 포함한 경우 성능 확인

-- 페이지 I/O 정보 표시
SET STATISTICS IO ON
GO

-- 쿼리 수행
SELECT SalesOrderID, SalesOrderDetailID, ProductID, OrderQty, LineTotal
	FROM dbo.SalesOrderDetail
	WHERE SalesOrderID = 333724 AND SalesOrderDetailID = 887788
GO

-- 페이지 I/O 정보 표시 취소
SET STATISTICS IO OFF
GO

/*
(1개 행이 영향을 받음)
테이블 'SalesOrderDetail'. 검색 수 0, 논리적 읽기 수 3, 물리적 읽기 수 0, 미리 읽기 수 0, LOB 논리적 읽기 수 0, LOB 물리적 읽기 수 0, LOB 미리 읽기 수 0.
*/



--*
--* 7.4.5. 필요한 열만 SELECT 절에 나열하기
--*


-- [소스 7-27] 인덱스 만들기

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

CREATE NONCLUSTERED INDEX NCL_OrderDate_DueDate_ShipDate
	ON dbo.SalesOrderHeader(OrderDate, DueDate, ShipDate)
	WITH (ONLINE = ON)
GO


-- [소스 7-28] Status 열을 포함한 경우 성능 확인

-- 페이지 I/O 정보 표시
SET STATISTICS IO ON
GO

-- 쿼리 수행
SELECT SalesOrderID, OrderDate, DueDate, ShipDate, Status
	FROM dbo.SalesOrderHeader
	WHERE OrderDate BETWEEN '2014-06-02' AND '2014-06-05'
GO

-- 페이지 I/O 정보 표시 취소
SET STATISTICS IO OFF
GO

/*
(3827개 행이 영향을 받음)
테이블 'SalesOrderHeader'. 검색 수 1, 논리적 읽기 수 11743, 물리적 읽기 수 0, 미리 읽기 수 0, LOB 논리적 읽기 수 0, LOB 물리적 읽기 수 0, LOB 미리 읽기 수 0.
테이블 'Worktable'. 검색 수 0, 논리적 읽기 수 0, 물리적 읽기 수 0, 미리 읽기 수 0, LOB 논리적 읽기 수 0, LOB 물리적 읽기 수 0, LOB 미리 읽기 수 0.
*/


-- [소스 7-29] Status 열을 제외한 경우 성능 확인

-- 페이지 I/O 정보 표시
SET STATISTICS IO ON
GO

-- 쿼리 수행
SELECT SalesOrderID, OrderDate, DueDate, ShipDate 
	FROM dbo.SalesOrderHeader
	WHERE OrderDate BETWEEN '2014-06-02' AND '2014-06-05'
GO

-- 페이지 I/O 정보 표시 취소
SET STATISTICS IO OFF
GO

/*
(3827개 행이 영향을 받음)
테이블 'SalesOrderHeader'. 검색 수 1, 논리적 읽기 수 14, 물리적 읽기 수 0, 미리 읽기 수 0, LOB 논리적 읽기 수 0, LOB 물리적 읽기 수 0, LOB 미리 읽기 수 0.
*/