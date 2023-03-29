use db2208_A0_teacher
go

/*
1. create stored procedure to do:
	- view list of school girl
	- count number of school girl
*/
create proc up_schoolGirl as
begin
	select a.st_id, a.st_name, a.dob, year(getdate())-year(a.dob) [age], b.st_name [name]
			from vwSchoolGirl [a]
	   left join tbStudent [b]
			  on a.leader_id = b.st_id

	select @@ROWCOUNT [numberOfSchoolGirl] -- @@rowcount return number of row of the privious statement (the last select)
end
go

-- test case: call store
exec up_schoolGirl
go

select * from tbModule
go


/*
	2. create stored procedure to do:
		- view list of subject
		- increase fee by 10%
		- review list of subject
		- get the highest fee
*/
create proc increase_fee as
begin
	select * from tbModule

	update tbModule
		set fee = fee*1.1

	select * from tbModule

	select top 1 *
		from tbModule
		order by fee desc
end
go

exec increase_fee
go