--*
--* 6.1. XML 데이터 이해하기
--*


USE HRDB2
GO


--*
--* 6.1.2. 문자로 취급하던 XML 데이터
--*


-- [소스 6-1] 문자열로서의 XML 데이터

IF OBJECT_ID('dbo.strEmployee', 'U') IS NOT NULL
	DROP TABLE dbo.strEmployee
GO

CREATE TABLE dbo.strEmployee (
	Seq int IDENTITY PRIMARY KEY,
	EmpInfo nvarchar(1000)
)
GO

INSERT INTO dbo.strEmployee VALUES ('
	<Employees>
		<Employee EmpID="S0001">
			<EmpName>
				<FirstName>길동</FirstName>
				<LastName>홍</LastName>
			</EmpName>
			<Contact>
				<Phone>010-1234-1234</Phone>
				<Fax>02-3456-7800</Fax>
				<Email>hong@dbnuri.com</Email>
			</Contact>
		</Employee>
	</Employees>
	')
GO

SELECT * FROM dbo.strEmployee
GO



--*
--* 6.1.3. XML 데이터 형식 지원
--*


-- [소스 6-2] XML 데이터 형식에 저장되는 XML 데이터

IF OBJECT_ID('dbo.xmlEmployee', 'U') IS NOT NULL
	DROP TABLE dbo.xmlEmployee
GO

CREATE TABLE dbo.xmlEmployee (
	Seq int IDENTITY PRIMARY KEY,
	EmpInfo xml
)
GO

INSERT INTO dbo.xmlEmployee VALUES ('
	<Employees>
		<Employee EmpID="S0001">
			<EmpName>
				<FirstName>길동</FirstName>
				<LastName>홍</LastName>
			</EmpName>
			<Contact>
				<Phone>010-1234-1234</Phone>
				<Fax>02-3456-7800</Fax>
				<Email>hong@dbnuri.com</Email>
			</Contact>
		</Employee>
	</Employees>
	')
GO

SELECT * FROM dbo.xmlEmployee
GO


-- [소스 6-3] 문자열 데이터 형식을 XML 데이터 형식으로 변환

ALTER TABLE dbo.strEmployee
	ALTER COLUMN EmpInfo xml
GO



--*
--* 6.1.4. XML 스키마 컬렉션으로 무결성 확보
--*


-- [소스 6-4] XML 스키마 컬렉션 만들기

CREATE XML SCHEMA COLLECTION EmpSchema AS '
<schema xmlns="http://www.w3.org/2001/XMLSchema">
  <element name="Employees">
    <complexType>
      <sequence>
        <element name="Employee" minOccurs="0">
          <complexType>
            <sequence>
              <element name="EmpName" minOccurs="1" maxOccurs="1" />
              <element name="Contact" minOccurs="1" maxOccurs="1" />
            </sequence>
            <attribute name="EmpID" type="string" use="required" />
          </complexType>
        </element>
      </sequence>
    </complexType>
  </element>
</schema>'
GO


-- [소스 6-5] XML 데이터 형식의 열에 XML 스키마 컬렉션 지정

IF OBJECT_ID('dbo.xmlEmployee', 'U') IS NOT NULL
	DROP TABLE dbo.xmlEmployee
GO

CREATE TABLE dbo.xmlEmployee (
	Seq int IDENTITY PRIMARY KEY,
	EmpInfo xml (EmpSchema) -- XML 스키마 컬렉션 지정
)
GO


-- [소스 6-6] 스키마 컬렉션에 맞지 않은 XML 데이터 입력

INSERT INTO dbo.xmlEmployee VALUES ('
	<Employees>
		<Employee EmpID="S0003">
			<EmpName>
				<FirstName>우동</FirstName>
				<LastName>강</LastName>
			</EmpName>
		</Employee>
	</Employees>
	')
GO


-- 메시지 6908, 수준 16, 상태 1, 줄 115
-- XML 유효성 검사: 내용이 잘못되었습니다. 
-- 필요한 요소: 'Contact'. 위치: /*:Employees[1]/*:Employee[1]


-- [소스 6-7] 스키마 컬렉션에 맞는 XML 데이터 입력

INSERT INTO dbo.xmlEmployee  VALUES ('
	<Employees>
		<Employee EmpID="S0003">
			<EmpName>
				<FirstName>우동</FirstName>
				<LastName>강</LastName>
			</EmpName>
			<Contact>
				<Phone>010-6543-9876</Phone>
				<Fax>02-2390-4590</Fax>
				<Email>hodong@dbnuri.com</Email>
			</Contact>
		</Employee>
	</Employees>
	')
GO