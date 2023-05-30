use [CENTERO-1]

--declare @CMT_Category   NVARCHAR(50)	= N'CTR_NEWS'
--	,@CMT_Category_DIV	NVARCHAR(50)	= N'CTR_NEWS'
--	,@CMT_Category_SEQ	NVARCHAR(50)	= 16
--	,@PAGE_NUMBER		INT				= 1		


DECLARE @ROW_COUNT	INT	= 30

--DROP TABLE #TEMP_CMT
-- TB_CMM_COMMENT로부터 데이터를 가져와 #TEMP_CMT 임시테이블에 담는다
SELECT	[CMT_SEQ]
			,[CMT_Parent_SEQ]
			,[CMT_Category]
			,[CMT_Category_DIV]
			,[CMT_Category_SEQ]
			,[CMT_Contents]
			,[Deleted_YN]
			,[Create_ID]
			,[Create_DT]
			,[Update_ID]
			,[Update_DT]
			,REPLICATE('0', 8 - LEN([CMT_SEQ])) + CAST([CMT_SEQ] AS VARCHAR) AS Sorting
			,0	AS LVL
	INTO	#TEMP_CMT
	FROM	[dbo].[TB_CMM_COMMENT]
	WHERE	[CMT_Category]		= @CMT_Category
	AND		[CMT_Category_DIV]	= @CMT_Category_DIV
	AND		[CMT_Category_SEQ]	= @CMT_Category_SEQ
	AND		[CMT_Parent_SEQ] IS NULL
	-- OFFSET-FETCH
	-- 정렬 기준을 정함.
	ORDER BY [Update_DT] ASC
	-- 건너뛸 행의 수 없음. 1부터 가져옴.
	OFFSET	0 ROWS
	-- 한 페이지에 (@PAGE_NUMBER * @ROW_COUNT) 갯수만큼 행을 가져옴.
	FETCH NEXT (@PAGE_NUMBER * @ROW_COUNT) ROWS ONLY

--SELECT * FROM #TEMP_CMT

declare @CMT_Category   NVARCHAR(50)	= N'CTR_NEWS'
	,@CMT_Category_DIV	NVARCHAR(50)	= N'CTR_NEWS'
	,@CMT_Category_SEQ	NVARCHAR(50)	= 16
	,@PAGE_NUMBER		INT				= 1	

	-- CTE명과 만들 컬럼명
