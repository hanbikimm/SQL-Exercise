--*
--* 8.2. 저장 프로시저(Stored Procedures)
--*



USE HRDB2
GO



--*
--* 8.2.2. 저장 프로시저 만들기
--*


-- [소스 8-16] 저장 프로시저 만들기와 실행하기

CREATE PROC dbo.usp_GetEmployee
	@DeptID char(3),
	@FromDate date,
	@ToDate date
AS
BEGIN
	SET NOCOUNT ON
	SELECT EmpID, EmpName, DeptID, HireDate, Phone, EMail
		FROM dbo.Employee
		WHERE DeptID = @DeptID AND HireDate BETWEEN @FromDate AND @ToDate
END
GO

-- 저장 프로시저 호출
EXEC dbo.usp_GetEmployee  
		@DeptID = 'SYS', 
		@FromDate = '2013-01-01', 
		@ToDate = '2014-12-31'
GO


-- [소스 8-17] 저장 프로시저 변경

ALTER PROC dbo.usp_GetEmployee
	@DeptID char(3),
	@FromDate date,
	@ToDate date
AS
BEGIN
	SET NOCOUNT ON
	SELECT EmpID, EmpName, Gender, DeptID, HireDate, Phone, EMail
		FROM dbo.Employee
		WHERE DeptID = @DeptID AND HireDate BETWEEN @FromDate AND @ToDate
END
GO


-- [소스 8-18] 저장 프로시저 제거

/*
DROP PROCEDURE dbo.usp_GetEmployee
GO
*/



--*
--* 8.2.3. 입력 매개 변수와 출력 매개 변수
--*


-- [소스 8-19] 매개 변수 기본값 정의

ALTER PROC dbo.usp_GetEmployee
	@DeptID char(3) = NULL,
	@FromDate date = '1900-01-01',
	@ToDate date = '9999-12-31'
AS
BEGIN
	SET NOCOUNT ON;
	SELECT EmpID, EmpName, Gender, DeptID, HireDate, Phone, EMail
		FROM dbo.Employee
		WHERE DeptID = @DeptID AND HireDate BETWEEN @FromDate AND @ToDate
END
GO


-- [소스 8-20] 매개 변수 생략하고 프로시저 실행

EXEC dbo.usp_GetEmployee @DeptID = 'SYS' --> 모든 정보시스템 직원 정보
GO

EXEC dbo.usp_GetEmployee 'SYS', DEFAULT, '2014-12-31' --> 2008년까지 입사한 정보시스템 직원
GO


-- [소스 8-21] 매개 변수 유효성 검사

ALTER PROC dbo.usp_GetEmployee
	@DeptID char(3) = NULL,
	@FromDate date = '1900-01-01',
	@ToDate date = '9999-12-31'
AS
	SET NOCOUNT ON
	-- 부서 코드가 NULL 값이면 오류 메시지 표시 후 종료
	IF @DeptID IS NULL
		BEGIN
			RAISERROR('에러: 부서코드를 필히 지정해야 합니다.', 16, 1)
			RETURN
		END
	-- 정상적인 경우만 처리
	SELECT EmpID, EmpName, Gender, DeptID, HireDate, Phone, EMail
		FROM dbo.Employee
		WHERE DeptID = @DeptID AND HireDate BETWEEN @FromDate AND @ToDate
GO


-- [소스 8-22] 출력 매개 변수와 리턴 값

ALTER PROC dbo.usp_GetEmployee
	@DeptID char(3) = NULL,
	@FromDate date = '1900-01-01',
	@ToDate date = '9999-12-31',
	@RowNum int OUTPUT -- 출력 매개변수
