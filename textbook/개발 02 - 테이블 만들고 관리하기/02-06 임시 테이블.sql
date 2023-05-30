--*
--* 2.6. 임시 테이블
--*


USE HRDB2
GO


--*
--* 2.6.1. 지역 임시 테이블과 전역 임시 테이블
--*


-- [소스 2-65] 지역 임시 테이블 만들기

-- 임시 테이블 만들기
CREATE TABLE #Emp01 (
	EmpID char(5) NOT NULL,
	EmpName nvarchar(10) NOT NULL,
	HireDate date NOT NULL,
	RetireDate date NOT NULL,
	EMail varchar(60) NOT NULL
)
GO

-- 데이터 추가
INSERT INTO #Emp01
	SELECT EmpID, EmpName, HireDate, RetireDate, EMail
		FROM dbo.Employee
		WHERE RetireDate IS NOT NULL
GO

-- 확인
SELECT * FROM #Emp01
GO


-- [소스 2-66] SELECT…INTO 문으로 지역 임시 테이블 만들기

SELECT EmpID, EmpName, HireDate, RetireDate, EMail
	INTO #Emp02
	FROM dbo.Employee
	WHERE RetireDate IS NOT NULL
GO


-- [소스 2-67] 전역 임시 테이블 만들기

-- 임시 테이블 만들기
SELECT EmpID, EmpName, HireDate, RetireDate, EMail
	INTO ##EmpMan
	FROM dbo.Employee
	WHERE Gender = 'M' AND RetireDate IS NULL
GO

-- 확인
SELECT * FROM ##EmpMan
GO