/* SPSS Z-SKOR ÇIKTISI İLE UYUMLU SAS KODU */

PROC IMPORT OUT= WORK.orneklem_veri 
            DATAFILE= "/home/u64416754/cda_dataset_orneklem_spss - kumeleme.sav"
            DBMS=SPSS REPLACE;
RUN;

/* STANDARTLAŞTIRMA */
PROC STDIZE DATA=WORK.orneklem_veri OUT=std_calisanlar METHOD=STD;
    VAR MonthlyIncome PercentSalaryHike YearsWithCurrManager NumCompaniesWorked;
RUN;

/* HİYERARŞİK KÜMELEME */
PROC CLUSTER DATA=std_calisanlar METHOD=WARD OUTTREE=ward_agaci; 
    ID ID; 
    VAR MonthlyIncome PercentSalaryHike YearsWithCurrManager NumCompaniesWorked; 
RUN;

/* Dendrogram */
PROC TREE DATA=ward_agaci;
RUN;

/* K-MEANS KÜMELEME */
PROC FASTCLUS DATA=std_calisanlar MAXCLUSTERS=3 MAXITER=100 LIST DISTANCE OUT=clust_sonuc; 
    VAR MonthlyIncome PercentSalaryHike YearsWithCurrManager NumCompaniesWorked;
    ID ID; 
RUN;

/* ANOVA (Değişkenlerin Anlamlılık Testi) */ 

/* MonthlyIncome (Maaş) */
PROC GLM DATA=clust_sonuc; 
    CLASS CLUSTER; 
    MODEL MonthlyIncome=CLUSTER;
RUN;

/* PercentSalaryHike (Zam Oranı) */
PROC GLM DATA=clust_sonuc; 
    CLASS CLUSTER;
    MODEL PercentSalaryHike=CLUSTER;
RUN;

/* YearsWithCurrManager (Yöneticiyle Geçen Süre) */
PROC GLM DATA=clust_sonuc; 
    CLASS CLUSTER;
    MODEL YearsWithCurrManager=CLUSTER;
RUN;

/* NumCompaniesWorked (Şirket Sayısı) */
PROC GLM DATA=clust_sonuc; 
    CLASS CLUSTER;
    MODEL NumCompaniesWorked=CLUSTER;
RUN;
QUIT;