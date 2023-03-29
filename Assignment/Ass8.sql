create database Ass8
go

use Ass8
go

create table tbKhachHang(
	MaKH varchar(3) primary key,
	Hoten varchar(30) not null,
	DiaChi varchar(30) not null
)
go

create table tbMatHang(
	MaMH varchar(3) primary key,
	TenMH varchar(30) not null,
	DonVi varchar(10) not null,
	DonGia int not null
)
go

create table tbDonHang(
	MaDH varchar(3) primary key,
	MaKH varchar(3) Foreign key (MaKH) references tbKhachHang(MaKH),
	NgayDat date,
	DaThanhToan bit
)
go

create table tbCTDonHang(
	MaMH varchar(3) Foreign key (MaMH) references tbMatHang(MaMH),
	MaDH varchar(3) Foreign key (MaDH) references tbDonHang(MaDH),
	SoLuong int
)
go

SELECT * FROM tbDonHang

insert tbKhachHang (MaKH, Hoten, DiaChi) values 
('C01','An','Hue'),
('C02','Bao','Lao'),
('C03','Ky','Loi')
go

insert tbMatHang(MaMH, TenMH, DonVi, DonGia) values
('P01', 'COCA', 'LON', 2),
('P02', 'PEPSI', 'CAI', 5),
('P03', 'KEO', 'GOI', 3),
('P04', 'CAKE', 'KG', 4),
('P05', 'SUA', 'LON', 13)
GO

set dateformat DMY
INSERT tbDonHang(MaDH, MaKH, NgayDat, DaThanhToan) values
('1', 'C01', '15-10-2014', 1),
('2', 'C01', '15-10-2014', 0),
('3', 'C02', '15-10-2014', 1),
('4', 'C03', '15-10-2014', 0),
('5', 'C02', '15-10-2014', 0)
GO

INSERT tbCTDonHang(MaDH, MaMH, SoLuong) values
('1', 'P02', 5),
('1', 'P03', 1),
('2', 'P01', 10),
('3', 'P05', 2),
('3', 'P04', 2),
('3', 'P03', 1),
('4', 'P03', 2),
('5', 'P01', 12),
('5', 'P03', 3)
GO

select * from tbDonHang 
	where year(NgayDat) < year(getdate()) - 1
go

select MaMH, count(*) [soluong] from tbCTDonHang
	group by MaMH
go

create view vwDH AS
select * from tbDonHang 
	where DaThanhToan=0 and day(getdate())-day(NgayDat)>30

select * from vwDH
go

create proc uspKH 
@hoten varchar(30)
as
begin
	select * from tbKhachHang
		where Hoten = @hoten
end
go

exec uspKH 'An'
go

create proc uspMH
as
begin
	update tbMatHang
	set DonGia=DonGia*1.1
end
go
exec uspMH 
go
select * from tbMatHang