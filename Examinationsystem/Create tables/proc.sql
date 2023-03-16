---------- make exam by tm
alter proc make_exam (@cr_id int,@ex_type nvarchar(10),@st_time time,@end_time time,@num1 int,@num2 int)
as 
-- insert into exams
declare @ins int
	select @ins = ins_id from tm.instructor where ins_username=USER_NAME()
	insert into exams(cr_id,ex_type,total_time,start_time,end_time,ex_year,ins_id) 
	values(@cr_id,@ex_type,datediff(minute,@st_time,@end_time),@st_time,@end_time,year(getdate()),@ins)

-- select from q_pool
declare @x table(q_id int) 
declare @y table(q_id int)
declare @t table(q_id int)
insert into @x
	select top(@num1) q_id from q_pool where q_type='T or F' and cr_id=@cr_id order by newid()
insert into @y
	select top(@num2) q_id from q_pool where q_type='MCQ' and cr_id=@cr_id order by newid()
insert into @t
	select * from @x union all select * from @y

declare @w table(ex_id int)
insert into @w
	select top(1) ex_id from exams order by ex_id desc

-- insert into ex_pool
	insert into Ex_pool
	select * from @w,@t

exec make_exam 1,corrective,'9:00:00','9:40:00',1,2






---------- make exam manual by tm
alter proc make_exam_manual (@cr_id int,@ex_type nvarchar(10),@st_time time,@end_time time,@1 int,@2 int,@3 int)
as 
-- insert into exams
declare @ins int
	select @ins = ins_id from tm.instructor where ins_username=USER_NAME()
	insert into exams(cr_id,ex_type,total_time,start_time,end_time,ex_year,ins_id) 
	values(@cr_id,@ex_type,datediff(minute,@st_time,@end_time),@st_time,@end_time,year(getdate()),@ins)

-- select from q_pool
declare @t table(q_id int)
insert into @t
	select q_id from q_pool where q_id=@1 and cr_id=@cr_id union all
	select q_id from q_pool where q_id=@2 and cr_id=@cr_id union all
	select q_id from q_pool where q_id=@3 and cr_id=@cr_id 


declare @w table(ex_id int)
insert into @w
	select top(1) ex_id from exams order by ex_id desc

-- insert into ex_pool
	insert into Ex_pool
	select * from @w,@t

exec make_exam_manual 1,exam,'9:00:00','9:40:00',1,3,4











---------- make exam by ins
alter proc ins.ins_make_exam (@ex_type nvarchar(10),@st_time time,@end_time time,@num1 int,@num2 int)
as 
-- insert into exams
declare @ins int
	select @ins = ins_id from tm.instructor where ins_username=USER_NAME()
declare @cr_id int
	select @cr_id = cr_id from tm.instructor i,tm.courses c where i.ins_id=c.ins_id and ins_username=USER_NAME()
	insert into exams(cr_id,ex_type,total_time,start_time,end_time,ex_year,ins_id) 
	values(@cr_id,@ex_type,datediff(minute,@st_time,@end_time),@st_time,@end_time,year(getdate()),@ins)

-- select from q_pool
declare @x table(q_id int) 
declare @y table(q_id int)
declare @t table(q_id int)
insert into @x
	select top(@num1) q_id from q_pool where q_type='T or F' and cr_id=@cr_id order by newid()
insert into @y
	select top(@num2) q_id from q_pool where q_type='MCQ' and cr_id=@cr_id order by newid()
insert into @t
	select * from @x union all select * from @y

declare @w table(ex_id int)
insert into @w
	select top(1) ex_id from exams order by ex_id desc

-- insert into ex_pool
	insert into Ex_pool
	select * from @w,@t

exec ins.ins_make_exam corrective,'9:00:00','9:40:00',1,2











---------- make exam manual by ins
alter proc ins.ins_make_exam_manual (@ex_type nvarchar(10),@st_time time,@end_time time,@1 int,@2 int,@3 int)
as 
-- insert into exams
declare @ins int
	select @ins = ins_id from tm.instructor where ins_username=USER_NAME()
declare @cr_id int
	select @cr_id = cr_id from tm.instructor i,tm.courses c where i.ins_id=c.ins_id and ins_username=USER_NAME()
	insert into exams(cr_id,ex_type,total_time,start_time,end_time,ex_year,ins_id) 
	values(@cr_id,@ex_type,datediff(minute,@st_time,@end_time),@st_time,@end_time,year(getdate()),@ins)

-- select from q_pool
declare @t table(q_id int)
insert into @t
	select q_id from q_pool where q_id=@1 and cr_id=@cr_id union all
	select q_id from q_pool where q_id=@2 and cr_id=@cr_id union all
	select q_id from q_pool where q_id=@3 and cr_id=@cr_id 