AS
	SET NOCOUNT ON
	-- 부서 코드가 NULL 값이면 오류 메시지 표시 후 종료
	IF @DeptID IS NULL
		BEGIN
			RAISERROR('에러: 부서코드를 필히 지정해야 합니다.', 16, 1)
			RETURN -1  -- 처리 실패 통보
		END
	-- 정상적인 경우만 처리
	SELECT EmpID, EmpName, Gender, DeptID, HireDate, Phone, EMail
		FROM dbo.Employee
		WHERE DeptID = @DeptID AND HireDate BETWEEN @FromDate AND @ToDate
	SET @RowNum = @@ROWCOUNT
	RETURN 0  -- 정상 처리 완료 통보
GO


-- [소스 8-23] 출력 매개 변수와 리턴 값 받기

-- 변수 선언
DECLARE @Return int  -- 리턴 값을 받을 변수
DECLARE @Rows int  -- 출력 매개변수 값을 받을 변수

-- 저장 프로시저 실행
EXEC @Return = dbo.usp_GetEmployee
	@DeptID = 'SYS', 
	@FromDate = '2014-01-01', 
	@ToDate = '2014-12-31',
	@RowNum = @Rows OUTPUT

-- 전달 받은 출력 매개변수와 리턴 값 확인
SELECT @Return AS 'Return', @Rows AS 'RowCount'
GO


-- [소스 8-24] 저장 프로시저 실행 결과 테이블에 기록

-- 결과를 저장할 테이블 만들기
CREATE TABLE #Employee (
	EmpID char(5) PRIMARY KEY,
	EmpName nvarchar(4),
	Gender char(1),
	DeptID char(3),
	HireDate date,
	Phone char(13),
	EMail varchar(50)
)

-- 변수 선언
DECLARE @Return int
DECLARE @Rows int

-- 저장 프로시저 실행 결과 테이블에 기록
INSERT INTO #Employee EXEC @Return = dbo.usp_GetEmployee
	@DeptID = 'SYS', 
	@FromDate = '2014-01-01', 
	@ToDate = '2014-12-31',
	@RowNum = @Rows OUTPUT

-- 기록된 테이블 확인
SELECT EmpID, EmpName, Phone, EMail	
	FROM #Employee
GO



--*
--* 8.2.4. 오류 핸들링
--*


-- [소스 8-25] 오류 핸들링

CREATE PROC dbo.usp_InsertDepartment
	@DeptID char(3),
	@DeptName nvarchar(10),
	@UnitID char(1),
	@StartDate date
AS	
	BEGIN TRY
		INSERT INTO dbo.Department VALUES(@DeptID, @DeptName, @UnitID, @StartDate)
	END TRY
	BEGIN CATCH
		SELECT	
			ERROR_LINE() AS [ErrorLine], 
			ERROR_MESSAGE() AS [ErrorMessage],
			ERROR_NUMBER() AS [ErrorNumber],
			ERROR_PROCEDURE() AS [ErrorProcedure],
			ERROR_SEVERITY() AS [ErrorServerity],
			ERROR_STATE() AS [ErrorState]
	END CATCH
GO

EXEC dbo.usp_InsertDepartment 'SYS', N'정보시스템', 'A', '2016-01-01'
GO


-- [소스 8-26] 휴가 현황 조회하는 저장 프로시저 만들기

CREATE PROC dbo.usp_GetVacation
	@EmpID char(5),
	@FromDate date,
	@ToDate date
AS
	SET NOCOUNT ON
	SELECT v.EmpID, e.EmpName, e.Gender, e.DeptID, e.HireDate, 
		   v.BeginDate, v.EndDate, v.Reason
		FROM dbo.Vacation AS v
		INNER JOIN dbo.Employee AS e ON v.EmpID = e.EmpID
		WHERE v.EmpID = @EmpID AND v.BeginDate BETWEEN @FromDate AND @ToDate
GO

-- 호출
EXEC dbo.usp_GetVacation 
	@EmpID = 'S0001', 
	@FromDate = '2015-01-01', 
	@ToDate = '2015-12-31'
GO


-- [소스 8-27] 휴가 정보를 기록하는 저장 프로시저 만들기

