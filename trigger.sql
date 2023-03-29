
select * from tbStudentModule order by student, module
go

/*
	Write trigger in table with rule: not allow inserting mark of one module greater than 3 each student
	-> trigger: insert, update, 
*/
create trigger tg_mark on tbStudentModule
	for insert, update as
	begin
		declare @masv varchar(5), @msmh varchar(5)
		select @masv=student, @msmh=module from inserted
		select *
			from tbStudentModule 
				where student like @masv and module like @msmh
		if @@ROWCOUNT > 5
			begin
				rollback --cancel insert, update
				print 'Impossible to insert mark more than 3 times'
			end
	end
go

insert tbStudentModule values 
('S03', 'M01', 15)

select * from tbStudentModule where student like 'S03' and module like 'M01'
go



/*
	write trigger: not allow changing eid
*/


create trigger tg_employee on tbEmployee
	after update as 
	begin 
		if update(gender)
			begin 
				rollback
				print 'Impossible to change employee id'
			end
	end
go

-- test case 1:
update tbEmployee set salary = 1234 where e_id = 8
select * from tbEmployee
go
-- test case 2:
update tbEmployee set gender = 0 where e_id=8
select * from tbEmployee
go




/*
	Write trigger in table with rule: not allow deleting employee name an
	-> trigger: DELETE 
*/

create trigger tg_deleteName on tbEmployee
for delete as 
	begin
		select * from deleted where e_name like N'% an'
		if @@ROWCOUNT > 0 
			begin
				rollback
				print 'Impossible to delete employee naming as an'
			end
	end
go

--test case 1:
delete from tbEmployee where e_name like N'% anh'

--test case 2:
delete from tbEmployee where e_name like N'% an'

select * from tbEmployee




/*
	Write instead of trigger in table: when delete a student, also delete this student's mark
	-> type: instead of delete
*/ go

create trigger tg_student_delete on tbStudent
instead of delete as -- trigger when delete statement happen
	begin
		-- remove mark (foreign key)
		delete from tbStudentModule 
			where student in (select st_id from deleted)

		-- remove student
		delete from tbStudent
			where st_id in (select st_id from deleted)
	end
go

select * from tbStudent
select * from tbStudentModule
delete from tbStudent where st_id = 'CR7'



--  view defination of trigger tg_student_delete
sp_helptext tg_student_delete
go

