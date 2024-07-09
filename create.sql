
USE master;
GO
CREATE DATABASE Examination_System
ON PRIMARY
( NAME = Examination_System_data,
    FILENAME = 'C:\Users\essam\OneDrive\Desktop\ITI GENERAL\SQL\SQL project\database\Examination_System.mdf',
    SIZE = 10,
    MAXSIZE = 500,
    FILEGROWTH = 15% ),
( NAME = Examination_System_data2,
    FILENAME = 'C:\Users\essam\OneDrive\Desktop\ITI GENERAL\SQL\SQL project\database\Examination_System_data2.ndf',
    SIZE = 10,
    MAXSIZE = 500,
    FILEGROWTH = 15% ),
FILEGROUP Group1
( NAME = Examination_System_data3,
    FILENAME = 'C:\Users\essam\OneDrive\Desktop\ITI GENERAL\SQL\SQL project\database\group1\Examination_System_data3.ndf',
    SIZE = 10,
    MAXSIZE = 50,
    FILEGROWTH = 5 )
LOG ON
( NAME = Examination_System,
    FILENAME = 'C:\Users\essam\OneDrive\Desktop\ITI GENERAL\SQL\SQL project\database\Examination_System.ldf',
    SIZE = 5MB,
    MAXSIZE = 200MB,
    FILEGROWTH = 5MB ) ;
GO

CREATE TABLE Intake 
(
	intake_number int,
	[start_date] nvarchar(10),
	[end_date] nvarchar(10),
	[year] nvarchar(10),
    [description] nvarchar(200),
	phone varchar(11),
	constraint intake_pk primary key (intake_number),
    
);

ALTER TABLE [dbo].[Intake]
ADD CONSTRAINT intake_Phone_uq UNIQUE (phone);


GO
CREATE TABLE Track
(
	track_id int,
	track_name nvarchar(200),
	[description] nvarchar(500),
	prerequistes nvarchar(200),
	constraint track_pk primary key (track_id)
);

GO
CREATE TABLE Branch
(
	branch_id int,
	branch_name nvarchar(50),
	phone varchar(11) ,
	constraint branch_pk primary key (branch_id),
	constraint branch_phone_uq unique (phone)

);

GO
CREATE TABLE Student
(
  student_id int ,
  first_name nvarchar(30),
  last_name nvarchar(30),
  age int,
  account_id int unique,
  track_id int ,
  branch_id int ,
  intake_number int ,
  manager_id int,
  instructor_id int
  constraint student_pk primary key(student_id), 

  --constraint composite_fk_Student foreign key(track_id,branch_id,intake_number) references Program(track_id,branch_id,intake_number),

);
ALTER TABLE [dbo].[Student]
ADD CONSTRAINT student_manager_fk foreign key (manager_id)
references Instructor(instructor_id);

ALTER TABLE [dbo].[Student]
ADD CONSTRAINT student_instructor_fk foreign key (instructor_id)
references Instructor(instructor_id)  ON UPDATE CASCADE ON DELETE SET NULL;

-----------------------------------------------------------------------------
ALTER TABLE [dbo].[Student]
ADD CONSTRAINT student_track_fk foreign key ([track_id])
references [dbo].[Track]([track_id])  ON UPDATE CASCADE ON DELETE SET NULL;

ALTER TABLE [dbo].[Student]
ADD CONSTRAINT student_branch_fk foreign key (branch_id)
references [dbo].[Branch](branch_id)  ON UPDATE CASCADE ON DELETE SET NULL;

ALTER TABLE [dbo].[Student]
ADD CONSTRAINT student_intake_fk foreign key (intake_number)
references [dbo].[Intake](intake_number)  ON UPDATE CASCADE ON DELETE SET NULL;

GO
CREATE TABLE Instructor 
(
	instructor_id int,
	first_name nvarchar(30),
	last_name nvarchar(30),
	salary decimal(7,3),
	account_id int,
	department_id int,
	constraint instructor_pk primary key (instructor_id)
);

ALTER TABLE INSTRUCTOR
ADD INSTRUCTOR_MANAGER_ID INT

ALTER TABLE INSTRUCTOR
ADD CONSTRAINT INSTRUCTOR_MANAGER_ID_FK FOREIGN KEY (INSTRUCTOR_MANAGER_ID)
REFERENCES INSTRUCTOR(INSTRUCTOR_ID)

