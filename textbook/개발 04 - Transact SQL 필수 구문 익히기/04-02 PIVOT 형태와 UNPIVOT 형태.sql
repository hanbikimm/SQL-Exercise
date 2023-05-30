--*
--* 4.2. PIVOT 형태와 UNPIVOT 형태
--*


USE HRDB2
GO


--*
--* 4.2.1. PIVOT 문
--*


-- [소스 4-13] 2016년 2분기 휴가 현황 조회

SELECT EmpID, MONTH(BeginDate) AS [Month], Duration
	FROM dbo.Vacation
	WHERE BeginDate BETWEEN '2016-04-01' AND '2016-06-30'
GO


-- [소스 4-14] PIVOT 형태로 조회

SELECT EmpID, [4], [5], [6]
	FROM (
		SELECT EmpID, MONTH(BeginDate) AS [Month], Duration
			FROM dbo.Vacation
			WHERE BeginDate BETWEEN '2016-04-01' AND '2016-06-30'
		) AS src 
		PIVOT (
			SUM(Duration)
			FOR Month IN ([4], [5], [6])
			) AS pvt
GO


-- [소스 4-15] PIVOT 형태에서 NULL 값은 0으로 표시

SELECT EmpID, ISNULL([4], 0) AS [4월], ISNULL([5], 0) AS [5월], ISNULL([6], 0) AS [6월]
	FROM (
		SELECT EmpID, MONTH(BeginDate) AS [Month], Duration
			FROM dbo.Vacation
			WHERE BeginDate BETWEEN '2016-04-01' AND '2016-06-30'
		) AS src 
		PIVOT (
			SUM(Duration)
			FOR Month IN ([4], [5], [6])
			) AS pvt
GO



--*
--* 4.2.2. UNPIVOT 문
--*


-- [소스 4-16] PIVOT 형태 테이블 만들기

SELECT EmpID, [4], [5], [6]
	INTO dbo.mVacation
	FROM (
		SELECT EmpID, MONTH(BeginDate) AS [Month], Duration
			FROM dbo.Vacation
			WHERE BeginDate BETWEEN '2016-04-01' AND '2016-06-30'
		) AS src 
		PIVOT (
			SUM(Duration)
			FOR Month IN ([4], [5], [6])
			) AS pvt
GO

SELECT * FROM dbo.mVacation
GO


-- [소스 4-17] UNPIVOT 형태로 조회

SELECT EmpID, Month, Duration
	FROM dbo.mVacation
	UNPIVOT (Duration FOR Month IN ([4], [5], [6])) AS uPvt
GO