--*
--* 8.1. ��(Views)
--*


USE HRDB2
GO


--*
--* 8.1.2. �� ������ ����
--*


-- [�ҽ� 8-1] ��� ���� SELECT ��


SELECT e.EmpID, e.EmpName, e.HireDate, d.DeptName, e.Phone, e.EMail
	FROM dbo.Employee AS e
	INNER JOIN dbo.Department AS d ON e.DeptID = d.DeptID
	WHERE e.Gender = 'M' AND e.RetireDate IS NULL
GO


-- [�ҽ� 8-2] SELECT ���� ��� �����ϱ�

CREATE VIEW dbo.vw_ManEmployee
AS
	SELECT e.EmpID, e.EmpName, e.HireDate, d.DeptName, e.Phone, e.EMail
		FROM dbo.Employee AS e
		INNER JOIN dbo.Department AS d ON e.DeptID = d.DeptID
		WHERE e.Gender = 'M' AND e.RetireDate IS NULL
GO


-- [�ҽ� 8-3] �� ���� Ȯ��

-- �� ��ü ���� ��������
SELECT * FROM dbo.vw_ManEmployee
GO

-- �信�� 2014�� �Ի��ڸ� ��������
SELECT EmpID, EmpName, HireDate, DeptName 
	FROM dbo.vw_ManEmployee 
	WHERE HireDate BETWEEN '2014-01-01' AND '2014-12-31'
GO


-- [�ҽ� 8-4] ����� ������ �����ִ� �� �����

-- �� �����
CREATE VIEW dbo.vw_RetiredEmployee
AS
	SELECT EmpID, EmpName, Gender, HireDate, RetireDate, Phone, EMail
		FROM dbo.Employee
		WHERE RetireDate IS NOT NULL
GO

-- Ȯ��
SELECT * FROM dbo.vw_RetiredEmployee
GO


--[�ҽ� 8-5] �� �̸��� �ѱ۷� ǥ�õǴ� �� �����

CREATE VIEW dbo.vw_����
AS
	SELECT EmpID AS [���], EmpName AS [�̸�], Gender AS [����], HireDate AS [�Ի���], 
		   Phone AS [��ȭ��ȣ], EMail AS [���ڸ���]
		FROM dbo.Employee
		WHERE RetireDate IS NULL
GO


-- [�ҽ� 8-6] �� �̸��� �ѱ۷� ǥ�õǴ� �並 �ٸ� ������� �����

-- �� ����
ALTER VIEW dbo.vw_����(���, �̸�, ����, �Ի���, ��ȭ��ȣ, ���ڸ���)
AS
	SELECT EmpID, EmpName, Gender, HireDate, Phone, EMail 
		FROM dbo.Employee
		WHERE RetireDate IS NULL
GO

-- Ȯ��(2014�� �Ի��ڸ� ��ȸ)
SELECT * 
	FROM dbo.vw_����
	WHERE �Ի��� BETWEEN '2014-01-01' AND '2014-12-31'
GO


-- [�ҽ� 8-7] ���� ��Ⱓ �ް��� �� TOP 5 ��

-- �� �����
CREATE VIEW dbo.vw_MaxDuration_TOP_5
AS
SELECT TOP 5 WITH TIES v.EmpID, e.EmpName, e.DeptID, e.HireDate, v.BeginDate, 
		v.EndDate, v.Reason, v.Duration 
	FROM dbo.Vacation AS v
	INNER JOIN dbo.Employee AS e ON v.EmpID = e.EmpID
	ORDER BY Duration DESC
GO

-- Ȯ��
SELECT * FROM dbo.vw_MaxDuration_TOP_5
GO


-- [�ҽ� 8-8] �ް��� �� ���� ���� ���� ���� ��

-- �� �����
CREATE VIEW dbo.vw_NoVacation
AS
SELECT EmpID, EmpName, Gender, DeptID, HireDate, Phone, EMail
	FROM dbo.Employee AS e
	WHERE NOT EXISTS (
		SELECT * 
			FROM dbo.Vacation
			WHERE EmpID = e.EmpID
	)
