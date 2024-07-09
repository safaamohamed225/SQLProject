
-- procedure to select all students in a specific course
create or alter procedure select_all_students_in_course_for_exam
@course_id int,
@intructor_id int
as 
begin
	if exists (select * from Course_Instructor where course_id = @course_id and instructor_id = @intructor_id)
	begin
		update Student
		set instructor_id = @intructor_id
		where student_id in (select student_id from Student_Course where course_id = @course_id)
	end
	else
	begin
		print 'You are not allowed to select students for this course..'
		return;
	end
end

exec select_all_students_in_course_for_exam
@course_id = 7,
@intructor_id = 1

-- select * from student