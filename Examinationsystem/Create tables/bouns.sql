--from data file

BULK INSERT Student
FROM '\\SystemX\DiskD\student.dat';

--from xml
INSERT INTO Student(st_address)  
SELECT * FROM OPENROWSET(  
   BULK 'c:\SampleFolder\SampleData3.txt', SINGLE_BLOB) AS x;


--text correction
if exists(SELECT textcorrection FROM st_ans
WHERE textcorrection LIKE '%aaaaaaa%')
