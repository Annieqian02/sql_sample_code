EXEC (@TSQL2)

/*****************************************************/
UPDATE EF
SET 
[AttributeName]	=EFS.[AttributeName]	
,[Lot]			=EFS.[Lot]			
,[Part]			=EFS.[Part]			
,[AcknowledgedBy]=EFS.[AcknowledgedBy]
,[Severity]		=EFS.[Severity]		
,[IsAnnotated]	=EFS.[IsAnnotated]	
,[Status]		=EFS.[Status]		
,[Modified]		=EFS.[Modified]		
FROM [G7_SPC].[dbo].[MT26560_EF] EF
INNER JOIN [G7_SPC].[dbo].[MT26560_EF_Staging] EFS
ON EF.ID=EFS.ID

/*****************************************************/
DELETE  EFS
FROM [G7_SPC].[dbo].[MT26560_EF_Staging] EFS
INNER JOIN [G7_SPC].[dbo].[MT26560_EF] EF
ON EFS.ID=EF.ID 
/*****************************************************/
INSERT INTO [G7_SPC].[dbo].[MT26560_EF]
(ID,[AttributeName],[Lot],[Part],[AcknowledgedBy],[Severity],[IsAnnotated],[Status],[Modified])
SELECT ID
	  ,[AttributeName]
      ,[Lot]			
      ,[Part]			
      ,[AcknowledgedBy]
      ,[Severity]		
      ,[IsAnnotated]	
      ,[Status]		
      ,[Modified]	
  FROM [G7_SPC].[dbo].[MT26560_EF_Staging] EFS
  WHERE NOT EXISTS (SELECT * FROM [G7_SPC].[dbo].[MT26560_EF] EF
	WHERE ISNULL(EFS.ID,'00000000-0000-0000-0000-000000000000')=ISNULL(EF.ID,'00000000-0000-0000-0000-000000000000'))
/*****************************************************/
TRUNCATE TABLE [G7_SPC].[dbo].[MT26560_EF_Staging]
/*****************************************************/

