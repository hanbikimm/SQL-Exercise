--*
--* 4.3. 세 가지 형태의 조인(JOIN) 문
--*


USE HRDB2
GO


--*
--* 4.3.5. JOIN 문 작성
--*


-- [소스 4-18] 부서 이름을 포함해서 직원 정보 조회

SELECT e.EmpID, e.EmpName, e.DeptID, d.DeptName, e.Phone, e.EMail
	FROM dbo.Employee AS e
	INNER JOIN dbo.Department AS d ON e.DeptID = d.DeptID
	WHERE e.HireDate BETWEEN '2014-01-01' AND '2015-12-31' 
		AND RetireDate IS NULL
GO


-- [소스 4-19] 휴가를 간 적이 있는 직원 정보 조회

SELECT e.EmpID, e.EmpName, v.BeginDate, v.EndDate, v.Reason, v.Duration
	FROM dbo.Employee AS e
	INNER JOIN dbo.Vacation AS v ON e.EmpID = v.EmpID
	WHERE e.HireDate BETWEEN '2015-01-01' AND '2016-12-31' 
		AND RetireDate IS NULL
	ORDER BY e.EmpID ASC
GO


-- [소스 4-20] 본부 이름을 포함해서 부서 정보 조회

SELECT d.DeptID, d.DeptName, d.UnitID, u.UnitName, d.StartDate
	FROM dbo.Department AS d
	INNER JOIN dbo.Unit AS u ON d.UnitID = u.UnitID
GO


-- [소스 4-21] 직원 들의 휴가 현황 조회

SELECT e.EmpID, e.EmpName, v.BeginDate, v.EndDate, v.Reason, v.Duration
	FROM dbo.Employee AS e
	LEFT OUTER JOIN dbo.Vacation AS v ON e.EmpID = v.EmpID
	WHERE e.HireDate BETWEEN '2015-01-01' AND '2016-12-31' 
		AND RetireDate IS NULL
	ORDER BY e.EmpID ASC
GO


-- [소스 4-22] 본부 이름을 포함해서 모든 부서 정보 조회

SELECT d.DeptID, d.DeptName, d.UnitID, u.UnitName
   FROM dbo.Department AS d
   LEFT OUTER JOIN dbo.Unit AS u ON d.UnitID = u.UnitID
GO



--*
--* 4.3.6. 여러 테이블 간의 JOIN 문
--*


-- [소스 4-23] 휴가를 사용한 적이 직원들의 휴가 현황 조회

SELECT e.EmpID, e.EmpName, d.DeptName, u.UnitName, 
       v.BeginDate, v.EndDate, v.Duration
   FROM dbo.Employee AS e
   INNER JOIN dbo.Department AS d ON e.DeptID = d.DeptID
   LEFT OUTER JOIN dbo.Unit AS u ON d.UnitID = u.UnitID
   INNER JOIN dbo.Vacation AS v ON e.EmpID = v.EmpID
   WHERE v.BeginDate BETWEEN '2016-01-01' AND '2016-03-31'
   ORDER BY e.EmpID ASC
GO


-- [소스 4-24] 오류 발생

SELECT v.EmpID, e.EmpName, e.DeptID, e.Phone, SUM(v.Duration) AS [Tot_Duration]
	FROM dbo.Vacation AS v
	INNER JOIN dbo.Employee AS e ON v.EmpID = e.EmpID
	WHERE v.BeginDate BETWEEN '2016-01-01' AND '2016-06-30'
	GROUP BY v.EmpID
	ORDER BY SUM(V.Duration) DESC
GO
/*
메시지 8120, 수준 16, 상태 1, 줄 81
열 'dbo.Employee.EmpName'이(가) 집계 함수나 GROUP BY 절에 없으므로 SELECT 목록에서 사용할 수 없습니다.
*/


-- [소스 4-25] 직원 정보를 포함한 2016년 상반기 휴가 일수 합계 조회

SELECT v.EmpID, e.EmpName, e.DeptID, e.Phone, SUM(v.Duration) AS [Tot_Duration]
	FROM dbo.Vacation AS v
	INNER JOIN dbo.Employee AS e ON v.EmpID = e.EmpID
	WHERE v.BeginDate BETWEEN '2016-01-01' AND '2016-06-30'
	GROUP BY v.EmpID, e.EmpName, e.DeptID, e.Phone
	ORDER BY SUM(v.Duration) DESC
GO


-- [참고]

SELECT EmpID, EmpName, dbo.Employee.DeptID, DeptName, EMail
	FROM dbo.Employee 
	INNER JOIN dbo.Department ON dbo.Employee.DeptID = dbo.Department.DeptID
	WHERE RetireDate IS NULL
GO

SELECT EmpID, EmpName, e.DeptID, DeptName, EMail
	FROM dbo.Employee AS e
	INNER JOIN dbo.Department AS d ON e.DeptID = d.DeptID
	WHERE RetireDate IS NULL
GO

SELECT e.EmpID, e.EmpName, e.DeptID, d.DeptName, e.EMail
	FROM dbo.Employee AS e
	INNER JOIN dbo.Department AS d ON e.DeptID = d.DeptID
	WHERE e.RetireDate IS NULL
GO