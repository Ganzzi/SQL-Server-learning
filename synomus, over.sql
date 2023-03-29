USE [db2208_A0_teacher]
GO

/****** Object:  Synonym [dbo].[student]    Script Date: 12/26/2022 5:02:12 PM ******/
CREATE SYNONYM [dbo].[student] FOR [db2208_A0_teacher].[dbo].[tbStudentModule]
GO
 
select student, module, 
		avg(mark) over (partition by student, module) [diembq],
		count(mark) over (partition by student, module) [so lan thi]
	from dbo.student
