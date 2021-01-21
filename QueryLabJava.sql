use master

DROP DATABASE Assignment1_NguyenQuocVinh
CREATE DATABASE Assignment1_NguyenQuocVinh

use Assignment1_NguyenQuocVinh

create table tbl_Role
(
	roleId int primary key,
	name nvarchar(50) not null,
	description nvarchar(500) 
)

create table tbl_Account
(
	userId int identity(1,1) primary key,
	username varchar(30) not null,
	password varchar(100),
	lastname nvarchar(30),
	tokenKey varchar(200),
	role int default 0 foreign key references tbl_Role(roleId)
) 


create table tbl_Category
(
	categoryId int primary key,
	name nvarchar(50) not null,
	description nvarchar(500) 
)

create table tbl_Product
(
	productId int identity(1,1) primary key,
	name varchar(100) not null,
	image varchar(100),
	description nvarchar(500),
	price float not null,
	createDate datetime default GETDATE(),
	category int not null foreign key references tbl_Category(categoryId),
	status bit default 1,
	quantity int not null
)


create table tbl_Order 
(
	orderId int identity(1,1) primary key,
	name nvarchar(100),
	buyDate datetime default GETDATE(),
	userId int not null foreign key references tbl_Account(userId),
	total float not null
)

create table tbl_OrderProduct
(
	orderId int foreign key references tbl_Order(orderId),
	productId int foreign key references tbl_Product(productId),
	primary key(orderId,productId),
	amount int not null
)

create table tbl_History
(
	historyId int identity(1,1) primary key,
	userId int not null foreign key references tbl_Account(userId),
	date datetime default GETDATE(),
	description nvarchar(500)
)







USE [Assignment1_NguyenQuocVinh]
GO

INSERT INTO [dbo].[tbl_Role]
           ([roleId]
           ,[name]
           ,[description])
     VALUES
           (0
           ,'member'
           ,NULL)
GO

INSERT INTO [dbo].[tbl_Role]
           ([roleId]
           ,[name]
           ,[description])
     VALUES
           (1
           ,'admin'
           ,NULL)
GO

INSERT INTO [dbo].[tbl_Role]
           ([roleId]
           ,[name]
           ,[description])
     VALUES
           (2
           ,'google account'
           ,NULL)
GO


INSERT INTO [dbo].[tbl_Account]
           ([username]
           ,[password]
           ,[lastname]
           ,[tokenKey]
           ,[role])
     VALUES
           ('admin'
           ,'123456'
           ,N'Vinh'
           ,NULL
           ,1)
GO

INSERT INTO [dbo].[tbl_Account]
           ([username]
           ,[password]
           ,[lastname]
           ,[tokenKey]
           ,[role])
     VALUES
           ('test'
           ,'123456'
           ,N'Quốc Vinh'
           ,NULL
           ,0)
GO


INSERT INTO [dbo].[tbl_Account]
           ([username]
           ,[password]
           ,[lastname]
           ,[tokenKey]
           ,[role])
     VALUES
           ('quocvinhfacebook@gmail.com'
           ,NULL
           ,N'Thomas'
           ,NULL
           ,2)
GO

INSERT INTO [dbo].[tbl_Category]
           ([categoryId]
           ,[name]
           ,[description])
     VALUES
           (1
           ,N'Food'
           ,N'Đồ Ăn')
GO



INSERT INTO [dbo].[tbl_Category]
           ([categoryId]
           ,[name]
           ,[description])
     VALUES
           (2
           ,N'Drink'
           ,N'Nước uống')
GO


INSERT INTO [dbo].[tbl_Category]
           ([categoryId]
           ,[name]
           ,[description])
     VALUES
           (3
           ,N'Vegetable'
           ,N'Rau củ quả')
GO



INSERT INTO [dbo].[tbl_Product]
           ([name]
           ,[image]
           ,[description]
           ,[price]
           ,[createDate]
           ,[category]
           ,[quantity]
           ,[status])
     VALUES
           ('Grilled Chicken'
           ,'./images/food/chicken.jpg'
           ,N'Gà nướng muối ớt',
           4.5
           ,'2021-01-08 17:23:34.257'
           ,1
           ,6
           ,1)
