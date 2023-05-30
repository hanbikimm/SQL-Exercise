--*
--* 9.3. 잠금 관리 방법
--*



USE HRDB2
GO



--*
--* 9.3.1. 잠금 타임 아웃 설정
--*


-- [소스 9-7] 1분간 지속되는 변경 작업 수행

-- [세션1] 처리 내용
BEGIN TRANSACTION
	UPDATE dbo.Employee
		SET EmpName = N'홍길퉁'
		WHERE EmpID = 'S0001'
	WAITFOR DELAY '00:01:00' -- 1분간 처리 지연
COMMIT TRANSACTION
GO


-- [소스 9-8] SET LOCK_TIMEOUT 문을 사용한 잠금 타임아웃 지정

-- [세션2] 처리 내용
SET LOCK_TIMEOUT 5000 -- 5초
GO

SELECT * 
	FROM dbo.Employee
GO
/*
메시지 1222, 수준 16, 상태 51, 줄 2
잠금 요청 제한 시간이 초과되었습니다.
*/
 
SET LOCK_TIMEOUT -1  -- 기본 값
GO



--*
--* 9.3.2. 교착 상태(Deadlocks)
--*


-- [소스 9-9] 홍길동 직원 행을 잠그고 일지매 직원 행을 찾는 트랜잭션

-- [세션1] 
BEGIN TRANSACTION
	UPDATE dbo.Employee
		SET EmpName = N'홍길퉁'
		WHERE EmpID = 'S0001'
	WAITFOR DELAY '00:00:30' -- 30초간 처리 지연
	SELECT EmpName, EMail
		FROM dbo.Employee
		WHERE EmpID = 'S0002'
COMMIT TRANSACTION
GO


-- [소스 9-10] 일지매 직원 행을 잠그고 홍길동 직원 행을 찾는 트랜잭션

-- [세션2] 
BEGIN TRANSACTION
	UPDATE dbo.Employee
		SET EmpName = N'일주매'
		WHERE EmpID = 'S0002'
	WAITFOR DELAY '00:00:30' -- 30초간 처리 지연
	SELECT EmpName, EMail
		FROM dbo.Employee
		WHERE EmpID = 'S0001'
COMMIT TRANSACTION
GO
/*
메시지 1205, 수준 13, 상태 51, 줄 6
트랜잭션(프로세스 ID 56)이 잠금 리소스에서 다른 프로세스와의 교착 상태가 발생하여 실행이 중지되었습니다. 트랜잭션을 다시 실행하십시오.
*/


-- [소스 9-11] 트랜잭션 중요도를 가장 높게 설정

SET DEADLOCK_PRIORITY 10
GO


-- [소스 9-12] 트랜잭션 중요도를 HIGH로 설정

SET DEADLOCK_PRIORITY HIGH
GO

 

--*
--* 9.3.3. 잠금과 관련된 테이블 힌트
--*


-- [소스 9-13] 30초간 지속되는 변경 작업 수행

-- [세션1]
BEGIN TRANSACTION
	UPDATE dbo.Employee
		SET EmpName = N'홍길래'
		WHERE EmpID = 'S0001'
	WAITFOR DELAY '00:00:30' -- 30초간 처리 지연
COMMIT TRANSACTION
GO


-- [소스 9-14] NOLOCK 힌트 사용

-- [세션2]
SELECT EmpID, EmpName, Gender, HireDate, Phone, EMail 
	FROM dbo.Employee WITH (NOLOCK)
	WHERE DeptID = 'SYS'
GO


-- [소스 9-15] 30초간 지속되는 변경 작업 수행

-- [세션1]
BEGIN TRANSACTION
	UPDATE dbo.Employee
		SET EmpName = N'홍길삼'
		WHERE EmpID = 'S0001'
	WAITFOR DELAY '00:00:30' -- 30초간 처리 지연
COMMIT TRANSACTION
GO


-- [소스 9-16] READPAST 힌트 사용

-- [세션2]
SELECT EmpID, EmpName, Gender, HireDate, Phone, EMail 
	FROM dbo.Employee WITH (READPAST)
	WHERE DeptID = 'SYS'
GO