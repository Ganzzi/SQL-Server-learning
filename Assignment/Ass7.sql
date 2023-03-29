
create database ASM7 
	on primary 
		(name='asm7',
		filename='C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\asm7.mdf',
		size=10,
		filegrowth=20%,
		maxsize=15),
	filegroup MyFileGroup
		(name='asm7_1',
		filename='C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\asm7_1.ndf',
		size=10,
		filegrowth=20%,
		maxsize=15)
go

use ASM7
go

create table tbBatch (
	BatchNo varchar(10) primary key,
	Size int,
	TimeSlot varchar(20),
	RoomNo varchar(10)
)
go

create table tbStudent (
	RollNo varchar(10) Primary key,
	LastName varchar(20) not null,
	FirstName varchar(20) not null,
	Gender varchar(1) not null default('M') CHECK(Gender in  ('F','M')),
	DOB date,
	[Address] VARCHAR(40),
	EnrollYear smallint not null default(year(getdate())),
	BatchNo varchar(10) foreign key (BatchNo) references tbBatch(BatchNo)
)
go

-- create check constraint
alter table tbBatch
	add constraint Size
		check (Size < 6 and Size >= 0)
go

alter table tbStudent
	add constraint yearEnter
		check (EnrollYear >= 2000)
go

insert tbBatch(BatchNo,Size,TimeSlot,RoomNo ) values 
('B1', 1,'T1','R1'),
('B2', 2,'T2','R2'),
('B3', 3,'T3','R3'),
('B4', 4,'T4','R4')
GO

INSERT tbStudent(RollNo, LastName, FirstName, Gender, DOB, [Address], EnrollYear, BatchNo) values
('R4','L1','F1','F','2001-09-18','123 ABC', 2002,'B3'),
('R5','L1','F1','F','2001-09-18','123 ABC', 2002,'B1'),
('R6','L1','F1','M','2001-09-18','123 ABC', 2002,'B4'),
('R7','L1','F1','M','2001-09-18','123 ABC', 2002,'B4'),
('R8','L1','F1','F','2001-09-18','123 ABC', 2002,'B1'),
('R9','L1','F1','M','2001-09-18','123 ABC', 2002,'B2')
GO

SELECT * FROM tbStudent
	ORDER BY Gender, DOB
GO

SELECT Gender, COUNT(*) [STUDENTS] FROM tbStudent 
	GROUP BY Gender
GO

SELECT b.RollNo, b.LastName + b.FirstName [fullname], b.Gender, b.DOB, b.[Address], a.BatchNo, a.RoomNo 
	FROM tbBatch [a]
	join tbStudent [b]
	  on a.BatchNo = b.BatchNo
	where (year(getdate())-YEAR(b.DOB)>18)
go

create view vwSchoolBoy as 
	SELECT b.RollNo, b.LastName + b.FirstName [fullname], b.Gender, year(getdate()) - year(b.DOB) [age],  a.BatchNo
		FROM tbBatch [a]
		join tbStudent [b]
		  on a.BatchNo = b.BatchNo
		where b.Gender='M'
go
SELECT * FROM vwSchoolBoy
go

create view vwNewStudent as 
	SELECT b.RollNo, b.LastName + b.FirstName [fullname], b.Gender, year(getdate()) - year(b.DOB) [age],  a.BatchNo
		FROM tbBatch [a]
		join tbStudent [b]
		  on a.BatchNo = b.BatchNo
		where b.EnrollYear = year(getdate())
go
SELECT * FROM vwNewStudent
go