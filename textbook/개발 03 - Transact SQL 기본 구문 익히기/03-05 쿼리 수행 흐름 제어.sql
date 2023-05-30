--*
--* 3.5. 쿼리 수행 흐름 제어
--*


USE HRDB2
GO


--*
--* 3.5.1. IF … ELSE 문
--*


-- [소스 3-64] 조건을 만족하는 IF 문

DECLARE @Retired char(1)
SET @Retired = 'Y'

IF @Retired = 'Y'
	SELECT EmpID, EmpName, Gender, DeptID, HireDate, RetireDate, Email, Phone 
		FROM dbo.Employee
		WHERE RetireDate IS NOT NULL
GO

-- [소스 3-65] 조건을 만족하지 않는 IF 문

DECLARE @Retired char(1)
SET @Retired = 'N'

IF @Retired = 'Y'
	SELECT EmpID, EmpName, Gender, DeptID, HireDate, RetireDate, Email, Phone 
		FROM dbo.Employee
		WHERE RetireDate IS NOT NULL
GO


-- [소스 3-66] IF … ELSE 문

DECLARE @Retired char(1)
SET @Retired = 'Y'

IF @Retired = 'Y'
	SELECT EmpID, EmpName, Gender, DeptID, HireDate, RetireDate, Email, Phone 
		FROM dbo.Employee
		WHERE RetireDate IS NOT NULL
ELSE
	SELECT EmpID, EmpName, Gender, DeptID, HireDate, RetireDate, Email, Phone 
		FROM dbo.Employee
		WHERE RetireDate IS NULL
GO


-- [소스 3-67] 중첩 IF … ELSE 문

DECLARE @Retired char(1)
DECLARE @Order varchar(10)
SET @Retired = 'Y'
SET @Order = 'DESC'

IF @Retired = 'Y'
	IF @Order = 'DESC' 
		SELECT EmpID, EmpName, Gender, DeptID, HireDate, RetireDate, Email, Phone 
			FROM dbo.Employee
			WHERE RetireDate IS NOT NULL
			ORDER BY EmpID DESC
	ELSE
		SELECT EmpID, EmpName, Gender, DeptID, HireDate, RetireDate, Email, Phone 
			FROM dbo.Employee
			WHERE RetireDate IS NOT NULL
			ORDER BY EmpID ASC
ELSE
	IF @Order = 'DESC' 
		SELECT EmpID, EmpName, Gender, DeptID, HireDate, RetireDate, Email, Phone 
			FROM dbo.Employee
			WHERE RetireDate IS NULL
			ORDER BY EmpID DESC
	ELSE
		SELECT EmpID, EmpName, Gender, DeptID, HireDate, RetireDate, Email, Phone 
			FROM dbo.Employee
			WHERE RetireDate IS NULL
			ORDER BY EmpID ASC
GO



--*
--* 3.5.2. BEGIN … END 문
--*


-- [소스 3-68] BEGIN … END 문

DECLARE @Retired char(1)
SET @Retired = 'Y'

IF @Retired = 'Y'
	BEGIN
		SELECT EmpID, EmpName, Gender, DeptID, HireDate, RetireDate, Email, Phone 
			FROM dbo.Employee
			WHERE Gender = 'M' AND RetireDate IS NOT NULL
		SELECT EmpID, EmpName, Gender, DeptID, HireDate, RetireDate, Email, Phone 
			FROM dbo.Employee
			WHERE Gender = 'F' AND RetireDate IS NOT NULL
	END
ELSE
	BEGIN
		SELECT EmpID, EmpName, Gender, DeptID, HireDate, RetireDate, Email, Phone 
			FROM dbo.Employee
			WHERE Gender = 'M' AND RetireDate IS NULL
		SELECT EmpID, EmpName, Gender, DeptID, HireDate, RetireDate, Email, Phone 
			FROM dbo.Employee
			WHERE Gender = 'F' AND RetireDate IS NULL
	END
GO



--*
--* 3.5.3. WHILE 문
--*


-- [소스 3-69] WHILE 문

DECLARE @num int
DECLARE @sum int
SET @num = 1
SET @sum = 0
WHILE @num <= 10
	BEGIN
		SET @sum = @sum + @num
		SET @num = @num + 1
	END
PRINT @sum
GO
/*
55
*/


-- [소스 3-70] WHILE ... BREAK 문

DECLARE @num int
DECLARE @Sum int
SET @num = 1
SET @sum = 0
WHILE 1 = 1
	BEGIN
		IF @num > 10
			BREAK
		SET @sum = @sum + @num
		SET @num = @num + 1
	END
PRINT @sum
GO

/*
55
*/


-- [소스 3-71] WHILE ... CONTINUE 문

DECLARE @num int
DECLARE @sum int
SET @num = 0
SET @sum = 0
WHILE 1 = 1
	BEGIN
		SET @num = @num + 1
		IF @num > 10
			BREAK
		IF @num % 2 = 1
			CONTINUE
		SET @sum = @sum + @num
	END
PRINT @sum
GO
/*
30
*/