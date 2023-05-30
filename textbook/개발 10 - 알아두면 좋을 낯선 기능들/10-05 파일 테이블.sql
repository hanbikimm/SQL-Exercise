--*
--* 10.5. 파일 테이블(File Tables)
--*



--*
--* 10.5.1. 데이터베이스 속성 변경
--*


-- [소스 10-35] 데이터베이스 속성 변경

USE master
GO

ALTER DATABASE HRDB2
	SET FILESTREAM( 
		NON_TRANSACTED_ACCESS = FULL, 
		DIRECTORY_NAME = N'MyFileStream'
	) 
GO



--*
--* 10.5.2. 파일 테이블 만들기
--*


-- [소스 10-36] 파일 테이블 만들기

USE HRDB2
GO

CREATE TABLE dbo.New_Photos 
	AS FILETABLE
	WITH (
		FILETABLE_DIRECTORY = 'MyFileTable'
	)
GO



--*
--* 10.5.3. 파일 테이블 기능 확인
--*


-- [소스 10-37] 파일 테이블 내용 확인

SELECT name, file_type, creation_time, last_write_time, last_access_time
	FROM dbo.New_Photos 
GO


-- [소스 10-38] 쿼리문으로 파일 이름 변경하기

UPDATE dbo.New_Photos 
	SET name = 'hong.jpg'
	WHERE name = 's0001.jpg'
GO