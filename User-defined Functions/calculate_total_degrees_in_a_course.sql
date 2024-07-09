GO
create or alter function [dbo].calc_total_degrees (@student_id int , @course_id int)
returns int 
begin

declare @sum_degrees int
select @sum_degrees = sum(se.degree)
from Student_Exam se inner join Exam e on se.exam_id = e.exam_id and  se.student_id = @student_id and e.course_id = @course_id
return @sum_degrees
end

Go
select dbo.calc_total_degrees(1,1) as Total_Student_Course_degree