GO

-- Ȯ��
SELECT * FROM dbo.vw_NoVacation
GO

 
-- [�ҽ� 8-9] �� ����

-- �� ����
ALTER VIEW dbo.vw_ManEmployee
AS
	SELECT e.EmpName + '(' + e.EmpID + ')' AS [EmpName], e.HireDate, 
		   d.DeptName, e.Phone, e.EMail
		FROM dbo.Employee AS e
		INNER JOIN dbo.Department AS d ON e.DeptID = d.DeptID
		WHERE e.Gender = 'M' AND e.RetireDate IS NULL
GO

-- Ȯ��(2014�� �Ի��ڸ� ��ȸ)
SELECT * 
	FROM dbo.vw_ManEmployee
	WHERE HireDate BETWEEN '2014-01-01' AND '2014-12-31'
GO


-- [�ҽ� 8-10] �� ���Ű�

DROP VIEW dbo.vw_����
GO


-- [�ҽ� 8-11] �� ���� ���� Ȯ��

EXEC sp_helptext 'dbo.vw_ManEmployee'
GO


-- [�ҽ� 8-12] �� ��ȣȭ

-- �� ��ȣȭ
ALTER VIEW dbo.vw_ManEmployee
	WITH ENCRYPTION
AS
	SELECT e.EmpName + '(' + e.EmpID + ')' AS [EmpName], e.HireDate, 
		   d.DeptName, e.Phone, e.EMail
		FROM dbo.Employee AS e
		INNER JOIN dbo.Department AS d ON e.DeptID = d.DeptID
		WHERE e.Gender = 'M' AND e.RetireDate IS NULL
GO

-- �� ���� Ȯ��
EXEC sp_helptext 'dbo.vw_ManEmployee'
GO
/*
��ü 'dbo.vw_ManEmployee'�� �ؽ�Ʈ�� ��ȣȭ�Ǿ����ϴ�.
*/


-- [�ҽ� 8-13] ��ȣ ����

ALTER VIEW dbo.vw_ManEmployee
AS
	SELECT e.EmpName + '(' + e.EmpID + ')' AS [EmpName], e.HireDate, 
		   d.DeptName, e.Phone, e.EMail
		FROM dbo.Employee AS e
		INNER JOIN dbo.Department AS d ON e.DeptID = d.DeptID
		WHERE e.Gender = 'M' AND e.RetireDate IS NULL
GO


-- [�ҽ� 8-14] SCHEMABINDING �ɼ� ���

ALTER VIEW dbo.vw_ManEmployee
	WITH SCHEMABINDING
AS
	SELECT e.EmpName + '(' + e.EmpID + ')' AS [EmpName], e.HireDate, 
		   d.DeptName, e.Phone, e.EMail
		FROM dbo.Employee AS e
		INNER JOIN dbo.Department AS d ON e.DeptID = d.DeptID
		WHERE e.Gender = 'M' AND e.RetireDate IS NULL
GO


-- [�ҽ� 8-15] �� ���� �õ�

ALTER TABLE dbo.Employee
	DROP COLUMN EMail
GO

-- ���
/*
�޽��� 5074, ���� 16, ���� 1, �� 158
��ü 'vw_ManEmployee'��(��) �� 'EMail'�� ���ӵǾ� �ֽ��ϴ�.
�޽��� 5074, ���� 16, ���� 1, �� 158
��ü 'UQ__Employee__7614F5F60E6FED82'��(��) �� 'EMail'�� ���ӵǾ� �ֽ��ϴ�.
�޽��� 4922, ���� 16, ���� 9, �� 158
�ϳ� �̻��� ��ü�� �� ���� �׼����ϹǷ� ALTER TABLE DROP COLUMN EMail��(��) �����߽��ϴ�.
*/