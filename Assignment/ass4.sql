create database StudentDB
	on primary
		(name='Student_dat', 
		filename='C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\Student_dat.mdf', 
		size=5, 
		filegrowth=10%, 
		maxsize=unlimited)
	log on 
		(name='Student_log', 
		filename='C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\Student_log.ldf', 
		size=2, 
		filegrowth=1, 
		maxsize=15)
go

USE StudentDB
go

create table tbStudents (
	Roll_no int identity(1,1) primary key nonClustered,
	fullname varchar(40) not null, 
	Grade varchar(1) not null check (Grade in('A', 'B', 'C')), 
	Sex varchar(6) not null default('Female'),
	Addresses VARCHAR(60),
	dob date,
)
go

SET DATEFORMAT DMY
insert tbStudents(fullname, Grade, Sex, Addresses, dob) values 
('Beck', 'A', 'Male', 'California','23-12-1986'),
('Wilson', 'B', 'Male', 'New Jersey','09-07-1988'),
('Leonard', 'C', 'Male', 'Ohio','17-12-1987'),
('Julia', 'A', 'Female', 'Chicago','31-01-1986'),
('Ringo', 'A', 'Male', 'Atlanta','18-12-1985'),
('Annie', 'C', 'Female', 'Washington','15-04-1988'),
('Sandra', 'C', 'Female', 'California','12-09-1986'),
('Tom', 'A', 'Male', 'Ohio','01-08-1987'),
('Susie', 'B', 'Female', 'California','03-12-1988'),
('Bob', 'B', 'Male', 'Washington','04-12-1987'),
('Rosy', 'C', 'Female', 'New York','05-03-1985')
go
select * from tbStudents
go

create table tbBatch (
	Batch_no varchar(10) primary key,
	Course_name varchar(40) not null, 
	Start_dates date,
)
go

SET DATEFORMAT DMY
insert tbBatch(Batch_no, Course_name, Start_dates) values 
('F2_1401','ACCP 2011','02-01-2014'),
('F2_1402','ACCP 2011','01-02-2014'),
('F2_1403','ACCP 2013 new','05-03-2014'),
('F3_1402','ACCP 2011','02-02-2014'),
('F3_1404','ACCP 2013 new','03-04-2014')
go
select * from tbBatch
go

create table tbRegister (
	Batch_no varchar(10) foreign key (Batch_no) references tbBatch(Batch_no),
	Roll_no int foreign key (Roll_no) references tbStudents(Roll_no),
	Comment varchar(100),
	Register_date date default(getdate()),
	primary key (Batch_no, Roll_no )
)
go

SET DATEFORMAT DMY
insert tbRegister(Batch_no, Roll_no, Comment, Register_date) values 
('F2_1401','2','how','24/09/2014'),
('F2_1403','3','old','18/07/2014'),
('F2_1402','4','are','13/06/2014'),
('F2_1401','5','you?','09/05/2014')
go
select * from tbRegister
go