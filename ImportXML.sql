go
Create Procedure ImportProcfromXml
AS
Begin
	INSERT INTO Locations (city, country, region)
	SELECT
	   MY_XML.Location.query('city').value('.', 'VARCHAR(30)'),
	   MY_XML.Location.query('country').value('.', 'VARCHAR(30)'),
	   MY_XML.Location.query('region').value('.', 'VARCHAR(30)')

	FROM (SELECT CAST(MY_XML AS xml)
		  FROM OPENROWSET(BULK 'C:\Users\ermak\Course_DB\Import.xml', SINGLE_BLOB) AS T(MY_XML)) AS T(MY_XML)
		  CROSS APPLY MY_XML.nodes('Locations/Location') AS MY_XML (Location);
End;

drop procedure ImProdfromXml
exec ImportProcfromXml;

exec Show_all_location