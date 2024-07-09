-- Add Intake 
create or alter proc Add_Intake(@intakeNamber int, @startDate nvarchar(10),@endDate nvarchar(10),@In_Year nvarchar(200),@phone varchar(11))
as
begin
	IF NOT EXISTS(select 1 from [dbo].[Intake] where [intake_number]=@intakeNamber )
		begin
		      
					iF ( @In_Year > GETDATE())
						begin
							insert into [dbo].[Intake]
							values (@intakeNamber,@startDate,@endDate,@In_Year,null,@phone)
						end
					else
						begin
							select 'The Year Is Small Than of This Year'
						end
				
		end
	else
	begin
		select 'Intake is exist';
	end
end
go
exec  Add_Intake @intakeNamber=47 ,@startDate='10-01-2023',@endDate='20-04-2023',@In_Year = '2023',@phone='01222222222'
------------------------------------------------------------------update 
create or alter  proc Update_Intake(@intakeNamber int, @startDate nvarchar(10),@endDate nvarchar(10),@In_Year nvarchar(200))
as 
begin 
	IF EXISTS(select 1 from   [dbo].[Intake] where [intake_number]= @intakeNamber)
		begin
	
			
						update [dbo].[Intake]
						set [start_date]=@startDate ,[end_date]=@endDate,[year]=@In_Year
						where [intake_number]=@intakeNamber
				
		end
	else
	begin
		select 'Intake Does not is exist';
	end
end

exec Update_Intake @intakeNamber=1,@startDate='10-01-2023',@endDate='20-04-2023',@In_Year='2023'

------------------------------------------------------deleted 
create or alter trigger Prevent_Intake_Update
on [dbo].[Intake]
instead of  delete
as
begin
    
       throw 51000,'Cannot delete in Intake',16;
      
end 

begin try
   delete  [dbo].[Intake]
   where [intake_number]=42
end try
begin catch
   select ERROR_MESSAGE();
end catch