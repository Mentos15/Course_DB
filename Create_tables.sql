use Auction

drop table Locations;
drop table Category;
drop table Users;
drop table Lots;
drop table Bids;
drop table Photo;


create table Locations(
id int identity(1,1) primary key,
city varchar(30) not null,
country varchar(30),
region varchar(30),
)

create table Category(
id int identity(1,1) primary key,
name varchar(30) not null
)

create table Users (
id int identity(1,1) primary key,
name varchar(15) not null,
last_name varchar(15) not null,
email varchar(25) not null,
phone int not null,
location_id int constraint User_location foreign key references Locations(id) not null
)

create table Lots(
id int identity(1,1) primary key,
user_id int foreign key references Users(id) not null,
title varchar(40) not null,
description varchar(500) not null,
start_price int not null,
start_time DATETIME not null,
end_time DATETIME not null,
category_id int constraint Lots_category foreign key references Category(id) not null,
now_price int not null,
location_id int constraint Lots_location foreign key references Locations(id)  not null
)

create table Bids(
id int identity(1,1) primary key,
user_id int constraint Bids_users foreign key references Users(id) not null,
lots_id int constraint Bids_lots foreign key references Lots(id) not null,
bid int not null,
create_dt DATETIME not null,
update_dt DATETIME not null
)


create table Photo(
id int identity(1,1),
lot_id int constraint Photo_lots foreign key references Lots(id) not null,
photo varchar(100)
)