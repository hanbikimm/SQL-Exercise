--*
--* 3.5. ���� ���� �帧 ����
--*


USE HRDB2
GO


--*
--* 3.5.1. IF �� ELSE ��
--*


-- [�ҽ� 3-64] ������ �����ϴ� IF ��

DECLARE @Retired char(1)
SET @Retired = 'Y'

IF @Retired = 'Y'
	SELECT EmpID, EmpName, Gender, DeptID, HireDate, RetireDate, Email, Phone 
		FROM dbo.Employee
		WHERE RetireDate IS NOT NULL
GO

-- [�ҽ� 3-65] ������ �������� �ʴ� IF ��

DECLARE @Retired char(1)
SET @Retired = 'N'

IF @Retired = 'Y'
	SELECT EmpID, EmpName, Gender, DeptID, HireDate, RetireDate, Email, Phone 
		FROM dbo.Employee
		WHERE RetireDate IS NOT NULL
GO


-- [�ҽ� 3-66] IF �� ELSE ��

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


-- [�ҽ� 3-67] ��ø IF �� ELSE ��

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
--* 3.5.2. BEGIN �� END ��
--*


-- [�ҽ� 3-68] BEGIN �� END ��

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
--* 3.5.3. WHILE ��
--*


-- [�ҽ� 3-69] WHILE ��

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


-- [�ҽ� 3-70] WHILE ... BREAK ��

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


-- [�ҽ� 3-71] WHILE ... CONTINUE ��

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