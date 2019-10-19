USE [CCCIS]
GO

/****** Object:  StoredProcedure [dbo].[SP_ResendImportList]    Script Date: 10/19/2019 12:50:33 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




--exec SP_ResendImportList

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

  
  
/****** Object:  Stored Procedure dbo.SP_ResendImportList   ******/  
--execute SP_ResendImportList select * from CCCISCBSHealthCheckList
-- 0 No RSP 1-Got Rsp with error 2- Got Error 
CREATE PROC [dbo].[SP_ResendImportList]  
AS

SET ARITHABORT ON

DECLARE @BCB_CCCISNo  VARCHAR(7) 
DECLARE @BCB_Reference VARCHAR(10)  
DECLARE @BCB_AppType  VARCHAR(1) 
DECLARE @BCB_CreateDate datetime          
DECLARE @BCB_LastUpdateDate datetime    
DECLARE @BCB_Status  Int
DECLARE @MINS	Int
DECLARE @MinuteAsofThisTime  Int
DECLARE @Flag Int
	Declare @path varchar(30)
	Declare @RSPpath varchar(30)
	Declare @FileName varchar(30)
	declare @myquery varchar(1000)
	declare @query varchar(1000)
	declare @xmlField as xml
	declare @RunNo as varchar(20)
	declare @No_Errors as varchar(10)
	declare @RSP_MSG as varchar(500)
	declare @ImportLine as NVARCHAR(512)
	declare @Source as NVARCHAR(512)
	declare @Target as NVARCHAR(512)
	

  
Declare @inCCCISCBSHealthCheckList as int 

DECLARE @result2 INT 
declare @cmd2 nvarchar(100)

Declare @result3 as INT
DECLARE @result3tab TABLE (Line NVARCHAR(512))
declare @cmd3 nvarchar(100)
declare @findme nvarchar(20)

--BEGIN TRAN  
DECLARE APPCURSOR SCROLL CURSOR FOR   
  
-- Get All CCCISNo having Response time so long and NO RSP file and No Error Files
-- If got RSP file but having invalid DOB inert also in the table  
SELECT TOP 20
BCB_CCCISNo,BCB_Reference,BCB_AppType, BCB_CreateDate,BCB_LastUpdateDate,BCB_Status,
DATEDIFF(n, BCB_CreateDate,BCB_LastUpdateDate) AS MINS,
DATEDIFF(n, BCB_CreateDate,getdate()) AS MinuteAsofThisTime,0
from  BCB_NEW(NOLOCK) 
where 
--DATEDIFF(n, BCB_CreateDate,BCB_LastUpdateDate)  > 60 
bcb_status<>6 
and BCB_AppType='A' --C for CRES S for TRANSACT - W- Web
and BCB_CreateDate>CONVERT(VARCHAR(10),GETDATE(),101) -- get today date only
and DATEDIFF(n, BCB_CreateDate,getdate())>180
and MsgID is null
and BCB_Reference NOT IN (select BCB_Reference  from  BCB_NEW WHERE BCB_STATUS=6 or BCB_Status=5)
ORDER BY BCB_CreateDate DESC
--TESTING FIRST BCB_CCCISNo 4759090
--select CONVERT(VARCHAR(10),GETDATE(),101)
--SELECT CONVERT(VARCHAR(10),GETDATE(),101)

--CCCISCBSHealthCheckList
--BCB_CCCISNo,BCB_Reference,BCB_AppType, BCB_CreateDate,BCB_LastUpdateDate,BCB_Status,
--DATEDIFF(n, BCB_CreateDate,BCB_LastUpdateDate) AS MINS,
--DATEDIFF(n, BCB_CreateDate,getdate()) AS MinuteAsofThisTime,BCB_LastUpdateDate,0

  
PRINT 'executing SP_ResendImportList'   
  
