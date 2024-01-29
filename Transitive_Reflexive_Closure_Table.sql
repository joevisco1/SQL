

----Set Transative Closure




---select * from [dbo].[ObjectSet]

IF Object_Id('dbo.ObjectSetClosure') IS NOT NULL DROP TABLE dbo.ObjectSetClosure


CREATE TABLE ObjectSetClosure --where we store our edges
    (
    ObjectID INT NOT NULL,
    ChildObjectID INT NOT NULL,
    Depth INT NOT NULL,
	ValidFrom DATETIME NOT NULL,
    ValidTo DATETIME null
   -- PRIMARY KEY (ancestor, descendant),--enforce the rules
   -- FOREIGN KEY (ancestor) REFERENCES Staff (employee_ID),
   -- FOREIGN KEY (descendant) REFERENCES Staff (employee_ID)



    );
	
	select * from [dbo].[ObjectSetClosure]

	update a
	set a.[ValidTo] = Null
	from [dbo].[ObjectSetClosure] a


	----Reflexive Closure Level
	insert into [dbo].[ObjectSetClosure]
	select [ObjectID], [ObjectID], 1, '2022-01-01', '2023-01-01' 
	from [dbo].[ObjectMetadata]


	;WITH cteOS      
	
	AS (
  
        SELECT ObjectID,
               ChildObjectID,
               1 AS Depth
        FROM  [dbo].[ObjectSet] a
         where Not Exists(Select 1 from [ObjectSet] b Where b.ChildObjectID = a.ObjectID) 

        UNION ALL

		SELECT a.ObjectID,
               a.ChildObjectID,
               b.Depth + 1
        FROM  [dbo].[ObjectSet] a
               INNER JOIN cteOS  b
                   --use to get children
                   ON a.ObjectID = b.ChildObjectID
				   )
	
	
	
	
	
	
	insert into [dbo].[ObjectSetClosure] ([ObjectID],[ChildObjectID],[Depth],[ValidFrom] )
	select [ObjectID],[ChildObjectID], Depth, '2023-01-02'
	from cteOS