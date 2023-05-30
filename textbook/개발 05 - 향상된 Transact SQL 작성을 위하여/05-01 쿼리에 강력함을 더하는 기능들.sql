--*
--* 5.1. 쿼리에 강력함을 더하는 기능들
--*


USE HRDB2
GO


--*
--* 5.1.1 TOP (n) 문
--*


-- [소스 5-1] 급여를 많이 받는 상위 5명 조회

SELECT TOP (5) EmpID, EmpName, DeptID, HireDate, Phone, EMail, Salary
	FROM dbo.Employee
	WHERE RetireDate IS NULL
	ORDER BY Salary DESC
GO


-- [소스 5-2] 급여가 같은 경우 포함시켜 조회

SELECT TOP (5) WITH TIES EmpID, EmpName, DeptID, HireDate, Phone, EMail, Salary
	FROM dbo.Employee
	WHERE RetireDate IS NULL
	ORDER BY Salary DESC
GO


-- [소스 5-3] 급여를 많이 받는 상위 14.5% 조회

SELECT TOP (14.5) PERCENT EmpID, EmpName, DeptID, HireDate, Phone, EMail, Salary
	FROM dbo.Employee
	WHERE RetireDate IS NULL
	ORDER BY Salary DESC
GO


-- [소스 5-4] 휴가를 가장 많이 다녀온 직원 TOP 5 조회

SELECT TOP (5) WITH TIES v.EmpID, e.EmpName, SUM(v.Duration) AS [Tot_Duration]
	FROM dbo.Vacation AS v
	INNER JOIN dbo.Employee AS e ON v.EmpID = e.EmpID
	GROUP BY v.EmpID, e.EmpName
	ORDER BY SUM(v.Duration) DESC
GO



--*
--* 5.1.2. CASE 문
--*


-- [소스 5-5] 퇴사자 정보를 M과 F를 남, 여로 표시

SELECT EmpID, EmpName, 
		 CASE WHEN Gender = 'M' THEN N'남'
			  WHEN Gender = 'F' THEN N'여'
			  ELSE '' END AS [Gender], DeptID, HireDate, Phone, EMail 
	FROM dbo.Employee
	WHERE RetireDate IS NOT NULL
GO


-- [소스 5-6] 퇴사자 정보를 M과 F를 남, 여로 표시

SELECT EmpID, EmpName, 
		 CASE Gender WHEN 'M' THEN N'남'
					 WHEN 'F' THEN N'여'
					 ELSE '' END AS [Gender], DeptID, HireDate, EMail 
	FROM dbo.Employee
	WHERE RetireDate IS NOT NULL
GO


-- [소스 5-7] 2014년 입사자 근무, 퇴사로 현재 상태 표시

SELECT EmpID, EmpName, 
		 CASE WHEN RetireDate IS NULL THEN N'근무'
			  ELSE N'퇴사' END AS [Status], DeptID, HireDate, Phone, EMail 
	FROM dbo.Employee
	WHERE HireDate BETWEEN '2014-01-01' AND '2014-12-31'
GO


-- [소스 5-8] 정보시스템 직원 정보 조회

SELECT EmpID, EmpName, 
		CASE WHEN EngName IS NULL THEN 'N/A'
			 ELSE EngName END AS [EngName], Phone, EMail
	FROM dbo.Employee
	WHERE DeptID = 'SYS'
GO


-- [소스 5-9] ISNULL 함수 사용

SELECT EmpID, EmpName, ISNULL(EngName, 'N/A') AS [EngName], Phone, EMail
	FROM dbo.Employee
	WHERE DeptID = 'SYS'
GO


-- [소스 5-10] 근무 중인 직원 부서 코드로 오름차순 정렬

SELECT DeptID, EMpID, EmpName, HireDate, Phone, EMail
	FROM dbo.Employee
	WHERE RetireDate IS NULL
	ORDER BY DeptID ASC
GO


-- [소스 5-11] CASE 문으로 정렬 변경

