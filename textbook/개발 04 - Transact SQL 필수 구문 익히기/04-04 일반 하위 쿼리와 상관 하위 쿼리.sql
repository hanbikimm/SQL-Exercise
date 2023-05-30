--*
--* 4.4. �Ϲ� ���� ������ ��� ���� ����
--*


USE HRDB2
GO


--*
--* 4.4.1. �Ϲ� ���� ����
--*


-- [�ҽ� 4-26] ���� ���� �޿��� �޴� ���� ���� ��ȸ

SELECT EmpID, EmpName, DeptID, Phone, EMail, Salary
	FROM dbo.Employee
	WHERE Salary = (SELECT MAX(Salary) FROM dbo.Employee)
GO


-- [�ҽ� 4-27] �ް��� �� ���� �ִ� ���� ���� ��ȸ

SELECT EmpID, EmpName, DeptID, Phone, EMail
	FROM dbo.Employee
	WHERE DeptID = 'SYS'
	AND EmpID IN (SELECT EmpID FROM dbo.Vacation) 
GO


-- [�ҽ� 4-28] ���� �ֱٿ� ����� ���� ���� ��ȸ

SELECT EmpID, EmpName, DeptID, Gender, HireDate, RetireDate, Phone 
	FROM dbo.Employee
	WHERE RetireDate = (SELECT MAX(RetireDate) FROM dbo.Employee)
GO



--*
--* 4.4.2. ��� ���� ����
--*


-- [�ҽ� 4-29] �μ� �̸��� �����ؼ� ���� ���� ��ȸ

SELECT EmpID, EmpName, DeptID, (SELECT DeptName FROM dbo.Department
	  WHERE DeptID = e.DeptID) AS [DeptName], Phone, Salary
	FROM dbo.Employee AS e
	WHERE Salary > 7000
GO


-- [�ҽ� 4-30] �ް��� �� ���� �ִ� ���� ���� ��ȸ

SELECT EmpID, EmpName, DeptID, Phone, EMail
	FROM dbo.Employee e
	WHERE DeptID = 'SYS'
	AND EXISTS(
		SELECT * 
			FROM dbo.Vacation 
			WHERE EmpID = e.EmpID
	)
GO


-- [�ҽ� 4-31] �ް��� �� ���� ���� ���� ���� ��ȸ

SELECT EmpID, EmpName, DeptID, Phone, EMail
	FROM dbo.Employee e
	WHERE DeptID = 'SYS'
		AND NOT EXISTS (
			SELECT * 
                FROM dbo.Vacation 
                WHERE EmpID = e.EmpID
		)
GO


-- [�ҽ� 4-32] �� �μ����� ���� ���� �Ի��� ���� ���� ��ȸ

SELECT EmpID, EmpName, DeptID, Gender, HireDate, Phone, EMail
	FROM dbo.Employee AS e
	WHERE HireDate = (
		SELECT MIN(HireDate) 
			FROM dbo.Employee
			WHERE DeptID = e.DeptID
	)
	ORDER BY EmpID ASC
GO