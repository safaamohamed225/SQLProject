GO
create or alter function [dbo].calc_total_correct_answers_in_exam (@student_id int , @exam_id int)
returns int 
begin
	declare @total_correct_answer int
	select @total_correct_answer = count([correct]) from [dbo].[Student_Question_Answer]
	where student_id = @student_id and exam_id = @exam_id and correct = 1
	return @total_correct_answer
end

--select * from Student_Question_Answer

select dbo.calc_total_correct_answers_in_exam(1,6) as Total_correct_answers