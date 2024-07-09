
------------------------------- create exam -----------------------------------------

-- 1) method 1 : craete exam and pick questions randomly
go
exec create_exam 
@instructor_id = 1, 
@course_id = 1, 
@exam_type = 'Exam',
@start_time = '2024-01-11 13:44:00',
@end_time = '2024-01-11 14:50:00',
@duration = '00:30:00',
@allowance = 1,
@numOfMCQquestions = 2,
@numOfTFquestions = 2,
@numOfTextquestions =2

select * from viewExamsQuestions 

-- method 2 : craete exam and pick questions manually 
--select * from [dbo].[getAllCourseQuestions](1)
begin
	SET NOCOUNT ON;
	declare @choosedMcqQuestions idsArray;
	insert into @choosedMcqQuestions values (5),(6),(7)

	declare @choosedTrueFalseQuestions idsArray;
	insert into @choosedTrueFalseQuestions values (28),(29),(30)

	declare @choosedTextQuestions idsArray;
	insert into @choosedTextQuestions values (41),(42),(44)
end
exec create_exam_manually 
@instructor_id = 1, 
@course_id = 1, 
@exam_type = 'exam',
@start_time = '2024-01-11 13:50:00',
@end_time = '2024-01-11 14:30:00',
@duration = '00:30:00',
@allowance = 1,
@mcqQustions = @choosedMcqQuestions,
@trueOrFlaseQustions = @choosedTrueFalseQuestions,
@textQustions = @choosedTextQuestions

select * from viewExamsQuestions 

------------------------------- select students who can do the exam -----------------------------------------

-- method 1 : using procedure to select all students in a specific course
GO
exec select_all_students_in_course_for_exam
@course_id = 1,
@intructor_id = 1
select * from student

-- method 2: using procedure to select specific students
begin
	--SET NOCOUNT ON;
	declare @selectedStudents idsArray;
	insert into @selectedStudents values (1),(2),(3),(4)
end
execute select_students_for_exam
@students_ids = @selectedStudents,
@intructor_id = 1
-- select * from Student
-- update Student set instructor_id = null


------------------------------- Instructor can edit Questions degrees for the exam ---------------------------------
select * from viewExam(1)
--select * from viewExamsQuestions

declare @questions_degrees as exam_questions_degrees_Array -- user defined type
insert into @questions_degrees values
(3,2), (13,2) , (30,3) , (35,5) ,(44,5) ,(50,5)
execute put_exam_questions_degrees
@instructor_id = 1,
@exam_id = 1,
@exam_questions_degrees = @questions_degrees

------------------------------- Student Enter Exam -----------------------------------------

	--1 check whether he allowed or not
	--2 check whether he enters in the specified date and time
	--3 start timer
begin try
	execute enterExam
	@exam_id = 5,
	@student_id = 1;
end try
begin catch
   declare @error varchar(50);
   select @error = 'Exam Has been already started!!';
   print 'Error : '+ @error;
 end catch

 --select * from viewExam(5)


 ------------------------------- Student solve Exam and submit it -----------------------------------------
GO
declare @answers student_answers_type
insert into @answers values 
(4,'a'),
(13,'c'),
(21,'a'),
(38,'b'),
(41,'class selector'),
(47,'<meta> tag')
execute save_student_answer 
@student_answers = @answers,
@exam_id = 5,
@student_id = 1

GO

select * from dbo.view_Student_Question_Answers where student_id = 1

 ------------------------------- Student see his total correct answers -----------------------------------------
 declare @student_id int 
 set @student_id = 1

  declare @exam_id int 
 set @exam_id = 5

 select dbo.calc_total_correct_answers_in_exam (@student_id,@exam_id) as Total_correct_answers

 ------------------------------- Student see his total course degree -----------------------------------------
Go

declare @student_id int 
set @student_id = 1

declare @course_id int 
set @course_id = 1
select dbo.calc_total_degrees(@student_id,@course_id) as Total_Student_Course_degree
