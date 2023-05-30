--*
--* 8.3. ����� ���� �Լ�(User Defined Functions)
--*


USE HRDB2
GO


--*
--* 8.3.2. ��Į�� �Լ� �����
--*


-- [�ҽ� 8-40] �μ� �ڵ带 �޾� �ش� �μ��� ���� ���� �Ѱ��ִ� ��Į�� �Լ� �����

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


-- [�ҽ� 8-41] ��Į�� �Լ� ����ϱ�

SELECT dbo.ufn_MemberCount('SYS') 	-- ���: 6
GO


-- [�ҽ� 8-42] ��Į�� �Լ� ����ϱ�

SELECT DeptID, DeptName, StartDate, dbo.ufn_MemberCount(DeptID) AS [EmpCount]
	FROM dbo.Department
	WHERE dbo.ufn_MemberCount(DeptID) > 3
GO


-- [�ҽ� 8-43] �μ� �ڵ带 �޾� �μ� �̸��� �Ѱ��ִ� ��Į�� �Լ� �����

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


-- [�ҽ� 8-44] ��Į�� �Լ� ����ϱ�

SELECT dbo.ufn_DeptName('SYS')  --> �����ý���
GO

SELECT EmpID, EmpName, DeptID, dbo.ufn_DeptName(DeptID) AS [DeptName], HireDate, RetireDate
	FROM dbo.Employee
	WHERE RetireDate IS NOT NULL
GO



--*
--* 8.3.3. �ζ��� ���̺� �� �Լ� �����
--*


-- [�ҽ� 8-45] �μ� �ڵ带 �޾� �ش� �μ��� ���� ����� �Ѱ��ִ� ���̺� �� �Լ� �����

CREATE FUNCTION dbo.ufn_DepartmentMember(@DeptID char(3))
	RETURNS TABLE
AS
	RETURN(
		SELECT EmpID, EmpName, DeptID, Gender, HireDate, Phone, EMail
			FROM dbo.Employee
			WHERE DeptID = @DeptID
	)
GO


-- [�ҽ� 8-46] �ζ��� ���̺� �� �Լ� ���

SELECT * FROM dbo.ufn_DepartmentMember('SYS')
GO

SELECT * FROM dbo.ufn_DepartmentMember('MKT')
GO



--*
--* 8.3.4. ���߹� ���̺� �� �Լ� �����
--*


-- [�ҽ� 8-47] ���߹� ���̺� �� �Լ� �����

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


-- [�ҽ� 8-48] ���߹� ���̺� �� �Լ� ���

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