CREATE PROC dbo.usp_InsertVacation
	@EmpID char(5),
	@BeginDate date,
	@EndDate date,
	@Reason nvarchar(50)
AS
	SET NOCOUNT ON
	INSERT INTO dbo.Vacation(EmpID, BeginDate, EndDate, Reason)
		VALUES(@EmpID, @BeginDate, @EndDate, @Reason)
GO

-- 호출
EXEC dbo.usp_InsertVacation
	@EmpID = 'S0001',
	@BeginDate = '2016-10-10',
	@EndDate = '2016-10-12',
	@Reason = N'가을 여행'
GO

-- 확인
EXEC dbo.usp_GetVacation
	@EmpID = 'S0001', 
	@FromDate = '2016-10-01',
	@ToDate = '2016-10-31'
GO



--*
--* 8.2.5. 실행 계획 재사용과 재컴파일
--*

 
-- [소스 8-28] 모든 인덱스 삭제

USE IndexBasic
GO

-- 모든 인덱스 삭제
EXEC dbo.usp_RemoveAllIndexes
GO


-- [소스 8-29] 인덱스 만들기

CREATE NONCLUSTERED INDEX NCL_OrderDate 
	ON dbo.SalesOrderHeader(OrderDate)
GO


-- [소스 8-30] 2일간의 주문 현황 조회

SET STATISTICS IO ON
GO
SELECT SalesOrderID, OrderDate, DueDate, ShipDate, TotalDue 
	FROM dbo.SalesOrderHeader
	WHERE OrderDate BETWEEN '2015-07-01' AND '2015-07-02'
GO
SET STATISTICS IO OFF
GO
/*
(2695개 행이 영향을 받음)
테이블 'SalesOrderHeader'. 검색 수 1, 논리적 읽기 수 2704, 물리적 읽기 수 0, 미리 읽기 수 0, LOB 논리적 읽기 수 0, LOB 물리적 읽기 수 0, LOB 미리 읽기 수 0.
테이블 'Worktable'. 검색 수 0, 논리적 읽기 수 0, 물리적 읽기 수 0, 미리 읽기 수 0, LOB 논리적 읽기 수 0, LOB 물리적 읽기 수 0, LOB 미리 읽기 수 0.
*/


-- [소스 8-31] 1년간의 주문 현황 조회

SET STATISTICS IO ON
GO
SELECT SalesOrderID, OrderDate, DueDate, ShipDate, TotalDue 
	FROM dbo.SalesOrderHeader
	WHERE OrderDate BETWEEN '2015-01-01' AND '2015-12-31'
GO
SET STATISTICS IO OFF
GO
/*
(478046개 행이 영향을 받음)
테이블 'SalesOrderHeader'. 검색 수 1, 논리적 읽기 수 24688, 물리적 읽기 수 0, 미리 읽기 수 0, LOB 논리적 읽기 수 0, LOB 물리적 읽기 수 0, LOB 미리 읽기 수 0.
*/


-- [소스 8-32] 저장 프로시저로 만들기

CREATE PROC dbo.usp_GetOrderHeader
	@FromDate date,
	@ToDate date
AS
	SELECT SalesOrderID, OrderDate, DueDate, ShipDate, TotalDue 
		FROM dbo.SalesOrderHeader
		WHERE OrderDate BETWEEN @FromDate AND @ToDate
GO


-- [소스 8-33] 2일간의 주문 현황 조회

SET STATISTICS IO ON
GO
EXEC dbo.usp_GetOrderHeader '2015-07-01', '2015-07-02'
GO
SET STATISTICS IO OFF
GO
/*
(2695개 행이 영향을 받음)
테이블 'SalesOrderHeader'. 검색 수 1, 논리적 읽기 수 2704, 물리적 읽기 수 0, 미리 읽기 수 0, LOB 논리적 읽기 수 0, LOB 물리적 읽기 수 0, LOB 미리 읽기 수 0.
테이블 'Worktable'. 검색 수 0, 논리적 읽기 수 0, 물리적 읽기 수 0, 미리 읽기 수 0, LOB 논리적 읽기 수 0, LOB 물리적 읽기 수 0, LOB 미리 읽기 수 0.
*/


