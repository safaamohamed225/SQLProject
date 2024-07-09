use [Examination_System]


create sequence Exam_Question_sequence
	start with 1
	increment by 1;

--select next value for Exam_sequence
--alter sequence Exam_sequence restart with 1

--function to get all course questions
GO
create or alter function getAllCourseQuestions (@course_id int)
returns table as return
(select * from Question where course_id = @course_id)
GO

--function to get MCQ course questions
GO

create or alter function getCourseQuestions_MCQ (@course_id int)
returns table as return
(select * from Question where course_id = @course_id and type = 'MCQ')
GO

--function to get True/False course questions
GO

create or alter function getCourseQuestions_TF (@course_id int)
returns table as return
(select * from Question where course_id = @course_id and type = 'True/False')
GO

--function to get text course questions
GO

create or alter function getCourseQuestions_Text (@course_id int)
returns table as return
(select * from Question where course_id = @course_id and type = 'Text')
GO

--select * from getAllCourseQuestions(1)
--select * from getCourseQuestions_MCQ(1)
--select * from getCourseQuestions_TF(1)

GO
create or alter procedure create_exam 
@instructor_id int, 
@course_id int, 
@exam_type nvarchar(10),
@start_time datetime,
@end_time datetime,
@duration time,
@allowance bit,
@numOfMCQquestions int,
@numOfTFquestions int,
@numOfTextquestions int
as 
begin
	SET NOCOUNT ON;
	-- Get courses that Instructor teaches
	declare @instructor_courses_ids as table(course_id int)
	insert into @instructor_courses_ids
	select course_id from [dbo].[Course_Instructor] where [instructor_id] = @instructor_id
	if @course_id in (select * from @instructor_courses_ids)
	begin
		declare @MCQ_questions_ids as table(question_id int)
		insert into @MCQ_questions_ids
		exec ('select top '+@numOfMCQquestions+' question_id from dbo.getCourseQuestions_MCQ('+@course_id+') order by NEWID()')

		declare @true_false_questions_ids as table(question_id int)
		insert into @true_false_questions_ids
		exec ('select top '+@numOfTFquestions+' question_id from dbo.getCourseQuestions_TF('+@course_id+') order by NEWID()')

		declare @text_questions_ids as table(question_id int)
		insert into @text_questions_ids
		exec ('select top '+@numOfTextquestions+' question_id from dbo.getCourseQuestions_Text('+@course_id+') order by NEWID()')

		declare @exam_questions_ids as table (question_id int)

		insert into @exam_questions_ids
		select question_id from @MCQ_questions_ids

		insert into @exam_questions_ids
		select question_id from @true_false_questions_ids

		insert into @exam_questions_ids
		select question_id from @text_questions_ids

		--select * from @exam_questions_ids

		--declare @allowed bit = 
		--case @allowance 
		--	when 'allowed' then 1 
		--	when 'not allowed' then 0 
		--end;

		declare @exam_id int = (next value for Exam_sequence)
		insert into Exam values
		(
		@exam_id,
		@exam_type,
		@start_time,
		@end_time,
		@duration,
		SYSDATETIME(),
		@allowance,
		@instructor_id,
		@course_id
		);

	-- cursor to insert exam_questions in the table 
    declare @question_id int 
	declare cursor_exam_questions_ids cursor
	for select question_id from @exam_questions_ids
	open cursor_exam_questions_ids;

	fetch next from cursor_exam_questions_ids into @question_id;

	while @@fetch_status = 0
		begin
			insert into [dbo].[Exam_Question] values (@exam_id, @question_id);
			fetch next from cursor_exam_questions_ids into @question_id;
		end;
	close cursor_exam_questions_ids;
	deallocate cursor_exam_questions_ids;


	end
	else
		print 'Your are allowed to create exams for courses you teach only!!'
		return;
end

exec create_exam 
@instructor_id = 1, 
@course_id = 1, 
@exam_type = 'Exam',
@start_time = '2024-01-11 12:44:00',
@end_time = '2024-01-11 13:50:00',
@duration = '00:30:00',
@allowance = 1,
@numOfMCQquestions = 2,
@numOfTFquestions = 2,
@numOfTextquestions =2

alter sequence Exam_sequence
    restart with 1
    increment by 1;

--delete from exam
--delete from Exam_Question
--delete from Student_Exam
--delete from Student_Question_Answer


select * from exam
select * from Exam_Question

go
create or alter view viewExamsQuestions
as 
select c.course_name,e.exam_id,q.*
from Exam as e inner join Exam_Question eq on e.exam_id = eq.exam_id
inner join Question q on eq.question_id = q.question_id
inner join Course c on q.course_id = c.course_id
go

select * from viewExamsQuestions --where exam_id=5
select * from Exam