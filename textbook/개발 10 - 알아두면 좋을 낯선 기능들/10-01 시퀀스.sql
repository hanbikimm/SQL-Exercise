--*
--* 10.1. 시퀀스(Sequences)
--*


USE HRDB2
GO


--*
--* 10.1.2. 시퀀스 만들기
--*


-- [소스 10-1 시퀀스 만들기

-- 시퀀스 만들기
CREATE SEQUENCE dbo.MySeq01 
	AS bigint
	START WITH 1
	INCREMENT BY 1
GO

/*
-- 시퀀스 제거하기 
DROP SEQUENCE dbo.MySeq01 
GO
*/


--*
--* 10.1.3. 시퀀스 사용 예
--*


-- [소스 10-2] 기본적인 시퀀스 사용

-- 출근 테이블 만들기
CREATE TABLE dbo.OfficeIn (
	SeqNo bigint PRIMARY KEY,
	EmpID char(5) REFERENCES dbo.Employee(EmpID),
	Time_in datetime2 DEFAULT SYSDATETIME()
)
GO

-- 시퀀스 만들기
CREATE SEQUENCE dbo.CommuteSeq
   START WITH 1
   INCREMENT BY 1
GO

-- 행 추가하기
INSERT dbo.OfficeIn (SeqNo, EmpID) VALUES (NEXT VALUE FOR dbo.CommuteSeq, 'S0001')
GO
INSERT dbo.OfficeIn (SeqNo, EmpID) VALUES (NEXT VALUE FOR dbo.CommuteSeq, 'S0003')
GO
INSERT dbo.OfficeIn (SeqNo, EmpID) VALUES (NEXT VALUE FOR dbo.CommuteSeq, 'S0004')
GO

-- 결과 확인
SELECT * FROM dbo.OfficeIn
GO


-- [소스 10-3] 여러 테이블에 시퀀스로 증가 값 입력

-- 퇴근 테이블 만들기
CREATE TABLE dbo.OfficeOut (
	SeqNo bigint PRIMARY KEY,
	EmpID char(5) REFERENCES dbo.Employee(EmpID),
	Time_out datetime2 DEFAULT SYSDATETIME()
)
GO

-- 기존 출근 정보 삭제
TRUNCATE TABLE dbo.OfficeIn
GO

-- 데이터 추가(천천히 시간 간격을 두고 추가하면 좋음)
-- 출근
INSERT dbo.OfficeIn (SeqNo, EmpID) VALUES (NEXT VALUE FOR dbo.CommuteSeq, 'S0001')
GO
INSERT dbo.OfficeIn (SeqNo, EmpID) VALUES (NEXT VALUE FOR dbo.CommuteSeq, 'S0003')
GO

-- 퇴근
INSERT dbo.OfficeOut (SeqNo, EmpID) VALUES (NEXT VALUE FOR dbo.CommuteSeq, 'S0003')
GO
INSERT dbo.OfficeOut (SeqNo, EmpID) VALUES (NEXT VALUE FOR dbo.CommuteSeq, 'S0001')
GO

-- 출근
INSERT dbo.OfficeIn (SeqNo, EmpID) VALUES (NEXT VALUE FOR dbo.CommuteSeq, 'S0003')
GO
INSERT dbo.OfficeIn (SeqNo, EmpID) VALUES (NEXT VALUE FOR dbo.CommuteSeq, 'S0001')
GO

-- 퇴근
INSERT dbo.OfficeOut (SeqNo, EmpID) VALUES (NEXT VALUE FOR dbo.CommuteSeq, 'S0003')
GO
INSERT dbo.OfficeOut (SeqNo, EmpID) VALUES (NEXT VALUE FOR dbo.CommuteSeq, 'S0001')
GO

-- 결과 확인
SELECT EmpID, SeqNo, N'출근' AS [Type], Time_in 
	FROM dbo.OfficeIn
UNION ALL
SELECT EmpID, SeqNo, N'퇴근' AS [Type], Time_out 
	FROM dbo.OfficeOut
	ORDER BY EmpID, SeqNo
GO



--*
--* 10.1.4. 시퀀스 값이 반복되게 하기
--*


-- [소스 10-4] 시퀀스 값 반복하기

-- 시퀀스 만들기
CREATE SEQUENCE dbo.MySeq 
	AS tinyint
	START WITH 1
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 5
	CYCLE 
GO

-- 반복되는 값 사용
SELECT NEXT VALUE FOR dbo.MySeq AS [Group], EmpID, EmpName, HireDate, EMail, Phone 
	FROM dbo.Employee
	WHERE Gender = 'M' AND RetireDate IS NULL
GO



--*
--* 10.1.5. OVER 절로 정렬한 결과에 시퀀스 사용
--*


-- [소스 10-5] ORDER BY 사용시 오류 발생

SELECT NEXT VALUE FOR dbo.MySeq AS [Group], EmpID, EmpName, HireDate, EMail, Phone 
	FROM dbo.Employee
	WHERE Gender = 'M' AND RetireDate IS NULL
	ORDER BY HireDate DESC
GO
/*
메시지 11723, 수준 15, 상태 1, 줄 122
NEXT VALUE FOR 함수는 OVER 절을 지정하지 않으면 ORDER BY 절을 포함하는 문에서 직접 사용할 수 없습니다.
*/


-- [소스 10-6] OVER 절로 정렬한 결과에 시퀀스 사용

-- 리셋 하기
ALTER SEQUENCE dbo.MySeq
   RESTART WITH 1 
GO

-- OVER 절 사용
SELECT NEXT VALUE FOR dbo.MySeq OVER(ORDER BY HireDate DESC) AS [Group], 
	EmpID, EmpName,	HireDate, EMail, Phone 
	FROM dbo.Employee
	WHERE Gender = 'M' AND RetireDate IS NULL
	ORDER BY HireDate DESC
GO