-- [소스 8-34] 1년간의 주문 현황 조회

SET STATISTICS IO ON
GO
EXEC dbo.usp_GetOrderHeader '2015-01-01', '2015-12-31'
GO
SET STATISTICS IO OFF
GO
/*
(478046개 행이 영향을 받음)
테이블 'SalesOrderHeader'. 검색 수 1, 논리적 읽기 수 479058, 물리적 읽기 수 0, 미리 읽기 수 4, LOB 논리적 읽기 수 0, LOB 물리적 읽기 수 0, LOB 미리 읽기 수 0.
테이블 'Worktable'. 검색 수 0, 논리적 읽기 수 0, 물리적 읽기 수 0, 미리 읽기 수 0, LOB 논리적 읽기 수 0, LOB 물리적 읽기 수 0, LOB 미리 읽기 수 0.
*/


-- [소스 8-35] RECOMPILE 옵션을 사용해서 1년간의 주문 현황 조회

SET STATISTICS IO ON
GO
EXEC dbo.usp_GetOrderHeader '2015-01-01', '2015-12-31' WITH RECOMPILE
GO
SET STATISTICS IO OFF
GO
/*
(478046개 행이 영향을 받음)
테이블 'SalesOrderHeader'. 검색 수 1, 논리적 읽기 수 24688, 물리적 읽기 수 0, 미리 읽기 수 0, LOB 논리적 읽기 수 0, LOB 물리적 읽기 수 0, LOB 미리 읽기 수 0.
*/


-- [소스 8-36] sp_recompile 시스템 저장 프로시저 사용

EXEC sp_recompile 'dbo.usp_GetOrderHeader'
GO


-- [소스 8-37] RECOMPILE을 포함해 생성

ALTER PROC dbo.usp_GetOrderHeader
	@FromDate date,
	@ToDate date
	WITH RECOMPILE
AS
	SELECT SalesOrderID, OrderDate, DueDate, ShipDate, TotalDue 
		FROM dbo.SalesOrderHeader
		WHERE OrderDate BETWEEN @FromDate AND @ToDate
GO



--*
--* 8.2.6. 동적 쿼리문(Dynamic Queries)
--*


-- [소스 8-38] 동적 쿼리문 사용

CREATE PROC dbo.usp_GetEmployee_New
	@DeptID char(3) = '',
	@Retired char(1) = ''
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @str varchar(2000)
	SET @str = 'SELECT EmpID, EmpName, Gender, DeptID, HireDate, Phone, EMail
		FROM dbo.Employee
		WHERE 1 = 1 '
	IF ISNULL(@DeptID,'') <> ''
		SET @str = @str + ' AND DeptID = ''' + @DeptID + ''''
	IF @Retired = 'Y'
		SET @str = @str + ' AND RetireDate IS NOT NULL'
	IF @Retired = 'N'
		SET @str = @str + ' AND RetireDate IS NULL'
	EXECUTE(@str)		
END
GO


-- [소스 8-39] 저장 프로시저 호출

-- 전 직원 정보 조회
EXEC dbo.usp_GetEmployee_New @DeptID = '', @Retired = ''
GO

-- 근무중인 직원 정보 조회
EXEC dbo.usp_GetEmployee_New @DeptID = '', @Retired = 'N'
GO

-- 근무중인 영업팀 직원 정보
EXEC dbo.usp_GetEmployee_New @DeptID = 'MKT', @Retired = 'N'
GO

-- 퇴사한 영업팀 직원 정보
EXEC dbo.usp_GetEmployee_New @DeptID = 'MKT', @Retired = 'Y'
GO