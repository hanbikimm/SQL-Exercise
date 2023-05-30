--*
--* 4.3. �� ���� ������ ����(JOIN) ��
--*


USE HRDB2
GO


--*
--* 4.3.5. JOIN �� �ۼ�
--*


-- [�ҽ� 4-18] �μ� �̸��� �����ؼ� ���� ���� ��ȸ

SELECT e.EmpID, e.EmpName, e.DeptID, d.DeptName, e.Phone, e.EMail
	FROM dbo.Employee AS e
	INNER JOIN dbo.Department AS d ON e.DeptID = d.DeptID
	WHERE e.HireDate BETWEEN '2014-01-01' AND '2015-12-31' 
		AND RetireDate IS NULL
GO


-- [�ҽ� 4-19] �ް��� �� ���� �ִ� ���� ���� ��ȸ

SELECT e.EmpID, e.EmpName, v.BeginDate, v.EndDate, v.Reason, v.Duration
	FROM dbo.Employee AS e
	INNER JOIN dbo.Vacation AS v ON e.EmpID = v.EmpID
	WHERE e.HireDate BETWEEN '2015-01-01' AND '2016-12-31' 
		AND RetireDate IS NULL
	ORDER BY e.EmpID ASC
GO


-- [�ҽ� 4-20] ���� �̸��� �����ؼ� �μ� ���� ��ȸ

SELECT d.DeptID, d.DeptName, d.UnitID, u.UnitName, d.StartDate
	FROM dbo.Department AS d
	INNER JOIN dbo.Unit AS u ON d.UnitID = u.UnitID
GO


-- [�ҽ� 4-21] ���� ���� �ް� ��Ȳ ��ȸ

SELECT e.EmpID, e.EmpName, v.BeginDate, v.EndDate, v.Reason, v.Duration
	FROM dbo.Employee AS e
	LEFT OUTER JOIN dbo.Vacation AS v ON e.EmpID = v.EmpID
	WHERE e.HireDate BETWEEN '2015-01-01' AND '2016-12-31' 
		AND RetireDate IS NULL
	ORDER BY e.EmpID ASC
GO


-- [�ҽ� 4-22] ���� �̸��� �����ؼ� ��� �μ� ���� ��ȸ

SELECT d.DeptID, d.DeptName, d.UnitID, u.UnitName
   FROM dbo.Department AS d
   LEFT OUTER JOIN dbo.Unit AS u ON d.UnitID = u.UnitID
GO



--*
--* 4.3.6. ���� ���̺� ���� JOIN ��
--*


-- [�ҽ� 4-23] �ް��� ����� ���� �������� �ް� ��Ȳ ��ȸ

SELECT e.EmpID, e.EmpName, d.DeptName, u.UnitName, 
       v.BeginDate, v.EndDate, v.Duration
   FROM dbo.Employee AS e
   INNER JOIN dbo.Department AS d ON e.DeptID = d.DeptID
   LEFT OUTER JOIN dbo.Unit AS u ON d.UnitID = u.UnitID
   INNER JOIN dbo.Vacation AS v ON e.EmpID = v.EmpID
   WHERE v.BeginDate BETWEEN '2016-01-01' AND '2016-03-31'
   ORDER BY e.EmpID ASC
GO


-- [�ҽ� 4-24] ���� �߻�

SELECT v.EmpID, e.EmpName, e.DeptID, e.Phone, SUM(v.Duration) AS [Tot_Duration]
	FROM dbo.Vacation AS v
	INNER JOIN dbo.Employee AS e ON v.EmpID = e.EmpID
	WHERE v.BeginDate BETWEEN '2016-01-01' AND '2016-06-30'
	GROUP BY v.EmpID
	ORDER BY SUM(V.Duration) DESC
GO
/*
�޽��� 8120, ���� 16, ���� 1, �� 81
�� 'dbo.Employee.EmpName'��(��) ���� �Լ��� GROUP BY ���� �����Ƿ� SELECT ��Ͽ��� ����� �� �����ϴ�.
*/


-- [�ҽ� 4-25] ���� ������ ������ 2016�� ��ݱ� �ް� �ϼ� �հ� ��ȸ

SELECT v.EmpID, e.EmpName, e.DeptID, e.Phone, SUM(v.Duration) AS [Tot_Duration]
	FROM dbo.Vacation AS v
	INNER JOIN dbo.Employee AS e ON v.EmpID = e.EmpID
	WHERE v.BeginDate BETWEEN '2016-01-01' AND '2016-06-30'
	GROUP BY v.EmpID, e.EmpName, e.DeptID, e.Phone
	ORDER BY SUM(v.Duration) DESC
GO


-- [����]

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