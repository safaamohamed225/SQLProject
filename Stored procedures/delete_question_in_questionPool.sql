
-- procedure to delete question to the question pool
GO
create or alter procedure delete_question_in_questionPool
@instructor_id int,
@course_id int,
@question_id int
as 
begin
	if exists (select * from Course_Instructor where course_id = @course_id and instructor_id = @instructor_id)
	begin
		if exists (select * from Question where course_id = @course_id and question_id = @question_id)
		begin
		delete from Question
		where question_id = @question_id
		end
		else
		begin
			print 'The id of question you entered is not ralated to this course!!'
			return;
		end
	end
	else
	begin
		print 'You are not allowed to delete question for this course'
		return;
	end
end

exec delete_question_in_questionPool
@instructor_id = 1,
@question_id = 606,
@course_id = 6

GO
select * from getAllCourseQuestions(1)

-- delete from question where question_id in ()
