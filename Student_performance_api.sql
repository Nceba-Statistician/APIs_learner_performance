
use LearnerPerformanceDB
go

select Age, GradeClass, ParentalEducation_, ParentalSupport_, Sports_, Music_,
avg(case when Gender_ = 'Male' then StudyTimeWeekly else NULL end) StudyTimeWeekly_Male,
avg(case when Gender_ = 'Female' then StudyTimeWeekly else NULL end) StudyTimeWeekly_Female,
avg(case when Gender_ = 'Male' then Absences else NULL end) Absences_Male,
avg(case when Gender_ = 'Female' then Absences else NULL end) Absences_Female,
avg(case when Gender_ = 'Male' then GPA else NULL end) GPA_Male,
avg(case when Gender_ = 'Female' then GPA else NULL end) GPA_Female
into Aggregated_Student_Performance
from (
select *,  case
when Gender = 1 then 'Male'
else 'Female' end Gender_, case
when ParentalEducation = 0 then 'None'
when ParentalEducation = 1 then 'Poor'
when ParentalEducation = 2 then 'Below Average'
when ParentalEducation = 3 then 'Satisfactory'
when ParentalEducation = 4 then 'Excellent'
end ParentalEducation_, case
when ParentalSupport = 0 then 'None'
when ParentalSupport = 1 then 'Poor'
when ParentalSupport = 2 then 'Below Average'
when ParentalSupport = 3 then 'Satisfactory'
when ParentalSupport = 4 then 'Excellent'
end ParentalSupport_, case
when Sports = 1 then 'Yes'
else 'No'
end Sports_, case
when Music = 1 then 'Yes'
else 'No'
end Music_
from Student_performance_api
) Sub
group by Age, GradeClass, ParentalEducation_, ParentalSupport_, Sports_, Music_
go

select * from  Aggregated_Student_Performance
select * from Student_performance_api

select Age, round(Avg_Male_GPA, 2) Avg_Male_GPA, round(Avg_Female_GPA, 2) Avg_Female_GPA from
(
select Age, row_number() over(partition by Age order by Age) Age_Part,
avg(GPA_Male) over(partition by Age order by Age) Avg_Male_GPA,
avg(GPA_Female) over(partition by Age order by Age) Avg_Female_GPA
from Aggregated_Student_Performance
) Sub where Age_Part = 1


select distinct Age, ParentalEducation_, ParentalSupport_, round(Avg_Male_GPA, 2) Avg_Male_GPA, round(Avg_Female_GPA, 2) Avg_Female_GPA from
(
select Age, ParentalEducation_, ParentalSupport_, row_number() over(partition by Age order by Age) Age_Part,
avg(GPA_Male) over(partition by Age, ParentalEducation_, ParentalSupport_ order by Age) Avg_Male_GPA,
avg(GPA_Female) over(partition by Age, ParentalEducation_, ParentalSupport_ order by Age) Avg_Female_GPA
from Aggregated_Student_Performance
) Sub