OPEN APPCURSOR  
FETCH NEXT FROM APPCURSOR INTO @BCB_CCCISNo,@BCB_Reference,@BCB_AppType,@BCB_CreateDate,@BCB_LastUpdateDate,@BCB_Status,@MINS,@MinuteAsofThisTime ,@Flag
WHILE @@FETCH_STATUS = 0  
BEGIN  
	SET @No_Errors=''
	SET @RSP_MSG =''
    PRINT 'CCCIS No : ' + cast(@BCB_CCCISNo as varchar(20))   
    
-- 1. Check if the CCCISNumber already exist in the folder   
    set @inCCCISCBSHealthCheckList =0
	select  @inCCCISCBSHealthCheckList=   count(*) from CCCISCBSHealthCheckList	where BCB_CCCISNo=@BCB_CCCISNo
	
-- 2. Check if got RSP folder E:\SGCCCIS\DONE
	 --DECLARE @BCB_CCCISNo  VARCHAR(7)
  --   DECLARE @result2 INT 
	 --declare @cmd2 nvarchar(100) 
  --   set @BCB_CCCISNo='4795180' -- for testing		
	 set @cmd2=''
	 set @result2=0
     --EXEC master.dbo.xp_fileexist 'E:\SGCCCIS\CBS\DONE\BCB_REQ_380813.XML', @result OUTPUT          
     set @cmd2 = 'E:\SGCCCIS\CBS\DONE\BCB_RSP_' +@BCB_CCCISNo+'.XML'
     print @cmd2
     EXEC master.dbo.xp_fileexist @cmd2, @result2 OUTPUT
     
     IF @result2>0 
		BEGIN
			--E:\SGCCCIS\CBS\RSP
			TRUNCATE table XMLwithOpenXML2
			set @path='E:\SGCCCIS\CBS\RSP'			
			--set @myquery = 'INSERT INTO XMLwithOpenXML(XMLData, LoadedDateTime) SELECT CONVERT(XML, BulkColumn) AS BulkColumn, GETDATE() 
			--FROM OPENROWSET(BULK ' + '''' + ltrim(rtrim(@path)) + '\' +  @name + '''' + ', SINGLE_BLOB) AS x; '
	
			set @myquery = 'INSERT INTO XMLwithOpenXML2(XMLData, LoadedDateTime) SELECT CONVERT(XML, BulkColumn) AS BulkColumn, GETDATE() 
			FROM OPENROWSET(BULK ' + '''' + @cmd2 + '''' + ', SINGLE_BLOB) AS x; '				
			exec (@Myquery)
			
			--select * from XMLwithOpenXML2
			select @xmlField = XMLData FROM XMLwithOpenXML2

			--select @RunNo = T.N.value('RUN_NO[1]', 'nvarchar(max)')
			--'from @xmlField.nodes('/RESPONSE/MESSAGE/HEADER') as T(N)
			
			select @No_Errors = T.N.value('NO_ERRORS[1]', 'nvarchar(max)')
			from @xmlField.nodes('/RESPONSE/MESSAGE/ITEM') as T(N)						

			select @RSP_MSG	= T.N.value('RSP_MSG[1]', 'nvarchar(max)')
			from @xmlField.nodes('/RESPONSE/MESSAGE/ITEM/ERROR') as T(N)						


			--select * from XMLwithOpenXML2
			--TRUNCATE table XMLwithOpenXML2
		END          
     ---PRINT @result2
     
		--  --if found ge any error if any   
		--   <ITEM>
		--  <RSP_ENQUIRY_REF>4795180</RSP_ENQUIRY_REF> 
		--  <NO_ERRORS>1</NO_ERRORS> 
		--- <ERROR>
		--  <CONSUMER_SEQ>1</CONSUMER_SEQ> 
		--  <FIELD>CDOB</FIELD> 
		--  <RSP_MSG>CRBLIO00004 Date of Birth not a valid date</RSP_MSG> 
		--  <DATA>2018-05-03</DATA> 
		--  </ERROR>
		--  </ITEM>

	 -- 3. Check if got ERR
	 --414d51204544434d5120202020202020534aa35a25f30980.xml.err 
	 --E:\SGCCCIS\cbs\ERR <RSP_ENQUIRY_REF>4796437</RSP_ENQUIRY_REF>
	--for testing
	set @result3=0
	set @ImportLine=''
	if (@result2=0)  -- execute this if no CBS\RSP
	BEGIN
		--set @findme='485369'
		--set @cmd = 'findstr /M "<RUN_NO>" E:\SGCCCIS\CBS\ERR\*.*'
		set @cmd3 = 'findstr /M "<RUN_NO>' +@BCB_CCCISNo+'</RUN_NO>" E:\SGCCCIS\CBS\ERR\*.xml'
		print  @cmd3 
		DELETE @result3tab
		INSERT INTO @result3tab
		execute master.dbo.xp_cmdshell @cmd3
		SELECT @result3= count(*) FROM @result3tab where line is not null
		SELECT @ImportLine=Line FROM @result3tab where line is not null
		print 'line 1: ' + @ImportLine
		print 'line 2: ' + replace(@ImportLine,'ERR','RSP')
		set @Source = @ImportLine
		set @Target = 'E:\SGCCCIS\CBS\RSP'--replace(@ImportLine,'ERR','RSP')
		--PRINT 'condition 3 :' +@result3
	END
		
	print cast(@inCCCISCBSHealthCheckList as int)
	print cast(@result2 as int)
	print cast(@result3 as int)
	
	
	if (@inCCCISCBSHealthCheckList=0 and @result2=0 and @result3=0 )-- 0 NO CBS respond
	BEGIN
		Insert into CCCISCBSHealthCheckList values(@BCB_CCCISNo,@BCB_Reference,@BCB_AppType,@BCB_CreateDate,@BCB_LastUpdateDate,@BCB_Status,@MINS,@MinuteAsofThisTime ,0,@RSP_MSG,@No_Errors,null)
	END
	
	if (@inCCCISCBSHealthCheckList=0 and @result2>0 and @result3=0 ) -- 1 got CBS\RSP check if error
	BEGIN
		Insert into CCCISCBSHealthCheckList values(@BCB_CCCISNo,@BCB_Reference,@BCB_AppType,@BCB_CreateDate,@BCB_LastUpdateDate,@BCB_Status,@MINS,@MinuteAsofThisTime ,1,@RSP_MSG,@No_Errors,null)
	END

	if (@inCCCISCBSHealthCheckList=0 and @result2=0 and @result3>0 ) -- 2 got CBS\RSP\ERR - copy to the RSP folder
	BEGIN
		Insert into CCCISCBSHealthCheckList values(@BCB_CCCISNo,@BCB_Reference,@BCB_AppType,@BCB_CreateDate,@BCB_LastUpdateDate,@BCB_Status,@MINS,@MinuteAsofThisTime ,2,@RSP_MSG,@No_Errors,null)
		
		Exec resetImport @BCB_CCCISNo
				
		--set @myquery = 'exec master.dbo.xp_cmdshell ''copy '+ ltrim(rtrim(@path)) + '\'+ replace(@name, '.err', '') + ' ' + ltrim(rtrim(@RSPpath)) + ''''
		set @myquery = 'exec master.dbo.xp_cmdshell ''copy '+ @source + ' ' + @target  + ''''
		print @myquery
		exec (@Myquery)		
		
	END

	----exec SP_ResendImportList
	--SELECT * FROM CCCISCBSHealthCheckList order by BCB_CCCISNO 
	--DELETE CCCISCBSHealthCheckList
	--select * from bcb_new where bcb_cccisno='4759090'
	-- update bcb_new set BCB_STATUS='9' where bcb_cccisno='4759090'
	-- WAITFOR DELAY '00:00:10'; --accept value hh:mm:ss
FETCH NEXT FROM APPCURSOR INTO  @BCB_CCCISNo,@BCB_Reference,@BCB_AppType,@BCB_CreateDate,@BCB_LastUpdateDate,@BCB_Status,@MINS,@MinuteAsofThisTime ,@Flag
END  
CLOSE APPCURSOR  
DEALLOCATE APPCURSOR  
  


GO


