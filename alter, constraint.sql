use db2208_A0_teacher
go

/*
	1. create employee table, contains:
	- e_id: employee's id, number increase automatically start from 1
	- e_name: employee's name (can be unicode): nvarchar(30)
	- dob: date of birth, date
	- gender: gender, bit (0,1)
	- salary: basic salary, int
*/
create table tbEmployee (
	e_id int identity(1,1) primary key nonClustered,
	e_name nvarchar(30) not null,
	dob date,
	gender bit not null,
	salary int 
)
go

-- insert data
SET DATEFORMAT DMY
insert tbEmployee(e_name, dob, gender, salary) values 
(N'Nguyễn Trịnh Duy An', '18-09-2004', 1, 200),
(N'Trần Đăng Khoa', '22-04-2003', 1, 300) 
select * from tbEmployee
go

SET DATEFORMAT DMY
insert tbEmployee values 
(N'Nguyễn kim Ngọc', '16-05-2004', 0, 800),
(N'Trần Mĩ Chi', '22-08-2005', 0, 750) 
select * from tbEmployee
go

-- re-edit structure of table: 
alter table tbEmployee
	add constraint df_gender 
		default 1 for gender
go

SET DATEFORMAT DMY
insert tbEmployee(e_name, dob, salary) values 
(N'Nguyễn Trãi', '16-05-2004', 800),
(N'Trần Văn Biên', '22-08-2005', 750) 
select * from tbEmployee
go

-- 3 add two foreign keys into module&student
alter table tbStudentModule
	add constraint fk_student 
		foreign key (student) 
			references tbStudent(st_id)
go

alter table tbStudentModule
	add constraint fk_module
		foreign key (module) 
			references tbModule(module_id)
go

-- 4 add check constraint for column mark [0-100]
alter table tbStudentModule
	add constraint ck_mark
		check (mark between 0 and 100)
go

-- 5 test how check constraint run
-- 1. see mark result
select * from tbStudentModule
-- 2. add 1 result with mark 101
insert tbStudentModule values ('S21', 'M03', 100)

-- 6 rectify data in tbStudent
select * from tbStudent
update tbStudent
	set st_name = 'Nguyen Thi Thanh Tuan'
	where st_id like 'S19'
go 

-- 7. delete one employee in table tbEmployee
delete from tbEmployee where year(dob) = 2003
select * from tbEmployee

