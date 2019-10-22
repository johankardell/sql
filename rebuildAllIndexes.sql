SET NOCOUNT ON
GO
DECLARE rebuildindexes CURSOR
FOR
SELECT SysSche.Name, SysObj.Name
FROM         Sys.Objects SysObj
INNER JOIN         sys.schemas SysSche ON SysObj.Schema_ID = SysSche.Schema_ID
WHERE         TYPE = 'U'              
  AND object_id NOT IN (
    SELECT object_id
    FROM sys.external_tables
    )
OPEN rebuildindexes  
DECLARE @tableSchema NVARCHAR(128)
DECLARE @tableName NVARCHAR(128)
DECLARE @Statement NVARCHAR(300)  
FETCH NEXT
FROM rebuildindexes
INTO @tableSchema, @tableName  
WHILE (@@FETCH_STATUS = 0)
BEGIN
    
  SET @Statement = 'ALTER INDEX ALL ON '   + '[' + @tableSchema + ']' + '.' + '[' + @tableName + ']' + ' REBUILD'   
  PRINT @Statement -- comment this print statement to prevent it from printing whenever you are ready to execute the command below.
  EXEC sp_executesql @Statement -- remove the comment on the beginning of this line to run the commands 
  
  FETCH NEXT
  FROM rebuildindexes
  INTO @tableSchema, @tableName
END  
CLOSE rebuildindexes
DEALLOCATE rebuildindexes
GO
SET NOCOUNT OFF
GO