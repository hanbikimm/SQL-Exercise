--*
--* 9.4. 트랜잭션 격리 수준(Transaction Isolation Levels)
--*



USE HRDB2
GO


--*
--* 9.4.1. READ UNCOMMITTED 격리 수준
--*


-- [세션1]
BEGIN TRANSACTION
	UPDATE dbo.Employee
		SET Salary = 9000
		WHERE EmpID = 'S0001'
	WAITFOR DELAY '00:01:00'
ROLLBACK TRANSACTION
GO


-- [세션2]
SET TRANSACTION ISOLATION LEVEL 
    READ UNCOMMITTED
GO

SELECT *
   FROM dbo.Employee
   WHERE EmpID = 'S0001'
GO



--*
--* 9.4.2. READ COMMITTED (기본값) 격리 수준
--*


-- [세션1]
BEGIN TRANSACTION
	UPDATE dbo.Employee
		SET Salary = 8500
		WHERE EmpID = 'S0002'
	WAITFOR DELAY '00:01:00'
ROLLBACK TRANSACTION
GO

-- [세션2]
SET TRANSACTION ISOLATION LEVEL 
    READ COMMITTED
GO

SELECT *
   FROM dbo.Employee
   WHERE EmpID = 'S0002'
GO



--*
--* 9.4.3. REPEATABLE READ 격리 수준
--*


-- [세션1]
SET TRANSACTION ISOLATION LEVEL 
   REPEATABLE READ
GO

BEGIN TRANSACTION
-- 반복 해서 읽기
   SELECT *
      FROM dbo.Employee
      WHERE DeptID = 'SYS'
	WAITFOR DELAY '00:01:00'
COMMIT TRANSACTION
GO

-- [세션2]
DELETE dbo.Employee
   WHERE EmpID = 'S0009'  -- X
GO

INSERT INTO dbo.Employee 
	VALUES('S0021', N'나처럼', 'nana', 'M', '2016-05-01', NULL, 'SYS', '010-7711-3311', 'nana@dbnuri.com', 4000)
GO



--*
--* 9.4.4. SERIALIZABLE 격리 수준
--*


-- [세션1]
SET TRANSACTION ISOLATION LEVEL 
   SERIALIZABLE
GO

BEGIN TRANSACTION
-- 반복 해서 읽기
   SELECT *
      FROM dbo.Employee
      WHERE DeptID = 'SYS'
	WAITFOR DELAY '00:01:00'
COMMIT TRANSACTION
GO


-- [세션2]
DELETE dbo.Employee
   WHERE EmpID = 'S0009'   
GO

INSERT INTO dbo.Employee 
	VALUES('S0022', N'오마나', 'mana', 'F', '2016-05-01', NULL, 'SYS', '010-1819-2829', 'ohmana@dbnuri.com', 3000)
GO



--*
--* 9.4.5. READ COMMITTED SNAPSHOT 격리 수준
--*


USE Master
GO

ALTER DATABASE HRDB2
   SET READ_COMMITTED_SNAPSHOT ON
GO

USE HRDB2
GO

-- [세션1]
BEGIN TRANSACTION
	UPDATE dbo.Employee
		SET Salary = 7000
		WHERE EmpID = 'S0003'
	WAITFOR DELAY '00:01:00'
ROLLBACK TRANSACTION
GO


-- [세션2]
SELECT *
   FROM dbo.Employee
   WHERE EmpID = 'S0003'
GO


-- 옵션 비 활성화

USE Master
GO

ALTER DATABASE HRDB2
   SET READ_COMMITTED_SNAPSHOT OFF
GO



--*
--* 9.4.6. SNAPSHOT 격리 수준
--*


USE Master
GO

ALTER DATABASE HRDB2
   SET ALLOW_SNAPSHOT_ISOLATION ON
GO

USE HRDB2
GO

-- [세션1]
SET TRANSACTION ISOLATION LEVEL SNAPSHOT
GO

BEGIN TRANSACTION
-- 반복 해서 읽기
    SELECT *
        FROM dbo.Employee
        WHERE DeptID = 'SYS'
    WAITFOR DELAY '00:01:00'
	    UPDATE dbo.Employee
			SET Salary = 6000
			WHERE EmpID = 'S0009'
COMMIT TRANSACTION
GO
/*
메시지 3960, 수준 16, 상태 2, 줄 1
업데이트 충돌로 인해 스냅숏 격리 트랜잭션이 중단되었습니다. 스냅숏 격리를 사용하여 데이터베이스 'HRDB'의 테이블 'dbo.Employee'에 직접 또는 간접적으로 액세스하여 다른 트랜잭션에 의해 수정되거나 삭제된 행을 업데이트, 삭제 또는 삽입할 수 없습니다. 트랜잭션을 다시 시도하거나 UPDATE/DELETE 문에 대한 격리 수준을 변경하십시오.
*/


-- [세션2]
DELETE dbo.Employee
   WHERE EmpID = 'S0009' 
GO


-- 옵션 비활성화

USE Master
GO

ALTER DATABASE HRDB2
   SET ALLOW_SNAPSHOT_ISOLATION OFF
GO