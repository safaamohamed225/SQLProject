go
create type idsArray as table
(
    id int
);
go

create or alter function getQuestionsIds(@ids idsArray readonly)
returns table
as
return
(
    select id as IDs
    from @ids
);
GO
create or alter function allIdsExistsIn(@ids1 idsArray readonly, @ids2 idsArray readonly)
returns bit
as
begin
	declare @resultbit bit;
	if exists(
	select 1 from @ids1 t1 where not exists(
		 select 1 from @ids2 t2 where t1.id = t2.id
		 )
	)
		begin
		set @resultbit = 0;
		end
	else
		begin
		set @resultbit = 1;
		end;
	return @resultbit;
end

go
create or alter procedure create_exam_manually 
@instructor_id int, 
@course_id int, 
@exam_type nvarchar(10),
@start_time datetime,
@end_time datetime,
@duration time,
@allowance bit,
@mcqQustions idsArray readonly,
@trueOrFlaseQustions idsArray readonly,
@textQustions idsArray readonly
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

		declare @mcqIds idsArray;
		insert into @mcqIds select question_id from dbo.getCourseQuestions_MCQ(@course_id)

		declare @trueFalseIds idsArray;
		insert into @trueFalseIds select question_id from dbo.getCourseQuestions_TF(@course_id)

		declare @textIds idsArray;
		insert into @textIds select question_id from dbo.getCourseQuestions_Text(@course_id)

		declare @condition1 bit , @condition2 bit, @condition3 bit;
		set @condition1 = dbo.allIdsExistsIn(@mcqQustions,@mcqIds)
		set @condition2 = dbo.allIdsExistsIn(@trueOrFlaseQustions,@trueFalseIds)
		set @condition3 = dbo.allIdsExistsIn(@textQustions,@textIds)

		if @condition1 = 0 and @condition2 = 0 and @condition3 = 0
			begin
			print 'One or more Qustions Ids you selected is not related to the course!!'
			return;
			end
		else
			begin
			declare @exam_questions_ids as table (question_id int)

			insert into @exam_questions_ids
			select id from @mcqQustions

			insert into @exam_questions_ids
			select id from @trueOrFlaseQustions

			insert into @exam_questions_ids
			select id from @textQustions


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
	end
	else
		print 'Your are allowed to create exams for courses you teach only!!'
		return;
end


begin
	SET NOCOUNT ON;
	declare @choosedMcqQuestions idsArray;
	insert into @choosedMcqQuestions values (1),(2),(3)

	declare @choosedTrueFalseQuestions idsArray;
	insert into @choosedTrueFalseQuestions values (22),(20),(24)

	declare @choosedTextQuestions idsArray;
	insert into @choosedTextQuestions values (40),(50),(44)
end
--select * from [dbo].[getAllCourseQuestions](1)

exec create_exam_manually 
@instructor_id = 1, 
@course_id = 1, 
@exam_type = 'exam',
@start_time = '2024-01-9 00:00:00',
@end_time = '2024-1-10 00:00:00',
@duration = '00:30:00',
@allowance = 1,
@mcqQustions = @choosedMcqQuestions,
@trueOrFlaseQustions = @choosedTrueFalseQuestions,
@textQustions = @choosedTextQuestions

select * from viewExamsQuestions --where exam_id=5

alter sequence Exam_sequence
    restart with 1
    increment by 1;

--select * from exam
--select * from Exam_Question
--delete from exam
--delete from Exam_Question
