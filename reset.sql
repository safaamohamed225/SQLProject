
go 
alter sequence Exam_sequence
    restart with 1
    increment by 1;

delete from exam
delete from Exam_Question
delete from Student_Exam
delete from Student_Question_Answer

update student
set instructor_id = NULL