GO
alter table [dbo].[Instructor]
ADD constraint instructor_account_fk foreign key (account_id)
references Account(account_id) ON UPDATE CASCADE ON DELETE SET NULL;
GO
alter table [dbo].[Instructor]
ADD constraint instructor_department_fk foreign key (department_id)
references Department(department_id) ON UPDATE CASCADE ON DELETE SET NULL;
GO
CREATE TABLE Account
(
	account_id int, 
	user_type nvarchar(20),
	username nvarchar(30),
	email varchar(30),
	account_password nvarchar(70),
	constraint account_pk primary key (account_id)
);
GO
CREATE TABLE Course
(
	course_id int,
	course_name nvarchar(30),
	[description] nvarchar(500),
	min_degree int,
	max_degree int,
	instructor_id int,
	department_id int,
	constraint course_pk primary key (course_id),
);

alter table [dbo].[Course]
ADD constraint course_instructor_fk foreign key (instructor_id)
references Instructor(instructor_id) ON UPDATE CASCADE ON DELETE SET NULL;

alter table [dbo].[Course]
ADD constraint course_department_fk foreign key (department_id)
references Department(department_id) ON UPDATE NO ACTION ON DELETE NO ACTION;

GO

CREATE TABLE Exam
(
	exam_id int,
	[type] nvarchar,
	start_time datetime,
	end_time datetime,
	duration time,
	[year] datetime,
	allowance bit not null,
	instructor_id int,
	course_id int ,
	constraint exam_pk primary key (exam_id),
);
GO

alter table [dbo].[Exam]
ADD constraint exam_instructor_fk foreign key (instructor_id)
references Instructor(instructor_id) ON UPDATE CASCADE ON DELETE SET NULL;

alter table [dbo].[Exam]
ADD constraint exam_course_fk foreign key (course_id)
references Course(course_id) ON UPDATE NO ACTION ON DELETE NO ACTION;

CREATE TABLE Department 
(
	department_id int,
	department_name nvarchar(30),
	manager_id int,
    constraint department_pk primary key (department_id),
);

GO

alter table [dbo].[Department]
ADD constraint department_manager_fk foreign key (manager_id)
references Instructor(instructor_id) ON UPDATE NO ACTION ON DELETE NO ACTION;


CREATE TABLE Program
(
	track_id int,
	branch_id int,
	intake_number int ,
	manager_id int,
	constraint Program_pk primary key(track_id,branch_id,intake_number),

);
GO

 ALTER TABLE [dbo].[Program]
 ADD CONSTRAINT  program_manager_fk FOREIGN KEY(manager_id)
 REFERENCES Instructor (instructor_id) ON UPDATE CASCADE ON DELETE SET NULL;


 ALTER TABLE [dbo].[Program]
 ADD CONSTRAINT  program_track_fk FOREIGN KEY(track_id)
 REFERENCES Track (track_id) ON UPDATE CASCADE ON DELETE CASCADE;
 

 ALTER TABLE [dbo].[Program]
 ADD CONSTRAINT  program_branch_fk FOREIGN KEY(branch_id)
 REFERENCES Branch (branch_id) ON UPDATE CASCADE ON DELETE CASCADE;

 ALTER TABLE [dbo].[Program]
 ADD CONSTRAINT  program_intake_fk FOREIGN KEY(intake_number)
 REFERENCES Intake (intake_number) ON UPDATE CASCADE ON DELETE CASCADE;

CREATE TABLE Question 
(
	question_id int,
	course_id int,
	[type] nvarchar(30),
	question_text nvarchar(200),
	optionA nvarchar(500),
	optionB nvarchar(500),
	optionC nvarchar(500),
	optionD nvarchar(500),
	correct_answer nvarchar(1000),
	degree int,
	constraint question_pk primary key (question_id)
);
 ALTER TABLE [dbo].[Question]
 ADD CONSTRAINT  question_course_fk FOREIGN KEY(course_id)
 REFERENCES Course(course_id) ON UPDATE CASCADE ON DELETE NO ACTION;
GO

