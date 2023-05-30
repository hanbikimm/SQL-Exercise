--*
--* 5.1. ������ �������� ���ϴ� ��ɵ�
--*


USE HRDB2
GO


--*
--* 5.1.1 TOP (n) ��
--*


-- [�ҽ� 5-1] �޿��� ���� �޴� ���� 5�� ��ȸ

SELECT TOP (5) EmpID, EmpName, DeptID, HireDate, Phone, EMail, Salary
	FROM dbo.Employee
	WHERE RetireDate IS NULL
	ORDER BY Salary DESC
GO


-- [�ҽ� 5-2] �޿��� ���� ��� ���Խ��� ��ȸ

SELECT TOP (5) WITH TIES EmpID, EmpName, DeptID, HireDate, Phone, EMail, Salary
	FROM dbo.Employee
	WHERE RetireDate IS NULL
	ORDER BY Salary DESC
GO


-- [�ҽ� 5-3] �޿��� ���� �޴� ���� 14.5% ��ȸ

SELECT TOP (14.5) PERCENT EmpID, EmpName, DeptID, HireDate, Phone, EMail, Salary
	FROM dbo.Employee
	WHERE RetireDate IS NULL
	ORDER BY Salary DESC
GO


-- [�ҽ� 5-4] �ް��� ���� ���� �ٳ�� ���� TOP 5 ��ȸ

SELECT TOP (5) WITH TIES v.EmpID, e.EmpName, SUM(v.Duration) AS [Tot_Duration]
	FROM dbo.Vacation AS v
	INNER JOIN dbo.Employee AS e ON v.EmpID = e.EmpID
	GROUP BY v.EmpID, e.EmpName
	ORDER BY SUM(v.Duration) DESC
GO



--*
--* 5.1.2. CASE ��
--*


-- [�ҽ� 5-5] ����� ������ M�� F�� ��, ���� ǥ��

SELECT EmpID, EmpName, 
		 CASE WHEN Gender = 'M' THEN N'��'
			  WHEN Gender = 'F' THEN N'��'
			  ELSE '' END AS [Gender], DeptID, HireDate, Phone, EMail 
	FROM dbo.Employee
	WHERE RetireDate IS NOT NULL
GO


-- [�ҽ� 5-6] ����� ������ M�� F�� ��, ���� ǥ��

SELECT EmpID, EmpName, 
		 CASE Gender WHEN 'M' THEN N'��'
					 WHEN 'F' THEN N'��'
					 ELSE '' END AS [Gender], DeptID, HireDate, EMail 
	FROM dbo.Employee
	WHERE RetireDate IS NOT NULL
GO


-- [�ҽ� 5-7] 2014�� �Ի��� �ٹ�, ���� ���� ���� ǥ��

SELECT EmpID, EmpName, 
		 CASE WHEN RetireDate IS NULL THEN N'�ٹ�'
			  ELSE N'���' END AS [Status], DeptID, HireDate, Phone, EMail 
	FROM dbo.Employee
	WHERE HireDate BETWEEN '2014-01-01' AND '2014-12-31'
GO


-- [�ҽ� 5-8] �����ý��� ���� ���� ��ȸ

SELECT EmpID, EmpName, 
		CASE WHEN EngName IS NULL THEN 'N/A'
			 ELSE EngName END AS [EngName], Phone, EMail
	FROM dbo.Employee
	WHERE DeptID = 'SYS'
GO


-- [�ҽ� 5-9] ISNULL �Լ� ���

SELECT EmpID, EmpName, ISNULL(EngName, 'N/A') AS [EngName], Phone, EMail
	FROM dbo.Employee
	WHERE DeptID = 'SYS'
GO


-- [�ҽ� 5-10] �ٹ� ���� ���� �μ� �ڵ�� �������� ����

SELECT DeptID, EMpID, EmpName, HireDate, Phone, EMail
	FROM dbo.Employee
	WHERE RetireDate IS NULL
	ORDER BY DeptID ASC
GO


-- [�ҽ� 5-11] CASE ������ ���� ����

SELECT DeptID, EmpID, EmpName, HireDate, Phone, EMail
	FROM dbo.Employee
	WHERE RetireDate IS NULL
	ORDER BY CASE DeptID WHEN 'STG' THEN 'AAA' ELSE DeptID END ASC
