use db2208_A0_teacher
GO

-- 
SELECT year(dob) N'nam sinh', count(*) [so sinh vien] 
	from tbStudent
	group by year(dob)
	having count(*) >=4
go

-- view student's test result
select * from tbStudentModule 
	order by student

-- calculate each subject's average point
select module, AVG(mark) [diem bq] from tbStudentModule 
	group by module

-- change student table's structure: add a column have No increase automatically, also be primary key
alter table tbStudentModule
	add id int identity(1,1) not null primary key nonclustered
go

-- add exam mark
insert tbStudentModule(student, module, mark) values
('S02', 'M01', 60),
('S01', 'M02', 93),
('S03', 'M01', 60),
('S04', 'M01', 90),
('S05', 'M01', 60)

-- CALCULATE AVERAGE POINT OF EACH STUDENT
Select student, module, AVG(mark) [diem binh quan], count(*) [so lan thi]
	from tbStudentModule
	group by student, module with cube

-- without with cube
Select student, module, AVG(mark) [diem binh quan], count(*) [so lan thi]
	from tbStudentModule
	group by student, module 

-- find youngest students
select * from tbStudent 
	where year(dob) = (select max(year(dob)) [nam sinh] from tbStudent)
	order by dob desc


-- find top mark students
select * from tbStudentModule 
	where mark = (select max(mark) [diem] from tbStudentModule)
	order by mark desc

-- find bottom mark students
select * from tbStudentModule 
	where mark = (select min(mark) [diem] from tbStudentModule)


-- JOIN
select b.id, c.module_name,a.st_id, a.st_name, a.gender, b.module, b.mark  
		from tbStudentModule [b]
		join tbStudent [a] 
		  on a.st_id = b.student
		join tbModule [c]
		  on b.module = c.module_id

-- view list of subject hold
select *
		 from tbModule [a] 
	left join tbStudentModule [b] 
		   on a.module_id = b.module
		where b.mark is not null

-- view list of subject not having mark
select *
		 from tbModule [a] 
	left join tbStudentModule [b] 
		   on a.module_id = b.module
		where b.mark is null

-- SELF JOIN
select a.*, b.st_name [leader name]
	from tbStudent [a]  join tbStudent [b]
	  on a.leader_id = b.st_id

select a.*, b.st_name [leader name]
	from tbStudent [a]  left join tbStudent [b]
	  on a.leader_id = b.st_id


-- list of student take in m1,2,3
select distinct module, student
	from tbStudentModule
	where module in('M01', 'M02', 'M03')
	order by student

select distinct student
	from tbStudentModule
	where module like 'm01'
intersect -- giao
select distinct student
	from tbStudentModule
	where module like 'm02'

-- CTE Example
with ds_thi as (
	select distinct student
		from tbStudentModule
		where module like 'm01'
	intersect -- giao
	select distinct student
		from tbStudentModule
		where module like 'm02'
)
select a.*
	from tbStudent [a] join ds_thi [b] on a.st_id = b.student
