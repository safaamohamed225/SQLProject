-- create function to enable student see exam questions
GO
create or alter function viewExam (@exam_id int)
returns table as return
(
	select q.question_id,q.type,q.question_text,
	ISNULL(q.optionA,'') as 'OptionA',
	ISNULL(q.optionB,'') as 'OptionB',
	ISNULL(q.optionC,'') as 'OptionC',
	ISNULL(q.optionD,'') as 'OptionD',
	q.degree
	from Exam as e inner join Exam_Question eq on e.exam_id = eq.exam_id
	inner join Question q on eq.question_id = q.question_id
	where eq.exam_id = @exam_id
)
GO