select * from [dbo].[Branch];
-------------------------- add in branch
Go
create or alter proc insert_into_branch
   @BranchName varchar(50),
   @phone int,
   @id int 
	
 as
 begin
  begin try
    
  if(LEN(@BranchName) > 2)
  begin 
     if exists(select 1 from  [dbo].[Branch] b where b.branch_name = @BranchName )
	   throw 51000,'the branch is exist', 16
     else
	 begin
		     -----------insert into branch ------------
		   	 insert into [dbo].[Branch]
			 values(@id,@BranchName ,@phone)
	  end
	  end
    else
	  throw 51000,'Enter Valid branch name', 16
 end try

 begin catch
   declare @error varchar(50);
   select @error = ERROR_MESSAGE();
   print 'Error : '+ @error;
 end catch
end
go

Exec insert_into_branch 'Alex','01120144524',14

----------------------------------------------update branch
GO
CREATE  OR ALTER PROCEDURE UpdatInBranch
  @BranchName varchar(50),
   @phone int
AS
BEGIN
  BEGIN TRY
      if exists(select [branch_name] from [dbo].[Branch] where [branch_name]=@BranchName)
	  begin
	    -- Update branch
        UPDATE  [dbo].[Branch]
        SET  [phone]  =@phone
        WHERE  [branch_name]= @BranchName;
      end
	  else 
	  begin
	   THROW 51000, 'invaild branch name try again', 16;
	  end
  
  END TRY
  BEGIN CATCH
    DECLARE @error varchar(50);
    SELECT @error = ERROR_MESSAGE();
    PRINT 'Error: ' + @error;
  END CATCH
END
GO
exec UpdatInBranch 'ahm','01120304050'
-----------------------------------------deleted
go
create or alter trigger Prevent_branch_Deletion
on[dbo].[Branch]
instead of delete
as
begin
  
      throw 51000,'Cannot delete the Branch',16;
	  
End 
begin try
delete   [dbo].[Branch]
where  [branch_id]= 1;
end try 
begin catch
select ERROR_MESSAGE()
end catch