CREATE TABLE Exam_Question
(
	exam_id int,
	question_id int,
);
GO

 ALTER TABLE [dbo].[Exam_Question]
 ADD CONSTRAINT exam_question_fk1 FOREIGN KEY(exam_id)
 REFERENCES Exam (exam_id) ON UPDATE CASCADE ON DELETE CASCADE;

 ALTER TABLE [dbo].[Exam_Question]
 ADD CONSTRAINT exam_question_fk2 FOREIGN KEY(question_id)
 REFERENCES [dbo].[Question] (question_id) ON UPDATE NO ACTION ON DELETE NO ACTION;

GO
CREATE TABLE Student_Question_Answer
(
	exam_id int,
	question_id int,
	student_id int,
	student_answer nvarchar(30),
	correct bit,
	constraint exam_question_pk primary key(exam_id,question_id,student_id), 
);
GO

 ALTER TABLE [dbo].[Student_Question_Answer]
 ADD CONSTRAINT exam_id_fk FOREIGN KEY(exam_id)
 REFERENCES Exam (exam_id) ON UPDATE CASCADE ON DELETE CASCADE;

 ALTER TABLE [dbo].[Student_Question_Answer]
 ADD CONSTRAINT question_id_fk FOREIGN KEY(question_id)
 REFERENCES Question (question_id)ON UPDATE NO ACTION ON DELETE NO ACTION;

 ALTER TABLE [dbo].[Student_Question_Answer]
 ADD CONSTRAINT student_id_fk FOREIGN KEY(student_id)
 REFERENCES Student (student_id)ON UPDATE NO ACTION ON DELETE NO ACTION;

GO
CREATE TABLE Student_Exam
(
	exam_id int ,
	student_id int ,
	constraint student_exam_pk primary key(exam_id,student_id), 
);
GO
ALTER TABLE STUDENT_EXAM ADD STUDENT_START_TIME DATETIME, SUBMIT_TIME DATETIME, DEGREE INT
 ALTER TABLE Student_Exam
 ADD CONSTRAINT student_exam_fk1 FOREIGN KEY(exam_id)
 REFERENCES Exam (exam_id) ON UPDATE CASCADE ON DELETE CASCADE;

 ALTER TABLE Student_Exam
 ADD CONSTRAINT student_exam_fk2 FOREIGN KEY(student_id)
 REFERENCES Student (student_id);

CREATE TABLE Student_Course
(
	course_id int,
	student_id int ,
	constraint student_course_pk primary key(course_id,student_id),
);
GO
 ALTER TABLE Student_Course
 ADD CONSTRAINT Student_Course_Code_fk FOREIGN KEY(course_id)
 REFERENCES Course (course_id) ON UPDATE CASCADE ON DELETE CASCADE;


 ALTER TABLE Student_Course
 ADD CONSTRAINT Student_Course_fk FOREIGN KEY(student_id)
 REFERENCES Student (student_id);

 
CREATE TABLE Course_Instructor
(
	instructor_id int,
	course_id int,
	branch_id int,
	intake_number int,
	track_id int,
	constraint course_instructor_pk primary key(instructor_id,course_id),
	
	
	--constraint Course_Instructor_Track_fk foreign key(track_id)references Track(track_id) 
);

 ALTER TABLE Course_Instructor
 ADD CONSTRAINT Course_Instructor_fk1 FOREIGN KEY(instructor_id)
 REFERENCES Instructor (instructor_id)ON UPDATE CASCADE ON DELETE CASCADE;

 ALTER TABLE Course_Instructor
 ADD CONSTRAINT Course_Instructor_fk2 FOREIGN KEY(course_id)
 REFERENCES Course (course_id);

 ALTER TABLE Course_Instructor
 ADD CONSTRAINT Course_Instructor_Branch_fk FOREIGN KEY(branch_id)
 REFERENCES Branch (branch_id)ON UPDATE NO ACTION ON DELETE NO ACTION;

 ALTER TABLE Course_Instructor
 ADD CONSTRAINT Course_Instructor_Intake_fk FOREIGN KEY(intake_number)
 REFERENCES [dbo].[Intake] (intake_number)ON UPDATE NO ACTION ON DELETE NO ACTION;


 ALTER TABLE Course_Instructor
 ADD CONSTRAINT Course_Instructor_Track_fk FOREIGN KEY(track_id)
 REFERENCES [dbo].[Track] (track_id)ON UPDATE CASCADE ON DELETE CASCADE;