SELECT DeptID, EmpID, EmpName, HireDate, Phone, EMail
	FROM dbo.Employee
	WHERE RetireDate IS NULL
	ORDER BY CASE DeptID WHEN 'STG' THEN 'AAA' ELSE DeptID END ASC
GO


-- [참고] IIF 함수

SELECT DeptID, EMpID, EmpName, HireDate, Phone, EMail
	FROM dbo.Employee
	WHERE RetireDate IS NULL
	ORDER BY IIF(DeptID = 'STG', 'AAA', DeptID) ASC
GO



--*
--* 5.1.3. CTE 문
--*


-- [소스 5-12] 기본적인 CTE 사용

WITH DeptSalary (DeptID, Tot_Salary)
	AS (SELECT DeptID, SUM(Salary)
			FROM dbo.Employee
			WHERE RetireDate IS NULL
			GROUP BY DeptID)
SELECT * FROM DeptSalary
	WHERE Tot_Salary >= 10000
GO


-- [소스 5-13] CTE와 JOIN

WITH 
	DeptSalary (DeptID, Tot_Salary)
	AS (
		SELECT DeptID, SUM(Salary)
			FROM dbo.Employee
			WHERE RetireDate IS NULL
			GROUP BY DeptID
	)
SELECT s.DeptID, d.DeptName, d.UnitID, s.Tot_Salary 
	FROM DeptSalary AS s
	INNER JOIN dbo.Department AS d ON s.DeptID = d.DeptID
	WHERE s.Tot_Salary >=10000
GO


-- [소스 5-14] CTE를 중첩해서 본부 이름 포함

WITH 
	DeptSalary (DeptID, Tot_Salary)
	AS 
	(
		SELECT DeptID, SUM(Salary)
			FROM dbo.Employee
			WHERE RetireDate IS NULL
			GROUP BY DeptID
	),
	DeptNameSalary (DeptID,  DeptName, UnitID, Tot_Salary)
	AS 
	(
		SELECT s.DeptID, d.DeptName, d.UnitID, s.Tot_Salary
		FROM DeptSalary AS s
		INNER JOIN dbo.Department AS d ON s.DeptID = d.DeptID
		WHERE s.Tot_Salary >=10000
	)
SELECT s.DeptID, s.DeptName, s.UnitID, u.UnitName, s.Tot_Salary
	FROM DeptNameSalary AS s
	LEFT OUTER JOIN dbo.Unit AS u ON s.UnitID = u.UnitID
GO


-- [소스 5-15] 근무 중인 직원 중에서 가장 먼저 입사한 직원 남녀별 3명 조회

WITH HireDate_RNK 
	AS (
		SELECT EmpID, EmpName, DeptID, Gender, HireDate, Phone,
				RANK() OVER(PARTITION BY Gender ORDER BY HireDate ASC) AS [Rnk]
			FROM dbo.Employee
			WHERE RetireDate IS NULL
	)
SELECT * 
	FROM HireDate_RNK
	WHERE Rnk <= 3
GO


-- [소스 5-16] 상하 보고 체계 저장

-- ManagerID 열 추가
ALTER TABLE dbo.Employee
	ADD ManagerID char(5) NULL
GO

-- 테이블 변수에 관리자 정보 추가
DECLARE @ManagerInfo TABLE (
	EmpID  char(5),
	ManagerID char(5)
)
INSERT INTO @ManagerInfo VALUES
('S0003', 'S0001'), ('S0009', 'S0003'),
('S0011', 'S0009'), ('S0013', 'S0009'),
('S0019', 'S0009'), ('S0002', 'S0001'),
('S0006', 'S0002'), ('S0007', 'S0002'),
('S0012', 'S0002'), ('S0017', 'S0007'),
('S0008', 'S0006'), ('S0016', 'S0006'),
('S0018', 'S0006'), ('S0004', 'S0001'),
('S0005', 'S0004'), ('S0010', 'S0004'),
('S0014', 'S0005'), ('S0015', 'S0010'),
('S0020', 'S0001')

-- 테이블에 반영
UPDATE dbo.Employee 
	SET ManagerID = m.ManagerID
	FROM dbo.Employee AS e 
	INNER JOIN @ManagerInfo AS m
		ON e.EmpID = m.EmpID
