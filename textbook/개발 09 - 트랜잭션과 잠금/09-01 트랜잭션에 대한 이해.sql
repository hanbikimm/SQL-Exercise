--*
--* 9.1.  트랜잭션에 대한 이해
--*



USE HRDB2
GO


--*
--* 9.1.3. 자동 커밋 트랜잭션(Auto Commit Transactions)
--*


-- [소스 9-1] 자동 커밋 트랜잭션


DELETE dbo.Employee
	WHERE EmpID = 'S0020'
ROLLBACK TRANSACTION
GO
/*
메시지 3903, 수준 16, 상태 1, 줄 3
ROLLBACK TRANSACTION 요청에 해당하는 BEGIN TRANSACTION이 없습니다.
*/



--*
--* 9.1.4. 명시적 트랜잭션(Explicit Transactions)
--*


-- [소스 9-2] 명시적 트랜잭션으로 일관된 처리 유지

BEGIN TRANSACTION
	UPDATE dbo.Employee
		SET Salary = Salary - 1000
		WHERE EmpID = 'S0001'
	UPDATE dbo.Employee
		SET Salary = Salary + 1000
		WHERE EmpID = 'S0003'
COMMIT TRANSACTION


-- [소스 9-3] ROLLBACK TRANSACTION 문으로 트랜잭션 취소

BEGIN TRANSACTION
	DELETE dbo.Employee
		WHERE EmpID = 'S0018'
ROLLBACK TRANSACTION
GO

-- 삭제 취소된 이리와(S0018) 직원 정보 조회 가능
SELECT * 
	FROM dbo.Employee
	WHERE EmpID = 'S0018'
GO


-- [소스 9-4] SET XACT_ABORT ON 사용하지 않음

BEGIN TRANSACTION
	INSERT INTO dbo.Vacation VALUES('S0001', '2016-10-05', '2016-10-06', N'감기몸살')
	INSERT INTO dbo.Vacation VALUES('C0002', '2016-10-05', '2016-10-06', N'감기몸살')
COMMIT TRANSACTION
/*
(1개 행이 영향을 받음)
메시지 547, 수준 16, 상태 0, 줄 54
INSERT 문이 FOREIGN KEY 제약 조건 "FK__Vacation__EmpID__2D27B809"과(와) 충돌했습니다. 
데이터베이스 "HRDB2", 테이블 "dbo.Employee", column 'EmpID'에서 충돌이 발생했습니다.
문이 종료되었습니다
*/

SELECT * 
	FROM dbo.Vacation
	WHERE BeginDate = '2016-10-05'
GO


-- [소스 9-5] SET XACT_ABORT ON 사용함

SET XACT_ABORT ON
BEGIN TRANSACTION
	INSERT INTO dbo.Vacation VALUES('S0001', '2016-11-05', '2016-11-06', N'감기몸살')
	INSERT INTO dbo.Vacation VALUES('C0002', '2016-11-05', '2016-11-06', N'감기몸살')
COMMIT TRANSACTION
SET XACT_ABORT OFF
/*
(1개 행이 영향을 받음)
메시지 547, 수준 16, 상태 0, 줄 74
INSERT 문이 FOREIGN KEY 제약 조건 "FK__Vacation__EmpID__2D27B809"과(와) 충돌했습니다. 
데이터베이스 "HRDB2", 테이블 "dbo.Employee", column 'EmpID'에서 충돌이 발생했습니다.
*/

SELECT * 
	FROM dbo.Vacation
	WHERE BeginDate = '2016-11-05'
GO



--*
--* 9.1.5. 묵시적 트랜잭션(Implicit Transactions)
--*


-- [소스 9-6] 묵시적 트랜잭션 사용 예

-- 묵시적 트랜잭션 활성화
SET IMPLICIT_TRANSACTIONS ON
GO

-- 이리와(S0018) 직원 정보 삭제
DELETE dbo.Employee
	WHERE EmpID = 'S0018'
GO

-- 삭제 취소 가능
ROLLBACK TRANSACTION
GO

-- 묵시적 트랜잭션 비활성화
SET IMPLICIT_TRANSACTIONS OFF
GO

-- 삭제 취소된 이리와 직원 정보 확인
SELECT * 
	FROM dbo.Employee
	WHERE EmpID = 'S0018'
GO

