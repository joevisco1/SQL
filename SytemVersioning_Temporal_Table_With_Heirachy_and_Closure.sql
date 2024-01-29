

/****** Object:  Table [dbo].[ObjectMetadata_V]    Script Date: 5/8/2023 2:19:56 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
ALTER TABLE [dbo].[ObjectMetadata_V] SET (SYSTEM_VERSIONING = OFF)
IF Object_Id('[dbo].[ObjectMetadata_V]') IS NOT NULL DROP TABLE [dbo].[ObjectMetadata_V]
CREATE TABLE [dbo].[ObjectMetadata_V](
	[ObjectID] [int] IDENTITY(1,1) NOT NULL,
	[ObjectTerm] [varchar](50) NOT NULL,
	[Vocabulary] [varchar](50) NOT NULL,
	[Model] [varchar](50) NOT NULL,
	[SetType] [varchar](50) NOT NULL,
	[Comment] [varchar](50) NOT NULL,
	[Details] [varchar](50) NOT NULL,
	[CreateDate] [datetime2](7) NULL,
	[Version] [decimal](3, 1) NULL,
	[ValidFrom] [datetime2](7) GENERATED ALWAYS AS ROW START NOT NULL,
	[ValidTo] [datetime2](7) GENERATED ALWAYS AS ROW END NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ObjectID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
	PERIOD FOR SYSTEM_TIME ([ValidFrom], [ValidTo])
) ON [PRIMARY]
WITH
(
SYSTEM_VERSIONING = ON ( HISTORY_TABLE = [dbo].[ObjectMetadata_V_History] )
)
GO


insert into [dbo].[ObjectMetadata_V] (ObjectTerm, Vocabulary, Model, SetType, Comment, Details, CreateDate, Version)
Values
('Alcohol Use Disorder', 'ICD10', 'Standard', 'Codeset', 'Test1', 'TestDetails', SYSDATETIME(),1.0),
('Cannibas Use Disorder', 'ICD9', 'Standard', 'Codeset', 'Test1', 'TestDetails', SYSDATETIME(),1.0),
('Bipolar', 'ICD10', 'Standard', 'Codeset', 'Test1', 'TestDetails', SYSDATETIME(),1.0),
('Alcohol Use Disorder', 'Dx', 'Standard', 'ValueSet', 'Test1', 'TestDetails', SYSDATETIME(),1.0),
('Cannibas Use Disorder', 'Rx', 'Standard', 'ValueSet', 'Test1', 'TestDetails', SYSDATETIME(),1.0),
('Bipolar', 'ICD10', 'Cerner', 'ValueSet', 'Test1', 'TestDetails', SYSDATETIME(),1.0),
('D302.23', 'ICD10', 'ICD10_Value', 'CodeValue', 'Test1', 'TestDetails', SYSDATETIME(),1.0),
('E302.23', 'ICD10', 'IDC9_Value', 'CodeValue', 'Test1', 'TestDetails', SYSDATETIME(),1.0),
('F302.23', 'ICD10', 'PX_Value', 'CodeValue', 'Test1', 'TestDetails', SYSDATETIME(),1.0),
('AUD', 'ICD10', 'Dx', 'Codeset', 'Superset', 'TestDetails', SYSDATETIME(),1.0),
('CUD', 'ICD10', 'Rx', 'Codeset', 'Superset', 'TestDetails', SYSDATETIME(),1.0),
('BUD', 'ICD10', 'Cerner', 'Codeset', 'Superset', 'TestDetails', SYSDATETIME(),1.0)

IF Object_Id('[dbo].[ObjectSet_V]') IS NOT NULL  ALTER TABLE [dbo].[ObjectSet_V] SET (SYSTEM_VERSIONING = OFF)

IF Object_Id('[dbo].[ObjectSet_V]') IS NOT NULL DROP TABLE [dbo].[ObjectSet_V]
CREATE TABLE [dbo].[ObjectSet_V](
	[ObjectID] [int] NOT NULL  PRIMARY KEY CLUSTERED,
	[ChildObjectID] [int] NOT NULL,
	[CreateDate] [datetime2](7) NULL,
	[Version] [decimal](3, 1) NULL,
	[ValidFrom] [datetime2](7) GENERATED ALWAYS AS ROW START NOT NULL,
	[ValidTo] [datetime2](7) GENERATED ALWAYS AS ROW END NOT NULL,
	PERIOD FOR SYSTEM_TIME (ValidFrom, ValidTo)
) 
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE = dbo.ObjectSet_V_History));
GO



insert into [dbo].[ObjectSet_V] (ObjectID, ChildObjectID,  CreateDate, Version)
Values (1,7, SYSDATETIME(),1.0)
,(2,8, SYSDATETIME(),1.0)
,(3,9, SYSDATETIME(),1.0)
,(4,1, SYSDATETIME(),1.0)
,(5,2, SYSDATETIME(),1.0)
,(6,3, SYSDATETIME(),1.0)
,(10,1, SYSDATETIME(),1.0)
,(11,2, SYSDATETIME(),1.0)
,(12,3, SYSDATETIME(),1.0)





update  a
Set 
a.Comment = 'Version ' + Cast((a.Version + .1) as varchar(10)),
a.[Version] = a.Version + .1
from [dbo].[ObjectMetadata_V] a
where a.ObjectID = 4




SELECT * FROM [dbo].[ObjectMetadata_V]
	  for System_Time 
	  ALL --	Returns a table with rows containing the values that were current at the specified point in time in the past.
--	  CONTAINED IN Returns a table with the values for all row versions that were active within the specified time range. Inlcudes exact to date
--	  BETWEEN --Returns a table with the values for all row versions that were active within the specified time range. Excludes exact to date
--	  AS OF - One Date
--	  FROM --Returns a table with the values for all row versions that were active within the specified time range. Excludes exact dates


      WHERE ObjectID = 4 ORDER BY ValidFrom;


update  a
Set 
a.Comment = 'Version ' + Cast((a.Version + .1) as varchar(10)),
a.[Version] = a.Version + .1
from [dbo].[ObjectMetadata_V] a
where a.ObjectID = 4


IF Object_Id('vw_GetObjectHistory') IS NOT NULL DROP View vw_GetObjectHistory
  GO


CREATE VIEW [dbo].[vw_GetObjectHistory]
AS
SELECT
om.[ObjectID],
om.[ObjectTerm],
om.[Vocabulary],
om.[Model],
om.[SetType],
om.[Comment],
om.[Details],
om.[CreateDate],
om.[Version]


FROM [dbo].[ObjectMetadata_V] om
LEFT JOIN [dbo].[ObjectSet_V] os
    ON [om].ObjectID = os.ObjectID
LEFT JOIN [dbo].[ObjectSet_V] cos
    ON [om].ObjectID = cos.ObjectID


GO


SELECT * FROM [dbo].[vw_GetObjectHistory]
  for System_Time 
	  ALL --	Returns a table with rows containing the values that were current at the specified point in time in the past.
--	  CONTAINED IN '2023-05-08 14:51:31.6177013' AND '2023-05-08 14:51:31.6177013'  Returns a table with the values for all row versions that were active within the specified time range. Inlcudes exact to date
--	  BETWEEN '2023-05-08 14:51:31.6177013' AND '2023-05-08 14:51:31.6177013'  --Returns a table with the values for all row versions that were active within the specified time range. Excludes exact to date
--	  AS OF - '2023-05-08 14:51:31.6177013' One Date
--	  FROM --Returns a table with the values for all row versions that were active within the specified time range. Excludes exact dates






----Hierarchy ID




 IF Object_Id('Hierarchy_V') IS NOT NULL  ALTER TABLE [dbo].[Hierarchy_V] SET (SYSTEM_VERSIONING = OFF);
  GO
IF Object_Id('Hierarchy_V') IS NOT NULL DROP  TABLE [dbo].[Hierarchy_V] 
  GO
 IF Object_Id('Hierarchy_V_History') IS NOT NULL DROP  TABLE [dbo].[Hierarchy_V_History]  
   GO


CREATE TABLE [dbo].[Hierarchy_V](
	[ObjectID] [int] NULL,
	[ChildObjectID] [int] NOT NULL,
	[Level] int NULL,
	[Version] [decimal](3, 1) NULL,
	[TreePath] hierarchyid Not Null,
	[TreePathString] as TreePath.ToString(),
	[ValidFrom] [datetime2](7) GENERATED ALWAYS AS ROW START NOT NULL,
	[ValidTo] [datetime2](7) GENERATED ALWAYS AS ROW END NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[TreePath] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
	PERIOD FOR SYSTEM_TIME ([ValidFrom], [ValidTo])
) ON [PRIMARY]
WITH
(
SYSTEM_VERSIONING = ON ( HISTORY_TABLE = [dbo].[Hierarchy_V_History] )
)
GO


Declare @ObjectSet as Table
(
	[ObjectID] [int] NULL,
	[ChildObjectID] [int] NULL,
	[CreateDate] [datetime2](7) NULL
) 

Insert into @ObjectSet
([ObjectID] 
 ,[ChildObjectID]
 ,[CreateDate])
 Values (Null, 999999999, SYSDATETIME())

 Insert into @ObjectSet
([ObjectID]
 ,[ChildObjectID]
 ,[CreateDate])
 Select 999999999, [ObjectID],[CreateDate]
 from [dbo].[ObjectSet] a
 where Not Exists(Select 1 from [ObjectSet] b Where b.ChildObjectID = a.ObjectID) 

 Insert into @ObjectSet
([ObjectID]
 ,[ChildObjectID]
 ,[CreateDate])
 Select [ObjectID],[ChildObjectID],[CreateDate]
 from [dbo].[ObjectSet] a

 ;WITH CTEHierarchy(ObjectID, ChildObjectID, TreeLevel, Hierarchy, CreateDate)
     AS (
  
        SELECT ObjectID,
               ChildObjectID,
               1 AS TreeLevel,
               hierarchyid::GetRoot() AS Hierarchy,
			   [CreateDate]

        FROM  @ObjectSet
        WHERE  ObjectID Is Null

        UNION ALL

        SELECT a.ObjectID,
               a.ChildObjectID,
               b.[TreeLevel] + 1 AS TreeLevel,
                Cast(b.Hierarchy.ToString()  + CAST(a.ChildObjectID AS varchar(200))+ '/'  AS  hierarchyid),
			   a.[CreateDate]
        FROM   @ObjectSet a
               INNER JOIN CTEHierarchy b
                   --use to get children
                   ON a.ObjectID = b.ChildObjectID
				   )
	
	
	Insert Into [dbo].[Hierarchy_V]( ObjectID, ChildObjectID, Level, Version, TreePath )
	Select ObjectID, ChildObjectID, TreeLevel, 1.0, Hierarchy from CTEHierarchy	

	select * from  [dbo].[Hierarchy_V]


	
----Search for Parents of 
	SELECT a.ObjectID, a.[ChildObjectID], a.[Version], a.[TreePathString] 
	   FROM   [dbo].[Hierarchy_V] AS a
       JOIN [dbo].[Hierarchy_V] AS b
           ON b.ObjectId = 9

               --get the nodes where the searched item is the decendent instead of the target rows
               AND b.[TreePath].IsDescendantOf --gets rows where the target is a 
                   (   a.[TreePath]) = 1;



				
Declare @SearchForObjectID int = 4




---Get Parents
SELECT a.ObjectID, a.ChildObjectID, a.Version, a.TreePathString AS Hierarchy
FROM   [dbo].[Hierarchy_V]  for System_Time as Of '2023-05-09' AS a
       JOIN [dbo].[Hierarchy_V] for System_Time as Of '2023-05-09' AS b--represents the one row that matches the search
           ON b.ChildObjectId = @SearchForObjectID

               --get the nodes where the searched item is the decendent instead of the target rows
               AND b.[TreePath].IsDescendantOf --gets rows where the target is a 
                   (   a.[TreePath]) = 1
				   and a.ChildObjectID <> 999999999
				    and a.ObjectID <> 999999999
					and a.ChildObjectID <> b.ChildObjectID
					

----Get Children of				   
SELECT a.ObjectID, a.ChildObjectID, a.Version, a.TreePathString AS Hierarchy
FROM   [dbo].[Hierarchy_V] for System_Time as Of '2023-05-09'  AS a
       JOIN [dbo].[Hierarchy_V] for System_Time as Of '2023-05-09' AS b
           ON b.ObjectID = @SearchForObjectID
               AND a.TreePath.IsDescendantOf(b.TreePath) = 1;





---Stretch Databases - Move cold data into Azure



/* Time Travel in Delta Lake

--By Date

--Scala
val df = spark.read
  .format("delta")
  .option("timestampAsOf", "2019-01-01")
  .load("/path/to/my/table")

--Python

df = spark.read \
  .format("delta") \
  .option("timestampAsOf", "2019-01-01") \
  .load("/path/to/my/table")

---SQL

SELECT count(*) FROM my_table TIMESTAMP AS OF "2019-01-01"
SELECT count(*) FROM my_table TIMESTAMP AS OF date_sub(current_date(), 1)
SELECT count(*) FROM my_table TIMESTAMP AS OF "2019-01-01 01:30:00.000"


--By Version Number
df = spark.read \
  .format("delta") \
  .option("versionAsOf", "5238") \
  .load("/path/to/my/table")

df = spark.read \
  .format("delta") \
  .load("/path/to/my/table@v5238")

  */