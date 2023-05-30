--*
--* 8.3. 사용자 정의 함수(User Defined Functions)
--*


USE HRDB2
GO


--*
--* 8.3.2. 스칼라 함수 만들기
--*


-- [소스 8-40] 부서 코드를 받아 해당 부서의 직원 수를 넘겨주는 스칼라 함수 만들기

CREATE FUNCTION dbo.ufn_MemberCount(@DeptID char(3))
	RETURNS int
AS
BEGIN
	DECLARE @num int
	SELECT @num = COUNT(*) FROM dbo.Employee
		WHERE DeptID = @DeptID
	RETURN @num
END
GO


-- [소스 8-41] 스칼라 함수 사용하기

SELECT dbo.ufn_MemberCount('SYS') 	-- 결과: 6
GO


-- [소스 8-42] 스칼라 함수 사용하기

SELECT DeptID, DeptName, StartDate, dbo.ufn_MemberCount(DeptID) AS [EmpCount]
	FROM dbo.Department
	WHERE dbo.ufn_MemberCount(DeptID) > 3
GO


-- [소스 8-43] 부서 코드를 받아 부서 이름을 넘겨주는 스칼라 함수 만들기

CREATE FUNCTION dbo.ufn_DeptName(@DeptID char(3))
	RETURNS nvarchar(10)
AS
BEGIN
	DECLARE @DeptName nvarchar(10)
	SELECT @DeptName = DeptName FROM dbo.Department
		WHERE DeptID = @DeptID
	RETURN @DeptName
END
GO


-- [소스 8-44] 스칼라 함수 사용하기

SELECT dbo.ufn_DeptName('SYS')  --> 정보시스템
GO

SELECT EmpID, EmpName, DeptID, dbo.ufn_DeptName(DeptID) AS [DeptName], HireDate, RetireDate
	FROM dbo.Employee
	WHERE RetireDate IS NOT NULL
GO



--*
--* 8.3.3. 인라인 테이블 값 함수 만들기
--*


-- [소스 8-45] 부서 코드를 받아 해당 부서의 직원 목록을 넘겨주는 테이블 값 함수 만들기

CREATE FUNCTION dbo.ufn_DepartmentMember(@DeptID char(3))
	RETURNS TABLE
AS
	RETURN(
		SELECT EmpID, EmpName, DeptID, Gender, HireDate, Phone, EMail
			FROM dbo.Employee
			WHERE DeptID = @DeptID
	)
GO


-- [소스 8-46] 인라인 테이블 값 함수 사용

SELECT * FROM dbo.ufn_DepartmentMember('SYS')
GO

SELECT * FROM dbo.ufn_DepartmentMember('MKT')
GO



--*
--* 8.3.4. 다중문 테이블 값 함수 만들기
--*


-- [소스 8-47] 다중문 테이블 값 함수 만들기

CREATE FUNCTION dbo.ufn_EmployeeList(@format varchar(6))
	RETURNS @Employee TABLE(
		EmplD char(5) PRIMARY KEY, 
		EmpName nvarchar(100),
		Gender char(1),
		HireDate date,
		Phone char(13)
)
AS
	BEGIN
		IF (@format = 'EMAIL')
			INSERT INTO @Employee
				SELECT EmpID, EmpName + '(' + EMail + ')', Gender, HireDate, Phone
					FROM dbo.Employee
		ELSE IF (@format = 'DEPTID')
			INSERT INTO @Employee
				SELECT EmpID, EmpName + '(' + DeptID + ')', Gender, HireDate, Phone
					FROM dbo.Employee
		ELSE IF (@format = 'NAME')
			INSERT INTO @Employee
				SELECT EmpID, EmpName, Gender, HireDate, Phone
					FROM dbo.Employee
		RETURN
	END
GO


-- [소스 8-48] 다중문 테이블 값 함수 사용

SELECT * 
	FROM dbo.ufn_EmployeeList('DEPTID')
	WHERE HireDate BETWEEN '2014-01-01' AND '2014-12-31'
GO

SELECT * 
	FROM dbo.ufn_EmployeeList('EMAIL')
	WHERE HireDate BETWEEN '2014-01-01' AND '2014-12-31'
GO

SELECT * 
	FROM dbo.ufn_EmployeeList('NAME')
	WHERE HireDate BETWEEN '2014-01-01' AND '2014-12-31'
GO