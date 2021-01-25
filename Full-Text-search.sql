use Auction

--Создание полнотекстового каталога
go
CREATE FULLTEXT CATALOG AuctionCatalog

go
CREATE UNIQUE INDEX PK_lots ON Lots(id); 


go
 --Создание полнотекстового индекса
CREATE FULLTEXT INDEX ON Lots(description)
    KEY INDEX PK_lots ON (AuctionCatalog)
    WITH (CHANGE_TRACKING AUTO)
GO