GO


-- [����] IIF �Լ�

SELECT DeptID, EMpID, EmpName, HireDate, Phone, EMail
	FROM dbo.Employee
	WHERE RetireDate IS NULL
	ORDER BY IIF(DeptID = 'STG', 'AAA', DeptID) ASC
GO



--*
--* 5.1.3. CTE ��
--*


-- [�ҽ� 5-12] �⺻���� CTE ���

WITH DeptSalary (DeptID, Tot_Salary)
	AS (SELECT DeptID, SUM(Salary)
			FROM dbo.Employee
			WHERE RetireDate IS NULL
			GROUP BY DeptID)
SELECT * FROM DeptSalary
	WHERE Tot_Salary >= 10000
GO


-- [�ҽ� 5-13] CTE�� JOIN

WITH 
	DeptSalary (DeptID, Tot_Salary)
	AS (
		SELECT DeptID, SUM(Salary)
			FROM dbo.Employee
			WHERE RetireDate IS NULL
			GROUP BY DeptID
	)
SELECT s.DeptID, d.DeptName, d.UnitID, s.Tot_Salary 
	FROM DeptSalary AS s
	INNER JOIN dbo.Department AS d ON s.DeptID = d.DeptID
	WHERE s.Tot_Salary >=10000
GO


-- [�ҽ� 5-14] CTE�� ��ø�ؼ� ���� �̸� ����

WITH 
	DeptSalary (DeptID, Tot_Salary)
	AS 
	(
		SELECT DeptID, SUM(Salary)
			FROM dbo.Employee
			WHERE RetireDate IS NULL
			GROUP BY DeptID
	),
	DeptNameSalary (DeptID,  DeptName, UnitID, Tot_Salary)
	AS 
	(
		SELECT s.DeptID, d.DeptName, d.UnitID, s.Tot_Salary
		FROM DeptSalary AS s
		INNER JOIN dbo.Department AS d ON s.DeptID = d.DeptID
		WHERE s.Tot_Salary >=10000
	)
SELECT s.DeptID, s.DeptName, s.UnitID, u.UnitName, s.Tot_Salary
	FROM DeptNameSalary AS s
	LEFT OUTER JOIN dbo.Unit AS u ON s.UnitID = u.UnitID
GO


-- [�ҽ� 5-15] �ٹ� ���� ���� �߿��� ���� ���� �Ի��� ���� ���ະ 3�� ��ȸ

WITH HireDate_RNK 
	AS (
		SELECT EmpID, EmpName, DeptID, Gender, HireDate, Phone,
				RANK() OVER(PARTITION BY Gender ORDER BY HireDate ASC) AS [Rnk]
			FROM dbo.Employee
			WHERE RetireDate IS NULL
	)
SELECT * 
	FROM HireDate_RNK
	WHERE Rnk <= 3
GO


-- [�ҽ� 5-16] ���� ���� ü�� ����

-- ManagerID �� �߰�
ALTER TABLE dbo.Employee
	ADD ManagerID char(5) NULL
GO

-- ���̺� ������ ������ ���� �߰�
DECLARE @ManagerInfo TABLE (
	EmpID  char(5),
	ManagerID char(5)
)
INSERT INTO @ManagerInfo VALUES
('S0003', 'S0001'), ('S0009', 'S0003'),
('S0011', 'S0009'), ('S0013', 'S0009'),
('S0019', 'S0009'), ('S0002', 'S0001'),
('S0006', 'S0002'), ('S0007', 'S0002'),
('S0012', 'S0002'), ('S0017', 'S0007'),
('S0008', 'S0006'), ('S0016', 'S0006'),
('S0018', 'S0006'), ('S0004', 'S0001'),
('S0005', 'S0004'), ('S0010', 'S0004'),
('S0014', 'S0005'), ('S0015', 'S0010'),
('S0020', 'S0001')

-- ���̺� �ݿ�
UPDATE dbo.Employee 
	SET ManagerID = m.ManagerID
	FROM dbo.Employee AS e 
	INNER JOIN @ManagerInfo AS m
		ON e.EmpID = m.EmpID
GO


