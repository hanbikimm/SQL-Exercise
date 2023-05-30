--*
--* 6.3. 테이블 형태로 변환하는 OPENXML 함수
--*


USE HRDB2
GO


--*
--* 6.3.2. OPENXML 함수 사용 예
--*


-- [소스 6-18] OPENXML 사용 예

DECLARE @DocHandle int
DECLARE @XmlDoc xml

SET @XmlDoc = N'
<root>
  <Employee>
    <EmpID>S0002</EmpID>
    <EmpName>일지매</EmpName>
    <Gender>M</Gender>
    <EMail>jimae@dbnuri.com</EMail>
  </Employee>
  <Employee>
    <EmpID>S0012</EmpID>
    <EmpName>최일국</EmpName>
    <Gender>M</Gender>
    <EMail>ilkook@dbnuri.com</EMail>
  </Employee>
</root>'

EXEC sp_xml_preparedocument @DocHandle OUTPUT, @XmlDoc

SELECT *
	FROM OPENXML (@DocHandle, '/root/Employee', 2) WITH dbo.Employee

EXEC sp_xml_removedocument @DocHandle
GO