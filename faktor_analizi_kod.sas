PROC IMPORT OUT= WORK.ANALIZ_DATA 
            DATAFILE= "/home/u64416754/cda_dataset_orneklem_spss.sav"  
            DBMS=SPSS REPLACE;
RUN;

proc factor data=WORK.ANALIZ_DATA 
      corr                  
      method=principal      
      nfactors=2            
      rotate=varimax        
      reorder               
      msa                   
      plots=(scree initloadings loading); 

   var Age MonthlyIncome TotalWorkingYears YearsAtCompany YearsWithCurrManager TrainingTimesLastYear;
run;