-- [�ҽ� 5-17] ��ü ���� ���� ��ȸ

WITH CTE_Emp (EmpID, EmpName, DeptID, ManagerID, Level) 
	AS (
	SELECT EmpID, EmpName, DeptID, ManagerID, 0 
		FROM dbo.Employee
		WHERE ManagerID IS NULL

	UNION ALL

	SELECT e.EmpID, e.EmpName, e.DeptID, e.ManagerID, c.Level + 1
		FROM dbo.Employee AS e
		INNER JOIN CTE_Emp AS c ON c.EmpID = e.ManagerID
)
SELECT * FROM CTE_Emp
GO


-- [�ҽ� 5-18] ������ ���� ü�� ��ȸ

WITH CTE_Emp (EmpID, EmpName, DeptID, ManagerID, Level, ManagerList) 
	AS (
	SELECT EmpID, EmpName, DeptID, ManagerID, 0, CAST('' AS nvarchar(1000))
		FROM dbo.Employee
		WHERE ManagerID IS NULL

	UNION ALL

	SELECT e.EmpID, e.EmpName, e.DeptID, e.ManagerID, c.Level + 1, 
	       CAST( ' �� ' + c.EmpName  +  c.ManagerList AS nvarchar(1000))
		FROM dbo.Employee AS e
		INNER JOIN CTE_Emp AS c ON c.EmpID = e.ManagerID
) 
SELECT * 
	FROM CTE_Emp
	WHERE DeptID = 'MKT'
GO


-- [�ҽ� 5-19] 2017�� ��¥ ��ȸ

WITH Dates AS (
	SELECT CAST('2017-01-01' AS date) AS [CalDate]

	UNION ALL

	SELECT DATEADD(day, 1, CalDate) AS [CalDate]
		FROM Dates
		WHERE DATEADD(day, 1, CalDate) < '2018-01-01'
)
SELECT *
	FROM Dates
	OPTION (MAXRECURSION 366) -- ��� �Ѱ� ����
GO
/*
�޽��� 530, ���� 16, ���� 1, �� 282
���� ����Ǿ����ϴ�. ���� �Ϸ�Ǳ� ���� �ִ� ��� Ƚ��(100)�� �ʰ��Ǿ����ϴ�.
*/



--*
--* 5.1.4. MERGE ��
--*


-- [�ҽ� 5-20] ���տ� ���� �ҽ� ���̺� �����

CREATE TABLE dbo.EmpChanged (
	EmpID char(5) PRIMARY KEY,
	EmpName nvarchar(4) NOT NULL,
	EngName varchar(20) NULL,
	Gender char(1) NOT NULL,
	HireDate date NOT NULL,
	RetireDate date NULL,
	DeptID char(3) REFERENCES Department(DeptID) NOT NULL,
	Phone char(13) NULL,
	EMail varchar(50) NOT NULL,
	Salary int NULL
)
GO


-- [�ҽ� 5-21] ���յ� ���� �� �߰� ����

-- �����
INSERT INTO dbo.EmpChanged VALUES('S0001', N'ȫ���', 'hong', 'M', '2011-01-01', NULL, 'SYS', '010-1234-1234', 'hong@dbnuri.com', 8500)
INSERT INTO dbo.EmpChanged VALUES('S0006', N'��ġ��', 'kimchi','M', '2013-03-01', NULL, 'HRD', '010-8765-8765', 'kimchi@dbnuri.com',	6000)
INSERT INTO dbo.EmpChanged VALUES('S0020', N'�����', 'gogo', 'F', '2013-03-01', '2016-09-30', 'STG', '010-9966-1230', 'haha@dbnuri.com', 5000)
-- �߰���
INSERT INTO dbo.EmpChanged VALUES('S0021', N'�ڿ���', 'over', 'M', '2016-10-01', NULL, 'SYS', '010-9922-1100', 'over@dbnuri.com', 4500)
INSERT INTO dbo.EmpChanged VALUES('S0022', N'������', 'nama', 'F', '2016-10-01', NULL, 'HRD', '010-5599-2271', 'merge@dbnuri.com', 4500)
GO

SELECT * FROM dbo.EmpChanged
GO


-- [�ҽ� 5-22] ������ ����

