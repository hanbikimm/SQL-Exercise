--*
--* 10.10. 테이블 반환 매개변수(Table-Valued Parameters)
--*



--*
--* 10.10.1. 사용자 정의 테이블 형식 만들기
--*


-- [소스 10-61] 사용자 정의 테이블 형식 만들기

USE HRDB2
GO

CREATE TYPE Tbl_EmpList AS TABLE ( 
	EmpID char(5),
	EmpName nvarchar(4)
)
GO


-- [소스 10-62] 테이블 형식 사용 예

-- 변수 선언
DECLARE @EmpList AS Tbl_EmpList

-- 데이터 추가
INSERT INTO @EmpList VALUES('S0001', N'홍길동')
INSERT INTO @EmpList VALUES('S0002', N'일지매')

-- 데이터 변경
UPDATE @EmpList
	 SET EmpName = N'홍길퉁'
	 WHERE EmpID = 'S0001'

-- 확인
SELECT * FROM @EmpList
GO



--*
--* 10.10.2. 테이블 반환 매개 변수를 사용하는 저장 프로시저 만들기
--*


-- [소스 10-63] 테이블 반환 매개 변수를 사용하는 저장 프로시저 만들기

CREATE PROC dbo.usp_VacationList
	@TVP AS Tbl_EmpList READONLY
AS 
BEGIN
	SET NOCOUNT ON
	SELECT e.EmpID, e.EmpName, v.BeginDate, v.EndDate, v.Duration, v.Reason
		FROM @TVP AS e
		INNER JOIN dbo.Vacation AS v ON e.EmpID = v.EmpID
		ORDER BY v.BeginDate DESC
END
GO



--*
--* 10.10.3. 사용 예
--*


-- [소스 10-64] 사용자 정의 테이블 형식 사용 예

-- 테이블 형식 변수 선언
DECLARE @EmpList AS Tbl_EmpList

-- 테이블 변수에 데이터 추가(퇴사자 정보)
INSERT INTO @EmpList
    SELECT EmpID, EmpName
		FROM dbo.Employee
		WHERE RetireDate IS NOT NULL

-- 저장 프로시저 매개변수로 전달(퇴사자들의 휴가 내역 조회)
EXEC dbo.usp_VacationList @EmpList
GO



--*
--* 10.10.4. 고려사항
--*


-- [소스 10-65] 사용자 정의 테이블 형식 변경과 삭제 문제

-- 사용자 정의 테이블 형식 변경 불가능
ALTER TYPE Tbl_EmpList AS TABLE ( 
	EmpID char(5)
)
GO
/*
메시지 102, 수준 15, 상태 1, 줄 59
'TYPE' 근처의 구문이 잘못되었습니다.
*/

-- 사용중인 사용자 정의 테이블 형식 삭제 불가능
DROP TYPE Tbl_EmpList
GO
/*
메시지 3732, 수준 16, 상태 1, 줄 51
'Tbl_EmpList' 유형은 개체 'usp_VacationList'에서 참조하고 있으므로 삭제할 수 없습니다. 
이 유형을 참조하는 다른 개체도 있을 수 있습니다.
*/

