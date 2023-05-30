--*
--* 8.5. 커서(Cursors)
--*



--*
--* 8.5.1. 커서에 대한 이해
--*


-- [소스 8-77] 커서를 사용하는 쿼리문의 기본 형태

USE HRDB2
GO

-- 필요한 변수 선언
DECLARE @EmpName nvarchar(4)
DECLARE @EmpID char(5)
DECLARE @EMail varchar(50)

-- 커서 선언
DECLARE Emp_Cursor CURSOR FOR
	SELECT EmpName, EmpID, EMail
		FROM dbo.Employee
		WHERE DeptID = 'SYS'
		ORDER BY EmpName

-- 커서 열기
OPEN Emp_Cursor

-- 커서 사용
-- 커서에서 읽어와 변수에 대입
FETCH NEXT FROM Emp_Cursor
	INTO @EmpName, @EmpID, @EMail
-- 마지막 까지 반복헤서 읽기
WHILE @@FETCH_STATUS = 0
BEGIN
	SELECT @EmpName AS [EmpName], @EmpID AS [EmpID], @EMail AS [EMail]
	FETCH NEXT FROM Emp_Cursor
		INTO @EmpName, @EmpID, @EMail
END

-- 커서 닫기 및 제거
CLOSE Emp_Cursor
DEALLOCATE Emp_Cursor
GO



--*
--* 8.5.2. 커서 사용하기
--*


-- [소스 8-78] 커서가 포함할 데이터 정의

SELECT EmpName, EMail
	FROM dbo.Employee
	WHERE Gender = 'F' AND RetireDate IS NULL
	ORDER BY EmpName
GO


-- [소스 8-79] 커서 선언 ... DEALLOCATE문


DECLARE Cur_Emp01 CURSOR STATIC FOR
	SELECT EmpName, EMail
		FROM dbo.Employee
		WHERE Gender = 'F' AND RetireDate IS NULL
		ORDER BY EmpName

OPEN Cur_Emp01

FETCH NEXT FROM Cur_Emp01
FETCH PRIOR FROM Cur_Emp01
FETCH ABSOLUTE 2 FROM Cur_Emp01
FETCH RELATIVE 2 FROM Cur_Emp01

CLOSE Cur_Emp01
DEALLOCATE Cur_Emp01
GO