MERGE dbo.Employee AS e1
	USING (SELECT * FROM dbo.EmpChanged) AS e2 
	ON (e1.EmpID = e2.EmpID)
	WHEN MATCHED THEN
		 UPDATE SET e1.EmpName = e2.EmpName, 
					e1.EngName = e2.EngName, 
					e1.Gender = e2.Gender, 
					e1.HireDate = e2.HireDate,
					e1.RetireDate = e2.RetireDate,
					e1.DeptID = e2.DeptID,
					e1.EMail = e2.EMail,
					e1.Phone = e2.Phone,
					e1.Salary = e2.Salary
	WHEN NOT MATCHED THEN
		 INSERT VALUES(e2.EmpID, e2.EmpName, e2.EngName, e2.Gender, e2.HireDate, e2.RetireDate, e2.DeptID, e2.Phone, e2.EMail, e2.Salary);
GO

-- �ݿ� �� ����
TRUNCATE TABLE dbo.EmpChanged
GO

-- �ݿ� ��� Ȯ��
SELECT * 
	FROM dbo.Employee
	WHERE EmpID IN('S0001', 'S0006', 'S0020', 'S0021', 'S0022')
GO



--*
--* 5.1.5. OUTPUT ��
--*


-- [�ҽ� 5-23] �޿� ���� ó�� ���� ��Ͽ� ���̺� �����

CREATE TABLE dbo.EmpSalaryLog (
	LogID int IDENTITY PRIMARY KEY,
	LogType char(1) NOT NULL,
	EmpID char(5) NOT NULL,
	EmpName nvarchar(4) NOT NULL,
	Salary int NULL,
	chgDate datetime DEFAULT GETDATE()
)
GO


-- [�ҽ� 5-24] INSERT ���

INSERT INTO dbo.Employee
	OUTPUT 'I', Inserted.EmpID, Inserted.EmpName, Inserted.Salary
	INTO dbo.EmpSalaryLog(LogType, EmpID, EmpName, Salary)
	VALUES('S0023', N'�����', 'sana', 'F', '2016-10-01', NULL, 'MKT', '010-6677-3366', 'kimsae@dbnuri.com', 4000)
GO


-- [�ҽ� 5-25] UPDATE ���

UPDATE dbo.Employee
	SET Salary = Salary * 1.5
	OUTPUT 'U', Inserted.EmpID, Inserted.EmpName, Inserted.Salary
	INTO dbo.EmpSalaryLog(LogType, EmpID, EmpName, Salary)
	WHERE DeptID = 'SYS'
GO


-- [�ҽ� 5-26] DELETE ���

DELETE dbo.Employee
	OUTPUT 'D', Deleted.EmpID, Deleted.EmpName, Deleted.Salary
	INTO dbo.EmpSalaryLog(LogType, EmpID, EmpName, Salary)
	WHERE EmpID = 'S0020'
GO


-- [�ҽ� 5-27] �޿� ���� ��� ��ȸ

SELECT * 
	FROM dbo.EmpSalaryLog
GO



--*
--* 5.1.6. APPLY ��
--*


-- [�ҽ� 5-28] ����� ���� �Լ� �����

CREATE FUNCTION dbo.ufn_MemVacation(@EmpID char(5))
    RETURNS TABLE
AS
    RETURN (
	SELECT BeginDate, EndDate, Reason, Duration
		FROM dbo.Vacation
		WHERE EmpID = @EmpID
    )
GO

SELECT * FROM dbo.ufn_MemVacation('S0006')
GO


-- [�ҽ� 5-29] CROSS APPLY

SELECT e.EmpID, e.EmpName, e.HireDate, v.BeginDate, v.EndDate, v.Reason, v.Duration
	FROM dbo.Employee AS e
	CROSS APPLY dbo.ufn_MemVacation(EmpID) AS v
	WHERE DeptID = 'MKT'
GO


-- [�ҽ� 5-30] OUTER APPLY

SELECT e.EmpID, e.EmpName, e.HireDate, v.BeginDate, v.EndDate, v.Reason, v.Duration
	FROM dbo.Employee AS e
	OUTER APPLY dbo.ufn_MemVacation(EmpID) AS v
	WHERE DeptID = 'MKT'
GO


-- [�ҽ� 5-31] ���� ������ CROSS APPLY