truncate table [G7_SPC].[dbo].[MT26560_Staging]
--SELECT * FROM [G7_SPC].[dbo].[MT26560_Archive_Staging]
/*********************/
;WITH AttributePivotTable AS
(SELECT * FROM [G7_SPC].[dbo].[MT26560_Archive_Staging]),
AttributePivotTable2 AS
(SELECT * FROM [G7_SPC].[dbo].[MT26560_EF]),
AttributePivotTable3 AS
(
SELECT Part,Lot,Max([Status]) as Lot_Status
FROM
	(
		SELECT * from AttributePivotTable2
	)L
Group by Part,Lot
),
AttributePivotTable4 AS
(
SELECT Part,Max([Status]) as Part_Status
FROM
	(
		SELECT * from AttributePivotTable2
	)P
Group by Part
),
/******/
--select * from AttributePivotTable
--select * from AttributePivotTable2
--select * from AttributePivotTable3
--select * from AttributePivotTable4
/*****/
AttributePivotTable5 AS
(
SELECT A1.*,
/**Mean+1sigma**/
CASE WHEN		CONVERT(DECIMAL(7,5),(CONVERT(float,REPLACE(REPLACE(A1.[C03_01 Average],'Set to Bad','0'),'Calc Failed','0')))+CONVERT(DECIMAL(7,5),CONVERT(float,REPLACE(REPLACE(A1.[C03_01 Standard Deviation],'Set to Bad','0'),'Calc Failed','0')))) = 0
	THEN NULL 
	ELSE		CONVERT(DECIMAL(7,5),(CONVERT(float,REPLACE(REPLACE(A1.[C03_01 Average],'Set to Bad','0'),'Calc Failed','0')))+CONVERT(DECIMAL(7,5),CONVERT(float,REPLACE(REPLACE(A1.[C03_01 Standard Deviation],'Set to Bad','0'),'Calc Failed','0')))) END
AS [C03_01_p1StdDev],
/******************************************************/
CASE WHEN		CONVERT(DECIMAL(7,5),(CONVERT(float,REPLACE(REPLACE(A1.[C03_02 Average],'Set to Bad','0'),'Calc Failed','0')))+CONVERT(DECIMAL(7,5),CONVERT(float,REPLACE(REPLACE(A1.[C03_02 Standard Deviation],'Set to Bad','0'),'Calc Failed','0')))) = 0 
	THEN NULL 
	ELSE	CONVERT(DECIMAL(7,5),(CONVERT(float,REPLACE(REPLACE(A1.[C03_02 Average],'Set to Bad','0'),'Calc Failed','0')))+CONVERT(DECIMAL(7,5),CONVERT(float,REPLACE(REPLACE(A1.[C03_02 Standard Deviation],'Set to Bad','0'),'Calc Failed','0'))))  END
AS [C03_02_p1StdDev],
/******************************************************/
CASE WHEN		CONVERT(DECIMAL(7,5),(CONVERT(float,REPLACE(REPLACE(A1.[C03_03 Average],'Set to Bad','0'),'Calc Failed','0')))+CONVERT(DECIMAL(7,5),CONVERT(float,REPLACE(REPLACE(A1.[C03_03 Standard Deviation],'Set to Bad','0'),'Calc Failed','0')))) = 0
	THEN NULL 
	ELSE		CONVERT(DECIMAL(7,5),(CONVERT(float,REPLACE(REPLACE(A1.[C03_03 Average],'Set to Bad','0'),'Calc Failed','0')))+CONVERT(DECIMAL(7,5),CONVERT(float,REPLACE(REPLACE(A1.[C03_03 Standard Deviation],'Set to Bad','0'),'Calc Failed','0')))) END
AS [C03_03_p1StdDev],
/******************************************************/
CASE WHEN		CONVERT(DECIMAL(7,5),(CONVERT(float,REPLACE(REPLACE(A1.[C03_04 Average],'Set to Bad','0'),'Calc Failed','0'))))+CONVERT(DECIMAL(7,5),(CONVERT(float,REPLACE(REPLACE(A1.[C03_04 Standard Deviation],'Set to Bad','0'),'Calc Failed','0')))) = 0 
	THEN NULL 
	ELSE	CONVERT(DECIMAL(7,5),(CONVERT(float,REPLACE(REPLACE(A1.[C03_04 Average],'Set to Bad','0'),'Calc Failed','0'))))+CONVERT(DECIMAL(7,5),(CONVERT(float,REPLACE(REPLACE(A1.[C03_04 Standard Deviation],'Set to Bad','0'),'Calc Failed','0'))))  END
AS [C03_04_p1StdDev],
/******************************************************/
CASE WHEN		CONVERT(DECIMAL(7,5),(CONVERT(float,REPLACE(REPLACE(A1.[C07 Average],'Set to Bad','0'),'Calc Failed','0'))))+CONVERT(DECIMAL(7,5),(CONVERT(float,REPLACE(REPLACE(A1.[C07 Standard Deviation],'Set to Bad','0'),'Calc Failed','0')))) = 0 
	THEN NULL 
	ELSE	CONVERT(DECIMAL(7,5),(CONVERT(float,REPLACE(REPLACE(A1.[C07 Average],'Set to Bad','0'),'Calc Failed','0'))))+CONVERT(DECIMAL(7,5),(CONVERT(float,REPLACE(REPLACE(A1.[C07 Standard Deviation],'Set to Bad','0'),'Calc Failed','0'))))  END
AS [C07_p1StdDev],
/******************************************************/
CASE WHEN		CONVERT(DECIMAL(7,5),(CONVERT(float,REPLACE(REPLACE(A1.[C16 Average],'Set to Bad','0'),'Calc Failed','0')))+CONVERT(DECIMAL(7,5),CONVERT(float,REPLACE(REPLACE(A1.[C16 Standard Deviation],'Set to Bad','0'),'Calc Failed','0')))) = 0
	THEN NULL 
	ELSE		CONVERT(DECIMAL(7,5),(CONVERT(float,REPLACE(REPLACE(A1.[C16 Average],'Set to Bad','0'),'Calc Failed','0')))+CONVERT(DECIMAL(7,5),CONVERT(float,REPLACE(REPLACE(A1.[C16 Standard Deviation],'Set to Bad','0'),'Calc Failed','0')))) END
AS [C16_p1StdDev],
/******************************************************/
CASE WHEN		CONVERT(DECIMAL(7,5),(CONVERT(float,REPLACE(REPLACE(A1.[C17 Average],'Set to Bad','0'),'Calc Failed','0')))+CONVERT(DECIMAL(7,5),CONVERT(float,REPLACE(REPLACE(A1.[C17 Standard Deviation],'Set to Bad','0'),'Calc Failed','0')))) = 0 
	THEN NULL 
	ELSE	CONVERT(DECIMAL(7,5),(CONVERT(float,REPLACE(REPLACE(A1.[C17 Average],'Set to Bad','0'),'Calc Failed','0')))+CONVERT(DECIMAL(7,5),CONVERT(float,REPLACE(REPLACE(A1.[C17 Standard Deviation],'Set to Bad','0'),'Calc Failed','0'))))  END
AS [C17_p1StdDev],
/******************************************************/
--/**Mean-1sigma**/
CASE WHEN		CONVERT(DECIMAL(7,5),(CONVERT(float,REPLACE(REPLACE(A1.[C03_01 Average],'Set to Bad','0'),'Calc Failed','0'))))-CONVERT(DECIMAL(7,5),(CONVERT(float,REPLACE(REPLACE(A1.[C03_01 Standard Deviation],'Set to Bad','0'),'Calc Failed','0')))) =0 
	THEN NULL 
	ELSE		CONVERT(DECIMAL(7,5),(CONVERT(float,REPLACE(REPLACE(A1.[C03_01 Average],'Set to Bad','0'),'Calc Failed','0'))))-CONVERT(DECIMAL(7,5),(CONVERT(float,REPLACE(REPLACE(A1.[C03_01 Standard Deviation],'Set to Bad','0'),'Calc Failed','0')))) END
AS [C03_01_n1StdDev],
/******************************************************/
CASE WHEN		CONVERT(DECIMAL(7,5),(CONVERT(float,REPLACE(REPLACE(A1.[C03_02 Average],'Set to Bad','0'),'Calc Failed','0'))))-CONVERT(DECIMAL(7,5),(CONVERT(float,REPLACE(REPLACE(A1.[C03_02 Standard Deviation],'Set to Bad','0'),'Calc Failed','0'))))  = 0
	THEN NULL 
	ELSE		CONVERT(DECIMAL(7,5),(CONVERT(float,REPLACE(REPLACE(A1.[C03_02 Average],'Set to Bad','0'),'Calc Failed','0'))))-CONVERT(DECIMAL(7,5),(CONVERT(float,REPLACE(REPLACE(A1.[C03_02 Standard Deviation],'Set to Bad','0'),'Calc Failed','0'))))  END
AS [C03_02_n1StdDev],
/******************************************************/
CASE WHEN		CONVERT(DECIMAL(7,5),(CONVERT(float,REPLACE(REPLACE(A1.[C03_03 Average],'Set to Bad','0'),'Calc Failed','0')))-CONVERT(DECIMAL(7,5),CONVERT(float,REPLACE(REPLACE(A1.[C03_03 Standard Deviation],'Set to Bad','0'),'Calc Failed','0')))) =0 
	THEN NULL 
	ELSE		CONVERT(DECIMAL(7,5),(CONVERT(float,REPLACE(REPLACE(A1.[C03_03 Average],'Set to Bad','0'),'Calc Failed','0')))-CONVERT(DECIMAL(7,5),CONVERT(float,REPLACE(REPLACE(A1.[C03_03 Standard Deviation],'Set to Bad','0'),'Calc Failed','0')))) END
AS [C03_03_n1StdDev],
/******************************************************/
CASE WHEN		CONVERT(DECIMAL(7,5),(CONVERT(float,REPLACE(REPLACE(A1.[C03_04 Average],'Set to Bad','0'),'Calc Failed','0'))))-CONVERT(DECIMAL(7,5),(CONVERT(float,REPLACE(REPLACE(A1.[C03_04 Standard Deviation],'Set to Bad','0'),'Calc Failed','0'))))  = 0
	THEN NULL 
	ELSE		CONVERT(DECIMAL(7,5),(CONVERT(float,REPLACE(REPLACE(A1.[C03_04 Average],'Set to Bad','0'),'Calc Failed','0'))))-CONVERT(DECIMAL(7,5),(CONVERT(float,REPLACE(REPLACE(A1.[C03_04 Standard Deviation],'Set to Bad','0'),'Calc Failed','0'))))  END
AS [C03_04_n1StdDev],
/******************************************************/
CASE WHEN		CONVERT(DECIMAL(7,5),(CONVERT(float,REPLACE(REPLACE(A1.[C07 Average],'Set to Bad','0'),'Calc Failed','0'))))-CONVERT(DECIMAL(7,5),(CONVERT(float,REPLACE(REPLACE(A1.[C07 Standard Deviation],'Set to Bad','0'),'Calc Failed','0'))))  = 0
	THEN NULL 
	ELSE		CONVERT(DECIMAL(7,5),(CONVERT(float,REPLACE(REPLACE(A1.[C07 Average],'Set to Bad','0'),'Calc Failed','0'))))-CONVERT(DECIMAL(7,5),(CONVERT(float,REPLACE(REPLACE(A1.[C07 Standard Deviation],'Set to Bad','0'),'Calc Failed','0'))))  END
AS [C07_n1StdDev],
/******************************************************/
CASE WHEN		CONVERT(DECIMAL(7,5),(CONVERT(float,REPLACE(REPLACE(A1.[C16 Average],'Set to Bad','0'),'Calc Failed','0'))))-CONVERT(DECIMAL(7,5),(CONVERT(float,REPLACE(REPLACE(A1.[C16 Standard Deviation],'Set to Bad','0'),'Calc Failed','0')))) =0 
	THEN NULL 
	ELSE		CONVERT(DECIMAL(7,5),(CONVERT(float,REPLACE(REPLACE(A1.[C16 Average],'Set to Bad','0'),'Calc Failed','0'))))-CONVERT(DECIMAL(7,5),(CONVERT(float,REPLACE(REPLACE(A1.[C16 Standard Deviation],'Set to Bad','0'),'Calc Failed','0')))) END
AS [C16_n1StdDev],
/******************************************************/
CASE WHEN		CONVERT(DECIMAL(7,5),(CONVERT(float,REPLACE(REPLACE(A1.[C17 Average],'Set to Bad','0'),'Calc Failed','0'))))-CONVERT(DECIMAL(7,5),(CONVERT(float,REPLACE(REPLACE(A1.[C17 Standard Deviation],'Set to Bad','0'),'Calc Failed','0'))))  = 0
	THEN NULL 
	ELSE		CONVERT(DECIMAL(7,5),(CONVERT(float,REPLACE(REPLACE(A1.[C17 Average],'Set to Bad','0'),'Calc Failed','0'))))-CONVERT(DECIMAL(7,5),(CONVERT(float,REPLACE(REPLACE(A1.[C17 Standard Deviation],'Set to Bad','0'),'Calc Failed','0'))))  END
AS [C17_n1StdDev],
/******************************************************/
--/**Mean+2sigma**/
CASE WHEN		CONVERT(DECIMAL(7,5),(CONVERT(float,REPLACE(REPLACE(A1.[C03_01 Average],'Set to Bad','0'),'Calc Failed','0'))))+(2*CONVERT(DECIMAL(7,5),(CONVERT(float,REPLACE(REPLACE(A1.[C03_01 Standard Deviation],'Set to Bad','0'),'Calc Failed','0'))))) =0
	THEN NULL 
	ELSE		CONVERT(DECIMAL(7,5),(CONVERT(float,REPLACE(REPLACE(A1.[C03_01 Average],'Set to Bad','0'),'Calc Failed','0'))))+(2*CONVERT(DECIMAL(7,5),(CONVERT(float,REPLACE(REPLACE(A1.[C03_01 Standard Deviation],'Set to Bad','0'),'Calc Failed','0')))))  END
AS [C03_01_p2StdDev],
/******************************************************/
CASE WHEN		CONVERT(DECIMAL(7,5),(CONVERT(float,REPLACE(REPLACE(A1.[C03_02 Average],'Set to Bad','0'),'Calc Failed','0'))))+(2*CONVERT(DECIMAL(7,5),(CONVERT(float,REPLACE(REPLACE(A1.[C03_02 Standard Deviation],'Set to Bad','0'),'Calc Failed','0'))))) = 0  
	THEN NULL 
	ELSE		CONVERT(DECIMAL(7,5),(CONVERT(float,REPLACE(REPLACE(A1.[C03_02 Average],'Set to Bad','0'),'Calc Failed','0'))))+(2*CONVERT(DECIMAL(7,5),(CONVERT(float,REPLACE(REPLACE(A1.[C03_02 Standard Deviation],'Set to Bad','0'),'Calc Failed','0'))))) END
AS [C03_02_p2StdDev],
/******************************************************/
CASE WHEN		CONVERT(DECIMAL(7,5),(CONVERT(float,REPLACE(REPLACE(A1.[C03_03 Average],'Set to Bad','0'),'Calc Failed','0')))+(2*CONVERT(DECIMAL(7,5),CONVERT(float,REPLACE(REPLACE(A1.[C03_03 Standard Deviation],'Set to Bad','0'),'Calc Failed','0'))))) =0
	THEN NULL 
	ELSE		CONVERT(DECIMAL(7,5),(CONVERT(float,REPLACE(REPLACE(A1.[C03_03 Average],'Set to Bad','0'),'Calc Failed','0')))+(2*CONVERT(DECIMAL(7,5),CONVERT(float,REPLACE(REPLACE(A1.[C03_03 Standard Deviation],'Set to Bad','0'),'Calc Failed','0')))))  END
AS [C03_03_p2StdDev],
/******************************************************/
CASE WHEN		CONVERT(DECIMAL(7,5),(CONVERT(float,REPLACE(REPLACE(A1.[C03_04 Average],'Set to Bad','0'),'Calc Failed','0'))))+(2*CONVERT(DECIMAL(7,5),(CONVERT(float,REPLACE(REPLACE(A1.[C03_04 Standard Deviation],'Set to Bad','0'),'Calc Failed','0'))))) = 0  
	THEN NULL 
	ELSE		CONVERT(DECIMAL(7,5),(CONVERT(float,REPLACE(REPLACE(A1.[C03_04 Average],'Set to Bad','0'),'Calc Failed','0'))))+(2*CONVERT(DECIMAL(7,5),(CONVERT(float,REPLACE(REPLACE(A1.[C03_04 Standard Deviation],'Set to Bad','0'),'Calc Failed','0'))))) END
AS [C03_04_p2StdDev],
/******************************************************/
CASE WHEN		CONVERT(DECIMAL(7,5),(CONVERT(float,REPLACE(REPLACE(A1.[C07 Average],'Set to Bad','0'),'Calc Failed','0'))))+(2*CONVERT(DECIMAL(7,5),(CONVERT(float,REPLACE(REPLACE(A1.[C07 Standard Deviation],'Set to Bad','0'),'Calc Failed','0'))))) = 0  
	THEN NULL 
	ELSE		CONVERT(DECIMAL(7,5),(CONVERT(float,REPLACE(REPLACE(A1.[C07 Average],'Set to Bad','0'),'Calc Failed','0'))))+(2*CONVERT(DECIMAL(7,5),(CONVERT(float,REPLACE(REPLACE(A1.[C07 Standard Deviation],'Set to Bad','0'),'Calc Failed','0'))))) END
AS [C07_p2StdDev],
/******************************************************/
CASE WHEN		CONVERT(DECIMAL(7,5),(CONVERT(float,REPLACE(REPLACE(A1.[C16 Average],'Set to Bad','0'),'Calc Failed','0'))))+(2*CONVERT(DECIMAL(7,5),(CONVERT(float,REPLACE(REPLACE(A1.[C16 Standard Deviation],'Set to Bad','0'),'Calc Failed','0'))))) =0
	THEN NULL 
	ELSE		CONVERT(DECIMAL(7,5),(CONVERT(float,REPLACE(REPLACE(A1.[C16 Average],'Set to Bad','0'),'Calc Failed','0'))))+(2*CONVERT(DECIMAL(7,5),(CONVERT(float,REPLACE(REPLACE(A1.[C16 Standard Deviation],'Set to Bad','0'),'Calc Failed','0')))))  END
AS [C16_p2StdDev],
/******************************************************/
CASE WHEN		CONVERT(DECIMAL(7,5),(CONVERT(float,REPLACE(REPLACE(A1.[C17 Average],'Set to Bad','0'),'Calc Failed','0'))))+(2*CONVERT(DECIMAL(7,5),(CONVERT(float,REPLACE(REPLACE(A1.[C17 Standard Deviation],'Set to Bad','0'),'Calc Failed','0'))))) = 0  
	THEN NULL 
	ELSE		CONVERT(DECIMAL(7,5),(CONVERT(float,REPLACE(REPLACE(A1.[C17 Average],'Set to Bad','0'),'Calc Failed','0'))))+(2*CONVERT(DECIMAL(7,5),(CONVERT(float,REPLACE(REPLACE(A1.[C17 Standard Deviation],'Set to Bad','0'),'Calc Failed','0'))))) END
AS [C17_p2StdDev],
/******************************************************/
--/**Mean-2sigma**/
CASE WHEN		CONVERT(DECIMAL(7,5),(CONVERT(float,REPLACE(REPLACE(A1.[C03_01 Average],'Set to Bad','0'),'Calc Failed','0'))))-(2*CONVERT(DECIMAL(7,5),(CONVERT(float,REPLACE(REPLACE(A1.[C03_01 Standard Deviation],'Set to Bad','0'),'Calc Failed','0'))))) = 0 
	THEN NULL 
	ELSE		CONVERT(DECIMAL(7,5),(CONVERT(float,REPLACE(REPLACE(A1.[C03_01 Average],'Set to Bad','0'),'Calc Failed','0'))))-(2*CONVERT(DECIMAL(7,5),(CONVERT(float,REPLACE(REPLACE(A1.[C03_01 Standard Deviation],'Set to Bad','0'),'Calc Failed','0'))))) END
AS [C03_01_n2StdDev],
/******************************************************/
CASE WHEN		CONVERT(DECIMAL(7,5),(CONVERT(float,REPLACE(REPLACE(A1.[C03_02 Average],'Set to Bad','0'),'Calc Failed','0'))))-(2*CONVERT(DECIMAL(7,5),(CONVERT(float,REPLACE(REPLACE(A1.[C03_02 Standard Deviation],'Set to Bad','0'),'Calc Failed','0'))))) = 0 
	THEN NULL 
	ELSE	CONVERT(DECIMAL(7,5),(CONVERT(float,REPLACE(REPLACE(A1.[C03_02 Average],'Set to Bad','0'),'Calc Failed','0'))))-(2*CONVERT(DECIMAL(7,5),(CONVERT(float,REPLACE(REPLACE(A1.[C03_02 Standard Deviation],'Set to Bad','0'),'Calc Failed','0'))))) END	
AS [C03_02_n2StdDev],
/******************************************************/
CASE WHEN		CONVERT(DECIMAL(7,5),(CONVERT(float,REPLACE(REPLACE(A1.[C03_03 Average],'Set to Bad','0'),'Calc Failed','0')))-(2*CONVERT(DECIMAL(7,5),CONVERT(float,REPLACE(REPLACE(A1.[C03_03 Standard Deviation],'Set to Bad','0'),'Calc Failed','0'))))) = 0 
	THEN NULL 
	ELSE		CONVERT(DECIMAL(7,5),(CONVERT(float,REPLACE(REPLACE(A1.[C03_03 Average],'Set to Bad','0'),'Calc Failed','0')))-(2*CONVERT(DECIMAL(7,5),CONVERT(float,REPLACE(REPLACE(A1.[C03_03 Standard Deviation],'Set to Bad','0'),'Calc Failed','0'))))) END
AS [C03_03_n2StdDev],
/******************************************************/
CASE WHEN		CONVERT(DECIMAL(7,5),(CONVERT(float,REPLACE(REPLACE(A1.[C03_04 Average],'Set to Bad','0'),'Calc Failed','0'))))-(2*CONVERT(DECIMAL(7,5),(CONVERT(float,REPLACE(REPLACE(A1.[C03_04 Standard Deviation],'Set to Bad','0'),'Calc Failed','0'))))) = 0 
	THEN NULL 
	ELSE	CONVERT(DECIMAL(7,5),(CONVERT(float,REPLACE(REPLACE(A1.[C03_04 Average],'Set to Bad','0'),'Calc Failed','0'))))-(2*CONVERT(DECIMAL(7,5),(CONVERT(float,REPLACE(REPLACE(A1.[C03_04 Standard Deviation],'Set to Bad','0'),'Calc Failed','0'))))) END	
AS [C03_04_n2StdDev],
/******************************************************/
CASE WHEN		CONVERT(DECIMAL(7,5),(CONVERT(float,REPLACE(REPLACE(A1.[C07 Average],'Set to Bad','0'),'Calc Failed','0'))))-(2*CONVERT(DECIMAL(7,5),(CONVERT(float,REPLACE(REPLACE(A1.[C07 Standard Deviation],'Set to Bad','0'),'Calc Failed','0'))))) = 0 
	THEN NULL 
	ELSE	CONVERT(DECIMAL(7,5),(CONVERT(float,REPLACE(REPLACE(A1.[C07 Average],'Set to Bad','0'),'Calc Failed','0'))))-(2*CONVERT(DECIMAL(7,5),(CONVERT(float,REPLACE(REPLACE(A1.[C07 Standard Deviation],'Set to Bad','0'),'Calc Failed','0'))))) END	
AS [C07_n2StdDev],
/******************************************************/
CASE WHEN		CONVERT(DECIMAL(7,5),(CONVERT(float,REPLACE(REPLACE(A1.[C16 Average],'Set to Bad','0'),'Calc Failed','0'))))-(2*CONVERT(DECIMAL(7,5),(CONVERT(float,REPLACE(REPLACE(A1.[C16 Standard Deviation],'Set to Bad','0'),'Calc Failed','0'))))) = 0 
	THEN NULL 
	ELSE		CONVERT(DECIMAL(7,5),(CONVERT(float,REPLACE(REPLACE(A1.[C16 Average],'Set to Bad','0'),'Calc Failed','0'))))-(2*CONVERT(DECIMAL(7,5),(CONVERT(float,REPLACE(REPLACE(A1.[C16 Standard Deviation],'Set to Bad','0'),'Calc Failed','0'))))) END
AS [C16_n2StdDev],
/******************************************************/
CASE WHEN		CONVERT(DECIMAL(7,5),(CONVERT(float,REPLACE(REPLACE(A1.[C17 Average],'Set to Bad','0'),'Calc Failed','0'))))-(2*CONVERT(DECIMAL(7,5),(CONVERT(float,REPLACE(REPLACE(A1.[C17 Standard Deviation],'Set to Bad','0'),'Calc Failed','0'))))) = 0 
	THEN NULL 
	ELSE	CONVERT(DECIMAL(7,5),(CONVERT(float,REPLACE(REPLACE(A1.[C17 Average],'Set to Bad','0'),'Calc Failed','0'))))-(2*CONVERT(DECIMAL(7,5),(CONVERT(float,REPLACE(REPLACE(A1.[C17 Standard Deviation],'Set to Bad','0'),'Calc Failed','0'))))) END	
AS [C17_n2StdDev],
/******************************************************/
CASE	WHEN A4.Part_Status =1 THEN 'Green'
		WHEN A4.Part_Status =2 THEN 'Orange'
		WHEN A4.Part_Status =3 THEN 'Red'
		ELSE 'Green' END AS Part_Status,
CASE	WHEN A3.Lot_Status =1 THEN 'Green'
		WHEN A3.Lot_Status =2 THEN 'Orange'
		WHEN A3.Lot_Status =3 THEN 'Red'
		ELSE 'Green' END AS Lot_Status
FROM 
	(
	SELECT mcs, RK as [Sample], StartTimeStamp, D.PART, --A2.Lot as A2_Lot, A2.Part as A2_part,
	[Fixture] AS [Fixture], D.[Lot] AS [Lot], [Qualification Date],[C01] AS [C01], [C01 Historical Max] AS [C01 Historical Max], [C01 Historical Min] AS [C01 Historical Min], [C01_USL_X] AS [C01_USL], [C01_LSL_X] AS [C01_LSL], [C01_Target_X] AS [C01_Target], [C02] AS [C02], [C02 Historical Max] AS [C02 Historical Max], [C02 Historical Min] AS [C02 Historical Min], [C02_USL_X] AS [C02_USL], [C02_LSL_X] AS [C02_LSL], [C02_Target_X] AS [C02_Target], [C03_01] AS [C03_01], [C03_01 Historical Max] AS [C03_01 Historical Max], [C03_01 Historical Min] AS [C03_01 Historical Min], [C03_01_USL_X] AS [C03_01_USL], [C03_01_LSL_X] AS [C03_01_LSL], [C03_01_Target_X] AS [C03_01_Target], [C03_02] AS [C03_02], [C03_02 Historical Max] AS [C03_02 Historical Max], [C03_02 Historical Min] AS [C03_02 Historical Min], [C03_02_USL_X] AS [C03_02_USL], [C03_02_LSL_X] AS [C03_02_LSL], [C03_02_Target_X] AS [C03_02_Target], [C03_03] AS [C03_03], [C03_03 Historical Max] AS [C03_03 Historical Max], [C03_03 Historical Min] AS [C03_03 Historical Min], [C03_03_USL_X] AS [C03_03_USL], [C03_03_LSL_X] AS [C03_03_LSL], [C03_03_Target_X] AS [C03_03_Target], [C03_04] AS [C03_04], [C03_04 Historical Max] AS [C03_04 Historical Max], [C03_04 Historical Min] AS [C03_04 Historical Min], [C03_04_USL_X] AS [C03_04_USL], [C03_04_LSL_X] AS [C03_04_LSL], [C03_04_Target_X] AS [C03_04_Target], [C04] AS [C04], [C04 Historical Max] AS [C04 Historical Max], [C04 Historical Min] AS [C04 Historical Min], [C04_USL_X] AS [C04_USL], [C04_LSL_X] AS [C04_LSL], [C04_Target_X] AS [C04_Target], [C05] AS [C05], [C05 Historical Max] AS [C05 Historical Max], [C05 Historical Min] AS [C05 Historical Min], [C05_USL_X] AS [C05_USL], [C05_LSL_X] AS [C05_LSL], [C05_Target_X] AS [C05_Target], [C06] AS [C06], [C06 Historical Max] AS [C06 Historical Max], [C06 Historical Min] AS [C06 Historical Min], [C06_USL_X] AS [C06_USL], [C06_LSL_X] AS [C06_LSL], [C06_Target_X] AS [C06_Target], [C07] AS [C07], [C07 Historical Max] AS [C07 Historical Max], [C07 Historical Min] AS [C07 Historical Min], [C07_USL_X] AS [C07_USL], [C07_LSL_X] AS [C07_LSL], [C07_Target_X] AS [C07_Target], [C08] AS [C08], [C08 Historical Max] AS [C08 Historical Max], [C08 Historical Min] AS [C08 Historical Min], [C08_USL_X] AS [C08_USL], [C08_LSL_X] AS [C08_LSL], [C08_Target_X] AS [C08_Target], [C09] AS [C09], [C09 Historical Max] AS [C09 Historical Max], [C09 Historical Min] AS [C09 Historical Min], [C09_USL_X] AS [C09_USL], [C09_LSL_X] AS [C09_LSL], [C09_Target_X] AS [C09_Target], [C10] AS [C10], [C10 Historical Max] AS [C10 Historical Max], [C10 Historical Min] AS [C10 Historical Min], [C10_USL_X] AS [C10_USL], [C10_LSL_X] AS [C10_LSL], [C10_Target_X] AS [C10_Target], [C11] AS [C11], [C11 Historical Max] AS [C11 Historical Max], [C11 Historical Min] AS [C11 Historical Min], [C11_USL_X] AS [C11_USL], [C11_LSL_X] AS [C11_LSL], [C11_Target_X] AS [C11_Target], [C12] AS [C12], [C12 Historical Max] AS [C12 Historical Max], [C12 Historical Min] AS [C12 Historical Min], [C12_USL_X] AS [C12_USL], [C12_LSL_X] AS [C12_LSL], [C12_Target_X] AS [C12_Target], [C13] AS [C13], [C13 Historical Max] AS [C13 Historical Max], [C13 Historical Min] AS [C13 Historical Min], [C13_USL_X] AS [C13_USL], [C13_LSL_X] AS [C13_LSL], [C13_Target_X] AS [C13_Target], [C14] AS [C14], [C14 Historical Max] AS [C14 Historical Max], [C14 Historical Min] AS [C14 Historical Min], [C14_USL_X] AS [C14_USL], [C14_LSL_X] AS [C14_LSL], [C14_Target_X] AS [C14_Target], [C15] AS [C15], [C15 Historical Max] AS [C15 Historical Max], [C15 Historical Min] AS [C15 Historical Min], [C15_USL_X] AS [C15_USL], [C15_LSL_X] AS [C15_LSL], [C15_Target_X] AS [C15_Target], [C16] AS [C16], [C16 Historical Max] AS [C16 Historical Max], [C16 Historical Min] AS [C16 Historical Min], [C16_USL_X] AS [C16_USL], [C16_LSL_X] AS [C16_LSL], [C16_Target_X] AS [C16_Target], [C17] AS [C17], [C17 Historical Max] AS [C17 Historical Max], [C17 Historical Min] AS [C17 Historical Min], [C17_USL_X] AS [C17_USL], [C17_LSL_X] AS [C17_LSL], [C17_Target_X] AS [C17_Target], [C18_01] AS [C18_01], [C18_01 Historical Max] AS [C18_01 Historical Max], [C18_01 Historical Min] AS [C18_01 Historical Min], [C18_01_USL_X] AS [C18_01_USL], [C18_01_LSL_X] AS [C18_01_LSL], [C18_01_Target_X] AS [C18_01_Target], [C18_02] AS [C18_02], [C18_02 Historical Max] AS [C18_02 Historical Max], [C18_02 Historical Min] AS [C18_02 Historical Min], [C18_02_USL_X] AS [C18_02_USL], [C18_02_LSL_X] AS [C18_02_LSL], [C18_02_Target_X] AS [C18_02_Target], [C18_03] AS [C18_03], [C18_03 Historical Max] AS [C18_03 Historical Max], [C18_03 Historical Min] AS [C18_03 Historical Min], [C18_03_USL_X] AS [C18_03_USL], [C18_03_LSL_X] AS [C18_03_LSL], [C18_03_Target_X] AS [C18_03_Target], [C19_01] AS [C19_01], [C19_01 Historical Max] AS [C19_01 Historical Max], [C19_01 Historical Min] AS [C19_01 Historical Min], [C19_01_USL_X] AS [C19_01_USL], [C19_01_LSL_X] AS [C19_01_LSL], [C19_01_Target_X] AS [C19_01_Target], [C19_02] AS [C19_02], [C19_02 Historical Max] AS [C19_02 Historical Max], [C19_02 Historical Min] AS [C19_02 Historical Min], [C19_02_USL_X] AS [C19_02_USL], [C19_02_LSL_X] AS [C19_02_LSL], [C19_02_Target_X] AS [C19_02_Target],[C19_03] AS [C19_03], [C19_03 Historical Max] AS [C19_03 Historical Max], [C19_03 Historical Min] AS [C19_03 Historical Min], [C19_03_USL_X] AS [C19_03_USL],[C19_03_LSL_X] AS [C19_03_LSL], [C19_03_Target_X] AS [C19_03_Target],[C20] AS [C20], [C20 Historical Max] AS [C20 Historical Max], [C20 Historical Min] AS [C20 Historical Min], [C20_USL_X] AS [C20_USL],[C20_LSL_X] AS [C20_LSL], [C20_Target_X] AS [C20_Target],[C21] AS [C21], [C21 Historical Max] AS [C21 Historical Max], [C21 Historical Min] AS [C21 Historical Min], [C21_USL_X] AS [C21_USL],[C21_LSL_X] AS [C21_LSL], [C21_Target_X] AS [C21_Target],[C22] AS [C22], [C22 Historical Max] AS [C22 Historical Max], [C22 Historical Min] AS [C22 Historical Min], [C22_USL_X] AS [C22_USL],[C22_LSL_X] AS [C22_LSL], [C22_Target_X] AS [C22_Target],[C23] AS [C23], [C23 Historical Max] AS [C23 Historical Max], [C23 Historical Min] AS [C23 Historical Min], [C23_USL_X] AS [C23_USL],[C23_LSL_X] AS [C23_LSL], [C23_Target_X] AS [C23_Target],[C03_01 Average],[C03_01 Standard Deviation],[C03_02 Average],[C03_02 Standard Deviation],[C03_3 Average],[C03_3 Standard Deviation],[C03_4 Average],[C03_4 Standard Deviation],[C07 Average],[C07 Standard Deviation],[C16 Average],[C16 Standard Deviation],[C17 Average],[C17 Standard Deviation], [Supplier] AS [Supplier]
		FROM
		(
				SELECT datepart(ns, StartTimeStamp) as mcs,
				RANK() OVER   
					(ORDER BY StartTimeStamp asc) as RK,*	
				FROM AttributePivotTable e1,
				(SELECT [C01_USL] AS [C01_USL_X],[C01_LSL] AS [C01_LSL_X],[C01_Target] AS [C01_Target_X],[C02_USL] AS [C02_USL_X],[C02_LSL] AS [C02_LSL_X],[C02_Target] AS [C02_Target_X],[C03_01_USL] AS [C03_01_USL_X],[C03_01_LSL] AS [C03_01_LSL_X],[C03_01_Target] AS [C03_01_Target_X],[C03_02_USL] AS [C03_02_USL_X],[C03_02_LSL] AS [C03_02_LSL_X],[C03_02_Target] AS [C03_02_Target_X],[C03_03_USL] AS [C03_03_USL_X],[C03_03_LSL] AS [C03_03_LSL_X],[C03_03_Target] AS [C03_03_Target_X],[C03_04_USL] AS [C03_04_USL_X],[C03_04_LSL] AS [C03_04_LSL_X],[C03_04_Target] AS [C03_04_Target_X],[C04_USL] AS [C04_USL_X],[C04_LSL] AS [C04_LSL_X],[C04_Target] AS [C04_Target_X],[C05_USL] AS [C05_USL_X],[C05_LSL] AS [C05_LSL_X],[C05_Target] AS [C05_Target_X],[C06_USL] AS [C06_USL_X],[C06_LSL] AS [C06_LSL_X],[C06_Target] AS [C06_Target_X],[C07_USL] AS [C07_USL_X],[C07_LSL] AS [C07_LSL_X],[C07_Target] AS [C07_Target_X],[C08_USL] AS [C08_USL_X],[C08_LSL] AS [C08_LSL_X],[C08_Target] AS [C08_Target_X],[C09_USL] AS [C09_USL_X],[C09_LSL] AS [C09_LSL_X],[C09_Target] AS [C09_Target_X],[C10_USL] AS [C10_USL_X],[C10_LSL] AS [C10_LSL_X],[C10_Target] AS [C10_Target_X],[C11_USL] AS [C11_USL_X],[C11_LSL] AS [C11_LSL_X],[C11_Target] AS [C11_Target_X],[C12_USL] AS [C12_USL_X],[C12_LSL] AS [C12_LSL_X],[C12_Target] AS [C12_Target_X],[C13_USL] AS [C13_USL_X],[C13_LSL] AS [C13_LSL_X],[C13_Target] AS [C13_Target_X],[C14_USL] AS [C14_USL_X],[C14_LSL] AS [C14_LSL_X],[C14_Target] AS [C14_Target_X],[C15_USL] AS [C15_USL_X],[C15_LSL] AS [C15_LSL_X],[C15_Target] AS [C15_Target_X],[C16_USL] AS [C16_USL_X],[C16_LSL] AS [C16_LSL_X],[C16_Target] AS [C16_Target_X],[C17_USL] AS [C17_USL_X],[C17_LSL] AS [C17_LSL_X],[C17_Target] AS [C17_Target_X],[C18_01_USL] AS [C18_01_USL_X],[C18_01_LSL] AS [C18_01_LSL_X],[C18_01_Target] AS [C18_01_Target_X],[C18_02_USL] AS [C18_02_USL_X],[C18_02_LSL] AS [C18_02_LSL_X],[C18_02_Target] AS [C18_02_Target_X],[C18_03_USL] AS [C18_03_USL_X],[C18_03_LSL] AS [C18_03_LSL_X],[C18_03_Target] AS [C18_03_Target_X],[C19_01_USL] AS [C19_01_USL_X],[C19_01_LSL] AS [C19_01_LSL_X],[C19_01_Target] AS [C19_01_Target_X],[C19_02_USL] AS [C19_02_USL_X],[C19_02_LSL] AS [C19_02_LSL_X],[C19_02_Target] AS [C19_02_Target_X],[C19_03_USL] AS [C19_03_USL_X],[C19_03_LSL] AS [C19_03_LSL_X],[C19_03_Target] AS [C19_03_Target_X],[C20_USL] AS [C20_USL_X],[C20_LSL] AS [C20_LSL_X],[C20_Target] AS [C20_Target_X],[C21_USL] AS [C21_USL_X],[C21_LSL] AS [C21_LSL_X],[C21_Target] AS [C21_Target_X],[C22_USL] AS [C22_USL_X],[C22_LSL] AS [C22_LSL_X],[C22_Target] AS [C22_Target_X],[C23_USL] AS [C23_USL_X],[C23_LSL] AS [C23_LSL_X],[C23_Target] AS [C23_Target_X]
				FROM AttributePivotTable WHERE StartTimeStamp='1970-01-01 00:00:00.0000000')w
		)D
	WHERE D.StartTimeStamp>'1970-01-01 00:00:00.0000000'
	)A1
LEFT OUTER JOIN AttributePivotTable3 A3
ON A1.Lot = A3.Lot
AND A1.Part = A3.Part
INNER JOIN AttributePivotTable4 A4
ON A1.Part = A4.Part
WHERE A1.Lot<>'Pt Created' AND A1.Lot IS NOT NULL
)
--select * from AttributePivotTable5


