/********************************************************************************
Searching for ICD-9 and-10 Diagnosis Records associated with the following conditions
included in calculating Charlson Comorbidity Index within 1 year before MGUS diagnosis:
	Myocardial infarction:
		ICD-10: I21.x, I22.x, I25.2 
		ICD-9 : 410.x, 412.x 
	Congestive heart failure:
		ICD-10: I09.9,I11.0, I13.0, I13.2, I25.5, I42.0, I42.5-I42.9, I43.x, I50.x, P29.0 
		ICD-9 : 398.91, 402.01, 402.11, 402.91, 404.01, 404.03, 404.11, 404.13, 404.91, 404.93, 425.4-425.9, 428.x 
	Peripheral vascular disease:
		ICD-10: I70.x, I71.x, I73.1, I73.8, I73.9, I77.1, I79.0, I79.2, K55.1, K55.8, K55.9, Z95.8, Z95.9 
		ICD-9 : 093.0, 437.3, 440.x, 441.x, 443.1-443.9, 447.1, 557.1, 557.9, V43.4 
	Cerebrovascular disease:
		ICD-10: G45.x, G46.x, H34.0, I60.x-I69.x 
		ICD-9 : 362.34, 430.x-438.x 
	Dementia:
		ICD-10: F00.x-F03.x, F05.1, G30.x, G31.1 
		ICD-9 : 290.x, 294.1, 331.2 
	Chronic pulmonary disease:
		ICD-10: I27.8, I27.9, J40.x-J47.x, J60.x-J67.x, J68.4, J70.1, J70.3 
		ICD-9 : 416.8, 416.9, 490.x-505.x, 506.4, 508.1, 508.8 
	Rheumatic disease:
		ICD-10: M05.x, M06.x, M31.5, M32.x-M34.x, M35.1, M35.3, M36.0 
		ICD-9 : 446.5, 710.0-710.4, 714.0-714.2, 714.8, 725.x 
	Peptic ulcer disease:
		ICD-10: K25.x-K28.x 
		ICD-9 : 531.x-534.x 
	Mild liver disease:
		ICD-10: B18.x, K70.0-K70.3, K70.9, K71.3-K71.5, K71.7, K73.x, K74.x, K76.0, K76.2-K76.4, K76.8, K76.9, Z94.4 
		ICD-9 : 070.22, 070.23, 070.32, 070.33, 070.44, 070.54, 070.6, 070.9, 570.x, 571.x, 573.3, 573.4, 573.8, 573.9, V42.7 
	Diabetes without chronic complication:
		ICD-10: E10.0, E10.l, E10.6, E10.8, E10.9, E11.0, E11.1, E11.6, E11.8, E11.9, E12.0, E12.1, E12.6, E12.8, E12.9, E13.0, E13.1, E13.6, E13.8, E13.9, E14.0, E14.1, E14.6, E14.8, E14.9 
		ICD-9 : 250.0-250.3, 250.8, 250.9 
	Diabetes with chronic complication:
		ICD-10: E10.2-E10.5, E10.7, E11.2-E11.5, E11.7, E12.2-E12.5, E12.7, E13.2-E13.5, E13.7, E14.2-E14.5, E14.7 
		ICD-9 : 250.4-250.7 
	Hemiplegia or paraplegia:
		ICD-10: G04.1, G11.4, G80.1, G80.2, G81.x, G82.x, G83.0-G83.4, G83.9 
		ICD-9 : 334.1, 342.x, 343.x, 344.0-344.6, 344.9 
	Renal disease:
		ICD-10: I12.0, I13.1, N03.2-N03.7, N05.2-N05.7, N18.x, N19.x, N25.0, Z49.0-Z49.2, Z94.0, Z99.2 
		ICD-9 : 403.01, 403.11, 403.91, 404.02, 404.03, 404.12, 404.13, 404.92, 404.93, 582.x, 583.0-583.7, 585.x, 586.x, 588.0, V42.0, V45.1, V56.x 
	Any malignancy, including lymphoma and leukemia, except malignant neoplasm of skin:
		ICD-10: C00.x-C26.x, C30.x-C34.x, C37.x-C41.x, C43.x, C45.x-C58.x, C60.x-C76.x, C81.x-C85.x, C88.x, C90.x-C97.x 
		ICD-9 : 140.x-172.x, 174.x-195.8, 200.x-208.x, 238.6 
	Moderate or severe liver disease:
		ICD-10: I85.0, I85.9, I86.4, I98.2, K70.4, K71.1, K72.1, K72.9, K76.5, K76.6, K76.7 
		ICD-9 : 456.0-456.2, 572.2-572.8 
	Metastatic solid tumor:
		ICD-10: C77.x-C80.x 
		ICD-9 : 196.x-199.x 
	AIDS/HIV:
		ICD-10: B20.x-B22.x, B24.x 
		ICD-9 : 042.x-044.x 
*********************************************************************************/

