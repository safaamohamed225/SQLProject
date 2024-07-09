GO
create or alter procedure save_student_answer
@student_answers student_answers_type readonly,
@exam_id int,
@student_id int
as
begin
	-- calculate the difference between enter_time and exam end_time
	-- if diff > 0 -------------> can save answers
	-- else -----------> cannot insert answers
	declare @student_start_time datetime
	select @student_start_time = student_start_time from Student_Exam 
	where student_id = @student_id and exam_id = @exam_id

	declare @exam_end_time datetime
	select @exam_end_time = end_time from Exam 
	where exam_id = @exam_id

			declare @degree_counter int
			set @degree_counter = 0
	
			declare @student_choosed_option nvarchar(1000)
			declare @question_id int 
			declare @answer nvarchar(1000)

			declare cursor_student_answer cursor
			for select * from @student_answers

			open cursor_student_answer;

			fetch next from cursor_student_answer into @question_id , @answer;
			while @@fetch_status = 0
			begin -- while begin
				if exists (select question_id from viewExam(@exam_id) where question_id = @question_id)
				begin -- begin of exists
					declare @type nvarchar(30)
					set @type = (select type from viewExam(@exam_id) where question_id = @question_id)
					if @type = 'MCQ'
					begin
					if @answer = 'a'
						set @student_choosed_option = (select OptionA from viewExam(@exam_id)  where question_id = @question_id)
					else if  @answer = 'b'
						set @student_choosed_option = (select OptionB from viewExam(@exam_id)  where question_id = @question_id)
					else if  @answer = 'c'
						set @student_choosed_option = (select OptionC from viewExam(@exam_id)  where question_id = @question_id)
					else if @answer = 'd'
						set @student_choosed_option = (select OptionD from viewExam(@exam_id)  where question_id = @question_id)
					else
						begin
							print 'you entered invalid option for MCQ question'
							return;
						end
				  end -- end of (if type = MCQ)
				  ------------ if type = true / false
				  else if @type = 'True/False'
					begin
					if @answer = 'a'
						set @student_choosed_option = (select OptionA from viewExam(@exam_id)  where question_id = @question_id)
					else if  @answer = 'b'
						set @student_choosed_option = (select OptionB from viewExam(@exam_id)  where question_id = @question_id)
					else
						begin
							print 'you entered invalid option for True False question'
							return;
						end
				end -- end of (if type = true false)
				else -- case type = text
					set @student_choosed_option = @answer

				-- compare answer
				declare @correct bit
				declare @correct_answer nvarchar(1000)
				set @correct_answer = (select correct_answer from question where question_id = @question_id)
				if @type = 'MCQ' or @type = 'True/False' -- grading of "MCQ" and "True False questions"
					begin
						if @student_choosed_option = @correct_answer
						begin
						set @correct = 1
						set @degree_counter = @degree_counter + (select degree from viewExam(@exam_id)  where question_id = @question_id);
						end
				else
					set @correct = 0
				end
				else -- @ grading of text questions
					begin
						if @correct_answer like '%'+@student_choosed_option+'%' 
						begin
						set @correct = 1
						set @degree_counter = @degree_counter + (select degree from viewExam(@exam_id)  where question_id = @question_id);
						end
						else
						set @correct = 0
					end

				insert into Student_Question_Answer values 
				(@exam_id,@question_id,@student_id,@student_choosed_option,@correct)

				update Student_Exam 
				set submit_time = SYSDATETIME(),
				degree = @degree_counter
				where exam_id = @exam_id and student_id = @student_id

				end  -- end of exists
				else -- if id is not in exam
				begin
					print 'You entered question id not part of the exam!!' 
					return;
				end
				fetch next from cursor_student_answer into @question_id , @answer;
			end -- while end
			close cursor_student_answer;
			deallocate cursor_student_answer;
end
GO
