PROC IMPORT OUT= WORK.IBM_DATA 
            DATAFILE= "/home/u64416754/cda_dataset_orneklem_spss.sav" 
            DBMS=SPSS REPLACE;
RUN;
/* Binary Lojistik Regresyon*/
proc logistic data=WORK.IBM_DATA descending;  
    model Attrition(event='Yes') = Age 
                                   DistanceFromHome 
                                   MonthlyIncome 
                                   PercentSalaryHike 
                                   TrainingTimesLastYear 
                                   YearsAtCompany 
                                   / expb lackfit rsquare; 
    output out=sonuclar predprobs=individual;
run;
proc freq data=sonuclar;
    tables _FROM_ * _INTO_;
run;
/* Stepwise Lojistik Regresyon*/
proc logistic data=WORK.IBM_DATA descending;
    model Attrition(event='Yes') = Age 
                                   DistanceFromHome 
                                   MonthlyIncome 
                                   PercentSalaryHike 
                                   TrainingTimesLastYear 
                                   YearsAtCompany 
                                   / expb lackfit rsquare selection=backward; 
    output out=sonuclar_step predprobs=individual;
run;
proc freq data=sonuclar_step;
    tables _FROM_ * _INTO_;
run;