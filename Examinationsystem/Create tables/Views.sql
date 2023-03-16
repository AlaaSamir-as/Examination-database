alter view ins.show_Qpool
WITH ENCRYPTION
as 
select q_id, question,ch1,ch2,ch3,ch4,correct_ans from q_pool q,tm.courses c,tm.instructor i
where q.cr_id=c.cr_id and c.ins_id=i.ins_id and ins_username=USER_NAME()
WITH CHECK OPTION

alter view ins.show_exam
WITH ENCRYPTION
as
select ex_id,ex_type,ex_year from q_pool q, exams e,tm.instructor i
where e.ins_id=i.ins_id and  ins_username=USER_NAME() 
WITH CHECK OPTION

create view ins.show_student
WITH ENCRYPTION
as
select st_id,st_fname,st_lname from tm_add.student s,tm.instructor i
where s.ins_id=i.ins_id and  ins_username=USER_NAME() 
WITH CHECK OPTION


alter view st.show_exam
WITH ENCRYPTION
as
select question ,ch1,ch2,ch3,ch4 from q_pool q,Ex_pool e,st_exam s,tm_add.student st,exams ex
where  q.q_id=e.q_id and e.ex_id=s.ex_id and s.st_id =st.st_id and st_username=USER_NAME() and e.ex_id=ex.ex_id 
WITH CHECK OPTION


--select distinct  question ,ch1,ch2 from q_pool q,Ex_pool e,st_exam s,student st,exams
--where  q.q_id=e.q_id and e.ex_id=s.ex_id and s.st_id =st.st_id and st_username=USER_NAME() and ex_type='exam' and q_type='t or f'

alter view st.show_correctiveExam
WITH ENCRYPTION
as
select question ,ch1,ch2,ch3,ch4 from q_pool q,Ex_pool e,st_exam s,tm_add.student st,exams ex
where  q.q_id=e.q_id and e.ex_id=s.ex_id and s.st_id =st.st_id and st_username=USER_NAME() and e.ex_id=ex.ex_id and ex_type='corrective' 
WITH CHECK OPTION





alter view st.show_answer
WITH ENCRYPTION
as
		select st_ans ,ex_type from score_card c ,tm_add.student s,exams ex
		where ex.ex_id=c.ex_id and s.st_id=c.st_id and st_username=USER_NAME() and month=month(getdate()) and year =year(getdate())
WITH CHECK OPTION



alter view st.show_score
WITH ENCRYPTION
as

		select st_fname,st_lname,st_score,ex_type from examination e,tm_add.student s,exams ex 
		where ex.ex_id=e.ex_id and e.st_id=s.st_id and st_username=USER_NAME() and month=month(getdate()) and year =year(getdate()) and st_score_manual is null
        UNION ALL 
		select st_fname,st_lname,st_score_manual,ex_type from examination e,tm_add.student s ,exams ex
		where ex.ex_id=e.ex_id and e.st_id=s.st_id and st_username=USER_NAME() and month=month(getdate()) and year =year(getdate()) and st_score_manual is not null		
WITH CHECK OPTION

--(declare @s int)
--select @s =st_score_manual from examination e,student s
--where e.st_id=s.st_id and st_username=USER_NAME() and month=month(getdate()) and year =year(getdate())
--EXISTS (SELECT st_score_manual from examination e,student s
--where e.st_id=s.st_id and st_username=USER_NAME() and month=month(getdate()) and year =year(getdate()))

