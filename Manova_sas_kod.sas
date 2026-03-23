PROC IMPORT OUT= WORK.analiz_data 
            DATAFILE= "/home/u64416754/cda_dataset_orneklem_spss.sav" 
            DBMS=SPSS REPLACE;
RUN;

/*Log Dönüşümleri */
DATA analiz_data;
    SET analiz_data;
    ln_Income = log(MonthlyIncome);
    ln_Age = log(Age);
    ln_Sat = log(JobSatisfaction); 
RUN;

/*BETİMSEL İSTATİSTİKLER */
PROC MEANS data = analiz_data;
  VAR ln_Income ln_Age ln_Sat; 
RUN;

PROC FREQ data = analiz_data;
  TABLE EducationField Gender; 
RUN;

/*VARSAYIM KONTROLÜ: BOX'S M TESTİ  */
PROC DISCRIM data=analiz_data POOL=TEST;
    CLASS EducationField;      
    VAR ln_Income ln_Age ln_Sat; 
RUN;

/*TEK YÖNLÜ MANOVA (Sadece Bölüm Etkisi)*/
PROC GLM data=analiz_data;
    CLASS EducationField;
    MODEL ln_Income ln_Age ln_Sat = EducationField / SS3;
    MANOVA H=EducationField;            
    MEANS EducationField / TUKEY WELCH HOVTEST=LEVENE; 
RUN;
 
/* Not: Gelir değişkeninde varyans homojenliği sağlanamadığı için (Levene p<0.05) */
/* WELCH testi eklenmiştir. Post-Hoc için SPSS Tamhane sonuçları kullanılacaktır. */
/* TUKEY: Yaş ve Tatmin için (Varyanslar Eşit) */
/* WELCH: Gelir için (Varyanslar Eşit Değilse Sağlama Testi) */
/* HOVTEST=LEVENE: Varyans Eşitliği Kontrolü */

/*ÇİFT YÖNLÜ (ETKİLEŞİMLİ) MANOVA */
PROC GLM data = analiz_data;
  CLASS EducationField Gender; 
  
  MODEL ln_Income ln_Age ln_Sat = EducationField Gender EducationField*Gender / SS3;
  
/*MANOVA Testi */
  MANOVA H = EducationField Gender EducationField*Gender;
  
/*Ana Etkiler için Post-Hoc */
  MEANS EducationField Gender / TUKEY;
  
/*ETKİLEŞİM DETAYI (Kırılım) */
  LSMEANS EducationField*Gender / ADJUST=TUKEY;
RUN;
QUIT;

/* Not: SAS'ta Welch testi çok faktörlü modellerde çalışmadığı için */
/* standart Tukey kodu bırakılmıştır. Raporlamada varyans homojenliği */
/* sorunu nedeniyle SPSS'ten elde edilen Tamhane sonuçları esas alınacaktır. */


   
