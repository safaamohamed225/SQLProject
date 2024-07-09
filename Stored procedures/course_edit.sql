go
create or alter proc add_course
@crc_id int, @Crs_Name nvarchar(30),@Crs_Discraption nvarchar(500) ,@Crs_MinDegree	int ,@Crs_MaxDegree int,@Crs_InstractorId int,@crc_departmentid int
as
begin
   if not exists(select *from [dbo].[Course] where [course_id]=@crc_id)
   begin 
       if not exists(select * from [dbo].[Course]where[course_name]=@Crs_Name )
	   begin
	        if (@Crs_Name = '')
				begin
					THROW 51000, 'The Name Of Course Is Not Valid',16
				end
				else
				begin
				     if(@Crs_MaxDegree<=100 and @Crs_MaxDegree>@Crs_MinDegree and @Crs_MinDegree>=0)
				      begin 
							if(@Crs_Discraption = '')
								begin
									THROW 51000, 'The Discraption of Course is Not Valid',16
								end
								else
								begin
								   if exists(select * from [dbo].[Instructor] where  [instructor_id] =@Crs_InstractorId)
								   begin 
								        if not exists(select * from [dbo].[Course] where[course_id]=@crc_id and [instructor_id] =@Crs_InstractorId )
										begin
										     if exists(select * from [dbo].[Department] where [department_id]=@crc_departmentid)
											 begin
											      insert into [dbo].[Course] values (@crc_id,@Crs_Name,@Crs_Discraption,@Crs_MinDegree,@Crs_MaxDegree,@Crs_InstractorId,@crc_departmentid)
											 end
											 else
											 begin
											    THROW 51000,'invalid depaetmenr id !!!',16
											 end
										end
										else
										begin 
										   THROW 51000, 'The Instractor already  in another course',16
										end

								   end
								   else
								   begin
								     THROW 51000, 'The Instractor id is not Valid',16
								   end


								end

				      end
					  else
					  begin
					   THROW 51000,'The Max Degree and Min Degree is not Valid',16
					  end
				end
	   end
	   else
	   begin
	        THROW 51000, 'Courses is exist !!!',16

	   end
   end
   else
   begin
      		   THROW 51000, 'Invalid id !!!',16

    end

end

begin try
exec add_course @crc_id=21,@Crs_Name='new course',@Crs_Discraption='newwww',@Crs_MinDegree=100,@Crs_MaxDegree=50,@Crs_InstractorId=21,@crc_departmentid=1
end try
begin catch
   select ERROR_MESSAGE()

end catch

---------------------Update Cource
create or alter proc Update_Coursee
@crc_id int, @Crs_Name nvarchar(30),@Crs_Discraption nvarchar(500) ,@Crs_MinDegree	int ,@Crs_MaxDegree int,@Crs_InstractorId int,@crc_departmentid int
as
begin
   if  exists(select *from [dbo].[Course] where [course_id]=@crc_id)
   begin 
       if  exists(select * from [dbo].[Course]where[course_name]=@Crs_Name )
	   begin
	        if (@Crs_Name = '')
				begin
					THROW 51000, 'The Name Of Course Is Not Valid',16
				end
				else
				begin
				     if(@Crs_MaxDegree<=100 and @Crs_MaxDegree>@Crs_MinDegree and @Crs_MinDegree>=0)
				      begin 
							if(@Crs_Discraption = '')
								begin
									THROW 51000, 'The Discraption of Course is Not Valid',16
								end
								else
								begin
								   if exists(select * from [dbo].[Instructor] where  [instructor_id] =@Crs_InstractorId)
								   begin 
								        if  exists(select * from [dbo].[Course] where[course_id]=@crc_id and [instructor_id] =@Crs_InstractorId )
										begin
										     if exists(select * from [dbo].[Department] where [department_id]=@crc_departmentid)
											 begin
											 update [dbo].[Course]
											 set [course_name]=@Crs_Name,[description]=@Crs_Discraption,[min_degree]=@Crs_MinDegree,
											 [max_degree]=@Crs_MaxDegree,[instructor_id]=@Crs_InstractorId,[department_id]=@crc_departmentid
											 where [course_id]=@crc_id

											 end
											 else
											 begin
											    THROW 51000,'invalid depaetmenr id !!!',16
											 end
										end
										else
										begin 
										   THROW 51000, 'The Instractor already  in another course',16
										end

								   end
								   else
								   begin
								     THROW 51000, 'The Instractor id is not Valid',16
								   end


								end

				      end
					  else
					  begin
					   THROW 51000,'The Max Degree and Min Degree is not Valid',16
					  end
				end
	   end
	   else
	   begin
	        THROW 51000, 'Course Does not is exist',16

	   end
   end
   else
   begin
      		   THROW 51000, 'Invalid id !!!',16

    end

end
go
--------------------instructor id =1 is already in course frist when i update refuse
begin try
exec Update_Coursee @crc_id=5,@Crs_Name='JavaScript',@Crs_Discraption='newwww',@Crs_MinDegree=50,@Crs_MaxDegree=100,@Crs_InstractorId=1,@crc_departmentid=1
end try
begin catch
   select ERROR_MESSAGE()
end catch

---------------- delete course 
create trigger Course_Deletion
on[dbo].[Course]
instead of delete
as
begin
  
      throw 51000,'Cannot delete the Course',16;
	  
End

go
begin try
delete  [dbo].[Course] where [course_id]=1
end try
begin catch
   select ERROR_MESSAGE()

end catch