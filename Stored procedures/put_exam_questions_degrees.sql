

-- function to get specific Course's exams with their questions
GO
create or alter function get_all_course_exams_with_questions(@course_id int)
returns table as return 
(
	select e.instructor_id, c.course_id,e.exam_id,q.question_id, q.type,q.question_text,q.optionA,q.optionB,q.optionC,q.optionD,q.correct_answer,q.degree
	from Course c inner join Exam e on c.course_id = e.course_id
	inner join Exam_Question eq on e.exam_id = eq.exam_id
	inner join Question q on eq.question_id = q.question_id
)
GO

create or alter procedure put_exam_questions_degrees
@instructor_id int,
@exam_id int,
@exam_questions_degrees as exam_questions_degrees_Array readonly
as
begin
	SET NOCOUNT ON;
	if exists (select * from Exam where exam_id = @exam_id and instructor_id = @instructor_id)
		begin
			declare @total_degrees_of_input int
			select @total_degrees_of_input = sum(degree) from @exam_questions_degrees

			declare @course_id int
			select @course_id = course_id from Exam where exam_id = @exam_id

			declare @course_max_degree int
			select @course_max_degree = max_degree from Course where course_id = @course_id

			declare @total_degrees_of_other_exams int
			set @total_degrees_of_other_exams = ISNULL((select sum(degree) from get_all_course_exams_with_questions(@course_id) where exam_id <> @exam_id),0)

			if @total_degrees_of_input + @total_degrees_of_other_exams <= @course_max_degree
				begin
					declare @question_id int
					declare @degree int
					-- cursor begin
					declare cursor_questions_degrees cursor
					for select * from @exam_questions_degrees
					open cursor_questions_degrees;
					fetch next from cursor_questions_degrees into @question_id , @degree;
					while @@fetch_status = 0
						begin
						if @question_id in (select question_id from viewExam(@exam_id))
							begin
							update Question
							set degree = @degree
							where question_id = @question_id and course_id = @course_id
							end
						else
							begin
							print 'One or more of Entered Ids not included in this exam'
							return;
							end
						fetch next from cursor_questions_degrees into @question_id , @degree;
						end
					close cursor_questions_degrees;
					deallocate cursor_questions_degrees;
					select * from viewExam(@exam_id)
					-- cursor end
				end
			else
				begin
				print 'The sum of questions degrees exceeded the course max degree!'
				return;
				end
		end
	else
		begin
			print 'Only the instructor who created the exam is allowed to edit exam''s questions degrees!' 
			return;
		end
end

GO

declare @questions_degrees as exam_questions_degrees_Array -- user defined type
insert into @questions_degrees values
(6,0), (8,0) , (14,0) , (22,5) ,(25,5) ,(44,5)

execute put_exam_questions_degrees
@instructor_id = 5,
@exam_id = 4 ,
@exam_questions_degrees = @questions_degrees

--select * from viewExam(4)
--select * from viewExamsQuestions
--select * from Question