SELECT e.EmpID, e.EmpName, e.HireDate, v.BeginDate, v.EndDate, v.Reason, v.Duration
	FROM dbo.Employee AS e
	CROSS APPLY (
	SELECT BeginDate, EndDate, Reason, Duration
		FROM dbo.Vacation
		WHERE EmpID = e.EmpID
	) AS v
	WHERE DeptID = 'MKT'
GO



--*
--* 5.1.7. OVER �� 
--*


-- [�ҽ� 5-32] ��ü ����

SELECT  DeptID, EmpID, EmpName, Salary,
		COUNT(Salary) OVER() AS [Emp_Count],
		SUM(Salary) OVER() AS [Tot_Salary],
		AVG(Salary) OVER() AS [Avg_Salary],
		MIN(Salary) OVER() AS [Min_Salary],
		MAX(Salary) OVER() AS [Max_Salary]
	FROM dbo.Employee
	WHERE RetireDate IS NULL AND DeptID IN ('MKT', 'SYS')
	ORDER BY DeptID, EmpID
GO


-- [�ҽ� 5-33] �μ��� ��ü ����

SELECT  DeptID, EmpID, EmpName, Salary,
		COUNT(Salary) OVER(PARTITION BY DeptID) AS [Emp_Count],
		SUM(Salary) OVER(PARTITION BY DeptID) AS [Tot_Salary],
		AVG(Salary) OVER(PARTITION BY DeptID) AS [Avg_Salary],
		MIN(Salary) OVER(PARTITION BY DeptID) AS [Min_Salary],
		MAX(Salary) OVER(PARTITION BY DeptID) AS [Max_Salary]
	FROM dbo.Employee
	WHERE RetireDate IS NULL AND DeptID IN ('MKT', 'SYS')
	ORDER BY DeptID, EmpID
GO


-- [�ҽ� 5-34] �μ��� ���� ��, �̵� ��� ��ȸ

SELECT  DeptID, EmpID, EmpName, Salary,
		SUM(Salary) OVER(PARTITION BY DeptID ORDER BY EmpID) AS [Cumulative_Total],
		AVG(Salary) OVER(PARTITION BY DeptID ORDER BY EmpID) AS [Moving_Avg]
	FROM dbo.Employee
	WHERE RetireDate IS NULL AND DeptID IN ('MKT', 'SYS')
	ORDER BY DeptID, EmpID
GO


-- [�ҽ� 5-35] ��ü ���� ��, �̵� ��� ��ȸ

SELECT  DeptID, EmpID, EmpName, Salary,
		SUM(Salary) OVER(ORDER BY DeptID, EmpID) AS [Cumulative_Total],
		AVG(Salary) OVER(ORDER BY DeptID, EmpID) AS [Moving_Avg]
	FROM dbo.Employee
	WHERE RetireDate IS NULL AND DeptID IN ('MKT', 'SYS')
	ORDER BY DeptID, EmpID
GO


-- [�ҽ� 5-36] ROWS ����ؼ� ���� �� ������ ������ �� �� ������ â ����

SELECT  DeptID, EmpID, EmpName, Salary,
			SUM(Salary) OVER(
				PARTITION BY DeptID 
				ORDER BY EmpID
				ROWS BETWEEN CURRENT ROW AND 2 FOLLOWING) AS [Cumulative_Total],
			AVG(Salary) OVER(
				PARTITION BY DeptID 
				ORDER BY EmpID
				ROWS BETWEEN CURRENT ROW AND 2 FOLLOWING) AS [Moving_Avg]
	FROM dbo.Employee
	WHERE RetireDate IS NULL AND DeptID IN ('MKT', 'SYS')
	ORDER BY DeptID, EmpID
GO


-- [�ҽ� 5-37] ROWS ���� �Բ� UNBOUNDED PRECEDING�� ����

-- PARTITION ù��° ��ּ� ����
SELECT  DeptID, EmpID, EmpName, Salary,
			SUM(Salary) OVER(
				PARTITION BY DeptID 
				ORDER BY EmpID
				ROWS UNBOUNDED PRECEDING) AS [Cumulative_Total],
			AVG(Salary) OVER(
				PARTITION BY DeptID 
				ORDER BY EmpID
				ROWS UNBOUNDED PRECEDING) AS [Moving_Avg]
	FROM dbo.Employee
	WHERE RetireDate IS NULL AND DeptID IN ('MKT', 'SYS')
	ORDER BY DeptID, EmpID
