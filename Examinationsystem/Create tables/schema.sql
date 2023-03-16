create schema html

select * into html.q_pool from q_pool where cr_id=1

create schema tm

alter schema tm transfer dbo.instructor
--alter schema tm transfer dbo.student
alter schema tm transfer dbo.courses
alter schema tm transfer dbo.st_course
alter schema tm transfer dbo.make_exam
alter schema tm transfer dbo.make_exam_manual
alter schema tm transfer dbo.show_st_score

create schema tm_add
alter schema tm_add transfer tm.student

select * from Ex_pool

create schema ins
alter schema ins transfer html.show_Qpool
alter schema ins transfer dbo.ins_make_exam
alter schema ins transfer dbo.ins_make_exam_manual
alter schema ins transfer dbo.give_student_exam
alter schema ins transfer dbo.exam_correction
alter schema ins transfer dbo.exam_correction_manual
alter schema ins transfer dbo.show_st_correction



create schema st
alter schema st transfer dbo.show_exam
alter schema st transfer dbo.exam_ans
alter schema st transfer dbo.show_answer
alter schema st transfer dbo.show_score