declare @w table(ex_id int)
insert into @w
	select top(1) ex_id from exams order by ex_id desc

-- insert into ex_pool
	insert into Ex_pool
	select * from @w,@t

exec make_exam_manual 1,exam,'9:00:00','9:40:00',1,3,4














---- put st answer
alter proc st.exam_ans (@1 nvarchar(max),@2 nvarchar(max),@3 nvarchar(max))
as
begin try 
	declare @ex_id int
		select @ex_id = ex_id from st_exam ex,tm_add.student s where ex.st_id=s.st_id and st_username=USER_NAME() 
	declare @st_id int
		select @st_id = st_id from tm_add.student where st_username=USER_NAME() 
	declare @cr_name nvarchar(max)
		select @cr_name = cr_name from tm.courses c,exams e where c.cr_id=e.cr_id and ex_id=@ex_id 
	declare @x nvarchar(max)
		select @x =ins_fname from tm.instructor i,exams e where i.ins_id=e.ins_id and ex_id=@ex_id
	declare @y nvarchar(max) 
		select @y =ins_lname from tm.instructor i,exams e where i.ins_id=e.ins_id and ex_id=@ex_id
	declare @cr_deg int 
		select @cr_deg =max_deg from tm.courses c,exams e where c.ins_id=e.ins_id and ex_id=@ex_id

--insert into examination
	insert into examination(ex_id,st_id,cr_name,ins_fname,ins_lname,month,year,cr_degree)
		values(@ex_id,@st_id,@cr_name,@x,@y,month(GETDATE()),year(GETDATE()),@cr_deg)

-- select correct answers
declare @corr_ans nvarchar(max)
	select @corr_ans=string_agg(correct_ans,',') from Ex_pool e,q_pool q 
		where ex_id=@ex_id and q.q_id=e.q_id
	
--insert into score card
	insert into score_card(st_id,ex_id,[month],[year],st_ans,correct_ans)
		values(@st_id,@ex_id,month(getdate()),year(getdate()),@1+','+@2+','+@3,@corr_ans)

-- put correct answers in variables
declare @1_ans nvarchar(max), @2_ans nvarchar(max), @3_ans nvarchar(max)
declare @t table (correct_ans nvarchar(max),r int)
	insert into @t
		select  correct_ans ,ROW_NUMBER() over(ORDER BY e.q_id) as r from Ex_pool e,q_pool q 
		where ex_id=@ex_id and q.q_id=e.q_id 

select @1_ans= correct_ans from @t where r = 1
select @2_ans= correct_ans from @t where r = 2
select @3_ans= correct_ans from @t where r = 3


-- Check answer
update examination set st_score =0
where st_id=@st_id and month=month(getdate()) and year= year(getdate())

declare @p int
	select @p =st_score from examination 
		where st_id=@st_id and month=month(getdate()) and year= year(getdate())
if(@1=@1_ans)
	begin
		update examination
		set st_score=@p,@p+=10
		where st_id=@st_id and month=month(getdate()) and year= year(getdate())
	end
if(@2=@2_ans)
	begin
		update examination
		set st_score=@p,@p+=10
		where st_id=@st_id and month=month(getdate()) and year= year(getdate())
	end
if(@3=@3_ans)
	begin
		update examination
		set st_score=@p,@p+=10
		where st_id=@st_id and month=month(getdate()) and year= year(getdate())
	end
	print 'Your answers was sent successfully'

-- Check min degree
declare @min int
	select @min = min_deg from tm.courses c,tm.st_course sc,tm_add.student s
	where c.cr_id=sc.cr_id and s.st_id=sc.st_id and st_username=USER_NAME()

if (@p<@min)
	begin
		print 'failed'
		declare @correx_id int
		select top(1) @correx_id = ex_id from exams where ex_type='corrective' order by newid()

		update st_exam
		set st_id= @st_id ,ex_id=@correx_id
		where st_id=@st_id
	end
	else print 'success'

end try
begin catch
		print'can not send your answers'
end catch
exec exam_ans 12,5,'true','d','l'













---- exam correction automatic
alter proc ins.show_st_correction (@ex_id int,@st_id int,@m int,@y int)
as
		if exists (select st_ans,correct_ans from score_card where st_id=@st_id and month=@m and year =@y and ex_id=@ex_id)
		select st_ans,correct_ans from score_card where st_id=@st_id and month=@m and year =@y and ex_id=@ex_id
		else print 'ID of student or exam is not correct'
exec show_st_correction 12,5,1,2023


---- exam correction manual


