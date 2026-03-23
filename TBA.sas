/* --- TEMEL BİLEŞENLER ANALİZİ (TBA) --- */
PROC IMPORT OUT= WORK.analiz_data 
            DATAFILE= "/home/u64416754/cda_dataset_orneklem_spss.sav" 
            DBMS=SPSS REPLACE;
RUN;
proc princomp data=WORK.analiz_data  
    n=2                               
    plots=(scree loading);       
    var Age MonthlyIncome TotalWorkingYears YearsAtCompany YearsWithCurrManager TrainingTimesLastYear; 
run;