--*
--* 10.3. �ý��� ���� �ӽ� ���̺�(System-Versioned Temporal Table)
--*


USE HRDB2
GO


--*
--* 10.3.1. �ý��� ���� �ӽ� ���̺� ����� 
--*


-- [�ҽ� 10-17] �ý��� ���� �ӽ� ���̺� �����

CREATE TABLE dbo.Employee (
	EmpID char(5) PRIMARY KEY,
	EmpName nvarchar(4) NOT NULL,
	EngName varchar(20) NULL,
	Gender char(1) NOT NULL,
	HireDate date NOT NULL,
	RetireDate date NULL,
	DeptID char(3) REFERENCES Department(DeptID) NOT NULL,
	Phone char(13) UNIQUE NOT NULL,
	EMail varchar(50) UNIQUE NOT NULL,
	Salary int NULL,
	SysStartTime datetime2 GENERATED ALWAYS AS ROW START NOT NULL, 
	SysEndTime datetime2 GENERATED ALWAYS AS ROW END NOT NULL,
	PERIOD FOR SYSTEM_TIME (SysStartTime,SysEndTime) 
) 
WITH (   
	SYSTEM_VERSIONING = ON (HISTORY_TABLE = dbo.Employee2History)   
) 
GO



--*
--* 10.3.2. ���� ���̺��� �ý��� ���� �ӽ� ���̺�� ����
--*


-- [�ҽ� 10-18] ���� ���̺��� �ý��� ���� �ӽ� ���̺�� ����

ALTER TABLE dbo.Employee
   ADD   
      SysStartTime datetime2 GENERATED ALWAYS AS ROW START HIDDEN    
           CONSTRAINT DF_SysStart DEFAULT SYSUTCDATETIME() NOT NULL,
      SysEndTime datetime2 GENERATED ALWAYS AS ROW END HIDDEN    
           CONSTRAINT DF_SysEnd DEFAULT '9999-12-31 23:59:59.9999999' NOT NULL,   
      PERIOD FOR SYSTEM_TIME (SysStartTime, SysEndTime);   
GO   

ALTER TABLE dbo.Employee   
   SET (SYSTEM_VERSIONING = ON (HISTORY_TABLE = dbo.EmployeeHistory))   
GO



--*
--* 10.3.3. �߰��� �� Ȯ��
--*


-- [�ҽ� 10-19] ���� ���������� Ȯ��

SELECT *
	FROM dbo.Employee
	WHERE DeptID = 'SYS'
GO


-- [�ҽ� 10-20] �� �̸� �����Ͽ� Ȯ��

SELECT EmpID, EmpName, EngName, Gender, DeptID, SysStartTime, SysEndTime
	FROM dbo.Employee
	WHERE DeptID = 'SYS'
GO



--*
--* 10.3.4. ������ ����
--*


-- [�ҽ� 10-21] ������ ����

-- �ֻ�� �̸��� ����
UPDATE dbo.Employee
	SET EMail = 'samonim@dbnuri.com'
	WHERE EmpID = 'S0009'
GO

-- �ֻ�� ��ȭ��ȣ ����
UPDATE dbo.Employee
	SET Phone = '010-8899-9999'
	WHERE EmpID = 'S0009'
GO

-- ȫ�浿 �̸� ����
UPDATE dbo.Employee
	SET EmpName = N'ȫ�漭'
	WHERE EmpID = 'S0001'
GO

-- �ֻ�� �̸��� ����
UPDATE dbo.Employee
	SET EMail = 'choisamonim@dbnuri.com'
	WHERE EmpID = 'S0009'
GO

-- ȫ�浿 �޿� ����
UPDATE dbo.Employee
	SET Salary = 9000
	WHERE EmpID = 'S0001'
GO

-- �ֻ�� �̸��� ����
UPDATE dbo.Employee
	SET EMail = 'samochoi@dbnuri.com'
	WHERE EmpID = 'S0009'
GO

-- �ֻ�� ��� ó��
UPDATE dbo.Employee
	SET RetireDate = '2016-11-30'
	WHERE EmpID = 'S0009'
GO



--*
--* 10.3.5. ���̺� ��ϵ� ���� Ȯ��
--*


-- [�ҽ� 10-22] ���̺� ���� ������ Ȯ��

