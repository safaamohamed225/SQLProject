
GO
create or alter function get_students_answers_for_text_questions (@exam_id int)
returns table as return(
SELECT sqa.exam_id, sqa.question_id, q.type, q.question_text, sqa.student_id, sqa.student_answer, q.correct_answer AS 'Best_Accepted_answer', q.degree, sqa.correct AS 'IsCorrect?'
FROM     Student_Question_Answer AS sqa INNER JOIN
                  Question AS q ON sqa.question_id = q.question_id
WHERE  (sqa.exam_id = @exam_id) AND (q.type = 'Text')
)
GO

-- select * from get_students_answers_for_text_questions(3)