--*
--* 4.7. ������ �ۼ��� ���� �ܻ�
--*



--*
--* 4.7.1. ���� ������
--*


-- [�ҽ� 4-52] ����� ������

USE HRDB2
GO

-- �޿��� ���� �޴� ���� 5��
SELECT TOP (5) EmpID, EmpName, DeptID, HireDate, Phone, EMail, Salary
	FROM dbo.Employee
	WHERE RetireDate IS NULL
	ORDER BY Salary DESC
GO


-- [�ҽ� 4-53] ��Ȯ�� ������

-- �޿��� ���� �޴� ���� 5��
SELECT TOP (5) WITH TIES EmpID, EmpName, DeptID, HireDate, Phone, EMail, Salary
	FROM dbo.Employee
	WHERE RetireDate IS NULL
	ORDER BY Salary DESC
GO
