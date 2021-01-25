use Auction

--Gen random symbols
go
CREATE VIEW vRand(V) AS SELECT RAND();

go
select * from vRand;

go
	create function RandomString(
	@min_length int,
	@max_length int,
	@CharPool varchar(100)
	)
	returns varchar(max)
	AS
	BEGIN
	declare @Length int, @PoolLength int, @LoopCount int, @RandomString varchar(max)
	SET @Length = (select V from vRand) * (@max_length - @min_length + 1) + @min_length;

	SET @PoolLength = Len(@CharPool)

	SET @LoopCount = 0
	SET @RandomString = ''

	WHILE (@LoopCount < @Length) BEGIN
	SELECT @RandomString = @RandomString +
	SUBSTRING(@Charpool, CONVERT(int, (select V from vRand) * @PoolLength), 1)
	SELECT @LoopCount = @LoopCount + 1
	END

	RETURN @RandomString;
END;

drop function RandomString



go  
	create procedure Show_all_category
	as
	begin
	select * from Category;
end

exec Show_all_category
go  
	create procedure Add_category
	@name varchar(30)
	as
	begin
	insert into Category values (@name);
end

exec Add_category 'новая'
delete from Category where id = 11
exec Show_all_category

go  
	create procedure Delete_category_by_name
	@name varchar(30)
	as
	begin
	delete from Category where name = @name;
end
exec Show_all_category
exec Delete_category_by_name 'новая'

go  
	create procedure Update_category_byId
	@id int,
	@name varchar(30)
	as
	begin
	update Category set name = @name where id = @id;
end

exec Add_category 'Для дома'
exec show_all_category
exec Delete_category_by_name 'Для дома'

exec Update_category_byId 11,'New_catehory'



---------------------------------------------------------

go  
	create procedure Add_lot
	@id_user int,
	@title varchar(40),
	@description varchar(500),
	@start_price int,
	@start_time DATETIME,
	@end_time DATETIME,
	@category_id int,
	@location_id int
	as
	begin
	insert into Lots values (@id_user,@title,@description,@start_price,@start_time,@end_time,@category_id,@start_price,@location_id);
end

drop procedure Add_lot

exec Add_lot 1005,'Светильник','Свтеильник навесной для дома ', 50,'2020-10-16 18:30:00','2020-10-20 00:00:00', 10,5
exec Show_all_lots
exec Delete_lot 2012

select * from Bids
delete Bids

select * from Users


go
	create procedure Show_all_lots
	as 
	begin 
	select * from Lots;
end
exec Show_all_lots;

go
	create procedure Update_lot
	@id_lot int,
	@id_user int,
	@title varchar(40),
	@description varchar(500),
	@start_price int,
	@start_time DATETIME,
	@end_time DATETIME,
	@category_id int,
	@now_price int,
	@location_id int
	as
	begin
	update Lots set user_id = @id_user, title = @title, description = @description, start_price = @start_price, start_time = @start_time,
	end_time = @end_time, category_id = @category_id, now_price = @now_price, location_id = @location_id where  id = @id_lot;
end

exec Update_lot 1012,3,'Велосипед','Новый в идеальном состоянии', 20,'2020-10-16 18:30:00','2020-10-20 00:00:00', 2, 20,2
exec Show_all_lots

go
	create procedure Delete_lot
	@id int
	as
	begin
	delete from Bids where lots_id = @id; 
	delete from Lots where id = @id;
	select * from Lots;
end

exec Delete_lot 1012;



go
	create procedure Show_lots_from_category
		@id int
	as
	begin
	select * from Lots where category_id = @id;

end
exec Show_lots_from_category 4;

select * from Category 

go
	create procedure Search_lot_from_location
	@city varchar(30)
	as
	begin
	select A.id,title, description from Lots A inner join Locations B on A.location_id = B.id where B.city = @city;
end
 exec Search_lot_from_location 'Солигорск'

--================================================================================

go
	create procedure Show_all_photo
	as
	begin
		select * from Photo
	end

exec Show_all_photo


go
	create procedure Insert_photo_from_lot
	@id_lot int, 
	@url varchar(100)
	as
	begin
	insert into Photo values (@id_lot, @url);
end

exec Insert_photo_from_lot 2031, 'C:\users\photo\19.png';
exec Show_all_lots
exec Show_all_photo

go 
	create procedure Show_photo_by_id
	@id_photo int
	as 
	begin
	select * from Photo where id = @id_photo;
end
exec Show_photo_by_id 1003

go 
	create procedure Update_photo
	@id_photo int,
	@photo varchar(100)
	as
	begin 
	update Photo set photo = @photo where id = @id_photo;
end

