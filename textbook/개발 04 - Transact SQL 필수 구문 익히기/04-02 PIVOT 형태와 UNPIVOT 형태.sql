--*
--* 4.2. PIVOT ���¿� UNPIVOT ����
--*


USE HRDB2
GO


--*
--* 4.2.1. PIVOT ��
--*


-- [�ҽ� 4-13] 2016�� 2�б� �ް� ��Ȳ ��ȸ

SELECT EmpID, MONTH(BeginDate) AS [Month], Duration
	FROM dbo.Vacation
	WHERE BeginDate BETWEEN '2016-04-01' AND '2016-06-30'
GO


-- [�ҽ� 4-14] PIVOT ���·� ��ȸ

SELECT EmpID, [4], [5], [6]
	FROM (
		SELECT EmpID, MONTH(BeginDate) AS [Month], Duration
			FROM dbo.Vacation
			WHERE BeginDate BETWEEN '2016-04-01' AND '2016-06-30'
		) AS src 
		PIVOT (
			SUM(Duration)
			FOR Month IN ([4], [5], [6])
			) AS pvt
GO


-- [�ҽ� 4-15] PIVOT ���¿��� NULL ���� 0���� ǥ��

SELECT EmpID, ISNULL([4], 0) AS [4��], ISNULL([5], 0) AS [5��], ISNULL([6], 0) AS [6��]
	FROM (
		SELECT EmpID, MONTH(BeginDate) AS [Month], Duration
			FROM dbo.Vacation
			WHERE BeginDate BETWEEN '2016-04-01' AND '2016-06-30'
		) AS src 
		PIVOT (
			SUM(Duration)
			FOR Month IN ([4], [5], [6])
			) AS pvt
GO



--*
--* 4.2.2. UNPIVOT ��
--*


-- [�ҽ� 4-16] PIVOT ���� ���̺� �����

SELECT EmpID, [4], [5], [6]
	INTO dbo.mVacation
	FROM (
		SELECT EmpID, MONTH(BeginDate) AS [Month], Duration
			FROM dbo.Vacation
			WHERE BeginDate BETWEEN '2016-04-01' AND '2016-06-30'
		) AS src 
		PIVOT (
			SUM(Duration)
			FOR Month IN ([4], [5], [6])
			) AS pvt
GO

SELECT * FROM dbo.mVacation
GO


-- [�ҽ� 4-17] UNPIVOT ���·� ��ȸ

SELECT EmpID, Month, Duration
	FROM dbo.mVacation
	UNPIVOT (Duration FOR Month IN ([4], [5], [6])) AS uPvt
GO