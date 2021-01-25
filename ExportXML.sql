go
Create Procedure ExportXML
AS
Begin
	SELECT id, city, country, region from Locations
		FOR XML PATH('Location'), ROOT('Locations'); 

	--to use xp_cmdshell
	EXEC master.dbo.sp_configure 'show advanced options', 1
		RECONFIGURE WITH OVERRIDE
	EXEC master.dbo.sp_configure 'xp_cmdshell', 1
		RECONFIGURE WITH OVERRIDE;

	-- Save XML records to a file
	DECLARE @fileName nVARCHAR(100)
	DECLARE @sqlStr VARCHAR(1000)
	DECLARE @sqlCmd VARCHAR(1000)

	SET @fileName = 'C:\Users\ermak\Course_DB\Export.xml'
	SET @sqlStr = 'USE Auction; SELECT id, city, country, region from Locations FOR XML PATH(''Location''), ROOT(''Locations'') '
	SET @sqlCmd = 'bcp "' + @sqlStr + '" queryout ' + @fileName + ' -w -T'
	EXEC xp_cmdshell @sqlCmd;
End;

drop procedure ExportXXML;
exec ExportXML;