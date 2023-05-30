--*
--* 3.4. �پ��� ������ ���� ���
--*


USE HRDB2
GO


--*
--* 3.4.1. SUM, AVG, MAX, MIN, COUNT �Լ�
--*


-- [�ҽ� 3-41] �ٹ� ���� �������� �޿� �� ��ȸ

SELECT SUM(Salary) AS [Tot_Salary]
	FROM dbo.Employee
	WHERE RetireDate IS NULL -- ���: 90,900
GO


-- [�ҽ� 3-42] �ٹ� ���� ���� �� ��ȸ

SELECT COUNT(*) AS [Emp_Count]
	FROM dbo.Employee
	WHERE RetireDate IS NULL -- ���: 16
GO


-- [�ҽ� 3-43] �ٹ� ���� �������� �޿� �ִ�, �ּڰ�, �ִ� - �ּڰ� ��ȸ

SELECT MAX(Salary) AS [Max_Salary], 
	   MIN(Salary) AS [Min_Salary],
	   MAX(Salary) - MIN(Salary) AS [Diff_Salary]
	FROM dbo.Employee
	WHERE RetireDate IS NULL
GO


-- [�ҽ� 3-44] ȫ�浿�� 2014�� �ް� �ϼ� �հ� ��ȸ  

SELECT SUM(Duration) AS [Tot_Duration]
	FROM dbo.Vacation
	WHERE EmpID = 'S0001' 
		AND BeginDate BETWEEN '2014-01-01' AND '2014-12-31' -- ���: 17
GO


-- [�ҽ� 3-45] ������ �� ó�� �Ի��� ��¥ ��ȸ

SELECT MIN(HireDate) AS [Min_HireDate]
	FROM dbo.Employee
GO


-- [�ҽ� 3-46] ���� �ֱٿ� ������ �Ի��� ��¥ ��ȸ

SELECT MAX(HireDate) AS [Max_HireDate]
	FROM dbo.Employee
GO


-- [�ҽ� 3-47] �ٹ� ���� ������ ��� �޿� ��ȸ

SELECT SUM(Salary) / COUNT(*) AS [Avg_Salary]
	FROM dbo.Employee
	WHERE RetireDate IS NULL -- ���: 5,681
GO


-- [�ҽ� 3-48] �ٹ� ���� ������ �޿� ��� ��ȸ

SELECT AVG(Salary) AS [Avg_Salary]
	FROM dbo.Employee
	WHERE RetireDate IS NULL -- ���: 6,060
GO
 
 
 -- [�ҽ� 3-49] �ٹ� ���� ������ �޿� ��� ��ȸ

SELECT AVG(ISNULL(Salary, 0)) AS [Avg_Salary]
	FROM dbo.Employee
	WHERE RetireDate IS NULL -- ���: 5,681
GO
 

-- [�ҽ� 3-50] COUNT ���� ��� ��

SELECT COUNT(EngName) AS [EngName_Count]
	FROM dbo.Employee  -- ���: 14
GO

SELECT COUNT(*) AS [EngName_Count]
	FROM dbo.Employee
	WHERE EngName IS NOT NULL -- ���: 14
GO



--*
--* 3.4.2. GROUP BY ��
--*


-- [�ҽ� 3-51] �ٹ� ���� �μ��� ���� �� ��ȸ

SELECT DeptID, COUNT(*) AS [Emp_Count]
	FROM dbo.Employee
	WHERE RetireDate IS NULL
	GROUP BY DeptID
GO


-- [�ҽ� 3-52] �����ϴ� GROUP BY ��

SELECT DeptID, EmpName, COUNT(*) AS [Emp_Count]
	FROM dbo.Employee
	WHERE RetireDate IS NULL
	GROUP BY DeptID
GO

/*
�޽��� 8120, ���� 16, ���� 1, �� 79
�� 'dbo.Employee.EmpName'��(��) ���� �Լ��� GROUP BY ���� �����Ƿ� SELECT ��Ͽ��� ����� �� �����ϴ�.
*/


