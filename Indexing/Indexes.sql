			
--**************************INDEXES**********************************

-- Indexes on Account Table
CREATE INDEX useraccount_index
ON [dbo].[Account] ([username]); 

CREATE INDEX email_account_index
ON [dbo].[Account] ([email]); 

-------------------------------------
-- Indexes on Branch Table
CREATE INDEX branch_index
ON  [dbo].[Branch]([branch_name]);  

CREATE UNIQUE INDEX branch_phone_index
ON  [dbo].[Branch]([phone]); 

-------------------------------------
-- Indexes on Course Table
CREATE INDEX course_index
ON [dbo].[Course] ([course_name]);  

-------------------------------------
-- Indexes on Course_Instructor Table
CREATE INDEX course_instructor_index
ON  [dbo].[Course_Instructor]([instructor_id]);  

CREATE INDEX course_id_instructor_index
ON  [dbo].[Course_Instructor]([course_id]); 

CREATE INDEX branch_id_instructor_index
ON  [dbo].[Course_Instructor]([branch_id]); 

CREATE INDEX intake_id_instructor_index
ON  [dbo].[Course_Instructor]([intake_number]); 

-------------------------------------
-- Indexes on Department Table
CREATE INDEX department_index
ON [dbo].[Department] ([department_id]);  

CREATE INDEX department_name_index
ON [dbo].[Department] ([department_name]);  
-------------------------------------
-- Indexes on Exam Table
CREATE INDEX exam_index
ON [dbo].[Exam] ([type] ,[date_created]); 

-------------------------------------
-- Indexes on Exam_Question Table
CREATE INDEX exam_question_index
ON [dbo].[Exam_Question] ([exam_id],[question_id]); 

-------------------------------------
-- Indexes on Instructor Table
CREATE INDEX instructor_index
ON [dbo].[Instructor] ([first_name],[last_name]); 

-------------------------------------
-- Indexes on Intake Table
CREATE UNIQUE INDEX intake_index
ON [dbo].[Intake] ([phone]); 

-------------------------------------
-- Indexes on Program Table
CREATE UNIQUE INDEX program_index
ON [dbo].[Program] ([track_id],[branch_id],[intake_number]); 

-----------------------------------------------------------
-- Indexes on Question Table
CREATE INDEX question_index
ON [dbo].[Question] ([course_id],[type],[degree]); 

-----------------------------------------------------------
-- Indexes on Student Table
CREATE INDEX student_index
ON [dbo].[Student] ([first_name],[last_name],[age]); 

-----------------------------------------------------------
-- Indexes on Student_Course Table
CREATE INDEX student_course_index
ON  [dbo].[Student_Course]([course_id],[student_id]); 
-----------------------------------------------------------
-- Indexes on Student_Exam Table
CREATE INDEX student_exam_index
ON [dbo].[Student_Exam]([exam_id],[student_id]); 

-----------------------------------------------------------
-- Indexes on Student_Question_Answer Table
CREATE INDEX student_question_answer_index
ON [dbo].[Student_Question_Answer]([exam_id],[question_id],[student_id]); 

-----------------------------------------------------------
-- Indexes on Track Table
CREATE INDEX track_index
ON [dbo].[Track]([track_name]); 

--------------------------------------------------------------------


--ALTER INDEX track_index ON [dbo].[Track] RENAME TO new_track_index; 
----------------------------------------------------------------------
--When should INDEXES not be used in SQL?
--The Indexes should not be used in SQL in the following cases or situations:

--SQL Indexes can be avoided when the size of the table is small.
--When the table needs to be updated frequently.
--Indexed should not be used on those cases when the column of a table contains a large number of NULL values.

----------------------------------------------------------------
--DROP INDEX [IF EXISTS] 
--    index_name1 ON table_name1,
--    index_name2 ON table_name2,
--    ...;
