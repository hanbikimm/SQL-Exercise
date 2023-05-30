--*
--* 2.1. 테이블 만들기
--*



--*
--* 2.1.1. 학습 준비
--*


-- [소스 2-1] HRDB2 데이터베이스 만들기

USE master
GO
 
CREATE DATABASE HRDB2
GO



--*
--* 2.1.4. CREATE TABLE 문으로 만들기
--*


-- [소스 2-2] 직원 테이블 만들기

USE HRDB2
GO

CREATE TABLE dbo.직원 (
    사원번호 char(5) NOT NULL,
    이름 nchar(10) NOT NULL,
    성별 char(1) NOT NULL,
    입사일 date NOT NULL,
    전자우편 varchar(60) NOT NULL,
	부서코드 char(3) NOT NULL
) 
GO



--*
--* 2.1.5. 테이블 관리
--*


-- [소스 2-3] 열 추가

ALTER TABLE dbo.직원
	ADD 급여 int NULL
GO


-- [소스 2-4] 기존 테이블에 NOT NULL 속성 추가
INSERT INTO dbo.직원 VALUES('S0001', N'홍길동', 'M', '2011-01-01', 'hong@dbnuri.com', 'SYS', 8500)
INSERT INTO dbo.직원 VALUES('S0002', N'일지매', 'M', '2011-01-12', 'jimae@dbnuri.com', 'GEN', 8200)
GO

ALTER TABLE dbo.직원
	ADD EngName varchar(20) NOT NULL
GO
/*
메시지 4901, 수준 16, 상태 1, 줄 42
ALTER TABLE은 Null 값을 포함하거나 DEFAULT 정의가 지정된 열만 추가할 수 있습니다. 
또는 추가되는 열이 ID 또는 타임스탬프 열이어야 합니다. 앞의 조건이 모두 만족되지 않을 경우 테이블이 비어 있어야 이 열을 추가할 수 있습니다. 열 'EngName'은(는) 이러한 조건을 만족하지 않으므로 비어 있지 않은 테이블 '직원'에 추가할 수 없습니다.
*/


-- [소스 2-5] DEFAULT 제약과 IDENTITY 속성 사용

-- DEFAULT 제약
ALTER TABLE dbo.직원
	ADD EngName varchar(20) DEFAULT('') NOT NULL
GO

-- IDENTITY 속성
ALTER TABLE dbo.직원
	ADD CheckID int IDENTITY(1, 1) NOT NULL 
GO

SELECT * FROM dbo.직원
GO


-- [소스 2-6] 열 삭제

ALTER TABLE dbo.직원
	DROP COLUMN 급여
GO


-- [소스 2-7] 열 변경

ALTER TABLE dbo.직원
    ALTER COLUMN 이름 nvarchar(20) NOT NULL
GO


-- [소스 2-8] 열 이름 변경

EXEC sp_rename 'dbo.직원.전자우편', '이메일',  'COLUMN'
GO
/*
주의: 개체 이름 부분을 변경하면 스크립트 및 저장 프로시저를 손상시킬 수 있습니다.
*/


-- [소스 2-9] 테이블 이름 변경

EXEC sp_rename 'dbo.직원', '직원정보', 'OBJECT'
GO
/*
주의: 개체 이름 부분을 변경하면 스크립트 및 저장 프로시저를 손상시킬 수 있습니다.
*/


-- [소스 2-10] 테이블 삭제

DROP TABLE dbo.직원정보
GO



--*
--* 2.1.6. 데이터 정렬(Collations)
--*



-- [소스 2-11] 직원 테이블 만들기 

USE HRDB2
GO

CREATE TABLE dbo.직원 (
    사원번호 char(5) NOT NULL,
    이름 nchar(10) NOT NULL,
    성별 char(1) NOT NULL,
    입사일 date NOT NULL,
    전자우편 varchar(60) NOT NULL,
    부서코드 char(3) NOT NULL
) 
GO


-- [소스 2-12] 데이터 정렬 정보 확인

-- SQL Server 데이터 정렬 확인
SELECT SERVERPROPERTY('collation')
GO
/*
Korean_Wansung_CI_AS
*/

-- HRDB2 데이터베이스 데이터 정렬 확인(방법1)
SELECT DATABASEPROPERTYEX('HRDB2','collation')
GO
/*
Korean_Wansung_CI_AS
*/

-- HRDB2 데이터베이스 데이터 정렬 확인(방법2)
SELECT collation_name
	FROM sys.databases
	WHERE name = 'HRDB2'
GO
/*
Korean_Wansung_CI_AS
*/


-- [소스 2-13] 정렬 방식 지정하여 테이블 다시 만들기

-- 기존 테이블 삭제
DROP TABLE dbo.직원
GO

-- 테이블 만들기
CREATE TABLE dbo.직원 (
    사원번호 char(5) COLLATE Korean_Wansung_CI_AS NOT NULL,
    이름 nchar(10) COLLATE Korean_Wansung_CI_AS NOT NULL,
    성별 char(1) COLLATE Korean_Wansung_CI_AS NOT NULL,
    입사일 date NOT NULL,
    전자우편 varchar(60) COLLATE Korean_Wansung_CI_AS NOT NULL,
    부서코드 char(3) COLLATE Korean_Wansung_CI_AS NOT NULL
) 
GO


-- [소스 2-14] 데이터 추가

INSERT INTO dbo.직원 VALUES('S0001', N'홍길동', 'M', '2011-01-01', 'hong@dbnuri.com', 'SYS')
INSERT INTO dbo.직원 VALUES('S0002', N'일지매', 'm', '2011-01-12', 'jimae@dbnuri.com', 'GEN')
INSERT INTO dbo.직원 VALUES('S0004', N'김삼순', 'F', '2012-08-01', 'samsoon@dbnuri.com', 'MKT')
GO


-- [소스 2-15] 대소문자 구문 여부 확인

SELECT 사원번호, 이름, 성별, 입사일, 전자우편, 부서코드
	FROM dbo.직원
	WHERE 성별 = 'M'
GO


-- [소스 2-16] 데이터 정렬 힌트 사용

SELECT 사원번호, 이름, 성별, 입사일, 전자우편, 부서코드
	FROM dbo.직원
	WHERE 성별 = 'M' COLLATE Korean_Wansung_CS_AS
GO