-- [�ҽ� 3-53] �����ϴ� GROUP BY ��

SELECT DeptID, MIN(EmpName) AS [First_EmpName], COUNT(*) AS [Emp_Count]
	FROM dbo.Employee
	WHERE RetireDate IS NULL
	GROUP BY DeptID
GO


-- [�ҽ� 3-54] �ٹ� ���� ������ �μ��� �޿��� �� ��ȸ

SELECT DeptID, SUM(Salary) AS [Tot_Salary]
	FROM dbo.Employee
	WHERE RetireDate IS NULL
	GROUP BY DeptID 
GO


-- [�ҽ� 3-55] �ٹ� ���� ������ �μ��� �޿� �ִ�, �ּڰ�, �ִ� - �ּڰ� ��ȸ

SELECT DeptID, 
		MAX(Salary) AS [Max_Salary], 
		MIN(Salary) AS [Min_Salary],
		MAX(Salary) - MIN(Salary) AS [Diff_Salary]
	FROM dbo.Employee
	WHERE RetireDate IS NULL
	GROUP BY DeptID
GO


-- [�ҽ� 3-56] �޿��� 5,000���� ���� �μ��� ���� �� ��ȸ

SELECT DeptID, COUNT(EmpID) AS [Emp_Count]
	FROM dbo.Employee
	WHERE Salary > 5000
	GROUP BY DeptID
GO



--*
--* 3.4.3. HAVING ��
--*


-- [�ҽ� 3-57] HAVING �� ���

SELECT DeptID, COUNT(*) AS [Emp_Count]
	FROM dbo.Employee
	GROUP BY DeptID
	HAVING COUNT(*) >= 3
GO


-- [�ҽ� 3-58] �ٹ� ���� ������ �μ��� ��� �޿� ��ȸ

SELECT DeptID, AVG(Salary) AS [Avg_Salary]
	FROM dbo.Employee
	WHERE RetireDate IS NULL
	GROUP BY DeptID
GO


-- [�ҽ� 3-59] �μ� ��� �޿��� ���� ��� �޿����� ���� �μ��� ��� �޿� ��ȸ

SELECT DeptID, AVG(Salary) AS [Avg_Salary]
	FROM dbo.Employee
	WHERE RetireDate IS NULL
	GROUP BY DeptID
	HAVING AVG(Salary) > (
		SELECT AVG(Salary) 
			FROM dbo.Employee 
			WHERE RetireDate IS NULL
	)
GO



--*
--* 3.4.4. GROUPING SETS ��
--*


-- [�ҽ� 3-60] ���ະ, �μ��� �Ұ� ��ȸ

SELECT DeptID, Gender, SUM(Salary) AS [Tot_Salary]
	FROM dbo.Employee
	WHERE DeptID IN('SYS', 'MKT') AND RetireDate IS NULL
	GROUP BY GROUPING SETS(DeptID, Gender)
GO


-- [�ҽ� 3-61] ��ü ���� ��ȸ

SELECT DeptID, Gender, SUM(Salary) AS [Tot_Salary]
	FROM dbo.Employee
	WHERE DeptID IN('SYS', 'MKT') AND RetireDate IS NULL
	GROUP BY GROUPING SETS(DeptID, Gender, ())
GO


-- [�ҽ� 3-62] �μ� �Ұ� + ��ü ���� ��ȸ

SELECT DeptID, Gender, SUM(Salary) AS [Tot_Salary]
	FROM dbo.Employee
	WHERE DeptID IN ('SYS', 'MKT') AND RetireDate IS NULL
	GROUP BY GROUPING SETS((DeptID, Gender), (DeptID))
GO


-- [�ҽ� 3-63] ��ü ���� �߰�

SELECT DeptID, Gender, SUM(Salary) AS [Tot_Salary]
	FROM dbo.Employee
	WHERE DeptID IN('SYS', 'MKT') AND RetireDate IS NULL
	GROUP BY GROUPING SETS((DeptID, Gender), DeptID, ())
GO