GO


-- [소스 5-17] 전체 보고 수준 조회

WITH CTE_Emp (EmpID, EmpName, DeptID, ManagerID, Level) 
	AS (
	SELECT EmpID, EmpName, DeptID, ManagerID, 0 
		FROM dbo.Employee
		WHERE ManagerID IS NULL

	UNION ALL

	SELECT e.EmpID, e.EmpName, e.DeptID, e.ManagerID, c.Level + 1
		FROM dbo.Employee AS e
		INNER JOIN CTE_Emp AS c ON c.EmpID = e.ManagerID
)
SELECT * FROM CTE_Emp
GO


-- [소스 5-18] 영업팀 보고 체계 조회

WITH CTE_Emp (EmpID, EmpName, DeptID, ManagerID, Level, ManagerList) 
	AS (
	SELECT EmpID, EmpName, DeptID, ManagerID, 0, CAST('' AS nvarchar(1000))
		FROM dbo.Employee
		WHERE ManagerID IS NULL

	UNION ALL

	SELECT e.EmpID, e.EmpName, e.DeptID, e.ManagerID, c.Level + 1, 
	       CAST( ' → ' + c.EmpName  +  c.ManagerList AS nvarchar(1000))
		FROM dbo.Employee AS e
		INNER JOIN CTE_Emp AS c ON c.EmpID = e.ManagerID
) 
SELECT * 
	FROM CTE_Emp
	WHERE DeptID = 'MKT'
GO


-- [소스 5-19] 2017년 날짜 조회

WITH Dates AS (
	SELECT CAST('2017-01-01' AS date) AS [CalDate]

	UNION ALL

	SELECT DATEADD(day, 1, CalDate) AS [CalDate]
		FROM Dates
		WHERE DATEADD(day, 1, CalDate) < '2018-01-01'
)
SELECT *
	FROM Dates
	OPTION (MAXRECURSION 366) -- 재귀 한계 설정
GO
/*
메시지 530, 수준 16, 상태 1, 줄 282
문이 종료되었습니다. 문이 완료되기 전에 최대 재귀 횟수(100)가 초과되었습니다.
*/



--*
--* 5.1.4. MERGE 문
--*


-- [소스 5-20] 병합에 사용될 소스 테이블 만들기

CREATE TABLE dbo.EmpChanged (
	EmpID char(5) PRIMARY KEY,
	EmpName nvarchar(4) NOT NULL,
	EngName varchar(20) NULL,
	Gender char(1) NOT NULL,
	HireDate date NOT NULL,
	RetireDate date NULL,
	DeptID char(3) REFERENCES Department(DeptID) NOT NULL,
	Phone char(13) NULL,
	EMail varchar(50) NOT NULL,
	Salary int NULL
)
GO


-- [소스 5-21] 병합될 변경 및 추가 사항

-- 변경건
INSERT INTO dbo.EmpChanged VALUES('S0001', N'홍길뚱', 'hong', 'M', '2011-01-01', NULL, 'SYS', '010-1234-1234', 'hong@dbnuri.com', 8500)
INSERT INTO dbo.EmpChanged VALUES('S0006', N'김치국', 'kimchi','M', '2013-03-01', NULL, 'HRD', '010-8765-8765', 'kimchi@dbnuri.com',	6000)
INSERT INTO dbo.EmpChanged VALUES('S0020', N'고소해', 'gogo', 'F', '2013-03-01', '2016-09-30', 'STG', '010-9966-1230', 'haha@dbnuri.com', 5000)
-- 추가건
INSERT INTO dbo.EmpChanged VALUES('S0021', N'박오버', 'over', 'M', '2016-10-01', NULL, 'SYS', '010-9922-1100', 'over@dbnuri.com', 4500)
INSERT INTO dbo.EmpChanged VALUES('S0022', N'나머지', 'nama', 'F', '2016-10-01', NULL, 'HRD', '010-5599-2271', 'merge@dbnuri.com', 4500)
GO

SELECT * FROM dbo.EmpChanged
GO


-- [소스 5-22] 데이터 병합