;WITH CMT_CTE (
		[CMT_SEQ]
		,[CMT_Parent_SEQ]
		,[CMT_Category]
		,[CMT_Category_DIV]
		,[CMT_Category_SEQ]
		,[CMT_Contents]
		,[Deleted_YN]
		,[Create_ID]
		,[Create_DT]
		,[Update_ID]
		,[Update_DT]
		,Sorting
		,LVL
		,S_Sort
	)
	-- AS 하위쿼리의 내용을 CTE에 담는다.
	AS 
	(
		-- Anchor Member ----------------------------------------------------------------
		SELECT	[CMT_SEQ]
				,[CMT_Parent_SEQ]
				,[CMT_Category]
				,[CMT_Category_DIV]
				,[CMT_Category_SEQ]
				,[CMT_Contents]
				,[Deleted_YN]
				,[Create_ID]
				,[Create_DT]
				,[Update_ID]
				,[Update_DT]
				-- 0을 (8 - CMT_SEQ 길이)번만큼 반복하고, CMT_SEQ를 VARCHAR로 캐스트해 이어붙임. 컬럼명은 Sorting
				,REPLICATE('0', 8 - LEN([CMT_SEQ])) + CAST([CMT_SEQ] AS VARCHAR) AS Sorting
				-- 컬럼명 LVL로, 데이터은 0을 넣음
				,0	AS LVL
				-- (10000000000000000 - CMT_SEQ)를 VARCHAR로 컨버트함. 컬럼명은 S_Sort
				,CONVERT(VARCHAR(MAX), (10000000000000000 - [CMT_SEQ])) AS S_Sort
		FROM	#TEMP_CMT
		WHERE	[CMT_Category]		= @CMT_Category
		AND		[CMT_Category_DIV]	= @CMT_Category_DIV
		AND		[CMT_Category_SEQ]	= @CMT_Category_SEQ
		
		--------------------------------------------------------------------------------------
		-- 중복제거 없이 합치는데, Anchor Member가 우선 CMT_CTE에 담김
		UNION ALL
		-- Recursive Member ------------------------------------------------------------------
		-- 우선 담긴 CTE(B) 데이터를 토대로 재귀를 시작함
		SELECT	A.[CMT_SEQ]
				,A.[CMT_Parent_SEQ]
				,A.[CMT_Category]
				,A.[CMT_Category_DIV]
				,A.[CMT_Category_SEQ]
				,A.[CMT_Contents]
				,A.[Deleted_YN]
				,A.[Create_ID]
				,A.[Create_DT]
				,A.[Update_ID]
				,A.[Update_DT]
				,B.Sorting + '|' + REPLICATE('0', 8 - LEN(A.[CMT_SEQ])) + CAST(A.[CMT_SEQ] AS VARCHAR) AS Sorting
				,B.LVL+1	AS LVL
				,CONVERT(VARCHAR(MAX),B.S_Sort)+'|100' + CONVERT(VARCHAR(MAX), A.[CMT_SEQ]) AS S_Sort
		FROM	[dbo].[TB_CMM_COMMENT] AS A
		-- CMT_SEQ가 TB_CMM_COMMENT의 CMT_Parent_SEQ와 같은 것을 기준으로 조건에 맞는 행만 가져와 조인함.
		INNER JOIN CMT_CTE AS B	ON B.[CMT_SEQ] = A.[CMT_Parent_SEQ]
		WHERE	A.[CMT_Category]		= @CMT_Category
		AND		A.[CMT_Category_DIV]	= @CMT_Category_DIV
		AND		A.[CMT_Category_SEQ]	= @CMT_Category_SEQ
		---------------------------------------------------------------------------------------------------
	)
	-- 만들어진 CMT_CTE를 활용해 셀렉트 해옴
	SELECT CTE.[CMT_SEQ]
			,CTE.[CMT_Parent_SEQ]
			,CTE.[CMT_Category]
			,CTE.[CMT_Category_DIV]
			,CTE.[CMT_Category_SEQ]
			-- CTE.[Deleted_YN]가 'N'이면 CTE.[CMT_Contents]값을, 아니라면 'Data deleted'값을 넣음. 컬럼명은 CMT_Contents
			,CASE WHEN CTE.[Deleted_YN] = 'N' THEN CTE.[CMT_Contents] ELSE 'Data deleted' END AS [CMT_Contents]
			,CTE.[Deleted_YN]
			,CTE.[Create_ID]
			,ACT.[ORG_Name]	AS Create_NM
			,CTE.[Create_DT]
			,CTE.[Update_ID]
			,CTE.[Update_DT]
			,CTE.Sorting
			,CTE.LVL
			,LVL3.ORG_Name AS 'Reply_NM'
			,CTE.S_Sort
	FROM	CMT_CTE AS CTE
	-- 1번. CTE와 TB_ACT_ACCOUNT을 INNER JOIN 하고, = A
	INNER JOIN	[dbo].[TB_ACT_ACCOUNT] AS ACT ON	ACT.[Account_ID] = CTE.[Create_ID]
	-- 3번. A와 B를 LEFT JOIN 함
	LEFT JOIN	(
					-- 2번. CTE와 TB_ACT_ACCOUNT를 INNER JOIN 함 = B
					SELECT	C.CMT_SEQ
							,C.Create_ID
							,A.ORG_Name
					FROM	CMT_CTE AS C
					INNER JOIN [dbo].[TB_ACT_ACCOUNT] AS A ON A.Account_ID = C.Create_ID
					WHERE	C.LVL > 0 
					
	) AS LVL3	ON LVL3.CMT_SEQ = CTE.CMT_Parent_SEQ
	--ORDER BY Sorting
	ORDER BY S_Sort  ASC