exec Update_photo 1005, 'C:\fdsj\flsdjf\photo.png';
exec Show_all_photo

go
	create procedure Delete_photo
	@id_photo int
	as
	begin
	delete from Photo where id = @id_photo;
end

exec Delete_photo 1005
exec Show_all_photo

-------------------------------------------------------------------------------------






go 
	create procedure Place_a_bet
	@user_id int,
	@lots_id int,
	@bid int
	as
	begin
		if EXISTS(select * from Bids where lots_id = @lots_id)
			begin
				if @bid > (select now_price from Lots where id = @lots_id)
					begin
						update Bids set update_dt = GETDATE(), bid =  @bid, user_id = @user_id where lots_id = @lots_id;
						update Lots set now_price = @bid where id = @lots_id;
					end
				else 
					print 'ставка меньше текущей';
			end
		else
			begin
				if @bid > (select now_price from Lots where id = @lots_id)
					begin
						insert into Bids values (@user_id,@lots_id, @bid,GETDATE(), GETDATE());	
						update Lots set now_price = @bid where id = @lots_id;
					end
				else 
					print 'ставка меньше текущей';
			end
			
end

drop procedure Place_a_bet;
exec Place_a_bet 1007,2026, 1250; 


select * from Bids;
select * from Users
select * from Lots





------------------------------------------------------------

go
	create procedure Add_user 
	@name varchar(15),
	@last_name varchar(15),
	@email varchar(25),
	@phone int,
	@location_id int,
	@password varchar(30)
	as 
	begin
	if EXISTS(select * from Users where Users.email = @email )
		begin
			print 'пользователь с таким email уже существует'
		end
	else	
		insert into Users values (@name,@last_name, @email,@phone, @location_id,@password);	
end

drop procedure Add_user

exec Add_user 'Dm','Su', 'ermakovich4@mail.ru',321343543, 3,'43729'

exec Show_all_users;



go
	create procedure Show_all_users
	as
	begin
		select * from Users;
end

exec Show_all_users;


go
	create procedure Update_user
	@name varchar(15),
	@last_name varchar(15),
	@email varchar(25),
	@phone int,
	@location_id int
	as
	begin
		update Users set name = @name, last_name =  @last_name, phone =  @phone, location_id =  @location_id where email = @email;
end

drop procedure Update_user

exec Update_user 'григорий', 'fdgdfg', 'ermakovich4@mail.ru',4332122,3

exec Show_all_users;



go
	create procedure Show_allBets_user
	@user_id int
	as
	begin
		select bid, lots_id, create_dt, update_dt from  Bids where user_id = @user_id ;
	end


exec Show_allBets_user 1007
select * from Bids




--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------

select * from Locations

go
	create procedure Add_location
	@city varchar(30),
	@country varchar(30),
	@region varchar(30)
	as
	begin

		if EXISTS(select * from Locations where city = @city)
			print 'Данный город уже есть';
		else	
			insert into Locations values (@city, @country, @region);
	end	

exec Add_location 'QWQWQ', 'Беларусь','Минская'

exec Show_all_location
go
	create procedure Show_location_byCity
	@city varchar(30)
	as
	begin

		if EXISTS(select * from Locations where city = @city)
			select * from Locations where city = @city;
		else	
			print 'данного города нет';
	end	

drop procedure Show_location_byCity
exec Show_location_byCity 'Солигорск'


go
	create procedure Show_all_location
	as
	begin
			select * from Locations;
	end

drop procedure Show_all_location
exec Show_all_location;


delete Locations where id>6

go
	create procedure Delete_location_byCity
	@city varchar(30)
	as
	begin
			delete from Locations where city = @city;
	end

exec Delete_location_byCity 'карпаты'
exec Show_all_location

--Демонстрация полнотекстового поиска
go
	create procedure Full_text_search
	@text varchar(50)
	as
	begin
		declare @text2 varchar(500) = '"' + @text + '"';
		select * from Lots where contains(description, @text2);
	end

exec Full_text_search 'Процессор'

CREATE NONCLUSTERED INDEX INDX_from_locationsId
ON Locations(id)


select id from Locations


go
	create procedure Generate_rows
	as
	begin
		declare @x int;
		set @x = 0;
		while @x <100000
			begin
				insert into Locations (city, country, region) values (dbo.RandomString(1,20, 'qwertyuiasdfghxzcbnmlkj'),dbo.RandomString(1,20, 'qwertyuiasdfghxzcbnmlkj'),dbo.RandomString(1,20, 'qwertyuiasdfghxzcbnmlkj'));
				set @x = @x+1;
			end
	end

	exec Generate_rows
	drop procedure Generate_rows;

	exec Show_all_location




