create trigger htmlQpool_insert
on academy.html.q_pool
after insert
as
begin 
	declare @q_type nvarchar(max) select @q_type= q_type from inserted
	declare @qus nvarchar(max) select @qus=question from inserted
	declare @ch1 nvarchar(max) select @ch1=ch1 from inserted
	declare @ch2 nvarchar(max) select @ch2=ch2 from inserted
	declare @ch3 nvarchar(max) select @ch3=ch3 from inserted
	declare @ch4 nvarchar(max) select @ch4=ch4 from inserted
	declare @cor nvarchar(max) select @cor=correct_ans from inserted
	declare @cr_id int select @cr_id=cr_id from tm.courses c, tm.instructor i
					   where c.ins_id=i.ins_id and ins_username= USER_NAME()
	insert into dbo.q_pool(q_type,question,ch1,ch2,ch3,ch4,correct_ans,cr_id)
	values (@q_type,@qus,@ch1,@ch2,@ch3,@ch4,@cor,@cr_id)
end

create trigger htmlQpool_notupdate
on academy.html.q_pool
after update
as
begin 
		if exists(select ins_id from tm.instructor where ins_username=USER_NAME())
		begin
			rollback
			print 'can not update'
		end
end

create trigger htmlQpool_notdelete
on academy.html.q_pool
after delete
as
begin 
		if exists(select ins_id from tm.instructor where ins_username=USER_NAME())
		begin
			rollback
			print 'can not delete'
		end
end

create trigger htmlQpool_update
on dbo.q_pool
after update
as
begin 
	declare @q_type nvarchar(max) select @q_type= q_type from inserted
	declare @qus nvarchar(max) select @qus=question from inserted
	declare @ch1 nvarchar(max) select @ch1=ch1 from inserted
	declare @ch2 nvarchar(max) select @ch2=ch2 from inserted
	declare @ch3 nvarchar(max) select @ch3=ch3 from inserted
	declare @ch4 nvarchar(max) select @ch4=ch4 from inserted
	declare @cor nvarchar(max) select @cor=correct_ans from inserted

	update academy.html.q_pool
	set q_type=@q_type,question=@qus,ch1=@ch1,ch2=@ch2,ch3=@ch3,ch4=@ch4,correct_ans=@cor
	where question=@qus
end

create trigger htmlQpool_delete
on dbo.q_pool
after delete
as
begin 
	declare @q nvarchar(max) select @q= question from deleted
	delete from academy.html.q_pool
	where question=@q
end

