

create or alter procedure select_students_for_exam 
@students_ids idsArray readonly, 
@intructor_id int
as
begin
	declare @student_id int 
	declare cursor_select_students cursor
	for select id from @students_ids
	open cursor_select_students;

	fetch next from cursor_select_students into @student_id;

	while @@fetch_status = 0
		begin
		update student
		set instructor_id = @intructor_id
		where student_id = @student_id
		fetch next from cursor_select_students into @student_id;
		end;
	close cursor_select_students;
	deallocate cursor_select_students;
end

begin
	SET NOCOUNT ON;
	declare @selectedStudents idsArray;
	insert into @selectedStudents values (1),(4),(3)
end
execute select_students_for_exam
@students_ids = @selectedStudents,
@intructor_id = 1

-- select * from Student
-- update Student set instructor_id = null
	
select * from student