MERGE dbo.Employee AS e1
	USING (SELECT * FROM dbo.EmpChanged) AS e2 
	ON (e1.EmpID = e2.EmpID)
	WHEN MATCHED THEN
		 UPDATE SET e1.EmpName = e2.EmpName, 
					e1.EngName = e2.EngName, 
					e1.Gender = e2.Gender, 
					e1.HireDate = e2.HireDate,
					e1.RetireDate = e2.RetireDate,
					e1.DeptID = e2.DeptID,
					e1.EMail = e2.EMail,
					e1.Phone = e2.Phone,
					e1.Salary = e2.Salary
	WHEN NOT MATCHED THEN
		 INSERT VALUES(e2.EmpID, e2.EmpName, e2.EngName, e2.Gender, e2.HireDate, e2.RetireDate, e2.DeptID, e2.Phone, e2.EMail, e2.Salary);
GO

-- 반영 건 삭제
TRUNCATE TABLE dbo.EmpChanged
GO

-- 반영 결과 확인
SELECT * 
	FROM dbo.Employee
	WHERE EmpID IN('S0001', 'S0006', 'S0020', 'S0021', 'S0022')
GO



--*
--* 5.1.5. OUTPUT 문
--*


-- [소스 5-23] 급여 변경 처리 내역 기록용 테이블 만들기

CREATE TABLE dbo.EmpSalaryLog (
	LogID int IDENTITY PRIMARY KEY,
	LogType char(1) NOT NULL,
	EmpID char(5) NOT NULL,
	EmpName nvarchar(4) NOT NULL,
	Salary int NULL,
	chgDate datetime DEFAULT GETDATE()
)
GO


-- [소스 5-24] INSERT 기록

INSERT INTO dbo.Employee
	OUTPUT 'I', Inserted.EmpID, Inserted.EmpName, Inserted.Salary
	INTO dbo.EmpSalaryLog(LogType, EmpID, EmpName, Salary)
	VALUES('S0023', N'김새나', 'sana', 'F', '2016-10-01', NULL, 'MKT', '010-6677-3366', 'kimsae@dbnuri.com', 4000)
GO


-- [소스 5-25] UPDATE 기록

UPDATE dbo.Employee
	SET Salary = Salary * 1.5
	OUTPUT 'U', Inserted.EmpID, Inserted.EmpName, Inserted.Salary
	INTO dbo.EmpSalaryLog(LogType, EmpID, EmpName, Salary)
	WHERE DeptID = 'SYS'
GO


-- [소스 5-26] DELETE 기록

DELETE dbo.Employee
	OUTPUT 'D', Deleted.EmpID, Deleted.EmpName, Deleted.Salary
	INTO dbo.EmpSalaryLog(LogType, EmpID, EmpName, Salary)
	WHERE EmpID = 'S0020'
GO


-- [소스 5-27] 급여 변경 기록 조회

SELECT * 
	FROM dbo.EmpSalaryLog
GO



--*
--* 5.1.6. APPLY 문
--*


-- [소스 5-28] 사용자 정의 함수 만들기

CREATE FUNCTION dbo.ufn_MemVacation(@EmpID char(5))
    RETURNS TABLE
AS
    RETURN (
	SELECT BeginDate, EndDate, Reason, Duration
		FROM dbo.Vacation
		WHERE EmpID = @EmpID
    )
GO

SELECT * FROM dbo.ufn_MemVacation('S0006')
GO


-- [소스 5-29] CROSS APPLY

SELECT e.EmpID, e.EmpName, e.HireDate, v.BeginDate, v.EndDate, v.Reason, v.Duration
	FROM dbo.Employee AS e
	CROSS APPLY dbo.ufn_MemVacation(EmpID) AS v
	WHERE DeptID = 'MKT'
GO


-- [소스 5-30] OUTER APPLY

SELECT e.EmpID, e.EmpName, e.HireDate, v.BeginDate, v.EndDate, v.Reason, v.Duration
	FROM dbo.Employee AS e
	OUTER APPLY dbo.ufn_MemVacation(EmpID) AS v
	WHERE DeptID = 'MKT'
