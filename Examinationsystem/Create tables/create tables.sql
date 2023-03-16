create table instructor
(
ins_id int identity(1,1),
ins_fname nvarchar(12),
ins_lname nvarchar(12),
ins_username nvarchar(max),
ins_password nvarchar(4),
ins_address nvarchar(8),
ins_age int

constraint ins_PK primary key (ins_id)
)

create table student
(
st_id int identity(1,1),
st_fname nvarchar(12),
st_lname nvarchar(12),
st_username nvarchar(max),
st_password nvarchar(4),
st_address nvarchar(8),
st_age int,
ins_id int


constraint St_PK primary key (st_id),
constraint St_Ins_FK foreign key (ins_id) references instructor(ins_id) 
)

create table courses
(
cr_id int,
cr_name nvarchar(30),
cr_des nvarchar(max),
max_deg int,
min_deg int,
ins_id int

constraint Cr_PK primary key (cr_id),
constraint Cr_Ins_FK foreign key (ins_id) references instructor(ins_id)
)

create table exams
(
ex_id int identity(1,1),
--ex_name nvarchar(20),
ex_type nvarchar(10) default 'exam',
ex_year int,
start_time time,
end_time time,
total_time time,
ins_id int,
cr_id int

constraint Ex_PK primary key (ex_id),
constraint Ex_Ins_FK foreign key (ins_id) references instructor(ins_id),
constraint Ex_Cr_FK foreign key (cr_id) references courses(cr_id)
)
alter table exams
drop column ex_name

create table q_pool
(
q_id int identity (1,1),
q_type nvarchar(10),
question nvarchar(max),
ch1 nvarchar(max),
ch2 nvarchar(max),
ch3 nvarchar(max),
ch4 nvarchar(max),
correct_ans nvarchar(max),
points int

constraint Q_PK primary key(q_id)
)
alter table q_pool
add cr_id int
alter table q_pool
add constraint Qpool_Cr_FK foreign key (cr_id) references courses(cr_id)

create table st_course
(
st_id int,
cr_id int

constraint St_course_PK primary key (st_id,cr_id),
constraint St_St_course_FK foreign key (st_id) references student(st_id),
constraint Cr_St_course_FK foreign key (cr_id) references courses(cr_id)
)

create table Ex_pool
(
ex_id int,
q_id int

constraint Ex_pool_PK primary key (ex_id,q_id),
constraint Ex_Ex_pool_FK foreign key (ex_id) references exams(ex_id),
constraint Q_Ex_pool_FK foreign key (q_id) references q_pool(q_id)
)



create table examination
(
st_id int,
ex_id int,
cr_name nvarchar(30),
ins_fname nvarchar(12),
ins_lname nvarchar(12),
[year] int,
st_score int,
cr_degree int
--constraint Examination_PK primary key (ex_id,st_id),
constraint Ex_Examination_FK foreign key (ex_id) references exams(ex_id),
constraint St_Examination_FK foreign key (st_id) references student(st_id)
)
alter table examination
add [month] int
alter table examination
drop constraint Examination_PK
alter table examination
add constraint Examination_PK primary key (st_id,[month],[year]) 
alter table examination
add constraint Examination_DF default 0  for st_score
alter table examination
add st_score_manual int

create table score_card
(
--q_id int,
st_id int,
[date] time,
st_ans nvarchar(max),
correct_ans nvarchar(max),
points int

--constraint score_card_PK primary key (q_id,st_id,[date]),
--constraint Q_score_card_FK foreign key (q_id) references q_pool(q_id),
constraint St_score_card_FK foreign key (st_id) references student(st_id)
)
alter table score_card
add ex_id int
alter table score_card
add constraint Ex_score_card_FK foreign key (ex_id) references exams(ex_id)
alter table score_card
drop constraint score_card_PK,Q_score_card_FK
alter table score_card
drop column q_id
alter table score_card
drop column [date] 
alter table score_card
add [month] int
alter table score_card
add [year] int
alter table score_card
add constraint score_card_PK primary key (st_id,[month],[year])
alter table score_card
drop column points 

create table st_exam
(
st_id int,
ex_id int

constraint St_exam_PK primary key (st_id,ex_id)
constraint St_exam_Ex_FK Foreign key (ex_id) references exams(ex_id),
constraint St_exam_St_FK Foreign key (st_id) references student(st_id)
)