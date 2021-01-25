use Auction

--�������� ��������������� ��������
go
CREATE FULLTEXT CATALOG AuctionCatalog

go
CREATE UNIQUE INDEX PK_lots ON Lots(id); 


go
 --�������� ��������������� �������
CREATE FULLTEXT INDEX ON Lots(description)
    KEY INDEX PK_lots ON (AuctionCatalog)
    WITH (CHANGE_TRACKING AUTO)
GO


