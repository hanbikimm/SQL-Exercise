--*
--* 10.9. ���Ǿ�(Synonyms)
--*



--*
--* 10.9.1. ���Ǿ� �����
--*


-- [�ҽ� 10-59] ���Ǿ� �����

USE HRDB2
GO

-- ���� �̸�, �����ͺ��̽� �̸� �Է�
CREATE SYNONYM dbo.����
	FOR DREAM.HRDB2.dbo.Unit
GO

-- ���� �̸�, �����ͺ��̽� �̸� ����
CREATE SYNONYM dbo.�μ�
	FOR dbo.Department
GO

CREATE SYNONYM dbo.����
	FOR dbo.Employee
GO

CREATE SYNONYM dbo.�ް�
	FOR dbo.Vacation
GO



--*
--* 10.9.2. ���Ǿ� ���
--*


-- [�ҽ� 10-60] ���Ǿ� ���

USE HRDB2
GO

SELECT e.EmpID, e.EmpName, e.Gender, e.DeptID, d.DeptName, e.HireDate, e.EMail
	FROM dbo.���� AS e
	INNER JOIN dbo.�μ� AS d ON e.DeptID = d.DeptID
	WHERE e.DeptID = 'SYS' AND RetireDate IS NULL
GO