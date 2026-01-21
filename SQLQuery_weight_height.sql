/********************************OMOPV5 MEASUREMENT domain: Weight, Height, BMI*******************************/

-- Height 
select coh.PatientICN
	,height.value_as_number as height
into #height
from Src.OMOPV5_MEASUREMENT height
inner join Src.OMOPV5_CohortCrosswalk walk
on height.person_id = walk.PERSON_ID
inner join #myanalyticcohort coh
on walk.PatientICN = coh.PatientICN
where height.MEASUREMENT_CONCEPT_ID = 3036277 
	and height.VALUE_AS_NUMBER is not NULL 
	and height.value_as_number>48 
	and height.value_as_number<90
order by PatientICN,VALUE_AS_NUMBER
;

Drop Table If Exists #heightfreq;
select count(height) as count1
	,height
	,PatientICN
into #heightfreq
from #height
group by PatientICN, height
order by PatientICN, count1

--each pt's most frequent height 
;with commonht as (
	select *, ROW_NUMBER() over(partition by PatientICN order by count1) as freq
	from #heightfreq
)
select PatientICN, 
		height 
from commonht
where freq = 1
order by PatientICN
;

-- Weight
select coh.PatientICN
	,weight.MEASUREMENT_DATE AS WEIGHT_DATE
	,weight.value_as_number as weight
into #weight
from ORD_Chang_202011003D.Src.OMOPV5_MEASUREMENT weight
inner join ORD_Chang_202011003D.Src.OMOPV5_CohortCrosswalk walk
on weight.person_id = walk.PERSON_ID
inner join #myanalyticcohort coh
on walk.PatientICN = coh.PatientICN
where weight.MEASUREMENT_CONCEPT_ID = 3025315
	and weight.VALUE_AS_NUMBER is not NULL 
	and weight.MEASUREMENT_DATE is not null 
	and weight.MEASUREMENT_DATE <= mgus_date
	and datediff(day,weight.MEASUREMENT_DATE, mgus_date) <= 2*365
	and weight.value_as_number >50 
	and weight.value_as_number <1400
order by PatientICN,MEASUREMENT_DATE
;

--keep only one measurement per date
select max(weight) as weight
	,PatientICN
	,WEIGHT_DATE
into #weightfreq
from #weight
group by PatientICN, WEIGHT_DATE
order by PatientICN, WEIGHT_DATE

--each pt's weight closest to mgus_date
;with lastwt as (
	select *, ROW_NUMBER() over(partition by PatientICN order by WEIGHT_DATE desc) as last
	from #weightfreq
)
select PatientICN, 
		weight 
from lastwt
where last = 1
order by PatientICN
;