GO
INSERT INTO [dbo].[tbl_Product]
           ([name]
           ,[image]
           ,[description]
           ,[price]
           ,[createDate]
           ,[category]
           ,[quantity]
           ,[status]
           )
     VALUES
           ('Hambergur'
           ,'./images/food/hamburger.jpg'
           ,N'Bánh mì nướng',
           6.4
           ,'2021-01-08 17:24:47.090'
           ,1
           ,31
           ,1
           )
GO

INSERT INTO [dbo].[tbl_Product]
           ([name]
           ,[image]
           ,[description]
           ,[price]
           ,[createDate]
           ,[category]
           ,[quantity]
           ,[status]
           )
     VALUES
           ('Noodle'
           ,'./images/food/noodle.jpeg'
           ,N'Mì ý Hàn Quốc',
           1.2
           ,'2021-01-08 17:25:23.077'
           ,1
           ,31
           ,1
           )
GO
INSERT INTO [dbo].[tbl_Product]
           ([name]
           ,[image]
           ,[description]
           ,[price]
           ,[createDate]
           ,[category]
           ,[quantity]
           ,[status]
           )
     VALUES
           ('Blue Grey'
           ,'./images/vegetable/vegetable4.jpg'
           ,N'Rau củ quả nướng muối ớt',
           2
           ,'2021-01-08 17:26:05.143'
           ,3
           ,30
           ,1
           )
GO
INSERT INTO [dbo].[tbl_Product]
           ([name]
           ,[image]
           ,[description]
           ,[price]
           ,[createDate]
           ,[category]
           ,[quantity]
           ,[status]
           )
     VALUES
           ('Mark Spon'
           ,'./images/vegetable/vegetable5.jpg'
           ,N'Rau quả màu đỏ',
           2.5
           ,'2021-01-08 17:26:46.560'
           ,3
           ,31
           ,1
           )
GO
INSERT INTO [dbo].[tbl_Product]
           ([name]
           ,[image]
           ,[description]
           ,[price]
           ,[createDate]
           ,[category]
           ,[quantity]
           ,[status]
           )
     VALUES
           ('Milk Tea'
           ,'./images/drink/milktea.jpg'
           ,N'Trà sữa trân châu đường đen',
           15.6
           ,'2021-01-08 17:27:49.307'
           ,2
           ,20
           ,1
           )
GO
INSERT INTO [dbo].[tbl_Product]
           ([name]
           ,[image]
           ,[description]
           ,[price]
           ,[createDate]
           ,[category]
           ,[quantity]
           ,[status]
           )
     VALUES
           ('Nihon Gongcha'
           ,'./images/drink/gongcha.png'
           ,N'Trà đen Nhật Bản',
           12.3
           ,'2021-01-08 17:28:52.153'
           ,2
           ,20
           ,1
           )
GO
INSERT INTO [dbo].[tbl_Product]
           ([name]
           ,[image]
           ,[description]
           ,[price]
           ,[createDate]
           ,[category]
           ,[quantity]
           ,[status]
           )
     VALUES
           ('Coca'
           ,'./images/drink/coca.jpg'
           ,N'CoCa CoLa',
           5
           ,'2021-01-09 07:57:31.390'
           ,2
           ,15
           ,1
           )
GO
INSERT INTO [dbo].[tbl_Product]
           ([name]
           ,[image]
           ,[description]
           ,[price]
           ,[createDate]
           ,[category]
           ,[quantity]
           ,[status]
           )
     VALUES
           ('Cocktail'
           ,'./images/drink/cocktail.jpg'
           ,N'Mát lạnh người luôn',
           8
           ,'2021-01-09 07:58:29.377'
           ,2
           ,31
           ,1
           )
