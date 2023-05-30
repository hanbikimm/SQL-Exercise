--*
--* 2.6. �ӽ� ���̺�
--*


USE HRDB2
GO


--*
--* 2.6.1. ���� �ӽ� ���̺�� ���� �ӽ� ���̺�
--*


-- [�ҽ� 2-65] ���� �ӽ� ���̺� �����

-- �ӽ� ���̺� �����
CREATE TABLE #Emp01 (
	EmpID char(5) NOT NULL,
	EmpName nvarchar(10) NOT NULL,
	HireDate date NOT NULL,
	RetireDate date NOT NULL,
	EMail varchar(60) NOT NULL
)
GO

-- ������ �߰�
INSERT INTO #Emp01
	SELECT EmpID, EmpName, HireDate, RetireDate, EMail
		FROM dbo.Employee
		WHERE RetireDate IS NOT NULL
GO

-- Ȯ��
SELECT * FROM #Emp01
GO


-- [�ҽ� 2-66] SELECT��INTO ������ ���� �ӽ� ���̺� �����

SELECT EmpID, EmpName, HireDate, RetireDate, EMail
	INTO #Emp02
	FROM dbo.Employee
	WHERE RetireDate IS NOT NULL
GO


-- [�ҽ� 2-67] ���� �ӽ� ���̺� �����

-- �ӽ� ���̺� �����
SELECT EmpID, EmpName, HireDate, RetireDate, EMail
	INTO ##EmpMan
	FROM dbo.Employee
	WHERE Gender = 'M' AND RetireDate IS NULL
GO

-- Ȯ��
SELECT * FROM ##EmpMan
GO