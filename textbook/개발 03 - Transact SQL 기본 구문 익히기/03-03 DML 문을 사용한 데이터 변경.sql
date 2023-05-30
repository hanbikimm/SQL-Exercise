--*
--* 3.3. DML ���� ����� ������ ����
--*



USE HRDB2
GO


--*
--* 3.3.1. INSERT ��
--*


-- [�ҽ� 3-31] �� INSERT(��� �� �̸� ����)

-- ��� �� �̸� ����
INSERT INTO dbo.Department(DeptID, DeptName, UnitID, StartDate)
   VALUES('PRD', N'��ǰ', 'A', GETDATE())
GO

-- Ȯ��
SELECT * FROM dbo.Department
GO


-- [�ҽ� 3-32] �� INSERT(��� �� �̸� ����)

-- ��� �� �̸� ����
INSERT INTO dbo.Department
   VALUES('DBA', N'DB����', 'A', GETDATE())
GO


-- [�ҽ� 3-33] �� �̸� ������ �ʿ��� ����

-- ����
INSERT INTO dbo.Department 
   VALUES('CST', N'������', GETDATE())
GO
/*
�޽��� 213, ���� 16, ���� 1, �� 29
������ ���� ������ �� �̸��� ���̺� ���ǿ� ��ġ���� �ʽ��ϴ�.
*/

-- ����
INSERT INTO dbo.Department(DeptID, DeptName, StartDate)
   VALUES('CST', N'������', GETDATE())
GO


-- [�ҽ� 3-34] ���ÿ� ���� �� INSERT

-- ���� �� �߰�
INSERT INTO dbo.Department(DeptID, DeptName, UnitID, StartDate)
   VALUES('OPR', N'�', 'A', GETDATE()), ('DGN', N'������', NULL, GETDATE())
GO

-- Ȯ��
SELECT * FROM dbo.Department
GO


-- [�ҽ� 3-35] SELECT ��� INSERT

-- ���̺� �����
CREATE TABLE dbo.RetiredEmployee (
	EmpID char(5) PRIMARY KEY,
	EmpName nvarchar(4) NOT NULL,
	HireDate date NOT NULL,
	RetireDate date NOT NULL,
	EMail varchar(50)
)
GO

-- ������ �߰�
INSERT INTO dbo.RetiredEmployee
	SELECT EmpID, EmpName, HireDate, RetireDate, EMail
		FROM dbo.Employee
		WHERE RetireDate IS NOT NULL
GO

-- Ȯ��
SELECT * FROM dbo.RetiredEmployee
GO


-- [�ҽ� 3-36] ���� ���ν��� ���� ����� ���̺� INSERT

-- ���� ���ν��� �����
CREATE PROC dbo.usp_GetVacation
	@EmpID char(5)
AS
	SELECT EmpID, BeginDate, EndDate, Duration, Reason
		FROM dbo.Vacation
		WHERE EmpID = @EmpID
GO

-- �ӽ� ���̺� �����
CREATE TABLE #Vacation (
   EmpID char(5),
   BeginDate date,
   EndDate date,
   Duration int,
   Reason nvarchar(50)
)
GO

-- ���� ���ν��� ��� �߰�
INSERT INTO #Vacation EXEC dbo.usp_GetVacation 'S0001'
GO

-- Ȯ��
SELECT EmpID, BeginDate, EndDate, Duration, Reason
	FROM #Vacation
	WHERE Duration > 5
GO



--*
--* 3.3.2. UPDATE ��
--*


-- [�ҽ� 3-37] ��ȭ��ȣ ����

-- ��ȭ��ȣ ����
UPDATE dbo.Employee
   SET Phone = '010-1239-1239'
   WHERE EmpID = 'S0001'
GO

-- Ȯ��
SELECT EmpID, EmpName, Gender, HireDate, Phone, EMail
	FROM dbo.Employee
	WHERE EmpID = 'S0001'
GO


-- [�ҽ� 3-38] FROM ���� ����� ���� ����

UPDATE dbo.Employee
   SET Salary = Salary * 0.8
   FROM dbo.Employee AS e
   WHERE (SELECT COUNT (*) 
            FROM dbo.Vacation 
		    WHERE EmpID = e.EmpID) > 10
GO



--*
--* 3.3.3. DELETE ��
--*


-- [�ҽ� 3-39] 2012�� ���� �ް� ��� ����

DELETE dbo.Vacation
   WHERE EndDate <= '2011-12-31'
GO


-- [�ҽ� 3-40] TRUNCATE TABLE ������ ��� �� ����

TRUNCATE TABLE dbo.Vacation
GO


-- [����]

SELECT *
	FROM dbo.Vacation
	WHERE EndDate <= '2011-12-31'
GO

/*
DELETE dbo.Vacation
	WHERE EndDate <= '2011-12-31'
GO
*/