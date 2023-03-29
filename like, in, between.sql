/* open batabase */
use db2208_A0_teacher
go

--view all from tbstudent
select * from tbStudent

--query data with words LIKE, IN, BETWEEN
-- Find student with last name 'vo'
select * from tbStudent where st_name LIKE 'vo %'
-- Find student with middle name 'van'
select * from tbStudent where st_name LIKE '% van %'
-- Find student with name start with 't'
select * from tbStudent where st_name LIKE '% % t%' 
-- Find student with year of birth 2000-2004
select * from tbStudent where YEAR(dob)>=2000 and Year(dob) <=2003
select * from tbStudent where YEAR(dob) between 2000 and 2003


-- Find students of group that have leader's is is 's01' and 's07' 
select * from tbStudent 
	where leader_id LIKE 's01' 
		or leader_id LIKE 's07' 
		or st_id like 's01' 
		or st_id like 's07'
select * from tbStudent 
	where leader_id IN ('s01' , 'S07') or st_id IN ('s01','s07')
go

-- list of students above 18 
declare @18year int
	set @18year = YEAR(getdate()) - 18
select * from tbStudent where YEAR(dob) = @18year 
go

select * from tbStudent where month(dob) = month(getdate())

select * from tbStudent
	where DATEDIFF(yy, dob, getdate()) = 18

select st_id [ma so], st_name [ho ten],
	case gender
		when 1 then 'nam'
		else 'nu'
	end [gioi tinh], dob [sinh nhat]
	from tbStudent
	where DATEDIFF(yy, dob, getdate()) = 18