SELECT EmpID, EmpName, RetireDate, Phone, EMail, Salary, SysStartTime, SysEndTime
	FROM dbo.Employee
	WHERE DeptID = 'SYS'
GO


-- [�ҽ� 10-23] ��� ���̺� Ȯ��

SELECT EmpID, EmpName, RetireDate, Phone, EMail, Salary, SysStartTime, SysEndTime
	FROM dbo.EmployeeHistory
	WHERE DeptID = 'SYS'
GO



--*
--* 10.3.6. AS OF �������� Ư�� ���� ������ Ȯ��
--*


-- [�ҽ� 10-24] Ư�� ���� ������ Ȯ�� #1

SELECT EmpID, EmpName, RetireDate, Phone, EMail, Salary, SysStartTime, SysEndTime
	FROM dbo.Employee
	FOR SYSTEM_TIME AS OF '2016-12-12 14:27:00'
	WHERE DeptID = 'SYS'
	ORDER BY EmpID ASC
GO


-- [�ҽ� 10-25] Ư�� ���� ������ Ȯ�� #2

SELECT EmpID, EmpName, RetireDate, Phone, EMail, Salary, SysStartTime, SysEndTime
	FROM dbo.Employee
	FOR SYSTEM_TIME AS OF '2016-12-12 14:28:30'
	WHERE DeptID = 'SYS'
	ORDER BY EmpID ASC
GO



--*
--* 10.3.7. ���� ��� Ȯ��
--*


-- [�ҽ� 10-26] CONTAINED IN ���

DECLARE @Start datetime2 = '2016-12-12 14:27:00.0000000'
DECLARE @End datetime2 = '2016-12-12 14:28:40.7037494'
SELECT EmpID, EmpName, EngName, DeptID, EMail, Phone, SysStartTime, SysEndTime
	FROM dbo.Employee
	FOR SYSTEM_TIME CONTAINED IN(@Start, @End)
	WHERE EmpID = 'S0009'
	ORDER BY SysStartTime ASC
GO


-- [�ҽ� 10-27] BETWEEN �� AND ���

DECLARE @Start datetime2 = '2016-12-13 02:51:45.2792746'
DECLARE @End datetime2 = '2016-12-13 02:52:05.5816841'
SELECT EmpID, EmpName, EngName, DeptID, EMail, Phone, SysStartTime, SysEndTime
	FROM dbo.Employee
	FOR SYSTEM_TIME BETWEEN @Start AND @End
	WHERE EmpID = 'S0009'
	ORDER BY SysStartTime ASC
GO


-- [�ҽ� 10-28] FROM �� TO ���

DECLARE @Start datetime2 = '2016-12-12 14:27:00.0000000'
DECLARE @End datetime2 = '2016-12-12 14:28:40.7037494'
SELECT EmpID, EmpName, EngName, DeptID, EMail, Phone, SysStartTime, SysEndTime
	FROM dbo.Employee
	FOR SYSTEM_TIME FROM @Start TO @End
	WHERE EmpID = 'S0009'
	ORDER BY SysStartTime ASC
GO


-- [�ҽ� 10-29] ALL ���

SELECT EmpID, EmpName, EngName, DeptID, EMail, Phone, SysStartTime, SysEndTime
	FROM dbo.Employee
	FOR SYSTEM_TIME ALL
	WHERE EmpID = 'S0009'
	ORDER BY SysStartTime ASC
GO



--*
--* 10.3.8. �ý��� ���� ���� ����
--*


-- [�ҽ� 10-30] �ӽ÷� �ý��� ���� ���� ����

ALTER TABLE dbo.Employee 
	SET (SYSTEM_VERSIONING = OFF) 
GO

TRUNCATE TABLE dbo.EmployeeHistory
GO

ALTER TABLE dbo.Employee 
	SET (SYSTEM_VERSIONING = ON (HISTORY_TABLE = dbo.EmployeeHistory))  
GO


-- [�ҽ� 10-31] ���������� �ý��� ���� ���� ����

ALTER TABLE dbo.Employee 
	SET (SYSTEM_VERSIONING = OFF) 
GO

ALTER TABLE dbo.Employee
	DROP PERIOD FOR SYSTEM_TIME
GO