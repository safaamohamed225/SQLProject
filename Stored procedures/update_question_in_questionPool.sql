
-- procedure to update question in the question pool
GO
create or alter procedure update_question_in_questionPool
@instructor_id int,
@question_id int,
@course_id int,
@type nvarchar(30),
@question_text nvarchar(200),
@optionA nvarchar(500),
@optionB nvarchar(500),
@optionC nvarchar(500),
@optionD nvarchar(500),
@correct_answer nvarchar(1000),
@degree int
as 
begin
	if exists (select * from Course_Instructor where course_id = @course_id and instructor_id = @instructor_id)
	begin
		if exists (select * from Question where course_id = @course_id and question_id = @question_id)
		begin
			update Question 
		set
		type = @type,
		question_text = @question_text,
		optionA = @optionA,
		optionB = @optionB,
		optionC = @optionC,
		optionD = @optionD,
		correct_answer = @correct_answer,
		degree = @degree
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
		print 'You are not allowed to Update question for this course'
		return;
	end
end

exec update_question_in_questionPool
@instructor_id = 1,
@question_id = 606,
@course_id = 1,
@type = 'text',
@question_text = 'how to add comment in HTML?',
@optionA = '',
@optionB = '',
@optionC = '',
@optionD = '',
@correct_answer = 'insert <-- comment ,,>',
@degree = 1
GO
select * from getAllCourseQuestions(1)

-- delete from question where question_id in ()
