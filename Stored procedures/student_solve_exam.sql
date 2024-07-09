
begin try
	execute enterExam
	@exam_id = 3,
	@student_id = 1;
end try
begin catch
   declare @error varchar(50);
   select @error = 'Exam Has been already started!!';
   print 'Error : '+ @error;
 end catch


select * from viewExam(3)

Go
begin try
declare @answers student_answers_type
insert into @answers values 
(7,'a'),
(19,'c'),
(31,'a'),
(35,'b'),
(42,'class selector'),
(48,'<meta> tag')
execute save_student_answer 
@student_answers = @answers,
@exam_id = 3,
@student_id = 1
end try
begin catch
   declare @error varchar(50);
   select @error = 'Answers Has been already Submitted!!';
   print 'Error : '+ @error;
end catch
GO

--delete from [Student_Question_Answer]
-- delete from student_exam
--select * from [dbo].[Student_Question_Answer]
--select * from Student_Exam
--select * from viewExamsQuestions 
--select * from exam

