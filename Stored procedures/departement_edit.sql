---------------------------------add departement
create or alter proc add_to_department
 @deptID int, @deptname nvarchar(30),@managerid int
 as 
 begin
     if not exists(select * from [dbo].[Department] where [department_id]=@deptID)
     begin
	       if(LEN(@deptname) > 0)
           begin
		           if not exists(select * from [dbo].[Department] where [department_name]=@deptname)
				   begin
				   --------------------------reblace  [instructor_id] to manger id 
				   --------------frist cheak if the id instructor is already fount 
				          if not exists(select * from Instructor where [instructor_id]= @deptID)
						  begin
						  --------secent cheak if the manger IN department 
  						        if not exists (select * from [dbo].[Department] where[department_id] =@deptID and [manager_id] = @managerid)
								begin 
								    insert into [dbo].[Department] values (@deptID,@deptname,@managerid)
								end
								else 
								begin
							      	throw 51000,'instructor is a manager for another department, change it !',16

								end
						  end
						  else
						  begin
						  throw 51000,'invalid id manger',16
						  end

				   end
				   else
				   begin
				             throw 51000,'this dpartment is exists already, change it !',16
				   end
		   end
		   else
		   begin
		           throw 51000,'invalid name !!',16

		   end
	 end
	 else 
	 begin
	 THROW 51000, 'id department is alreday add choose another id  !!!',16
	 end
 end

 
begin try
exec add_to_department @deptID=11,@deptname='JETS',@managerid=1
end try
begin catch
   select ERROR_MESSAGE()

end catch
--------------------------------------update department 

CREATE OR ALTER TRIGGER UpdateToDepartment
ON [dbo].[Department]
INSTEAD OF UPDATE
AS
BEGIN 
  
    DECLARE
       @NewDeptName nVARCHAR(30),@NewManagerId INT,@NewDeptId INT,
       @OldDeptId INT,@oldDeptname  nVARCHAR(30)
	   select @oldDeptname=d.[department_name] from deleted d;
	    select @NewDeptId=i.[department_id] ,@NewDeptName=i.[department_name],@NewManagerId=i.[manager_id] from inserted i;
		if exists(select * from [dbo].[Department] where [department_id]=@NewDeptId)
		begin
		           IF (LEN(@NewDeptName) >= 3)
				   begin
				           if not exists(select * from [dbo].[Department] where[department_name]=@NewDeptName)
						   begin
						   ---------------cheack  id is a already in instuctor   
						      if   exists (select * from [dbo].[Instructor] where [instructor_id]=@NewManagerId)
							  begin
							  ---------cheack id is a manger 
							     if exists(select * from [dbo].[Instructor] where [instructor_id]=@NewManagerId)
								 begin 
								      --------cheack id in department
									  if not exists (select * from [dbo].[Department] where [department_id]=@NewDeptId and [manager_id]=@NewManagerId )
									  begin
									  update [dbo].[Department]
									  set [department_name] =@NewDeptName,[manager_id]=@NewManagerId
									  where [department_id]=@NewDeptId
									  end
									  else
									  begin
                                     THROW 51000, 'Invalid manager id, the manger is already in depatmanger', 16;

									  end

								 end
								 else
								 begin
				                     THROW 51000, 'Invalid manager id, id is instructor not manger', 16;

								 end
							  end
							  else 
							  begin
                                THROW 51000, 'Invalid manager id, not an instructor', 16;
							  end
						         
						   end
						   else 
						   begin
						   THROW 51000, 'repate name!!!', 16;
						   end
				   end
				   else
				   begin
				   THROW 51000, 'Invalid name!!!', 16;
				   end
		end
		else
		begin
		 	throw 51000,'Invalid Dept id!!!',16

		end

end


begin try 
update [dbo].[Department]
set  [department_name]= 'me',
 [manager_id]= 3
where [department_id] =5
end try
begin catch
		select ERROR_MESSAGE() as 'Error'
end catch



-------------------------------delete department
create or alter trigger Prevent_dept_Deletion
on[dbo].[Department]
instead of delete
as
begin
  
      throw 51000,'Cannot delete the Departemnt ',16;
	  
End 

begin try 
delete from  [dbo].[Department]
where[department_id]=5
end try
begin catch
		select ERROR_MESSAGE() as 'Error'
end catch
