--*
--* 10.2. 분할된 테이블(Partitioned Tables)
--*


USE HRDB2
GO


--*
--* 10.2.2. 분할된 테이블 만들기
--*


-- [소스 10-7] 분할 기준 확인

SELECT MIN(BeginDate) AS [MIN_Date], MAX(BeginDate) AS [MAX_Date]
	FROM vacation -- 2011-01-12 / 2016-09-08
GO


-- [소스 10-8] 파티션 함수 만들기

CREATE PARTITION FUNCTION PF_Vacation (date)
        AS RANGE RIGHT
        FOR VALUES ('2012-01-01', 
					'2013-01-01', 
					'2014-01-01',
					'2015-01-01', 
					'2016-01-01'
		)
GO


-- [소스 10-9] 파티션 구성표 만들기

CREATE PARTITION SCHEME PS_Vacation
   AS PARTITION PF_Vacation
   ALL TO ([PRIMARY])
GO
/*
파티션 구성표 'PS_Vacation'이(가) 작성되었습니다. 
파티션 구성표 'PS_Vacation'에서 'PRIMARY'은(는) 다음에 사용되는 파일 그룹으로 표시됩니다.
*/


-- [소스 10-10] 분할 된 테이블 만들기

CREATE TABLE dbo.PT_Vacation (
	VacationID int IDENTITY,
	EmpID char(5) REFERENCES dbo.Employee(EmpID),
	BeginDate date NOT NULL,
	EndDate date NOT NULL,
	Reason nvarchar(50) DEFAULT N'개인사유',
	Duration AS (DATEDIFF(day, BeginDate, EndDate) + 1),
	CHECK (EndDate >= BeginDate),
	PRIMARY KEY CLUSTERED (
			BeginDate ASC,
			VacationID ASC
	)
) ON PS_Vacation(BeginDate)
GO


-- [소스 10-11] 분할된 테이블에 데이터 추가하기

SET IDENTITY_INSERT dbo.PT_Vacation ON
GO

INSERT INTO dbo.PT_Vacation(VacationID, EmpID, BeginDate, EndDate, Reason)
	SELECT VacationID, EmpID, BeginDate, EndDate, Reason FROM dbo.Vacation
GO

SET IDENTITY_INSERT dbo.PT_Vacation OFF
GO


-- [소스 10-12] 파티션 정보 확인

SELECT partition_id, object_id, partition_number, rows 
	FROM sys.partitions
	WHERE OBJECT_ID = OBJECT_ID('dbo.PT_Vacation')
	ORDER BY partition_number
GO



--*
--* 10.2.3. 분할된 테이블 관리
--*


-- [소스 10-13] 삭제용 분할된 테이블 만들기

-- 파티션 함수 만들기
CREATE PARTITION FUNCTION PT_DelVacation (date)
        AS RANGE RIGHT
        FOR VALUES ('2099-01-01')
GO

-- 파티션 구성표 만들기
CREATE PARTITION SCHEME PS_DelVacation 
   AS PARTITION PT_DelVacation 
   ALL TO ([PRIMARY])
GO

-- 테이블 만들기
CREATE TABLE dbo.PT_DelVacation (
	VacationID int IDENTITY,
	EmpID char(5) REFERENCES dbo.Employee(EmpID),
	BeginDate date NOT NULL,
	EndDate date NOT NULL,
	Reason nvarchar(50) DEFAULT N'개인사유',
	Duration AS (DATEDIFF(day, BeginDate, EndDate) + 1),
	CHECK (EndDate >= BeginDate),
	PRIMARY KEY CLUSTERED (
			BeginDate ASC,
			VacationID ASC
	)
) ON PS_DelVacation(BeginDate)
GO


-- [소스 10-14] 파티션 분할

-- 여유 파티션 만들기
ALTER PARTITION SCHEME PS_Vacation
    NEXT USED [PRIMARY]
GO

-- 파티션 분할
ALTER PARTITION FUNCTION PF_Vacation()
	SPLIT RANGE ('2017.01.01')
GO

-- 확인
SELECT partition_id, object_id, partition_number, rows 
    FROM sys.partitions
    WHERE OBJECT_ID = OBJECT_ID('dbo.PT_Vacation')
    ORDER BY partition_number
GO


-- [소스 10-15] 파티션 전환

-- 파티션 전환
ALTER TABLE dbo.PT_Vacation
	SWITCH PARTITION 1 
	TO dbo.PT_DelVacation PARTITION 1
GO

-- 데이터 삭제
TRUNCATE TABLE dbo.PT_DelVacation
GO

-- 확인
SELECT partition_id, object_id, partition_number, rows 
    FROM sys.partitions
    WHERE OBJECT_ID = OBJECT_ID('dbo.PT_Vacation')
    ORDER BY partition_number
GO


-- [소스 10-16] 파티션 병합

-- 파티션 병합
ALTER PARTITION FUNCTION PF_Vacation() 
	MERGE RANGE ('2012.01.01')
GO

-- 확인
SELECT partition_id, object_id, partition_number, rows 
	FROM sys.partitions
	WHERE OBJECT_ID = OBJECT_ID('dbo.PT_Vacation')
	ORDER BY partition_number
GO


