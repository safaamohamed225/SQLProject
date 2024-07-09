
--alter sequence question_sequence
--	restart with 601
--	increment by 1;

-- procedure to add question to the question pool
GO
create or alter procedure add_question_to_questionPool
@instructor_id int,
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
		declare @question_id int = (next value for question_sequence)
		insert into question (question_id, course_id, type, question_text, optiona, optionb, optionc, optiond, correct_answer, degree) values
		(
		@question_id,
		@course_id,
		@type,
		@question_text,
		@optionA,
		@optionB,
		@optionC,
		@optionD,
		@correct_answer,
		@degree
		)
	end
	else
	begin
		print 'You are not allowed to add question for this course'
		return;
	end
end

exec add_question_to_questionPool
@instructor_id = 1,
@course_id = 5,
@type = 'MCQ',
@question_text = 'how to add comment in HTML?',
@optionA = 'A) // this is a comment',
@optionB = 'B) /* this is a comment */',
@optionC = 'C) <-- this is a comment -->',
@optionD = 'D) -- this is a comment',
@correct_answer = 'C) <-- this is a comment -->',
@degree = 1
GO

select * from getAllCourseQuestions(1)

-- delete from question where question_id in ()