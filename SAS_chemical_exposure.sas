/* 
Chemical Exposure status is measured by Agent Orange, AO exposure 
*/

/* Step 1.
Define AO exposure using CDW - SPatient_SPatientDisability domain variables: 
AgentOrangeExposureCode="YES" 
AgentOrangeLocation="VIETNAM"
*/

proc sql;
 create table AO_Vietnam as
  select patientsid,AgentOrangeExposureCode,AgentOrangeLocation from SPatient_SPatientDisability
   where (patientsid in select patientsid from myanalyticcohort)	
		AND ((AgentOrangeExposureCode = "YES")
		OR (AgentOrangeLocation = "VIETNAM"));
run;

proc sort data=AO_Vietnam nodupkey; by _all_;run;
proc sort data= myanalyticcohort; by patientsid;run;
data AO_Vietnam2(drop=PatientSID); merge myanalyticcohort(in=X) AO_Vietnam(in=Y);
 by patientsid;
 if X and Y;
run;

proc sort data=AO_Vietnam2 nodupkey; by _all_;run;
proc sort data= myanalyticcohort; by PatientSSN;run;
data step1dataset; merge myanalyticcohort(in=X) AO_Vietnam2(in=Y);
 by PatientSSN;
 if X;
run;


/* Step 2.
Define AO status using CDW - SPatient_MilitaryServiceEpisode domain 
Ever served in Air Force/Army during 01/09/1962-12/31/1970
*/

proc sql;
 create table SPatient_MilitaryServiceEpisode as
  select BranchOfServiceSID, ServiceEntryDate, ServiceSeparationDate, patientsid from SPatient_MilitaryServiceEpisode
   where (patientsid in select patientsid from myanalyticcohort) and
		 ('09JAN1962'd<=ServiceEntryDate<='31DEC1970'd or '09JAN1962'd<=ServiceSeparationDate<='31DEC1970'd);
run;

proc sql;
 create table SPatient_branch as 
  select a.ServiceEntryDate,a.ServiceSeparationDate,a.patientsid,b.BranchOfService from SPatient_MilitaryServiceEpisode as a
   left join DIM_RB02.BranchOfService as b
    on a.BranchOfServiceSID = b.BranchOfServiceSID;
quit;

proc sort data=SPatient_branch nodupkey; by _all_;run;
proc sort data=SPatient_branch; by patientsid;run;
proc sort data= myanalyticcohort; by patientsid;run;
data SPatient_branch2(drop=patientsid); merge SPatient_branch(in=X) myanalyticcohort(in=Y);
 by patientsid;
 if X and Y and BranchOfService in ('ARMY' 'AIR FORCE');
run;
proc sort data=SPatient_branch2 nodupkey out=ever_army_airforce(keep=PatientSSN); by PatientSSN;run;

data step2dataset; merge step1dataset(in=X) ever_army_airforce (in=Y);
 by patientssn;
 if X=1 and Y=1 then ever_army_airforce6270=1;
 else if X=1 and Y=0 then ever_army_airforce6270=0;
 else delete;
run;

/* Step 3.
Finalize the definition variable - AO_newdef
*/

data step3dataset; set step2dataset;
 if AgentOrangeExposureCode = "YES" and AgentOrangeLocation = "VIETNAM" and ever_army_airforce6270=1
 then AO_newdef="YES";
 else AO_newdef="NO";
run;
