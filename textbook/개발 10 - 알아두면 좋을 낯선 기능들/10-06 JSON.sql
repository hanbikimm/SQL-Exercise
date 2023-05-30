--*
--* 10.6. JSON(JavaScript Object Notation)
--*



USE HRDB2
GO


--* 
--* 10.6.1. JSON 데이터 형태로 결과 출력
--*


-- [소스 10-39] FOR JSON AUTO 사용 예

SELECT e.EmpID, e.EmpName, e.Gender, d.DeptName, e.RetireDate
	FROM dbo.Employee AS e
	INNER JOIN dbo.Department AS d
	ON e.DeptID = d.DeptID
	WHERE EmpID BETWEEN 'S0005' AND 'S0006'
	FOR JSON AUTO
GO

-- 결과
/*
[  
   {  
      "EmpID":"S0005",
      "EmpName":"오삼식",
      "Gender":"M",
      "RetireDate":"2015-01-31",
      "d":[  
         {  
            "DeptName":"영업"
         }
      ]
   },
   {  
      "EmpID":"S0006",
      "EmpName":"김치국",
      "Gender":"M",
      "d":[  
         {  
            "DeptName":"인사"
         }
      ]
   }
]
*/


-- [소스 10-40] FOR JSON PATH 사용 예

SELECT e.EmpID, e.EmpName, e.Gender, d.DeptName, e.RetireDate
	FROM dbo.Employee AS e
	INNER JOIN dbo.Department AS d
	ON e.DeptID = d.DeptID
	WHERE EmpID BETWEEN 'S0005' AND 'S0006'
	FOR JSON PATH 
GO


-- 결과
/*
[  
   {  
      "EmpID":"S0005",
      "EmpName":"오삼식",
      "Gender":"M",
      "DeptName":"영업",
      "RetireDate":"2015-01-31"
   },
   {  
      "EmpID":"S0006",
      "EmpName":"김치국",
      "Gender":"M",
      "DeptName":"인사"
   }
]
*/


-- [소스 10-41] FOR JSON PATH, ROOT 사용 예

SELECT e.EmpID, e.EmpName, e.Gender, d.DeptName, e.RetireDate
	FROM dbo.Employee AS e
	INNER JOIN dbo.Department AS d
	ON e.DeptID = d.DeptID
	WHERE EmpID BETWEEN 'S0005' AND 'S0006'
	FOR JSON PATH, ROOT('Employee')
GO

/*
{  
   "Employee":[  
      {  
         "EmpID":"S0005",
         "EmpName":"오삼식",
         "Gender":"M",
         "DeptName":"영업",
         "RetireDate":"2015-01-31"
      },
      {  
         "EmpID":"S0006",
         "EmpName":"김치국",
         "Gender":"M",
         "DeptName":"인사"
      }
   ]
}
*/

-- [소스 10-42] INCLUDE_NULL_VALUES 사용 예

SELECT e.EmpID, e.EmpName, e.Gender, d.DeptName, e.RetireDate
	FROM dbo.Employee AS e
	INNER JOIN dbo.Department AS d
	ON e.DeptID = d.DeptID
	WHERE EmpID BETWEEN 'S0005'  AND 'S0006'
    FOR JSON PATH, ROOT('Employee'), INCLUDE_NULL_VALUES
GO

-- 결과
/*
{  
   "Employee":[  
      {  
         "EmpID":"S0005",
         "EmpName":"오삼식",
         "Gender":"M",
         "DeptName":"영업",
         "RetireDate":"2015-01-31"
      },
      {  
         "EmpID":"S0006",
         "EmpName":"김치국",
         "Gender":"M",
         "DeptName":"인사",
         "RetireDate":null
      }
   ]
}
*/



--*
--* 10.6.2. OPENJSON을 사용해 JSON 데이터를 테이블 형태로 변환
--*


-- [소스 10-43] OPENJSON 사용 예

DECLARE @json NVARCHAR(MAX) = N'
{  
   "Employee":[  
      {  
         "EmpID":"S0005",
         "EmpName":"오삼식",
         "Gender":"M",
         "DeptName":"영업",
         "RetireDate":"2015-01-31"
      },
      {  
         "EmpID":"S0006",
         "EmpName":"김치국",
         "Gender":"M",
         "DeptName":"인사"
      }
   ]
}'
SELECT *
	FROM OPENJSON(@json,'$.Employee')
	WITH(
		EmpID char(5),
		EmpName nvarchar(4),
		Gender char(1),
		DeptName nvarchar(10) ,
		RetireDate date
	)
GO



--*
--* 10.6.3. 기타 기능들
--*


-- [소스 10-44] ISJSON 함수 사용 예

DECLARE @json NVARCHAR(MAX) = N'
{  
   "Employee":[  
      {  
         "EmpID":"S0005",
         "EmpName":"오삼식",
         "Gender":"M",
         "DeptName":"영업",
         "RetireDate":"2015-01-31"
      },
      {  
         "EmpID":"S0006",
         "EmpName":"김치국",
         "Gender":"M",
         "DeptName":"인사"
      }
   ]
}'
 
IF ISJSON(@json) > 0
	PRINT N'JSON 맞아요!'
ELSE
	PRINT N'JSON이 아닌것 같아요!'
GO

-- 결과
/*
JSON 맞아요!
*/


-- [소스 10-45] JSON_VALUE 함수 사용 예

DECLARE @json NVARCHAR(MAX) = N'
{  
   "Employee":[  
      {  
         "EmpID":"S0005",
         "EmpName":"오삼식",
         "Gender":"M",
         "DeptName":"영업",
         "RetireDate":"2015-01-31"
      },
      {  
         "EmpID":"S0006",
         "EmpName":"김치국",
         "Gender":"M",
         "DeptName":"인사"
      }
   ]
}'
SELECT JSON_VALUE(@json, '$.Employee[0].EmpName') 

-- 결과
/*
오삼식
*/


-- [소스 10-46] JSON_QUERY 사용 예

DECLARE @json NVARCHAR(MAX) = N'
{  
   "Employee":[  
      {  
         "EmpID":"S0005",
         "EmpName":"오삼식",
         "Gender":"M",
         "DeptName":"영업",
         "RetireDate":"2015-01-31"
      },
      {  
         "EmpID":"S0006",
         "EmpName":"김치국",
         "Gender":"M",
         "DeptName":"인사"
      }
   ]
}'
SELECT JSON_QUERY(@json, 'strict $.Employee[1]')
GO

-- 결과
/*
{  
   "EmpID":"S0006",
   "EmpName":"김치국",
   "Gender":"M",
   "DeptName":"인사"
}
*/