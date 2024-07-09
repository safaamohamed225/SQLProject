USE [master]
GO
DECLARE @backupPath NVARCHAR(500)
SET @backupPath = 'C:\Users\essam\OneDrive\Desktop\ITI GENERAL\SQL\SQL project\database\Backup' + CONVERT(NVARCHAR(50), GETDATE(), 112) + '[Examination_System].bak'
BACKUP DATABASE [Examination_System] TO DISK = @backupPath WITH NOINIT, NAME = N'Full Database Backup', NOFORMAT, NOINIT, SKIP, NOREWIND, NOUNLOAD, STATS = 10
GO