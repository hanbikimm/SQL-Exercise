--*
--* 4.5. �ս��� ��� ���� ����
--*


USE HRDB2
GO


--*
--* 4.5.1. UNION, UNION ALL ��
--*


-- [�ҽ� 4-33] 2014�� �Ի��� ���� ���� ��ȸ

SELECT EmpID, EmpName, DeptID, HireDate, EMail, Salary
	FROM dbo.Employee
	WHERE HireDate BETWEEN '2014-01-01' AND '2014-12-31' 
GO


-- [�ҽ� 4-34] �޿��� 7,000 �̻� �޴� ���� ���� ��ȸ

SELECT EmpID, EmpName, DeptID, HireDate, EMail, Salary
	FROM dbo.Employee
	WHERE Salary >= 7000
GO


-- [�ҽ� 4-35] 2014�⿡ �Ի� �߰ų� �޿��� 7,000 �̻� �޴� ���� ���� ��ȸ

SELECT EmpID, EmpName, DeptID, HireDate, EMail, Salary
	FROM dbo.Employee
	WHERE HireDate BETWEEN '2014-01-01' AND '2014-12-31' 

UNION

SELECT EmpID, EmpName, DeptID, HireDate, EMail, Salary
	FROM dbo.Employee
	WHERE Salary >= 7000
GO


-- [�ҽ� 4-36] 2014�⿡ �Ի� �߰ų� �޿��� 7,000 �̻� �޴� ���� ���� ��ȸ

SELECT EmpID, EmpName, DeptID, HireDate, EMail, Salary
	FROM dbo.Employee
	WHERE HireDate BETWEEN '2014-01-01' AND '2014-12-31' 

UNION ALL

SELECT EmpID, EmpName, DeptID, HireDate, EMail, Salary
	FROM dbo.Employee
	WHERE Salary >= 7000
GO



--* 
--* 4.5.2. INTERSECT ��
--*


-- [�ҽ� 4-37] 2014�⿡ �Ի������� �޿��� 7,000 �̻� �޴� ���� ���� ��ȸ

SELECT EmpID, EmpName, DeptID, HireDate, EMail, Salary
	FROM dbo.Employee
	WHERE HireDate BETWEEN '2014-01-01' AND '2014-12-31' 

INTERSECT

SELECT EmpID, EmpName, DeptID, HireDate, EMail, Salary
	FROM dbo.Employee
	WHERE Salary >= 7000
GO



--*
--* 4.5.3. EXCEPT ��
--*


-- [�ҽ� 4-38] 2014�⿡ �Ի������� �޿��� 7,000 �̻� ������ ����

SELECT EmpID, EmpName, DeptID, HireDate, EMail, Salary
	FROM dbo.Employee
	WHERE HireDate BETWEEN '2014-01-01' AND '2014-12-31' 

EXCEPT

SELECT EmpID, EmpName, DeptID, HireDate, EMail, Salary
	FROM dbo.Employee
	WHERE Salary >= 7000
GO