create database Ass5_db
	on primary 
		(name='Ass5',
		filename='C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\Ass5.mdf',
		size=5,
		maxsize=5,
		filegrowth=10%)
	log on
		(name='Ass5_lg',
		filename='C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\Ass5_lg.mdf',
		size=2,
		maxsize=2,
		filegrowth=10%)
go

use Ass5_db
go

create table tbCustomer(
	CusId varchar(3) primary key,
	FullName varchar(30),
	CusAddress varchar(30),
	Phone varchar(11)
)
go

create table tbCategory (
	CatId varchar(5) primary key,
	CatName varchar(30)
)
go

create table tbProduct(
	ProId varchar(5) primary key,
	ProName varchar(30),
	UnitPrice int not null, --check (between 1 and 200)
	Unit varchar(10),
	CatId varchar(5) foreign key (CatId) REFERENCES tbCategory(CatId)
)
go

create table tbOrder(
	OrderId int identity(300,1) primary key nonClustered,
	OrderDate date default(getdate()),
	Comment varchar(100),
	CusId varchar(3) foreign key (CusId) references tbCustomer(CusId)
)
go

create table tbOrderDetail(
	OrderId int foreign key (OrderId) references tbOrder(OrderId),
	ProId varchar(5) foreign key (ProId) references tbProduct(ProId),
	Quantity int default(1),
	primary key(OrderId, ProId)
)
go

insert tbCustomer(CusId, FullName, CusAddress, Phone) values
('C01' , 'Lyly Tran', 'No Trang Long', '113'),
('C02' , 'Alex Pham', 'Nguyen Trai', '911'),
('C03' , 'Rose Nguyen', 'Pham ngu Lao', '1080'),
('C04' , 'Alan Pham', 'Nguyen Tri Phuong', '118')
go

insert tbCategory(CatId, CatName) values
('FO','Food'),
('BE','Beverage'),
('OT','Other')
GO

INSERT tbProduct(ProId, ProName, UnitPrice, Unit, CatId) values
('P01','Coca Cola', 2.5,'can','BE'),
('P02','Beer 333', 4,'can','BE'),
('P03','Chocalate', 9,'pack','FO'),
('P04','Chocopie Cake', 4,'pack','FO'),
('P05','Cheese', 10,'pack','FO'),
('P06','Sampoo', 8,'bottle','OT')
go

set dateformat DMY
INSERT tbOrder( OrderDate, Comment, CusId) values
('30-08-2014', 'Nothing','C01'),
('31-10-2014', 'Nothing','C01'),
('07-11-2014', 'Nothing','C03'),
('07-11-2014', 'Nothing','C02')
go

INSERT tbOrderDetail( OrderId, ProId, Quantity) values
(300,'P01', 3),
(300,'P03', 1),
(301,'P02', 8),
(301,'P03', 1),
(301,'P05', 15),
(302,'P06', 5),
(303,'P02', 4)
go

select * from tbCategory
select * from tbProduct
select * from tbCustomer
select * from tbOrder
select * from tbOrderDetail

--4a. display list of customers
select * from tbCustomer

--4b. display list of products, order by unit-price
select * from tbProduct 
	order by UnitPrice

--4c. display list of orders including orderid, order-date, customer name, product name, quantity, unit, unit price, amount.
select a.OrderId, b.OrderDate, c.FullName, d.ProName, a.Quantity, d.Unit, d.UnitPrice, (d.UnitPrice*a.Quantity) [Amount]
	from tbOrderDetail [a]
	join tbOrder [b]
	  on a.OrderId = b.OrderId
	join tbCustomer [c]
	  on b.CusId = c.CusId
	join tbProduct [d]
	  on a.ProId = d.ProId


--4d. display list of products belonged to category FO.
select * from tbProduct 
	where CatId='FO'

--4e. count products belonged to each category.
select CatId, count(*) [products] 
	from tbProduct 
	group by CatId


--4f. display detail of customer in the order having order number is 302.
select a.OrderId, b.*
	from tbOrder [a]
	join tbCustomer [b]
	  on a.CusId = b.CusId
	where a.OrderId=302

--4g. display list of orders having more than two items.
select *
	from tbOrderDetail
	where Quantity > 2

--4h. display the top two best-selling products (accounting for quantity)
SELECT TOP 2 * FROM tbOrderDetail
order by Quantity desc
