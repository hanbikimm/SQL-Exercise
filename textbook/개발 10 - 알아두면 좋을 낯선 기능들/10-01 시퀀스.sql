--*
--* 10.1. ������(Sequences)
--*


USE HRDB2
GO


--*
--* 10.1.2. ������ �����
--*


-- [�ҽ� 10-1 ������ �����

-- ������ �����
CREATE SEQUENCE dbo.MySeq01 
	AS bigint
	START WITH 1
	INCREMENT BY 1
GO

/*
-- ������ �����ϱ� 
DROP SEQUENCE dbo.MySeq01 
GO
*/


--*
--* 10.1.3. ������ ��� ��
--*


-- [�ҽ� 10-2] �⺻���� ������ ���

-- ��� ���̺� �����
CREATE TABLE dbo.OfficeIn (
	SeqNo bigint PRIMARY KEY,
	EmpID char(5) REFERENCES dbo.Employee(EmpID),
	Time_in datetime2 DEFAULT SYSDATETIME()
)
GO

-- ������ �����
CREATE SEQUENCE dbo.CommuteSeq
   START WITH 1
   INCREMENT BY 1
GO

-- �� �߰��ϱ�
INSERT dbo.OfficeIn (SeqNo, EmpID) VALUES (NEXT VALUE FOR dbo.CommuteSeq, 'S0001')
GO
INSERT dbo.OfficeIn (SeqNo, EmpID) VALUES (NEXT VALUE FOR dbo.CommuteSeq, 'S0003')
GO
INSERT dbo.OfficeIn (SeqNo, EmpID) VALUES (NEXT VALUE FOR dbo.CommuteSeq, 'S0004')
GO

-- ��� Ȯ��
SELECT * FROM dbo.OfficeIn
GO


-- [�ҽ� 10-3] ���� ���̺� �������� ���� �� �Է�

-- ��� ���̺� �����
CREATE TABLE dbo.OfficeOut (
	SeqNo bigint PRIMARY KEY,
	EmpID char(5) REFERENCES dbo.Employee(EmpID),
	Time_out datetime2 DEFAULT SYSDATETIME()
)
GO

-- ���� ��� ���� ����
TRUNCATE TABLE dbo.OfficeIn
GO

-- ������ �߰�(õõ�� �ð� ������ �ΰ� �߰��ϸ� ����)
-- ���
INSERT dbo.OfficeIn (SeqNo, EmpID) VALUES (NEXT VALUE FOR dbo.CommuteSeq, 'S0001')
GO
INSERT dbo.OfficeIn (SeqNo, EmpID) VALUES (NEXT VALUE FOR dbo.CommuteSeq, 'S0003')
GO

-- ���
INSERT dbo.OfficeOut (SeqNo, EmpID) VALUES (NEXT VALUE FOR dbo.CommuteSeq, 'S0003')
GO
INSERT dbo.OfficeOut (SeqNo, EmpID) VALUES (NEXT VALUE FOR dbo.CommuteSeq, 'S0001')
GO

-- ���
INSERT dbo.OfficeIn (SeqNo, EmpID) VALUES (NEXT VALUE FOR dbo.CommuteSeq, 'S0003')
GO
INSERT dbo.OfficeIn (SeqNo, EmpID) VALUES (NEXT VALUE FOR dbo.CommuteSeq, 'S0001')
GO

-- ���
INSERT dbo.OfficeOut (SeqNo, EmpID) VALUES (NEXT VALUE FOR dbo.CommuteSeq, 'S0003')
GO
INSERT dbo.OfficeOut (SeqNo, EmpID) VALUES (NEXT VALUE FOR dbo.CommuteSeq, 'S0001')
GO

-- ��� Ȯ��
SELECT EmpID, SeqNo, N'���' AS [Type], Time_in 
	FROM dbo.OfficeIn
UNION ALL
SELECT EmpID, SeqNo, N'���' AS [Type], Time_out 
	FROM dbo.OfficeOut
	ORDER BY EmpID, SeqNo
GO



--*
--* 10.1.4. ������ ���� �ݺ��ǰ� �ϱ�
--*


-- [�ҽ� 10-4] ������ �� �ݺ��ϱ�

-- ������ �����
CREATE SEQUENCE dbo.MySeq 
	AS tinyint
	START WITH 1
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 5
	CYCLE 
GO

-- �ݺ��Ǵ� �� ���
SELECT NEXT VALUE FOR dbo.MySeq AS [Group], EmpID, EmpName, HireDate, EMail, Phone 
	FROM dbo.Employee
	WHERE Gender = 'M' AND RetireDate IS NULL
GO



--*
--* 10.1.5. OVER ���� ������ ����� ������ ���
--*


-- [�ҽ� 10-5] ORDER BY ���� ���� �߻�

SELECT NEXT VALUE FOR dbo.MySeq AS [Group], EmpID, EmpName, HireDate, EMail, Phone 
	FROM dbo.Employee
	WHERE Gender = 'M' AND RetireDate IS NULL
	ORDER BY HireDate DESC
GO
/*
�޽��� 11723, ���� 15, ���� 1, �� 122
NEXT VALUE FOR �Լ��� OVER ���� �������� ������ ORDER BY ���� �����ϴ� ������ ���� ����� �� �����ϴ�.
*/


-- [�ҽ� 10-6] OVER ���� ������ ����� ������ ���

-- ���� �ϱ�
ALTER SEQUENCE dbo.MySeq
   RESTART WITH 1 
GO

-- OVER �� ���
SELECT NEXT VALUE FOR dbo.MySeq OVER(ORDER BY HireDate DESC) AS [Group], 
	EmpID, EmpName,	HireDate, EMail, Phone 
	FROM dbo.Employee
	WHERE Gender = 'M' AND RetireDate IS NULL
	ORDER BY HireDate DESC
GO