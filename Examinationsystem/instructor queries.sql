select * from ins.show_Qpool                                    --show question of his course

ins.ins_make_exam 'exam','9:30:00','10:00:00',1,2                  --select exam automatic

select * from ins.show_exam								             --select ID,type and year of his exams

ins.showExam_id 33                                                     --show questions of his exams by id

ins.ins_make_exam_manual 'corrective','9:30:00','10:00:00',1,2,3         --select exam manual

select * from ins.show_student						                       --select his students

ins.give_student_exam 33, 1												 --select student to exam

exec ins.show_st_correction 33,1,1,2023                                        --exam correction automatic 

ins.exam_correction_manual 33,1,1,2023,30									     --exam correction manual 

ins.exam_correction 33,1,1,2023                                                   --restore degree of correction automatic 

