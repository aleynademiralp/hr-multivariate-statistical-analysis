PROC IMPORT OUT= WORK.CALISAN_DATA 
            DATAFILE= "/home/u64416754/cda_dataset_orneklem_spss.sav" 
            DBMS=SPSS REPLACE;
RUN;

data CALISAN_DATA;
    set CALISAN_DATA; 
    
    Ln_Income = log(MonthlyIncome);  
    Ln_Age = log(Age);               
    Ln_Sat = log(JobSatisfaction);   
run;

/* Veri Dağılımı */
proc freq data=CALISAN_DATA;
    tables EducationField;
run;

/* Korelasyon */
proc corr data=CALISAN_DATA spearman; 
    var Ln_Income Ln_Age TotalWorkingYears YearsAtCompany TrainingTimesLastYear Ln_Sat;
run;

/* Normallik */
proc univariate data=CALISAN_DATA normal;
    var Ln_Income Ln_Age TotalWorkingYears YearsAtCompany TrainingTimesLastYear Ln_Sat;
    histogram / normal; 
run;

/* Diskriminant Analizi */
proc discrim data=CALISAN_DATA 
    can 
    simple 
    pool=test;
    class EducationField;
    var Ln_Income Ln_Age TotalWorkingYears YearsAtCompany TrainingTimesLastYear Ln_Sat;
    priors proportional;
run;

/* Stepwise (Adımsal) Analiz */
proc stepdisc data=CALISAN_DATA method=stepwise;
    class EducationField;
    var Ln_Income Ln_Age TotalWorkingYears YearsAtCompany TrainingTimesLastYear Ln_Sat;
run;