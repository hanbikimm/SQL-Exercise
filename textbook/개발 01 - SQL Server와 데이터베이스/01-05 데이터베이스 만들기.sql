--*
--* 1.5. 데이터베이스 만들기 
--*


--*
--* 1.5.4. CREATE DATABASE 문으로 만들기
--*


-- [소스 1-1] 이름만 주고 데이터베이스 만들기

USE master
GO

-- 데이터베이스 만들기
CREATE DATABASE FirstDB02
GO


-- [소스 1-2] 요구사항에 맞는 데이터베이스 만들기

USE master
GO

CREATE DATABASE SeconDB02
ON PRIMARY ( 
	NAME = N'SeconDB02', 
	FILENAME = N'D:\SQLData\SeconDB02.mdf', 
	SIZE = 1024MB, 
	MAXSIZE = UNLIMITED, 
	FILEGROWTH = 256MB 
)
LOG ON ( 
	NAME = 'SeconDB02_log', 
	FILENAME = 'E:\SQLLog\SeconDB02_log.ldf', 
	SIZE = 256MB, 
	MAXSIZE = UNLIMITED, 
	FILEGROWTH = 128MB 
)
GO