alter proc ins.exam_correction_manual (@ex_id int,@st_id int,@m int,@y int,@p int)
as
		if exists(select st_id ,ex_id from examination
		where st_id=@st_id and month=month(getdate()) and year= year(getdate()) and ex_id=@ex_id)
			update examination
			set st_score_manual=@p
			where st_id=@st_id and month=month(getdate()) and year= year(getdate()) and ex_id=@ex_id
		else print 'not found'

exec exam_correction_manual 12,5,1,2023,10






---- restore degree of correction automatic and delete degree of correction manual

alter proc ins.exam_correction (@ex_id int,@st_id int,@m int,@y int)
as
		if exists(select st_id ,ex_id from examination
		where st_id=@st_id and month=month(getdate()) and year= year(getdate()) and ex_id=@ex_id)
			update examination
			set st_score_manual =Null
			where st_id=@st_id and month=month(getdate()) and year= year(getdate()) and ex_id=@ex_id
		else print 'not found'
exec exam_correction 12,5,1,2023











--- show student score
alter proc show_st_score (@ex_id int,@st_id int,@m int,@y int)
as
declare @s int
select @s =st_score_manual from examination where st_id=@st_id and ex_id=@ex_id and month=@m and year =@y
	if(@s is null)
		select st_fname,st_lname,st_score from examination e,tm_add.student s 
		where e.st_id=s.st_id and e.st_id=@st_id and ex_id=@ex_id and month=@m and year =@y
	else
		select st_fname,st_lname,st_score_manual from examination e,tm_add.student s 
		where e.st_id=s.st_id and e.st_id=@st_id and ex_id=@ex_id and month=@m and year =@y
exec show_st_score 12,5,1,2023
	











--- give student exam
alter proc ins.give_student_exam (@ex_id int,@st_id int)
as
declare @st int
	select @st=st_id from st_exam where st_id=@st_id
declare @ex int
	select @ex=ex_id from st_exam where ex_id=@ex_id
	if ( @st is not null and @ex is not null)
		begin
			print 'st_id and ex_id has been added'
		end
    else if exists(select st_id from tm_add.student s,tm.instructor i where st_id=@st_id and s.ins_id=i.ins_id and ins_username= USER_NAME())
    and exists(select ex_id from exams s,tm.instructor i where ex_id=@ex_id and s.ins_id=i.ins_id and ins_username= USER_NAME())
		begin
			insert into st_exam (st_id,ex_id)
			values(@st_id,@ex_id)
		end
	else
		print 'ID of student or exam is not correct'

exec give_student_exam 12,5






----- demooo
---to show only corrective exam 
create proc st.show_correctiveExam
as
begin try 
declare @min int
	select @min = min_deg from tm.courses c,tm.st_course sc,tm_add.student s
	where c.cr_id=sc.cr_id and s.st_id=sc.st_id and st_username=USER_NAME()
declare @st_id int
		select @st_id = st_id from tm_add.student where st_username=USER_NAME() 
declare @p int
	select @p =st_score from examination 
		where st_id=@st_id and month=month(getdate()) and year= year(getdate())
if(@p<@min)

alter proc ins.showExam_id (@ex_id int)
as

if exists (select question,ch1,ch2,ch3,ch3,ch4,correct_ans from Ex_pool ep, q_pool q, exams e,tm.instructor i
where e.ins_id=i.ins_id and  ins_username=USER_NAME() and q.q_id=ep.q_id and ep.ex_id=@ex_id)
begin
select distinct question,ch1,ch2,ch3,ch3,ch4,correct_ans from Ex_pool ep, q_pool q, exams e,tm.instructor i
where e.ins_id=i.ins_id and  ins_username=USER_NAME() and q.q_id=ep.q_id and ep.ex_id=@ex_id
end
else 
	print 'ex_id is not correct'



--alter function examCorr (@s nvarchar(max),@f nvarchar(max),@st_id int,@m int,@y int)
--returns int
--begin
--declare @p int
--select @p =st_score from examination 
--where st_id=@st_id and month=@m and year= @y
--if(@s=@f)
--begin
--declare @sql varchar(max)
--set @sql='update examination
--set st_score=@p,@p+=10
--where st_id=@st_id and month=@m and year= @y'
--exec master..xp_cmdshell @sql 
--end
--return @p
--end


--EXECUTE sp_configure
--EXEC sp_configure 'show advanced options', 1; GO  RECONFIGURE; GO  EXEC sp_configure 'xp_cmdshell', 1; GO  RECONFIGURE GO

--EXECUTE sp_configure 'show advanced options', 1;  
--GO  
--RECONFIGURE;  
--GO  
--EXECUTE sp_configure 'xp_cmdshell', 1;  
--GO  
--RECONFIGURE;  
--GO  

--EXEC sp_configure 'xp_cmdshell', 0
--GO
--RECONFIGURE
--GO