GO
INSERT INTO [dbo].[tbl_Product]
           ([name]
           ,[image]
           ,[description]
           ,[price]
           ,[createDate]
           ,[category]
           ,[quantity]
           ,[status]
           )
     VALUES
           ('Coffee'
           ,'./images/drink/coffee.jpeg'
           ,N'Uống cho tỉnh người nha',
           3
           ,'2021-01-09 07:59:18.190'
           ,2
           ,31
           ,1
           )
GO
INSERT INTO [dbo].[tbl_Product]
           ([name]
           ,[image]
           ,[description]
           ,[price]
           ,[createDate]
           ,[category]
           ,[quantity]
           ,[status]
           )
     VALUES
           ('USA Wine'
           ,'./images/drink/wine.jpg'
           ,N'Uống cái say luôn',
           4
           ,'2021-01-09 08:00:33.793'
           ,2
           ,31
           ,1
           )
GO
INSERT INTO [dbo].[tbl_Product]
           ([name]
           ,[image]
           ,[description]
           ,[price]
           ,[createDate]
           ,[category]
           ,[quantity]
           ,[status]
           )
     VALUES
           ('Italia Hot Wine'
           ,'./images/drink/wine2.jpg'
           ,N'Hot Hot uống liền miệng',
           7
           ,'2021-01-09 08:01:03.877'
           ,2
           ,31
           ,1
           )
GO
INSERT INTO [dbo].[tbl_Product]
           ([name]
           ,[image]
           ,[description]
           ,[price]
           ,[createDate]
           ,[category]
           ,[quantity]
           ,[status]
           )
     VALUES
           ('Carrot'
           ,'./images/vegetable/carrot.png'
           ,N'Ăn bổ mắt',
           2
           ,'2021-01-09 08:02:17.990'
           ,3
           ,31
           ,1
           )
GO
INSERT INTO [dbo].[tbl_Product]
           ([name]
           ,[image]
           ,[description]
           ,[price]
           ,[createDate]
           ,[category]
           ,[quantity]
           ,[status]
           )
     VALUES
           ('Pack Salad'
           ,'./images/vegetable/salad1.png'
           ,N'Ăn cho mau đi cầu',
           3
           ,'2021-01-09 08:02:51.730'
           ,3
           ,31
           ,1
           )
GO
INSERT INTO [dbo].[tbl_Product]
           ([name]
           ,[image]
           ,[description]
           ,[price]
           ,[createDate]
           ,[category]
           ,[quantity]
           ,[status]
           )
     VALUES
           ('Radish'
           ,'./images/vegetable/radish.jpg'
           ,N'Ăn cho mau lớn',
           2.5
           ,'2021-01-09 08:03:23.887'
           ,3
           ,31
           ,1
           )
GO
INSERT INTO [dbo].[tbl_Product]
           ([name]
           ,[image]
           ,[description]
           ,[price]
           ,[createDate]
           ,[category]
           ,[quantity]
           ,[status]
           )
     VALUES
           ('Red Radish'
           ,'./images/vegetable/radish2.jpg'
           ,N'Ăn cho mau lành máu',
           3.2
           ,'2021-01-09 08:04:11.973'
           ,3
           ,31
           ,1
           )
GO
INSERT INTO [dbo].[tbl_Product]
           ([name]
           ,[image]
           ,[description]
           ,[price]
           ,[createDate]
           ,[category]
           ,[quantity]
           ,[status]
           )
     VALUES
           ('Salad'
           ,'./images/vegetable/vegetable1.jpg'
           ,N'Ăn cho khỏe người',
           2.5
           ,'2021-01-09 08:05:12.337'
           ,3
           ,31
           ,1
           )
GO
INSERT INTO [dbo].[tbl_Product]
           ([name]
           ,[image]
           ,[description]
           ,[price]
           ,[createDate]
           ,[category]
           ,[quantity]
           ,[status]
           )
     VALUES
           ('Combo Salad'
           ,'./images/vegetable/vegetable2.jpg'
           ,N'Ăn chứ đói quá',
           4.5
           ,'2021-01-09 08:05:45.450'
           ,3
           ,31
           ,1
           )