GO


-- [소스 5-31] 하위 쿼리와 CROSS APPLY


SELECT e.EmpID, e.EmpName, e.HireDate, v.BeginDate, v.EndDate, v.Reason, v.Duration
	FROM dbo.Employee AS e
	CROSS APPLY (
	SELECT BeginDate, EndDate, Reason, Duration
		FROM dbo.Vacation
		WHERE EmpID = e.EmpID
	) AS v
	WHERE DeptID = 'MKT'
GO



--*
--* 5.1.7. OVER 문 
--*


-- [소스 5-32] 전체 집계

SELECT  DeptID, EmpID, EmpName, Salary,
		COUNT(Salary) OVER() AS [Emp_Count],
		SUM(Salary) OVER() AS [Tot_Salary],
		AVG(Salary) OVER() AS [Avg_Salary],
		MIN(Salary) OVER() AS [Min_Salary],
		MAX(Salary) OVER() AS [Max_Salary]
	FROM dbo.Employee
	WHERE RetireDate IS NULL AND DeptID IN ('MKT', 'SYS')
	ORDER BY DeptID, EmpID
GO


-- [소스 5-33] 부서별 전체 집계

SELECT  DeptID, EmpID, EmpName, Salary,
		COUNT(Salary) OVER(PARTITION BY DeptID) AS [Emp_Count],
		SUM(Salary) OVER(PARTITION BY DeptID) AS [Tot_Salary],
		AVG(Salary) OVER(PARTITION BY DeptID) AS [Avg_Salary],
		MIN(Salary) OVER(PARTITION BY DeptID) AS [Min_Salary],
		MAX(Salary) OVER(PARTITION BY DeptID) AS [Max_Salary]
	FROM dbo.Employee
	WHERE RetireDate IS NULL AND DeptID IN ('MKT', 'SYS')
	ORDER BY DeptID, EmpID
GO


-- [소스 5-34] 부서별 누적 합, 이동 평균 조회

SELECT  DeptID, EmpID, EmpName, Salary,
		SUM(Salary) OVER(PARTITION BY DeptID ORDER BY EmpID) AS [Cumulative_Total],
		AVG(Salary) OVER(PARTITION BY DeptID ORDER BY EmpID) AS [Moving_Avg]
	FROM dbo.Employee
	WHERE RetireDate IS NULL AND DeptID IN ('MKT', 'SYS')
	ORDER BY DeptID, EmpID
GO


-- [소스 5-35] 전체 누적 합, 이동 평균 조회

SELECT  DeptID, EmpID, EmpName, Salary,
		SUM(Salary) OVER(ORDER BY DeptID, EmpID) AS [Cumulative_Total],
		AVG(Salary) OVER(ORDER BY DeptID, EmpID) AS [Moving_Avg]
	FROM dbo.Employee
	WHERE RetireDate IS NULL AND DeptID IN ('MKT', 'SYS')
	ORDER BY DeptID, EmpID
GO


-- [소스 5-36] ROWS 사용해서 현재 행 다음에 나오는 두 개 행으로 창 제한

SELECT  DeptID, EmpID, EmpName, Salary,
			SUM(Salary) OVER(
				PARTITION BY DeptID 
				ORDER BY EmpID
				ROWS BETWEEN CURRENT ROW AND 2 FOLLOWING) AS [Cumulative_Total],
			AVG(Salary) OVER(
				PARTITION BY DeptID 
				ORDER BY EmpID
				ROWS BETWEEN CURRENT ROW AND 2 FOLLOWING) AS [Moving_Avg]
	FROM dbo.Employee
	WHERE RetireDate IS NULL AND DeptID IN ('MKT', 'SYS')
	ORDER BY DeptID, EmpID
GO


-- [소스 5-37] ROWS 절과 함께 UNBOUNDED PRECEDING을 지정