GO



--*
--*  5.1.8. OFFSET AND FETCH ��
--*


-- [�ҽ� 5-38] ���ǿ� �´� ��� �� ��ȸ

SELECT EmpID, EmpName, DeptID, HireDate, Phone, EMail, Salary
	FROM dbo.Employee
	WHERE DeptID IN ('SYS', 'MKT') AND RetireDate IS NULL
	ORDER BY EmpID
GO


-- [�ҽ� 5-39] ó�� 3���� �����ϰ� ��ȸ

SELECT EmpID, EmpName, DeptID, HireDate, Phone, EMail, Salary
	FROM dbo.Employee
	WHERE DeptID IN ('SYS', 'MKT') AND RetireDate IS NULL
	ORDER BY EmpID 
	OFFSET 3 ROWS
GO


-- [�ҽ� 5-40] ó������ 5�� ��ȸ

SELECT EmpID, EmpName, DeptID, HireDate, Phone, EMail, Salary
	FROM dbo.Employee
	WHERE DeptID IN ('SYS', 'MKT') AND RetireDate IS NULL
	ORDER BY EmpID 
    OFFSET 0 ROWS
    FETCH NEXT 5 ROWS ONLY
GO


-- [�ҽ� 5-41] �� ����ϱ� 

DECLARE @StartNum tinyint = 2, @EndNum tinyint = 5
SELECT EmpID, EmpName, DeptID, HireDate, Phone, EMail, Salary
	FROM dbo.Employee
	WHERE DeptID IN ('SYS', 'MKT') AND RetireDate IS NULL
	ORDER BY EmpID 
    OFFSET @StartNum - 1 ROWS
    FETCH NEXT @EndNum - @StartNum + 1 ROWS ONLY
GO



--*
--*  5.1.9. WITH RESULT SET ��
--*


-- [�ҽ� 5-42] ���� ���ν��� �����

CREATE PROC dbo.usp_DeptEmployee
	@DeptID char(3)
AS
BEGIN 
	SELECT EmpID, EmpName, DeptID, HireDate, Phone, EMail, Salary
		FROM dbo.Employee
		WHERE DeptID = @DeptID
END
GO


-- [�ҽ� 5-43] �Ϲ����� ���� ���ν��� ȣ��

EXEC dbo.usp_DeptEmployee 'SYS'
GO


-- [�ҽ� 5-44] ���� ���ν��� ����� ���� �� �̸� ����

EXEC dbo.usp_DeptEmployee 'SYS'
	WITH RESULT SETS (
    (      
		��� char(5),
		�̸� nvarchar(4),
		�μ��ڵ� char(3),
		�Ի��� date,
		��ȭ��ȣ char(13),
		���ڸ��� varchar(50),
		�޿� int
    )
) 
GO



--*
--* 5.1.10. THROW ��
--*


-- [�ҽ� 5-45] THROW�� ���� �߻���Ű��

THROW 51000, N'��� ���� �������� �ʽ��ϴ�.', 1
GO
/*
�޽��� 51000, ���� 16, ���� 1, �� 1
��� ���� �������� �ʽ��ϴ�.
*/


-- [�ҽ� 5-46] �߻��� ���� �޽����� �ٽ� �߻���Ű��

BEGIN TRY
    INSERT dbo.Department VALUES('MKT', N'����', 'A', '2012-01-01')
END TRY
BEGIN CATCH
    PRINT N'���� �߻�!'
    ;THROW -- ������ �����̾�� ������ ;�� ��������� �ٿ���
END CATCH
/*
(0�� ���� ������ ����)
���� �߻�!
�޽��� 2627, ���� 14, ���� 1, �� 2
PRIMARY KEY ���� ���� 'PK__Departme__0148818E5709B548'��(��) �����߽��ϴ�. 
��ü 'dbo.Department'�� �ߺ� Ű�� ������ �� �����ϴ�. �ߺ� Ű ���� (MKT)�Դϴ�.
*/