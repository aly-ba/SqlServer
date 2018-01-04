/*
T-SQL Window Functions Class
Module 8
Demo 3
*/


USE PL_SampleData; 
GO


--Top 10% get As
SELECT StudentID, Grade, 
	CASE WHEN PERCENT_RANK() OVER(ORDER BY Grade) > 0.9 THEN 'A'
		WHEN PERCENT_RANK() OVER(ORDER BY Grade) > 0.8 THEN 'B'
		WHEN PERCENT_RANK() OVER(ORDER BY Grade) > 0.7 THEN 'C'
		WHEN PERCENT_RANK() OVER(ORDER BY Grade) > 0.6 THEN 'D'
		ELSE 'F' END AS LetterGrade		
FROM grades;


--Ignore top 5%
--http://blog.synology.com/?p=2086
SELECT DISTINCT PERCENTILE_DISC(0.95) 
	WITHIN GROUP(ORDER BY IOPS) OVER() AS IOPS95
FROM IOPS;
