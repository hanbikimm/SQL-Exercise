--*
--* 10.2. ���ҵ� ���̺�(Partitioned Tables)
--*


USE HRDB2
GO


--*
--* 10.2.2. ���ҵ� ���̺� �����
--*


-- [�ҽ� 10-7] ���� ���� Ȯ��

SELECT MIN(BeginDate) AS [MIN_Date], MAX(BeginDate) AS [MAX_Date]
	FROM vacation -- 2011-01-12 / 2016-09-08
GO


-- [�ҽ� 10-8] ��Ƽ�� �Լ� �����

CREATE PARTITION FUNCTION PF_Vacation (date)
        AS RANGE RIGHT
        FOR VALUES ('2012-01-01', 
					'2013-01-01', 
					'2014-01-01',
					'2015-01-01', 
					'2016-01-01'
		)
GO


-- [�ҽ� 10-9] ��Ƽ�� ����ǥ �����

CREATE PARTITION SCHEME PS_Vacation
   AS PARTITION PF_Vacation
   ALL TO ([PRIMARY])
GO
/*
��Ƽ�� ����ǥ 'PS_Vacation'��(��) �ۼ��Ǿ����ϴ�. 
��Ƽ�� ����ǥ 'PS_Vacation'���� 'PRIMARY'��(��) ������ ���Ǵ� ���� �׷����� ǥ�õ˴ϴ�.
*/


-- [�ҽ� 10-10] ���� �� ���̺� �����

CREATE TABLE dbo.PT_Vacation (
	VacationID int IDENTITY,
	EmpID char(5) REFERENCES dbo.Employee(EmpID),
	BeginDate date NOT NULL,
	EndDate date NOT NULL,
	Reason nvarchar(50) DEFAULT N'���λ���',
	Duration AS (DATEDIFF(day, BeginDate, EndDate) + 1),
	CHECK (EndDate >= BeginDate),
	PRIMARY KEY CLUSTERED (
			BeginDate ASC,
			VacationID ASC
	)
) ON PS_Vacation(BeginDate)
GO


-- [�ҽ� 10-11] ���ҵ� ���̺� ������ �߰��ϱ�

SET IDENTITY_INSERT dbo.PT_Vacation ON
GO

INSERT INTO dbo.PT_Vacation(VacationID, EmpID, BeginDate, EndDate, Reason)
	SELECT VacationID, EmpID, BeginDate, EndDate, Reason FROM dbo.Vacation
GO

SET IDENTITY_INSERT dbo.PT_Vacation OFF
GO


-- [�ҽ� 10-12] ��Ƽ�� ���� Ȯ��

SELECT partition_id, object_id, partition_number, rows 
	FROM sys.partitions
	WHERE OBJECT_ID = OBJECT_ID('dbo.PT_Vacation')
	ORDER BY partition_number
GO



--*
--* 10.2.3. ���ҵ� ���̺� ����
--*


-- [�ҽ� 10-13] ������ ���ҵ� ���̺� �����

-- ��Ƽ�� �Լ� �����
CREATE PARTITION FUNCTION PT_DelVacation (date)
        AS RANGE RIGHT
        FOR VALUES ('2099-01-01')
GO

-- ��Ƽ�� ����ǥ �����
CREATE PARTITION SCHEME PS_DelVacation 
   AS PARTITION PT_DelVacation 
   ALL TO ([PRIMARY])
GO

-- ���̺� �����
CREATE TABLE dbo.PT_DelVacation (
	VacationID int IDENTITY,
	EmpID char(5) REFERENCES dbo.Employee(EmpID),
	BeginDate date NOT NULL,
	EndDate date NOT NULL,
	Reason nvarchar(50) DEFAULT N'���λ���',
	Duration AS (DATEDIFF(day, BeginDate, EndDate) + 1),
	CHECK (EndDate >= BeginDate),
	PRIMARY KEY CLUSTERED (
			BeginDate ASC,
			VacationID ASC
	)
) ON PS_DelVacation(BeginDate)
GO


-- [�ҽ� 10-14] ��Ƽ�� ����

-- ���� ��Ƽ�� �����
ALTER PARTITION SCHEME PS_Vacation
    NEXT USED [PRIMARY]
GO

-- ��Ƽ�� ����
ALTER PARTITION FUNCTION PF_Vacation()
	SPLIT RANGE ('2017.01.01')
GO

-- Ȯ��
SELECT partition_id, object_id, partition_number, rows 
    FROM sys.partitions
    WHERE OBJECT_ID = OBJECT_ID('dbo.PT_Vacation')
    ORDER BY partition_number
GO


-- [�ҽ� 10-15] ��Ƽ�� ��ȯ

-- ��Ƽ�� ��ȯ
ALTER TABLE dbo.PT_Vacation
	SWITCH PARTITION 1 
	TO dbo.PT_DelVacation PARTITION 1
GO

-- ������ ����
TRUNCATE TABLE dbo.PT_DelVacation
GO

-- Ȯ��
SELECT partition_id, object_id, partition_number, rows 
    FROM sys.partitions
    WHERE OBJECT_ID = OBJECT_ID('dbo.PT_Vacation')
    ORDER BY partition_number
GO


-- [�ҽ� 10-16] ��Ƽ�� ����

-- ��Ƽ�� ����
ALTER PARTITION FUNCTION PF_Vacation() 
	MERGE RANGE ('2012.01.01')
GO

-- Ȯ��
SELECT partition_id, object_id, partition_number, rows 
	FROM sys.partitions
	WHERE OBJECT_ID = OBJECT_ID('dbo.PT_Vacation')
	ORDER BY partition_number
GO


