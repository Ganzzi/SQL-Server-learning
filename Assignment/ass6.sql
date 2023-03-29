create database ass6
go

use ass6
go

create table Monhoc(
	MSMH varchar(3) primary key,
	TENMH varchar(20) not null,
	SOTINCHI int not null default(3),
	TINHCHAT INT check(TINHCHAT in (1,0))
)

create table Lop(
	MALOP varchar(3) primary key,
	TenLop varchar(10) not null,
	SiSo int not null
)

create table SinhVien(
	MSSV varchar(10) primary key,
	Hoten varchar(30) not null,
	NgaySinh date not null,
	MALOP varchar(3) foreign key (MALOP) references Lop(MALOP)
)

create table Diem(
	MSMH varchar(3) foreign key (MSMH) references Monhoc(MSMH),
	MSSV varchar(10) foreign key (MSSV) references SinhVien(MSSV),
	Diem int not null,
	primary key (MSMH, MSSV)
)

insert Monhoc(MSMH, TENMH, SOTINCHI, TINHCHAT) values 
('S1','Toan', 3, 1),
('S2','Van',5,1),
('S3','Hoa',6,0),
('S4','Ly',4,1),
('S5','Dia',3,0)

insert Lop(MALOP, TenLop, SiSo) values 
('C1','C2209.1', 40),
('C2','C2209.2', 42),
('C3','C2209.3', 40),
('C4','C2209.4', 42),
('C5','C2209.5', 40)

SET DATEFORMAT DMY
INSERT SinhVien(MSSV, Hoten, NgaySinh, MALOP) values
('ST1', 'Duy', '18-12-1985', 'C1'),
('ST2', 'An', '23-12-1986', 'C2'),
('ST3', 'Nguyen', '09-07-1988', 'C5'),
('ST4', 'Trinh', '17-12-1987', 'C3'),
('ST5', 'Tran', '31-01-1986', 'C4')

insert Diem(MSSV, MSMH, Diem) values 
('ST1', 'S1', 9),
('ST2', 'S1', 8),
('ST3', 'S1', 7),
('ST4', 'S1', 10),
('ST5', 'S1', 9)

alter table SinhVien
	ADD gioitinh varchar(1) check (gioitinh in ('F', 'M'))


SELECT TOP 2 * FROM Monhoc
	WHERE TINHCHAT = 1
	order by SOTINCHI desc

	select a.MSSV, a.Hoten, a.MALOP, b.Diem
		from SinhVien [a]
		join Diem [b]
		  on a.MSSV = b.MSSV
		WHERE b.MSMH = 'S1'

select top 1 * 
	from Diem
	where MSMH = 'S1'
	order by Diem desc

select MSSV, Diem
	from Diem
	where MSSV = 'ST2'

	SELECT * FROM SinhVien	SELECT * FROM Monhoc	SELECT * FROM Lop	SELECT * FROM Diem

