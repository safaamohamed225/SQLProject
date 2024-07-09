-- for enter exam:
	--1 check whether he allowed or not
	--2 check whether he enters in the specified date and time
	--3 start timer
GO
create or alter procedure enterExam
@exam_id int,
@student_id int
as
begin
	declare @instructor_id int
	set @instructor_id = (select instructor_id from exam where exam_id = @exam_id)
	if exists (select instructor_id from Student where student_id = @student_id and instructor_id = @instructor_id)
		begin
		declare @allowance bit
		set @allowance = (select allowance from exam where exam_id = @exam_id)
		if @allowance = 1
			begin 
				declare @start_time datetime 
				set @start_time = (select start_time from exam where exam_id = @exam_id)
				declare @end_time datetime 
				set @end_time = (select end_time from exam where exam_id = @exam_id)
				if SYSDATETIME() between @start_time and @end_time
					begin
					insert into Student_Exam (exam_id,student_id,student_start_time)
					values (@exam_id,@student_id,SYSDATETIME())
					print 'Exam timer started...'
					select * from viewExam(@exam_id)
					return;
					end
				else
					begin
					print 'The exam time is ended!'
					end
			end
		else
		begin
			print 'This exam is not opened yet'
		end
		end
	else
		begin
		print 'You are currently not allowed to enter this exam. Please contact your instructor'
		end
end