INSERT INTO [G7_SPC].[dbo].[MT26560_Staging]
([Lot_Order],[mcs],[Sample],[StartTimeStamp],[PART],[Fixture],[Lot],[Qualification Date],[C01],[C01 Historical Max],[C01 Historical Min],[C01_USL],[C01_LSL],[C01_Target],[C02],[C02 Historical Max],[C02 Historical Min],[C02_USL],[C02_LSL],[C02_Target],[C03_01],[C03_01 Historical Max],[C03_01 Historical Min],[C03_01_USL],[C03_01_LSL],[C03_01_Target],[C03_02],[C03_02 Historical Max],[C03_02 Historical Min],[C03_02_USL],[C03_02_LSL],[C03_02_Target],[C03_03],[C03_03 Historical Max],[C03_03 Historical Min],[C03_03_USL],[C03_03_LSL],[C03_03_Target],[C03_04],[C03_04 Historical Max],[C03_04 Historical Min],[C03_04_USL],[C03_04_LSL],[C03_04_Target],[C04],[C04 Historical Max],[C04 Historical Min],[C04_USL],[C04_LSL],[C04_Target],[C05],[C05 Historical Max],[C05 Historical Min],[C05_USL],[C05_LSL],[C05_Target],[C06],[C06 Historical Max],[C06 Historical Min],[C06_USL],[C06_LSL],[C06_Target],[C07],[C07 Historical Max],[C07 Historical Min],[C07_USL],[C07_LSL],[C07_Target],[C08],[C08 Historical Max],[C08 Historical Min],[C08_USL],[C08_LSL],[C08_Target],[C09],[C09 Historical Max],[C09 Historical Min],[C09_USL],[C09_LSL],[C09_Target],[C10],[C10 Historical Max],[C10 Historical Min],[C10_USL],[C10_LSL],[C10_Target],[C11],[C11 Historical Max],[C11 Historical Min],[C11_USL],[C11_LSL],[C11_Target],[C12],[C12 Historical Max],[C12 Historical Min],[C12_USL],[C12_LSL],[C12_Target],[C13],[C13 Historical Max],[C13 Historical Min],[C13_USL],[C13_LSL],[C13_Target],[C14],[C14 Historical Max],[C14 Historical Min],[C14_USL],[C14_LSL],[C14_Target],[C15],[C15 Historical Max],[C15 Historical Min],[C15_USL],[C15_LSL],[C15_Target],[C16],[C16 Historical Max],[C16 Historical Min],[C16_USL],[C16_LSL],[C16_Target],[C17],[C17 Historical Max],[C17 Historical Min],[C17_USL],[C17_LSL],[C17_Target],[C18_01],[C18_01 Historical Max],[C18_01 Historical Min],[C18_01_USL],[C18_01_LSL],[C18_01_Target],[C18_02],[C18_02 Historical Max],[C18_02 Historical Min],[C18_02_USL],[C18_02_LSL],[C18_02_Target],[C18_03],[C18_03 Historical Max],[C18_03 Historical Min],[C18_03_USL],[C18_03_LSL],[C18_03_Target],[C19_01],[C19_01 Historical Max],[C19_01 Historical Min],[C19_01_USL],[C19_01_LSL],[C19_01_Target],[C19_02],[C19_02 Historical Max],[C19_02 Historical Min],[C19_02_USL],[C19_02_LSL],[C19_02_Target],[C19_03],[C19_03 Historical Max],[C19_03 Historical Min],[C19_03_USL],[C19_03_LSL],[C19_03_Target],[C20],[C20 Historical Max],[C20 Historical Min],[C20_USL],[C20_LSL],[C20_Target],[C21],[C21 Historical Max],[C21 Historical Min],[C21_USL],[C21_LSL],[C21_Target],[C22],[C22 Historical Max],[C22 Historical Min],[C22_USL],[C22_LSL],[C22_Target],[C23],[C23 Historical Max],[C23 Historical Min],[C23_USL],[C23_LSL],[C23_Target],[C03_01 Average],[C03_01 Standard Deviation],[C03_02 Average],[C03_02 Standard Deviation],[C03_3 Average],[C03_3 Standard Deviation],[C03_4 Average],[C03_4 Standard Deviation],[C07 Average],[C07 Standard Deviation],[C16 Average],[C16 Standard Deviation],[C17 Average],[C17 Standard Deviation],[Supplier],[C03_01_p1StdDev],[C03_02_p1StdDev],[C03_03_p1StdDev],[C03_04_p1StdDev],[C07_p1StdDev],[C16_p1StdDev],[C17_p1StdDev],[C03_01_n1StdDev],[C03_02_n1StdDev],[C03_03_n1StdDev],[C03_04_n1StdDev],[C07_n1StdDev],[C16_n1StdDev],[C17_n1StdDev],[C03_01_p2StdDev],[C03_02_p2StdDev],[C03_03_p2StdDev],[C03_04_p2StdDev],[C07_p2StdDev],[C16_p2StdDev],[C17_p2StdDev],[C03_01_n2StdDev],[C03_02_n2StdDev],[C03_03_n2StdDev],[C03_04_n2StdDev],[C07_n2StdDev],[C16_n2StdDev],[C17_n2StdDev],[Part_Status],[Lot_Status],[LotTime],[LastUpdatedTimestamp],[LastUpdatedByUser],[Status])
select DENSE_RANK() OVER  (ORDER BY LotTime desc) as Lot_Order, W.*,getdate() as [LastUpdatedTimestamp],CURRENT_USER as [LastUpdatedByUser],1 as [Status] from 
(
	select A.*, B.LotTime from  AttributePivotTable5 A
	inner join 
	(
	select Min(StartTimeStamp) as LotTime, Lot from AttributePivotTable5
	group by Lot
	)B
	on A.Lot=B.Lot	
)W
Order by W.LotTime

SELECT * FROM [G7_SPC].[dbo].[MT26560_Staging]


END
GO