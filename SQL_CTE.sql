use [CENTERO-1]

--declare @CMT_Category   NVARCHAR(50)	= N'CTR_NEWS'
--	,@CMT_Category_DIV	NVARCHAR(50)	= N'CTR_NEWS'
--	,@CMT_Category_SEQ	NVARCHAR(50)	= 16
--	,@PAGE_NUMBER		INT				= 1		


DECLARE @ROW_COUNT	INT	= 30

--DROP TABLE #TEMP_CMT
-- TB_CMM_COMMENT�κ��� �����͸� ������ #TEMP_CMT �ӽ����̺� ��´�
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
	-- ���� ������ ����.
	ORDER BY [Update_DT] ASC
	-- �ǳʶ� ���� �� ����. 1���� ������.
	OFFSET	0 ROWS
	-- �� �������� (@PAGE_NUMBER * @ROW_COUNT) ������ŭ ���� ������.
	FETCH NEXT (@PAGE_NUMBER * @ROW_COUNT) ROWS ONLY

--SELECT * FROM #TEMP_CMT

declare @CMT_Category   NVARCHAR(50)	= N'CTR_NEWS'
	,@CMT_Category_DIV	NVARCHAR(50)	= N'CTR_NEWS'
	,@CMT_Category_SEQ	NVARCHAR(50)	= 16
	,@PAGE_NUMBER		INT				= 1	

	-- CTE��� ���� �÷���
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
	-- AS ���������� ������ CTE�� ��´�.
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
				-- 0�� (8 - CMT_SEQ ����)����ŭ �ݺ��ϰ�, CMT_SEQ�� VARCHAR�� ĳ��Ʈ�� �̾����. �÷����� Sorting
				,REPLICATE('0', 8 - LEN([CMT_SEQ])) + CAST([CMT_SEQ] AS VARCHAR) AS Sorting
				-- �÷��� LVL��, �������� 0�� ����
				,0	AS LVL
				-- (10000000000000000 - CMT_SEQ)�� VARCHAR�� ����Ʈ��. �÷����� S_Sort
				,CONVERT(VARCHAR(MAX), (10000000000000000 - [CMT_SEQ])) AS S_Sort
		FROM	#TEMP_CMT
		WHERE	[CMT_Category]		= @CMT_Category
		AND		[CMT_Category_DIV]	= @CMT_Category_DIV
		AND		[CMT_Category_SEQ]	= @CMT_Category_SEQ
		
		--------------------------------------------------------------------------------------
		-- �ߺ����� ���� ��ġ�µ�, Anchor Member�� �켱 CMT_CTE�� ���
		UNION ALL
		-- Recursive Member ------------------------------------------------------------------
		-- �켱 ��� CTE(B) �����͸� ���� ��͸� ������
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
		-- CMT_SEQ�� TB_CMM_COMMENT�� CMT_Parent_SEQ�� ���� ���� �������� ���ǿ� �´� �ุ ������ ������.
		INNER JOIN CMT_CTE AS B	ON B.[CMT_SEQ] = A.[CMT_Parent_SEQ]
		WHERE	A.[CMT_Category]		= @CMT_Category
		AND		A.[CMT_Category_DIV]	= @CMT_Category_DIV
		AND		A.[CMT_Category_SEQ]	= @CMT_Category_SEQ
		---------------------------------------------------------------------------------------------------
	)
	-- ������� CMT_CTE�� Ȱ���� ����Ʈ �ؿ�
	SELECT CTE.[CMT_SEQ]
			,CTE.[CMT_Parent_SEQ]
			,CTE.[CMT_Category]
			,CTE.[CMT_Category_DIV]
			,CTE.[CMT_Category_SEQ]
			-- CTE.[Deleted_YN]�� 'N'�̸� CTE.[CMT_Contents]����, �ƴ϶�� 'Data deleted'���� ����. �÷����� CMT_Contents
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
	-- 1��. CTE�� TB_ACT_ACCOUNT�� INNER JOIN �ϰ�, = A
	INNER JOIN	[dbo].[TB_ACT_ACCOUNT] AS ACT ON	ACT.[Account_ID] = CTE.[Create_ID]
	-- 3��. A�� B�� LEFT JOIN ��
	LEFT JOIN	(
					-- 2��. CTE�� TB_ACT_ACCOUNT�� INNER JOIN �� = B
					SELECT	C.CMT_SEQ
							,C.Create_ID
							,A.ORG_Name
					FROM	CMT_CTE AS C
					INNER JOIN [dbo].[TB_ACT_ACCOUNT] AS A ON A.Account_ID = C.Create_ID
					WHERE	C.LVL > 0 
					
	) AS LVL3	ON LVL3.CMT_SEQ = CTE.CMT_Parent_SEQ
	--ORDER BY Sorting
	ORDER BY S_Sort  ASC