GO
INSERT INTO [dbo].[tbl_Product]
           ([name]
           ,[image]
           ,[description]
           ,[price]
           ,[createDate]
           ,[category]
           ,[quantity]
           ,[status]
           )
     VALUES
           ('Beef'
           ,'./images/food/beef.jpg'
           ,N'Thịt bò sịn sò',
           10
           ,'2021-01-09 08:07:56.473'
           ,1
           ,31
           ,1
           )
GO
INSERT INTO [dbo].[tbl_Product]
           ([name]
           ,[image]
           ,[description]
           ,[price]
           ,[createDate]
           ,[category]
           ,[quantity]
           ,[status]
           )
     VALUES
           ('Bread'
           ,'./images/food/bread.jpg'
           ,N'Bánh mì Việt Nam',
           6
           ,'2021-01-09 08:08:49.767'
           ,1
           ,31
           ,1
           )
GO
INSERT INTO [dbo].[tbl_Product]
           ([name]
           ,[image]
           ,[description]
           ,[price]
           ,[createDate]
           ,[category]
           ,[quantity]
           ,[status]
           )
     VALUES
           ('USA Bread'
           ,'./images/food/bread2.jpg'
           ,N'Bánh mì Mĩ Tho',
           5.5
           ,'2021-01-09 08:09:16.900'
           ,1
           ,31
           ,1
           )
GO
INSERT INTO [dbo].[tbl_Product]
           ([name]
           ,[image]
           ,[description]
           ,[price]
           ,[createDate]
           ,[category]
           ,[quantity]
           ,[status]
           )
     VALUES
           ('Cookie'
           ,'./images/food/cookie.jpg'
           ,N'Cookie ăn cho sướng',
           6
           ,'2021-01-09 08:09:41.600'
           ,1
           ,31
           ,1
           )
GO
INSERT INTO [dbo].[tbl_Product]
           ([name]
           ,[image]
           ,[description]
           ,[price]
           ,[createDate]
           ,[category]
           ,[quantity]
           ,[status]
           )
     VALUES
           ('Italia Cookie'
           ,'./images/food/cookie3.jpg'
           ,N'Bành mì Ý',
           3.5
           ,'2021-01-09 08:10:13.500'
           ,1
           ,31
           ,1
           )
GO

INSERT INTO [dbo].[tbl_Product]
           ([name]
           ,[image]
           ,[description]
           ,[price]
           ,[createDate]
           ,[category]
           ,[quantity]
           ,[status]
           )
     VALUES
           ('Fish'
           ,'./images/food/fish1.jpg'
           ,N'Cá này ăn khỏi chê',
           6
           ,'2021-01-09 08:10:36.587'
           ,1
           ,31
           ,1
           )
GO
INSERT INTO [dbo].[tbl_Product]
           ([name]
           ,[image]
           ,[description]
           ,[price]
           ,[createDate]
           ,[category]
           ,[quantity]
           ,[status]
           )
     VALUES
           ('USA Hamburger'
           ,'./images/food/hamburger2.jpg'
           ,N'Ăn là no tới chiều',
           7.6
           ,'2021-01-09 08:11:13.570'
           ,1
           ,31
           ,1
           )
GO
INSERT INTO [dbo].[tbl_Product]
           ([name]
           ,[image]
           ,[description]
           ,[price]
           ,[createDate]
           ,[category]
           ,[quantity]
           ,[status]
           )
     VALUES
           ('Grilled Pork'
           ,'./images/food/pork.jpg'
           ,N'Thịt heo thất lạc',
           8
           ,'2021-01-09 08:11:43.493'
           ,1
           ,31
           ,1
          )
GO
INSERT INTO [dbo].[tbl_Product]
           ([name]
           ,[image]
           ,[description]
           ,[price]
           ,[createDate]
           ,[category]
           ,[quantity]
           ,[status]
          )
     VALUES
           ('Steak'
           ,'./images/food/steak.jpg'
           ,N'Steak ăn đã nghiền lo gì đói rét',
           10
           ,'2021-01-09 08:12:10.890'
           ,1
           ,31
           ,1
           )
GO