--*
--* 4.1. ������ ��ȣ�� ǥ���ϴ� �پ��� �Լ�
--*


USE HRDB2
GO


--*
--* 4.1.1. RANK �Լ�
--*


-- [�ҽ� 4-1] ��ü �޿� ���� ǥ��

SELECT EmpID, EmpName, DeptID, Gender, Phone, Salary, 
	   RANK() OVER(ORDER BY Salary DESC) AS [Rnk]
   FROM dbo.Employee
   WHERE DeptID IN ('SYS', 'MKT') AND RetireDate IS NULL
   ORDER BY Salary DESC
GO


-- [�ҽ� 4-2] ���ະ �޿� ���� ǥ��

SELECT EmpID, EmpName, DeptID, Gender, Phone, Salary, 
	   RANK() OVER(PARTITION BY Gender ORDER BY Salary DESC) AS [Rnk]
   FROM dbo.Employee
   WHERE DeptID IN ('SYS', 'MKT') AND RetireDate IS NULL
   ORDER BY Gender ASC, Salary DESC
GO


-- [�ҽ� 4-3] �Ի��� ������ ���� ǥ��

SELECT EmpID, EmpName, HireDate, DeptID, Gender, Phone, Salary, 
	   RANK() OVER(ORDER BY HireDate DESC) AS [Rnk]
   FROM dbo.Employee
   WHERE DeptID IN ('SYS', 'MKT') AND RetireDate IS NULL
   ORDER BY HireDate DESC
GO


-- [�ҽ� 4-4] ������ �ް� �ϼ� �հ� ��ȸ

SELECT EmpID, SUM(Duration) AS [Tot_Duration]
	FROM dbo.Vacation
	GROUP BY EmpID
GO


-- [�ҽ� 4-5] �ް� �ϼ� �հ� ���� ��ȸ

SELECT EmpID, SUM(Duration) AS [Tot_Duration],
	   RANK() OVER(ORDER BY SUM(Duration) DESC) AS [Rnk]
	FROM dbo.Vacation
	GROUP BY EmpID
	ORDER BY SUM(Duration) DESC
GO



--*
--* 4.1.2. DENSE_RANK �Լ�
--*


-- [�ҽ� 4-6] ��ü �޿� ���� ǥ��

SELECT EmpID, EmpName, DeptID, Gender, Phone, Salary, 
	   DENSE_RANK() OVER(ORDER BY Salary DESC) AS [Rnk]
   FROM dbo.Employee
   WHERE DeptID IN ('SYS', 'MKT') AND RetireDate IS NULL
   ORDER BY Salary DESC
GO


-- [�ҽ� 4-7] ���ະ �޿� ���� ǥ��

SELECT EmpID, EmpName, DeptID, Gender, Phone, Salary, 
	   DENSE_RANK() OVER(PARTITION BY Gender ORDER BY Salary DESC) AS [Rnk]
   FROM dbo.Employee
   WHERE DeptID IN ('SYS', 'MKT') AND RetireDate IS NULL
   ORDER BY Gender ASC, Salary DESC
GO



--*
--* 4.1.3. ROW_NUMBER �Լ�
--*


-- [�ҽ� 4-8] ��ü ��ȣ ǥ��

SELECT ROW_NUMBER() OVER(ORDER BY EmpID ASC) AS [Num],
		EmpID, EmpName, DeptID, Gender, Phone, Salary
   FROM dbo.Employee
   WHERE DeptID IN ('SYS', 'MKT') AND RetireDate IS NULL
   ORDER BY EmpID ASC
GO


-- [�ҽ� 4-9] ���ະ ��ȣ ǥ��

SELECT ROW_NUMBER() OVER(PARTITION BY Gender ORDER BY EmpID ASC) AS [Num],
		EmpID, EmpName, DeptID, Gender, Phone, Salary
   FROM dbo.Employee
   WHERE DeptID IN ('SYS', 'MKT') AND RetireDate IS NULL
   ORDER BY Gender ASC, EmpID ASC
GO


-- [�ҽ� 4-10] 2014�� 10�� �ް� ��Ȳ ��ȸ

SELECT ROW_NUMBER() OVER(ORDER BY BeginDate ASC) AS [Num],
	EmpID, BeginDate, EndDate, Reason, Duration
	FROM dbo.Vacation
	WHERE BeginDate BETWEEN '2014-10-01' AND '2014-10-31'
	ORDER BY BeginDate ASC
GO



--*
--* 4.1.4. NTILE �Լ�
--*


-- [�ҽ� 4-11] ��ü �޿��� ���� ǥ��

SELECT EmpID, EmpName, DeptID, Gender, Phone, Salary,
		NTILE(3) OVER(ORDER BY Salary DESC) AS [Num]
   FROM dbo.Employee
   WHERE DeptID IN ('SYS', 'MKT') AND RetireDate IS NULL
GO


-- [�ҽ� 4-12] ���ະ �޿��� ���� ǥ��

SELECT EmpID, EmpName, DeptID, Gender, Phone, Salary,
		NTILE(3) OVER(PARTITION BY Gender ORDER BY Salary DESC) AS [Num]
   FROM dbo.Employee
   WHERE DeptID IN ('SYS', 'MKT') AND RetireDate IS NULL
GO