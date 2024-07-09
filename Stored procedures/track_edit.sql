CREATE OR ALTER PROCEDURE Add_Track
@trackId int ,
    @Track_Name VARCHAR(50),
    @description nvarchar(500),
	@prerquistes nvarchar(200)
AS
BEGIN
    IF (LEN(@Track_Name) > 3)
    BEGIN
        IF EXISTS (SELECT 1 FROM [dbo].[Track] WHERE  [track_name]= @Track_Name)
            THROW 51000, 'Track name is exists. Please change it!', 16;

			IF (LEN(@Track_Name) > 3)
			BEGIN
						IF (LEN(@Track_Name) > 3)
						begin
						            -- Insert into Track table
                                 INSERT INTO  [dbo].[Track] 
                                 VALUES (@trackId,@Track_Name,@description,@prerquistes);

						end
						else
						begin
						        THROW 51000, 'Invalid prerequistes of Track !', 16;

						end
			    

			END
			ELSE
			BEGIN
			        THROW 51000, 'Invalid description of Track !', 16;

			END


     END 
    ELSE
        THROW 51000, 'Invalid Track name!', 16;
END
GO



begin try
exec Add_Track @trackId=18,@Track_Name='na',@description='This track concentrates on full-stack web ',@prerquistes='basic programing c#'
end try
begin catch
select ERROR_MESSAGE()
end catch


---------------------------------------------update track
go
CREATE  TRIGGER Update_Track
on[dbo].[Track]
INSTEAD OF UPDATE
AS
BEGIN
declare
     @oldtrackid int,
	 @newtrackid int,
     @NewTrackName varchar(30),
	 @oldeTrackName varchar(30),
	 @newprerquistes nvarchar(500),
	 @oldprerquistes nvarchar(500),
	 @newdescription nvarchar(200),
	 @olddescription nvarchar(200)
	 
	 select @oldtrackid=d.track_id, @oldeTrackName=d.[track_name],@olddescription=d.[description],@oldprerquistes=[prerequistes]  from deleted d;
	 select @newtrackid=i.track_id, @NewTrackName = i.[track_name] ,@newdescription=i.[description],@newprerquistes= [prerequistes] from inserted i
	 	IF(@NewTrackId = @OldTrackId)
		begin
		   IF(LEN(@NewTrackName) >=2)
		   begin 
		      IF NOT EXISTS(SELECT 1 FROM [dbo].[Track] WHERE  [track_name]= @NewTrackName )
			  begin
			     IF(LEN(@newdescription) >=2)
				 begin 
				       IF(LEN(@newprerquistes) >=2)
					   begin
					    
					        	UPDATE [dbo].[Track]
			                    SET  [track_name]=@NewTrackName ,[description]=@newdescription,[prerequistes]=@newprerquistes
                  			   where  [track_id]= @OldTrackId

					   end
					   else
					   begin
					       THROW 51000, 'Invalid prerquistes !!!',16

					   end
				 end
				 else
				 begin
            		   THROW 51000, 'Invalid description !!!',16

				 end
			  end
			  else
			  begin
	           THROW 51000, 'Repeated name, please enter another name !',16;

			  end
		   end
		   else
		   begin
		   THROW 51000, 'Invalid name !!!',16
		   end
		
		end
		else
		begin
			  THROW 51000, 'Invalid Track id !!!',16;

		end


end


begin try
update [dbo].[Track]
 SET [track_name]='AYMAN'
 WHERE 11=55
end try
begin catch
select ERROR_MESSAGE()
end catch
-----------------------------------------------------------------------delete track
--create or alter trigger Prevent_TRAK_Deletion
--on[dbo].[Track]
--instead of delete
--as
--begin
--      throw 51000,'Cannot delete the Course',16;
--End 







begin try
delete from [dbo].[Track]
where [track_id] =12
end try
begin catch
select ERROR_MESSAGE()
end catch