--	Step 1	Make ICDSID dim table

DROP TABLE IF EXISTS #ICDSID_XXX;

;WITH CTE AS(
	SELECT
			ICD9SID AS ICDSID
			,ICD9Code AS ICDCode		
			,'ICD9' AS ICDCodeSource  -- Track ICD 9 or 10 as the source if needed
		FROM 
			CDWWork.Dim.ICD9
		WHERE 
			ICD9Code LIKE '410.%' OR ICD9Code LIKE '412.%'		-- Insert ICD-9 Code
	UNION		
	SELECT
			ICD10SID AS ICDSID
			,ICD10Code AS ICDCode		
			,'ICD10' AS ICDCodeSource  -- Track ICD 9 or 10 as the source if needed
		FROM 
			CDWWork.Dim.ICD10
		WHERE 
			ICD10Code LIKE 'I2.[12]%' OR ICD10Code = 'I25.2'		-- Insert ICD-10 Code
)
SELECT DISTINCT
		ICDSID
		,ICDCode
		,ICDCodeSource
	INTO
		#ICDSID_XXX
	FROM
		CTE;


--	Step 2	Query ICD history for the analytic cohort 

DROP TABLE IF EXISTS #ICD_XXX;

;WITH CTE AS(
--ICD 9 
	-- Outpatient
	SELECT
			COH.PatientSSN
			,CONVERT(DATE, OUTPAT.VisitDateTime) AS DxDate
			,ICD.ICDCode
			,ICD.ICDCodeSource
		FROM 
			#myanalyticcohort AS COH  
		INNER JOIN
			Src.Outpat_VDiagnosis AS OUTPAT
			ON		OUTPAT.PatientSID = COH.PatientSID
		INNER JOIN 
			#ICDSID_XXX AS ICD 
			ON		ICD.ICDSID = OUTPAT.ICD9SID
		WHERE 
				OUTPAT.VisitDateTime >= CAST(DATEADD(YEAR, -1, GETDATE()) AS DATE)	-- start date
			AND OUTPAT.VisitDateTime <= mgus_date	-- end date
	UNION
	-- Inpatient
	SELECT
			COH.PatientSSN
			,CONVERT(DATE, ISNULL(Dx.DischargeDateTime, INPAT.AdmitDateTime)) AS DxDate 
			,ICD.ICDCode
			,ICD.ICDCodeSource
		FROM 
			#myanalyticcohort AS COH  
		INNER JOIN
			Src.Inpat_InpatientDiagnosis AS Dx
			ON		Dx.PatientSID = COH.PatientSID
		INNER JOIN
			Src.Inpat_Inpatient AS INPAT
			ON		INPAT.InpatientSID = Dx.InpatientSID
		INNER JOIN 
			#ICDSID_XXX AS ICD 
			ON		ICD.ICDSID = Dx.ICD9SID
		WHERE 
			(INPAT.AdmitDateTime >= CAST(DATEADD(YEAR, -1, GETDATE()) AS DATE)	-- start date
			AND INPAT.AdmitDateTime <= mgus_date	-- end date
			OR
			(Dx.DischargeDateTime >= CAST(DATEADD(YEAR, -1, GETDATE()) AS DATE)	-- start date
			AND Dx.DischargeDateTime <= mgus_date)	-- end date
	UNION
	-- Fee Outpatient
	SELECT
			COH.PatientSSN
			,CONVERT(DATE, FIT.InitialTreatmentDateTime) AS DxDate
			,ICD.ICDCode
			,ICD.ICDCodeSource
		FROM 
			#myanalyticcohort AS COH  
		INNER JOIN
			Src.Fee_FeeInitialTreatment AS FIT
			ON		FIT.PatientSID = COH.PatientSID
		INNER JOIN 
			Src.Fee_FeeServiceProvided AS FSP
			ON		FSP.FeeInitialTreatmentSID = FIT.FeeInitialTreatmentSID
		INNER JOIN 
			#ICDSID_XXX AS ICD 
			ON		ICD.ICDSID = FSP.ICD9SID
		WHERE 
				FIT.InitialTreatmentDateTime >= CAST(DATEADD(YEAR, -1, GETDATE()) AS DATE)	-- start date
			AND FIT.InitialTreatmentDateTime <= mgus_date	-- end date
	UNION
	-- Fee Inpatient
	SELECT
			COH.PatientSSN
			,CONVERT(DATE, ISNULL(FINV.TreatmentFromDateTime, FINV.TreatmentToDateTime)) AS DxDate 
			,ICD.ICDCode
			,ICD.ICDCodeSource
		FROM
			#myanalyticcohort AS COH  
		INNER JOIN
			Src.Fee_FeeInpatInvoice AS FINV
			ON		FINV.PatientSID = COH.PatientSID
		INNER JOIN
			Src.Fee_FeeInpatInvoiceICDDiagnosis AS FICD
			ON		FICD.FeeInpatInvoiceSID = FINV.FeeInpatInvoiceSID
		INNER JOIN 
			#ICDSID_XXX AS ICD 
			ON		ICD.ICDSID = FICD.ICD9SID
		WHERE 
			(FINV.TreatmentFromDateTime >= CAST(DATEADD(YEAR, -1, GETDATE()) AS DATE)	-- start date
			AND FINV.TreatmentFromDateTime <= mgus_date)	-- end date
			OR
			(FINV.TreatmentToDateTime >= CAST(DATEADD(YEAR, -1, GETDATE()) AS DATE)	-- start date
			AND FINV.TreatmentToDateTime <= mgus_date)	-- end date
	UNION
	-- Inpat.InpatientFeeDiagnosis
	SELECT
			COH.PatientSSN
			,CONVERT(DATE, ISNULL(IFEE.AdmitDateTime, IFEE.DischargeDateTime)) AS DxDate 
			,ICD.ICDCode
			,ICD.ICDCodeSource
		FROM
			#myanalyticcohort AS COH 
		INNER JOIN
			Src.Inpat_InpatientFeeDiagnosis AS IFEE
			ON		IFEE.PatientSID = COH.PatientSID
		INNER JOIN 
			#ICDSID_XXX AS ICD 
			ON		ICD.ICDSID = IFEE.ICD9SID
		WHERE 
			(IFEE.AdmitDateTime >= CAST(DATEADD(YEAR, -1, GETDATE()) AS DATE)	-- start date
			AND IFEE.AdmitDateTime <= mgus_date)	-- end date
			OR
			(IFEE.DischargeDateTime >= CAST(DATEADD(YEAR, -1, GETDATE()) AS DATE)	-- start date
			AND IFEE.DischargeDateTime <= mgus_date)	-- end date
	UNION
-- ICD 10  
	-- Outpatient
	SELECT
			COH.PatientSSN
			,CONVERT(DATE, OUTPAT.VisitDateTime) AS DxDate
			,ICD.ICDCode
			,ICD.ICDCodeSource
		FROM 
			#myanalyticcohort AS COH  
		INNER JOIN
			Src.Outpat_VDiagnosis AS OUTPAT
			ON		OUTPAT.PatientSID = COH.PatientSID
		INNER JOIN 
			#ICDSID_XXX AS ICD 
			ON		ICD.ICDSID = OUTPAT.ICD10SID
		WHERE 
				OUTPAT.VisitDateTime >= CAST(DATEADD(YEAR, -1, GETDATE()) AS DATE)	-- start date
			AND OUTPAT.VisitDateTime <= mgus_date	-- end date
	UNION
	-- Inpatient
	SELECT
			COH.PatientSSN
			,CONVERT(DATE, ISNULL(Dx.DischargeDateTime, INPAT.AdmitDateTime)) AS DxDate 
			,ICD.ICDCode
			,ICD.ICDCodeSource
		FROM 
			#myanalyticcohort AS COH  
		INNER JOIN
			Src.Inpat_InpatientDiagnosis AS Dx
			ON		Dx.PatientSID = COH.PatientSID
		INNER JOIN
			Src.Inpat_Inpatient AS INPAT
			ON		INPAT.InpatientSID = Dx.InpatientSID
		INNER JOIN 
			#ICDSID_XXX AS ICD 
			ON		ICD.ICDSID = Dx.ICD10SID
		WHERE 
			(INPAT.AdmitDateTime >= CAST(DATEADD(YEAR, -1, GETDATE()) AS DATE)	-- start date
			AND INPAT.AdmitDateTime <= mgus_date)	-- end date
			OR
			(Dx.DischargeDateTime >= CAST(DATEADD(YEAR, -1, GETDATE()) AS DATE)	-- start date
			AND Dx.DischargeDateTime <= mgus_date)	-- end date
	UNION
	-- Fee Outpatient
	SELECT
			COH.PatientSSN
			,CONVERT(DATE, FIT.InitialTreatmentDateTime) AS DxDate
			,ICD.ICDCode
			,ICD.ICDCodeSource
		FROM 
			#myanalyticcohort AS COH  
		INNER JOIN
			Src.Fee_FeeInitialTreatment AS FIT
			ON		FIT.PatientSID = COH.PatientSID
		INNER JOIN 
			Src.Fee_FeeServiceProvided AS FSP
			ON		FSP.FeeInitialTreatmentSID = FIT.FeeInitialTreatmentSID
		INNER JOIN 
			#ICDSID_XXX AS ICD 
			ON		ICD.ICDSID = FSP.ICD10SID
		WHERE 
				FIT.InitialTreatmentDateTime >= CAST(DATEADD(YEAR, -1, GETDATE()) AS DATE)	-- start date
			AND FIT.InitialTreatmentDateTime <= mgus_date	-- end date
	UNION
	-- Fee Inpatient
	SELECT
			COH.PatientSSN
			,CONVERT(DATE, ISNULL(FINV.TreatmentFromDateTime, FINV.TreatmentToDateTime)) AS DxDate 
			,ICD.ICDCode
			,ICD.ICDCodeSource
		FROM
			#myanalyticcohort AS COH  
		INNER JOIN
			Src.Fee_FeeInpatInvoice AS FINV
			ON		FINV.PatientSID = COH.PatientSID
		INNER JOIN
			Src.Fee_FeeInpatInvoiceICDDiagnosis AS FICD
			ON		FICD.FeeInpatInvoiceSID = FINV.FeeInpatInvoiceSID
		INNER JOIN 
			#ICDSID_XXX AS ICD 
			ON		ICD.ICDSID = FICD.ICD10SID
		WHERE 
			(FINV.TreatmentFromDateTime >= CAST(DATEADD(YEAR, -1, GETDATE()) AS DATE)	-- start date
			AND FINV.TreatmentFromDateTime <= mgus_date)	-- end date
			OR
			(FINV.TreatmentToDateTime >= CAST(DATEADD(YEAR, -1, GETDATE()) AS DATE)	-- start date
			AND FINV.TreatmentToDateTime <= mgus_date)	-- end date
	UNION
	-- Inpat.InpatientFeeDiagnosis
	SELECT
			COH.PatientSSN
			,CONVERT(DATE, ISNULL(IFEE.AdmitDateTime, IFEE.DischargeDateTime)) AS DxDate 
			,ICD.ICDCode
			,ICD.ICDCodeSource
		FROM
			#myanalyticcohort AS COH  
		INNER JOIN
			Src.Inpat_InpatientFeeDiagnosis AS IFEE
			ON		IFEE.PatientSID = COH.PatientSID
		INNER JOIN 
			#ICDSID_XXX AS ICD 
			ON		ICD.ICDSID = IFEE.ICD10SID
		WHERE 
			(IFEE.AdmitDateTime >= CAST(DATEADD(YEAR, -1, GETDATE()) AS DATE)	-- start date
			AND IFEE.AdmitDateTime <= mgus_date)	-- end date
			OR
			(IFEE.DischargeDateTime >= CAST(DATEADD(YEAR, -1, GETDATE()) AS DATE)	-- start date
			AND IFEE.DischargeDateTime <= mgus_date)	-- end date
	UNION
	-- Community Care Claims - diagnosis (use the original ICD code instead of ICDSID to merge)
	SELECT
			COH.PatientSSN
			,CONVERT(DATE, ISNULL(IVC_CH.Service_Start_Date, IVC_CH.Service_End_Date)) AS DxDate 
			,ICD_DIM.ICDCode
			,ICD_DIM.ICDCodeSource
		FROM
			#myanalyticcohort AS COH  
		INNER JOIN 
			Src.IVC_CDS_CDS_Claim_Diagnosis AS IVC_CD
			ON		IVC_CD.[Patient_ICN] = COH.PatientICN
		INNER JOIN
			(SELECT DISTINCT ICDCode
					, ICDCodeSource
					FROM #ICDSID_XXX) AS ICD_DIM
			ON		REPLACE(ICD_DIM.ICDCode, '.', '') = IVC_CD.[ICD]
		INNER JOIN
			Src.IVC_CDS_CDS_Claim_Header AS IVC_CH
			ON		IVC_CH.ClaimSID = IVC_CD.ClaimSID
		WHERE
			(IVC_CH.Service_Start_Date >= CAST(DATEADD(YEAR, -1, GETDATE()) AS DATE)	-- start date
			AND IVC_CH.Service_Start_Date <= mgus_date)	-- end date
			OR
			(IVC_CH.Service_End_Date >= CAST(DATEADD(YEAR, -1, GETDATE()) AS DATE)	-- start date
			AND IVC_CH.Service_End_Date <= mgus_date)	-- end date
	UNION
	-- Community Care Claims - service line (use the original ICD code instead of ICDSID to merge)
	SELECT 
			COH.PatientSSN
			,CONVERT(DATE, ISNULL(IVC_CL.Service_Start_Date, IVC_CL.Service_End_Date)) AS DxDate 
			,ICD_DIM.ICDCode
			,ICD_DIM.ICDCodeSource
		FROM
			#myanalyticcohort AS COH  
		INNER JOIN 
			Src.IVC_CDS_CDS_Claim_Line_ICD_Detail AS IVC_CLICD
			ON		IVC_CLICD.[Patient_ICN] = COH.PatientICN
		INNER JOIN
			(SELECT DISTINCT ICDCode
					, ICDCodeSource
					FROM #ICDSID_XXX) AS ICD_DIM
			ON		REPLACE(ICD_DIM.ICDCode, '.', '') = IVC_CLICD.[ICD]
		INNER JOIN
			Src.IVC_CDS_CDS_Claim_Line AS IVC_CL
			ON		IVC_CL.ClaimSID = IVC_CLICD.ClaimSID
				AND IVC_CL.[Line_Number] = IVC_CLICD.[Line_Number]
		WHERE
			(IVC_CL.Service_Start_Date >= CAST(DATEADD(YEAR, -1, GETDATE()) AS DATE)	-- start date
			AND IVC_CL.Service_Start_Date <= mgus_date)	-- end date
			OR
			(IVC_CL.Service_End_Date >= CAST(DATEADD(YEAR, -1, GETDATE()) AS DATE)	-- start date
			AND IVC_CL.Service_End_Date <= mgus_date)	-- end date
)
SELECT DISTINCT
		PatientSSN
		,DxDate
		,ICDCode
	FROM
		CTE
	
	
