--*
--* 1.6. 파일 그룹(File Groups) 활용
--*



--*
--* 1.6.3. 파일 그룹 만들기
--*


-- [소스 1-3] 쿼리문으로 파일 그룹과 파일 추가

USE master
GO

-- UFG01 파일 그룹 추가
ALTER DATABASE FirstDB02
	ADD FILEGROUP UFG01
GO

-- UFG01 파일 그룹에 파일 추가
ALTER DATABASE FirstDB02
	ADD FILE ( 
		NAME = 'FirstDB02_02', 
		FILENAME = 'D:\SQLData\FirstDB02_02.ndf', 
		SIZE = 512MB, 
		FILEGROWTH = 128MB 
	) TO FILEGROUP UFG01
GO

-- UFG02 파일 그룹 
ALTER DATABASE FirstDB02
	ADD FILEGROUP UFG02
GO

-- UFG02 파일 그룹에 파일 추가
ALTER DATABASE FirstDB02
	ADD FILE ( 
		NAME = 'FirstDB02_03', 
		FILENAME = 'D:\SQLData\FirstDB02_03.ndf', 
		SIZE = 512MB, 
		FILEGROWTH = 128MB 
	) TO FILEGROUP UFG02
GO


USE FirstDB02
GO

-- UFG01 파일 그룹을 기본 파일 그룹으로 변경
ALTER DATABASE FirstDB02
	MODIFY FILEGROUP UFG01 DEFAULT
GO



--*
--* 1.6.4. 파일 그룹에 테이블 만들기
--*


-- [소스 1-4] 파일 그룹에 테이블 만들기

USE FirstDB02
GO

-- PRIMARY 파일 그룹에 TA 테이블 만들기
CREATE TABLE TA (
	col1 int,
	col2 int
) ON [PRIMARY]
GO

-- UFG01 파일 그룹에 TB 테이블 만들기
CREATE TABLE TB (
	col1 int,
	col2 int
) ON UFG01
GO

-- UFG02 파일 그룹에 TC 테이블 만들기
CREATE TABLE TC (
	col1 int,
	col2 int
) ON UFG02
GO

-- 기본 파일 그룹에 TD 테이블 만들기
CREATE TABLE TD (
	col1 int,
	col2 int
)
GO