USE [VA_Proj]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

USE [VA_Proj]
GO

/****** Object:  Table [dbo].[ObjectMetadata]    Script Date: 5/3/2023 3:47:42 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


IF Object_Id('[dbo].[ObjectMetadata]') IS NOT NULL DROP TABLE [dbo].[ObjectMetadata]

CREATE TABLE [dbo].[ObjectMetadata](
	[ObjectID] [int] IDENTITY(1,1) NOT NULL,
	[ObjectTerm] [varchar](50) NOT NULL,
	[Vocabulary] [varchar](50) NOT NULL,
	[Model] [varchar](50) NOT NULL,
	[SetType] [varchar](50) NOT NULL,
	[Comment] [varchar](50) NOT NULL,
	[Details] [varchar](50) NOT NULL,
	[CreateDate] [datetime2](7) NULL
) ON [PRIMARY]
GO


insert into [dbo].[ObjectMetadata] (ObjectTerm, Vocabulary, Model, SetType, Comment, Details, CreateDate)
Values
('Alcohol Use Disorder', 'ICD10', 'Standard', 'Codeset', 'Test1', 'TestDetails', SYSDATETIME()),
('Cannibas Use Disorder', 'ICD9', 'Standard', 'Codeset', 'Test1', 'TestDetails', SYSDATETIME()),
('Bipolar', 'ICD10', 'Standard', 'Codeset', 'Test1', 'TestDetails', SYSDATETIME()),
('Alcohol Use Disorder', 'Dx', 'Standard', 'ValueSet', 'Test1', 'TestDetails', SYSDATETIME()),
('Cannibas Use Disorder', 'Rx', 'Standard', 'ValueSet', 'Test1', 'TestDetails', SYSDATETIME()),
('Bipolar', 'ICD10', 'Cerner', 'ValueSet', 'Test1', 'TestDetails', SYSDATETIME()),
('D302.23', 'ICD10', 'ICD10_Value', 'CodeValue', 'Test1', 'TestDetails', SYSDATETIME()),
('E302.23', 'ICD10', 'IDC9_Value', 'CodeValue', 'Test1', 'TestDetails', SYSDATETIME()),
('F302.23', 'ICD10', 'PX_Value', 'CodeValue', 'Test1', 'TestDetails', SYSDATETIME()),
('AUD', 'ICD10', 'Dx', 'Codeset', 'Superset', 'TestDetails', SYSDATETIME()),
('CUD', 'ICD10', 'Rx', 'Codeset', 'Superset', 'TestDetails', SYSDATETIME()),
('BUD', 'ICD10', 'Cerner', 'Codeset', 'Superset', 'TestDetails', SYSDATETIME())


select * from [dbo].[ObjectMetadata]


IF Object_Id('[dbo].[ObjectSet]') IS NOT NULL DROP TABLE [dbo].[ObjectSet]


CREATE TABLE [dbo].[ObjectSet](
	[ObjectID] [int] NOT NULL,
	[ChildObjectID] [int] NOT NULL,
	[CreateDate] [datetime2](7) NULL
) ON [PRIMARY]
GO

insert into [dbo].[ObjectSet] (ObjectID, ChildObjectID,  CreateDate)
Values (1,7, SYSDATETIME())
,(2,8, SYSDATETIME())
,(3,9, SYSDATETIME())
,(4,1, SYSDATETIME())
,(5,2, SYSDATETIME())
,(6,3, SYSDATETIME())
,(10,1, SYSDATETIME())
,(11,2, SYSDATETIME())
,(12,3, SYSDATETIME())

select * from [dbo].[ObjectSet]


DROP TABLE IF EXISTS #Parents
GO

DROP TABLE IF EXISTS #Result
GO

Create Table #Parents
(

ObjectID int Null,
ChildObjectID int Null,
lvl int 
)

Create Table #Result
(
AncestorObjectID int Null,
AncestorObjectTerm varchar(2000),
AncestorVocabulary varchar(2000),
AncestorSetType varchar(2000),
ObjectID int Null,
ObjectTerm varchar(2000),
Vocabulary varchar(2000),
SetType varchar(2000),
ChildObjectID int Null,
ChildObjectTerm varchar(2000),
ChildVocabulary varchar(2000),
ChildSetType varchar(2000),
level int 
)

insert into #Parents
Select 
[ObjectID],
[ChildObjectID],
1
from [dbo].[ObjectSet]



Insert Into #Result
Select
b.[ObjectID] 
,om.[ObjectTerm] 
,om.[Vocabulary] 
,om.SetType
,b.[ObjectID] 
,om.[ObjectTerm] 
,om.[Vocabulary]
,om.SetType 
,com.ObjectID
,com.[ObjectTerm]
,com.[Vocabulary] 
,com.SetType
,1
from [dbo].[ObjectSet] b
inner join [dbo].[ObjectMetadata] om
on om.ObjectID = b.ObjectID
inner join [dbo].[ObjectMetadata] com
on com.ObjectID = b.ChildObjectID







Declare @CounterDown int = 2, @lvl int = 1

While @CounterDown <> 0
Begin




Insert Into #Result
Select
a.[ObjectID] 
,om.[ObjectTerm] 
,om.[Vocabulary] 
,om.SetType
,a.[ObjectID] 
,om.[ObjectTerm] 
,om.[Vocabulary]
,om.SetType 
,com.ObjectID
,com.[ObjectTerm]
,com.[Vocabulary] 
,com.SetType
,@lvl +1
from #Parents a
inner join 
[dbo].[ObjectSet] b
on a.ChildObjectID = b.ObjectID
inner join [dbo].[ObjectMetadata] om
on om.ObjectID = a.ObjectID
inner join [dbo].[ObjectMetadata] com
on com.ObjectID = b.ChildObjectID





Set @lvl = @lvl +1
Set @CounterDown = @CounterDown - 1






truncate table #Parents

insert into #Parents
Select 
a.[ObjectID],
a.[ChildObjectID],
@lvl
from [dbo].[ObjectSet] a
inner join #Result b
on b.ChildObjectID = a.ChildObjectID

--select * from #Parents
select * from #Result

End 


select * from #Result