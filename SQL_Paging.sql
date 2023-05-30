USE [CENTERO-1]

declare @page int = 3;

SELECT TOP(20) *
	FROM (
		SELECT TOP(242)
			ROW_NUMBER() OVER(ORDER BY Code_ID ASC) AS 'Row_Num'
			, Code_ID, Code_KOR_NM, Code_ENG_NM
			FROM TB_CMM_CODE
			WHERE Parent_Code_ID = 'Country_CD'
	)AS Temp
	WHERE Row_Num >= ((@page-1)*20)+1