-- PARTITION 첫번째 행애서 시작
SELECT  DeptID, EmpID, EmpName, Salary,
			SUM(Salary) OVER(
				PARTITION BY DeptID 
				ORDER BY EmpID
				ROWS UNBOUNDED PRECEDING) AS [Cumulative_Total],
			AVG(Salary) OVER(
				PARTITION BY DeptID 
				ORDER BY EmpID
				ROWS UNBOUNDED PRECEDING) AS [Moving_Avg]
	FROM dbo.Employee
	WHERE RetireDate IS NULL AND DeptID IN ('MKT', 'SYS')
	ORDER BY DeptID, EmpID
GO



--*
--*  5.1.8. OFFSET AND FETCH 문
--*


-- [소스 5-38] 조건에 맞는 모든 행 조회

SELECT EmpID, EmpName, DeptID, HireDate, Phone, EMail, Salary
	FROM dbo.Employee
	WHERE DeptID IN ('SYS', 'MKT') AND RetireDate IS NULL
	ORDER BY EmpID
GO


-- [소스 5-39] 처음 3개는 제외하고 조회

SELECT EmpID, EmpName, DeptID, HireDate, Phone, EMail, Salary
	FROM dbo.Employee
	WHERE DeptID IN ('SYS', 'MKT') AND RetireDate IS NULL
	ORDER BY EmpID 
	OFFSET 3 ROWS
GO


-- [소스 5-40] 처음부터 5개 조회

SELECT EmpID, EmpName, DeptID, HireDate, Phone, EMail, Salary
	FROM dbo.Employee
	WHERE DeptID IN ('SYS', 'MKT') AND RetireDate IS NULL
	ORDER BY EmpID 
    OFFSET 0 ROWS
    FETCH NEXT 5 ROWS ONLY
GO


-- [소스 5-41] 식 사용하기 

DECLARE @StartNum tinyint = 2, @EndNum tinyint = 5
SELECT EmpID, EmpName, DeptID, HireDate, Phone, EMail, Salary
	FROM dbo.Employee
	WHERE DeptID IN ('SYS', 'MKT') AND RetireDate IS NULL
	ORDER BY EmpID 
    OFFSET @StartNum - 1 ROWS
    FETCH NEXT @EndNum - @StartNum + 1 ROWS ONLY
GO



--*
--*  5.1.9. WITH RESULT SET 문
--*


-- [소스 5-42] 저장 프로시저 만들기

CREATE PROC dbo.usp_DeptEmployee
	@DeptID char(3)
AS
BEGIN 
	SELECT EmpID, EmpName, DeptID, HireDate, Phone, EMail, Salary
		FROM dbo.Employee
		WHERE DeptID = @DeptID
END
GO


-- [소스 5-43] 일반적인 저장 프로시저 호출

EXEC dbo.usp_DeptEmployee 'SYS'
GO


-- [소스 5-44] 저장 프로시저 결과에 대한 열 이름 변경

EXEC dbo.usp_DeptEmployee 'SYS'
	WITH RESULT SETS (
    (      
		사번 char(5),
		이름 nvarchar(4),
		부서코드 char(3),
		입사일 date,
		전화번호 char(13),
		전자메일 varchar(50),
		급여 int
    )
) 
GO



--*
--* 5.1.10. THROW 문
--*


-- [소스 5-45] THROW로 오류 발생시키기

THROW 51000, N'대상 행이 존재하지 않습니다.', 1
GO
/*
메시지 51000, 수준 16, 상태 1, 줄 1
대상 행이 존재하지 않습니다.
*/


-- [소스 5-46] 발생한 오류 메시지를 다시 발생시키기

BEGIN TRY
    INSERT dbo.Department VALUES('MKT', N'영업', 'A', '2012-01-01')
END TRY
BEGIN CATCH
    PRINT N'에러 발생!'
    ;THROW -- 구문의 시작이어야 함으로 ;를 명시적으로 붙여줌
END CATCH
/*
(0개 행이 영향을 받음)
에러 발생!
메시지 2627, 수준 14, 상태 1, 줄 2
PRIMARY KEY 제약 조건 'PK__Departme__0148818E5709B548'을(를) 위반했습니다. 
개체 'dbo.Department'에 중복 키를 삽입할 수 없습니다. 중복 키 값은 (MKT)입니다.
*/