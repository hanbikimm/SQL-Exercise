--*
--* 06-02 XML 형태로 변환하는 FOR XML 문
--*


USE HRDB2
GO


--*
--* 6.2.2. FOR XML RAW 문
--*


-- [소스 6-8] FOR XML RAW 사용 예


SELECT EmpID, EmpName
	FROM dbo.Employee
	WHERE DeptID = 'GEN'
	FOR XML RAW
GO

-- 결과
/*
<row EmpID="S0002" EmpName="일지매" />
<row EmpID="S0012" EmpName="최일국" />
*/


-- [소스 6-9] FOR XML RAW, ELEMENTS 사용 예

SELECT EmpID, EmpName, Gender, EMail
	FROM dbo.Employee  
	WHERE DeptID = 'GEN'
	ORDER BY EmpName
	FOR XML RAW, ELEMENTS
GO

-- 결과
/*
<row>
  <EmpID>S0002</EmpID>
  <EmpName>일지매</EmpName>
  <Gender>M</Gender>
  <EMail>jimae@dbnuri.com</EMail>
</row>
<row>
  <EmpID>S0012</EmpID>
  <EmpName>최일국</EmpName>
  <Gender>M</Gender>
  <EMail>ilkook@dbnuri.com</EMail>
</row>
*/


-- [소스 6-10] FOR XML RAW(‘...’), ROOT(‘...’) 사용 예

SELECT EmpID, EmpName, Gender, EMail
	FROM dbo.Employee  
	WHERE DeptID = 'GEN'
	ORDER BY EmpName
	FOR XML RAW('사원'), ROOT('사원들')
GO

-- 결과
/*
<사원들>
  <사원 EmpID="S0002" EmpName="일지매" Gender="M" EMail="jimae@dbnuri.com" />
  <사원 EmpID="S0012" EmpName="최일국" Gender="M" EMail="ilkook@dbnuri.com" />
</사원들>
*/


-- [소스 6-11] FOR XML RAW(‘...’), ROOT(‘...’), ELEMENTS 사용 예

SELECT EmpID, EmpName, Gender, EMail
	FROM dbo.Employee  
	WHERE DeptID = 'GEN'
	ORDER BY EmpName
	FOR XML RAW('사원'), ROOT('사원들'), ELEMENTS
GO

-- 결과
/*
<사원들>
  <사원>
    <EmpID>S0002</EmpID>
    <EmpName>일지매</EmpName>
    <Gender>M</Gender>
    <EMail>jimae@dbnuri.com</EMail>
  </사원>
  <사원>
    <EmpID>S0012</EmpID>
    <EmpName>최일국</EmpName>
    <Gender>M</Gender>
    <EMail>ilkook@dbnuri.com</EMail>
  </사원>
</사원들
*/



--*
--* 6.2.3. FOR XML AUTO 문
--*


-- [소스 6-12] FOR XML AUTO 사용 예

SELECT EmpID, EmpName, Gender, EMail
	FROM dbo.Employee  
	WHERE DeptID = 'GEN'
	ORDER BY EmpName
	FOR XML AUTO
GO

-- 결과
/*
<dbo.Employee EmpID="S0002" EmpName="일지매" Gender="M" EMail="jimae@dbnuri.com" />
<dbo.Employee EmpID="S0012" EmpName="최일국" Gender="M" EMail="ilkook@dbnuri.com" />
*/


-- [소스 6-13] FOR XML AUTO, ELEMENTS 사용 예

SELECT EmpID, EmpName, Gender, EMail
	FROM dbo.Employee  
	WHERE DeptID = 'GEN'
	ORDER BY EmpName
	FOR XML AUTO, ELEMENTS
GO

-- 결과
/*
<dbo.Employee>
  <EmpID>S0002</EmpID>
  <EmpName>일지매</EmpName>
  <Gender>M</Gender>
  <EMail>jimae@dbnuri.com</EMail>
</dbo.Employee>
<dbo.Employee>
  <EmpID>S0012</EmpID>
  <EmpName>최일국</EmpName>
  <Gender>M</Gender>
  <EMail>ilkook@dbnuri.com</EMail>
</dbo.Employee>
*/


-- [소스 6-14] FOR XML AUTO, ELEMENTS, ROOT(‘...’) 사용 예

SELECT EmpID, EmpName, Gender, EMail
	FROM dbo.Employee  
	WHERE DeptID = 'GEN'
	ORDER BY EmpName
	FOR XML AUTO, ELEMENTS, ROOT('사원들')
GO

-- 결과
/*
<사원들>
  <dbo.Employee>
    <EmpID>S0002</EmpID>
    <EmpName>일지매</EmpName>
    <Gender>M</Gender>
    <EMail>jimae@dbnuri.com</EMail>
  </dbo.Employee>
  <dbo.Employee>
    <EmpID>S0012</EmpID>
    <EmpName>최일국</EmpName>
    <Gender>M</Gender>
    <EMail>ilkook@dbnuri.com</EMail>
  </dbo.Employee>
</사원들>
*/



--*
--* 6.2.4. FOR XML EXPLICIT 문
--*


-- [소스 6-15] FOR XML EXPLICIT 사용 예

SELECT 1 AS Tag,
		NULL AS Parent,
		EmpID AS [사원!1!사원번호],
		EmpName AS [사원!1!사원이름!Element]
	FROM dbo.Employee
	WHERE DeptID = 'GEN'
	FOR XML EXPLICIT
GO

-- 결과
/*
<사원 사원번호="S0002">
  <사원이름>일지매</사원이름>
</사원>
<사원 사원번호="S0012">
  <사원이름>최일국</사원이름>
</사원>
*/



--*
--* 6.2.5. FOR XML PATH 문
--*


-- [소스 6-16] FOR XML PATH 사용 예

SELECT EmpName "@사원이름",
		'N/A' "연락처/전화번호",
		EMail "연락처/이메일"
	FROM dbo.Employee
	WHERE DeptID = 'GEN'
	FOR XML PATH
GO

-- 결과
/*
<row 사원이름="일지매">
  <연락처>
    <전화번호>N/A</전화번호>
    <이메일>jimae@dbnuri.com</이메일>
  </연락처>
</row>
<row 사원이름="최일국">
  <연락처>
    <전화번호>N/A</전화번호>
    <이메일>ilkook@dbnuri.com</이메일>
  </연락처>
</row>
*/


-- [소스 6-17] 요소 이름 변경 예

SELECT EmpName "@사원이름",
		'N/A' "연락처/전화번호",
		EMail "연락처/이메일"
	FROM dbo.Employee
	WHERE DeptID = 'GEN'
	FOR XML PATH('사원')
GO

-- 결과
/*
<사원 사원이름="일지매">
  <연락처>
    <전화번호>N/A</전화번호>
    <이메일>jimae@dbnuri.com</이메일>
  </연락처>
</사원>
<사원 사원이름="최일국">
  <연락처>
    <전화번호>N/A</전화번호>
    <이메일>ilkook@dbnuri.com</이메일>
  </연락처>
</사원>*/