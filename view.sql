use db2208_A0_teacher
go

--1. create info of school girl
create view vwSchoolGirl as
	select *
		from tbStudent
			where gender = 0
go

select * from vwSchoolGirl
go

--2. create view include info of school girl, age, leader name
-- way 1: from tbStudent
create view vwSchoolGirl_4 as
	select a.st_id, a.st_name, a.dob, year(getdate())-year(a.dob) [age], b.st_name [name]
		from tbStudent [a]
   left join tbStudent [b]
		  on a.leader_id = b.st_id
			where a.gender = 0
go
select * from vwSchoolGirl_4
go

-- way 2: from view
create view vwSchoolGirl_4x as
	select a.st_id, a.st_name, a.dob, year(getdate())-year(a.dob) [age], b.st_name [name]
		from vwSchoolGirl [a]
   left join tbStudent [b]
		  on a.leader_id = b.st_id
go
select * from vwSchoolGirl_4x
go

--3. create view include exam result, contain student name and module name
create view vwExam as
	select a.id, a.student [ma sv], b.st_name, c.module_name, a.mark
		from tbStudentModule [a] 
		join tbStudent [b]
		  on a.student = b.st_id
		join tbModule [c]
		  on a.module = c.module_id
go
select * from vwExam



--4. insert data: add 1 school girl into view vwSchoolGirl
insert vwSchoolGirl values 
('S30','Baby Girl', 0,'2022-12-21','S01')
go
select * from vwSchoolGirl

--5. Update data: change leader id 
update vwSchoolGirl
	set leader_id = 'S11'
	where st_id = 'S30'
go
select * from tbStudent -- Update table (not view)

--6. delete data: remove school girl 'Baby Girl'
delete from vwSchoolGirl
	where st_name = 'Baby Girl'
go

--7. See view creation statement
exec sp_helptext vwSchoolGirl
exec sp_helptext vwSchoolGirl_4
exec sp_helptext vwSchoolGirl_4x
go

--8, 9. alter-check option: add a school boy into vwSchoolGirl
alter view vwSchoolGirl as
	select *
		from tbStudent
			where gender = 0
	with check option
go

insert vwSchoolGirl values
('S31','Baby Boy',1,'2005-12-14','S01') --Cause error because just be able to insert school girl into vwSchoolGirl
go 

--10. schemabiding

--11. generate view employee contain columns: id, name, date of birth, gender
alter view vwEmployeeE
with schemabinding as
select e_id [id], e_name [name], dob [date of birth], 
	   case when gender = 1 
			then 'male' 
			else 'female' 
			end [gender]
	from tbEmployee
go

