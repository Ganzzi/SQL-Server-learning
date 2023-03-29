create database Ass10_Db
	on primary
		(name='Ass10', 
		filename='C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\Ass10.mdf', 
		size=5, 
		filegrowth=10%, 
		maxsize=50),
	filegroup Group1
		(name='Ass10_1', 
		filename='C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\Ass10_1.ndf', 
		size=10, 
		filegrowth=5, 
		maxsize=unlimited)
	log on 
		(name='Ass10_log', 
		filename='C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\Ass10_log.ldf', 
		size=2, 
		filegrowth=10%, 
		maxsize=unlimited)
go

use Ass10_Db
go

create table tbCustomer
(
	CustCode VARCHAR(5) not null primary key nonclustered,
	CustName varchar(30) not null,
	CustAddress varchar(50) not null,
	CustPhone varchar(15) ,
	CustEmail varchar(25),
	CustStatus varchar(10) default('Valid') check(CustStatus in ('Valid', 'Invalid')),
)
go

create table tbMessage
(
	MsgNo int identity(1000,1) primary key nonclustered,
	CustCode varchar(5) foreign key (CustCode) references tbCustomer(CustCode),
	MsgDetails varchar(300) not null,
	MsgDate datetime not null default(getdate()),
	Statuses varchar(10) check(Statuses in ('Pending', 'Resolved'))
)
go

insert tbCustomer(CustCode,CustName,  CustAddress,CustPhone,CustEmail,CustStatus ) values
('C001','Rahul Khana','7th Cross Road','298345878','khannar@hotmail.com','Valid'),
('C002','Anil Thakkar','Line Ali Road','657654323','Thakkar2002@yahoo.com','Valid'),
('C004','Sanjay Gupta','Link Road','367654323','SanjayG@indiatimes.com','Invalid'),
('C005','Sagar Vyas','Link Road','376543255','Sagarvyas@india.com','Valid')
go

set dateformat DMY
insert tbMessage (CustCode, MsgDetails, MsgDate, Statuses) values 
('C001','Voice mail always give ACCESS DENIED message','31-Aug-2014','Pending'),
('C005','Voice mail activation always give NO ACCESS message','1-Sep-2014','Pending'),
('C001','Please send all future bill to my residential address instead of my office address','5-Sep-2014','Resolved'),
('C004','Please send new monthly brochure ...','8-Nov-2014','Pending')
GO

select * from tbCustomer
select * from tbMessage

create clustered index IX_Name on tbCustomer(CustName)
go

create index IX_CustMsg on tbMessage(CustCode, MsgNo)
go

select a.*
	from tbCustomer [a]
	left join tbMessage [b]
	on a.CustCode = b.CustCode
	where b.MsgDetails is null
go
-- or
select * from tbCustomer where CustCode not in (select distinct CustCode from tbMessage)
go

alter view vReport with encryption as
	select a.MsgNo, a.MsgDetails, a.MsgDate [DatePosted], b.CustName [PostBy], a.Statuses [Status]
		from tbMessage [a]
		join tbCustomer [b]
		on a.CustCode = b.CustCode
		where a.MsgDate>='1-Sep-2014'  -- getdate() - MsgDate <= getdate() - '1-Sep-2014'
go
select * from vReport
go

alter proc uspChangeStatus as
begin
	update  tbCustomer 
		set CustStatus = 'Valid'
	where CustStatus like 'Invalid'
	select @@ROWCOUNT [so record changed]
end
go

exec uspChangeStatus
select * from tbCustomer
go

alter proc uspCountStatus 
@status varchar(10), @numberOfMessage int output
as
	begin
		select *, @@ROWCOUNT [number of rows] from tbMessage where Statuses like @status
	end
go

declare @rows int
exec uspCountStatus 'Resolved', @rows output
go

create trigger tgCustomerInvalid on tbCustomer
for insert as
	begin
		if(select CustStatus from inserted) = 'Invalid'
			begin
				rollback
				print 'imposible to add customer with status `Invalid`'
			end
	end
go

-- test case 1:
insert tbCustomer values 
('C006','Messi','7th Portuga','298345878','messi@hotmail.com','Invalid')
go

-- test case 2:
insert tbCustomer values 
('C006','Messi','7th Portuga','298345878','messi@hotmail.com','Valid')
go

select * from tbCustomer
go

create trigger tgCustomer on tbCustomer 
for delete as
	begin
		delete from tbMessage where CustCode = (select CustCode from deleted)
	end
go



select * from tbCustomer
select * from tbMessage