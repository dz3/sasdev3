**********************************************************************; 

* PROGRAM SUMMARY ; 

**********************************************************************; 

* Pgm name  : $Id$  ; 

* Curr Descr: Shows you how to do about 80% of common SAS data management tasks ; 

**********************************************************************; 

options nodate nocenter nonumber linesize=150 pagesize=72; 

************************************************; 

*     = A list of the main examples =           ; 

* READ A SAS LIBRARY DATASET                    ; 

* PRINT THE FILE                                ; 

* SORT THE FILE                                 ; 

* LOOK AT THE FILE'S METADATA                   ; 

* REMOVE ANY DUPLICATES - this is one way       ;  

* GET A FREQUENCY DISTRIBUTION                  ; 

* READ IN A CSV FILE                            ; 

* READ DATA THAT YOU MAKE UP or paste in        ; 

* READ AN ORACLE TABLE of incomes               ; 

* READ AN EXCEL FILE of incomes                 ; 

* MERGE TWO DATASETS > 1 DATASET                ; 

* OR USE SQL TO JOIN (MERGE) FILES              ; 

* MERGE A 3rd FILE, ADD A  COMMA FORMAT         ; 

* GET MEAN SALES PER MAKE AND MODEL and PRINT   ; 

* PUT THAT STATISTIC (MEAN) INTO A SAS DATASET  ; 

* GET A HANDY SET OF DISTRIBUTION STATISTICS    ; 

* ILLUSTRATE SOME SAS STATEMENTS & FUNCTIONS    ; 

* COMPARE TWO SAS FILES, ROW BY ROW, COL BY COL ; 

* TRANSPOSE A FILE SO ROWS BECOME COLUMNS AND   ; 

*     COLUMNS BECOME ROWS.                      ; 

* WRITE A SAS DATASET TO A CSV FILE             ; 

* SAS DATES AND TIMES                           ; 

* Docn: https://support.sas.com/en/software/base-sas-support.html#documentation; 

************************************************; 

**************************************; 

* LIBNAME tags a directory for input  ; 

* SAS data or for your final SAS files; 

* Docn: http://support.sas.com/documentation/cdl/en/hostwin/69955/HTML/default/viewer.htm#chloptfmain.htm; 

**************************************; 

libname mylib "C:\Users\n550513\Desktop"; 

 

***************************************; 

* READ A SAS LIBRARY DATASET           ; 

* Unless theres a need, do your most   ; 

* processing in the SAS WORK library.  ; 

* This data step reads in all rows     ; 

* and all columns from a SAS file      ; 

* found in SASHELP library, which      ; 

* your SAS session already has...      ; 

* but which I modified to overcome     ; 

* a minor data issue in the file       ; 

* The "data" statement names the output; 

* & the "set" statement names the input; 

* We dont need the "wheelbase" var, so ; 

* we drop it out of the set (read).    ; 

* There is also an opposite keep= option; 

* Docn: http://support.sas.com/rnd/base/datastep/index.html; 

***************************************; 

data work.cars; 

    set mylib.cars (drop=wheelbase); 

run; 

 

***********************************; 

* PRINT THE FILE                   ; 

* Docn: https://go.documentation.sas.com/?cdcId=pgmsascdc&cdcVersion=9.4_3.4&docsetId=proc&docsetTarget=p10qiuo2yicr4qn17rav8kptnjpu.htm&locale=en; 

* Docn: https://go.documentation.sas.com/?cdcId=pgmsascdc&cdcVersion=9.4_3.4&docsetId=proc&docsetTarget=p0bqogcics9o4xn17yvt2qjbgdpi.htm&locale=en; 

***********************************; 

title "work.cars"; 

proc print data=work.cars; 

run; 

 

 

***********************************; 

* PRINT THE DATA, but only the     ; 

* make, model, and price vars, and ; 

* only 10 rows ("observations")    ; 

***********************************; 

title "work.cars (obs=10)"; 

proc print data=work.cars (obs=10) heading=h width=min; 

    var make model; 

run; 

 

************************************************; 

* SORT THE FILE                                 ; 

* Docn: https://go.documentation.sas.com/?cdcId=pgmsascdc&cdcVersion=9.4_3.4&docsetId=proc&docsetTarget=p1nd17xr6wof4sn19zkmid81p926.htm&locale=en; 

************************************************; 

proc sort data=work.cars; 

    by make model; 

run; 

 

***********************************; 

* LOOK AT THE FILES METADATA       ; 

* Docn: https://go.documentation.sas.com/?cdcId=pgmsascdc&cdcVersion=9.4_3.4&docsetId=proc&docsetTarget=n1hqa4dk5tay0an15nrys1iwr5o2.htm&locale=en; 

* Docn: https://support.sas.com/rnd/base/Tipsheet_DATASETS.pdf; 

***********************************; 

proc contents data=work.cars; 

run; 

 

************************************************; 

* IDENTIFY ANY DUPLICATES                       ;  

************************************************; 

data work.cars_dups; 

    set work.cars; 

    by make model; 

    if not (first.model and last.model) then output; 

run; 

 

************************************************; 

* Notice what the "id" + "by" statments do...   ; 

************************************************; 

title "work.cars_dups by make and model"; 

proc print data=work.cars_dups; 

    id make model; 

    by make model; 

run; 

 

************************************************; 

* REMOVE ANY DUPLICATES - this is one way       ;  

************************************************; 

proc sort data=work.cars  NODUPKEY; 

    by make model; 

run; 

 

************************************************; 

* GET A FREQUENCY DISTRIBUTION                  ; 

* Normally, categorical vars (often character   ; 

* datatype vars) get count distributions        ; 

* Docn: https://go.documentation.sas.com/?cdcId=pgmsascdc&cdcVersion=9.4_3.4&docsetId=procstat&docsetTarget=procstat_freq_syntax.htm&locale=en; 

************************************************; 

title "work.cars - Frequency Distribution"; 

proc freq data=work.cars; 

    tables make  origin 

           origin*make 

           /list missing nocum; 

run; 

 

***********************************; 

* READ IN A CSV FILE (included in  ; 

* this paper/PPT)                  ; 

* Note that proc import generates a; 

* SAS Data Step in to do its work..; 

* you can see it in the SAS log    ; 

* Docn: https://go.documentation.sas.com/?cdcId=pgmsascdc&cdcVersion=9.4_3.4&docsetId=proc&docsetTarget=n1qn5sclnu2l9dn1w61ifw8wqhts.htm&locale=en; 

***********************************; 

proc import datafile = "C:\Users\n550513\Desktop\car_sales.csv" 

            out = work.car_sales 

            dbms = csv 

            replace; 

run; 

 

title "work.car_sales"; 

proc print data=work.car_sales; 

run; 

 

***********************************; 

* READ DATA THAT YOU MAKE UP or    ; 

* that you paste in.  This is from ; 

*https://people.sc.fsu.edu/~jburkardt/datasets/census/census_2010.txt; 

* $1-2 means character data in cols; 

* 1 and 2, 4-14 means numeric data ; 

* in cols 4 to 14                  ; 

* Docn: https://support.sas.com/techsup/technote/ts673.pdf; 

***********************************; 

data work.state_populations; 

    infile datalines; 

    input state $1-2 

          population 4-14 

          ; 

    datalines; 

AL    4779736 

AK      710231    

AZ    6392017 

AR    2915918 

CA   37253956 

CO    5029196 

CT    3574097 

DE      897934 

DC      601723 

FL   18801310 

GA    9687653 

HI    1360301 

ID    1567582 

IL   12830632 

IN    6483802 

IA    3046355 

KS    2853118 

KY    4339367 

LA    4533372 

ME    1328361 

MD    5773552 

MA    6547629 

MI    9883640 

MN    5303925 

MS    2967297 

MO    5988144 

MT      989415 

NE    1826341 

NV    2700551 

NH    1316470 

NJ    8791894 

NM    2059179 

NY   19378102 

NC    9535483 

ND      672591 

OH   11536504 

OK    3751351 

OR    3831074 

PA   12702379 

RI    1052567 

SC    4625364 

SD      814180 

TN    6346165 

TX   25145561 

US  308745538 

UT    2763885 

VT      625741 

VA    8001024 

WA    6724540 

WV    1852994 

WI    5686986 

WY      563626 

; 

run; 

 

***********************************; 

* Now print the whole thing, but   ; 

* add commas to the populations    ; 

***********************************; 

title "work.state_populations"; 

proc print data=work.state_populations  heading=h width=min; 

    format population comma12.; 

run; 

 

************************************; 

* READ AN ORACLE TABLE of incomes   ; 

* with SAS/ACCESS for Oracle, using ; 

* a libname statement.  There is    ; 

* another way with Proc SQL, not    ; 

* shown in this example.            ; 

* Notice the /* */ comments, which  ; 

* prevent the code from being executed; 

* and it wont appear in the SAS log ; 

/************************************ 

libname oralib oracle path=uat001 schema=states  user=u12345 password="mypassword"; 

 

title "uat001.states.personal_income"; 

proc print data=oralib.personal_income (obs=10)  heading=h width=min; 

run; 

*************************************/ 

 

***********************************; 

* READ AN EXCEL FILE of incomes    ; 

* If you dont have Oracle and the  ; 

* SAS/ACCESS product for it at your; 

* site, you can use the xlsx version; 

* also included (modified from     ; 

* https://www.bea.gov/data/income-saving/personal-income-by-state; 

***********************************; 

proc import datafile = "C:\Users\n550513\Desktop\spi0919.xlsx" 

            out = work.personal_income 

            dbms = xlsx 

            replace; 

run; 

 

title "work.personal_income, in millions"; 

proc print data=work.personal_income  heading=h width=min; 

    format personal_income comma12.; 

run; 

 

***********************************; 

* Now sort the datasets before     ; 

* merging them together            ; 

***********************************; 

proc sort data=work.cars; 

    by make model; 

run; 

 

proc sort data=work.car_sales; 

    by make model; 

run; 

 

***********************************; 

* MERGE TWO DATASETS > 1 DATASET   ; 

* That is, read in a row from cars ; 

* and a row from car_sales - if they; 

* match on make and model, then    ; 

* write them to the output file    ; 

* Docn: https://documentation.sas.com/?docsetId=lestmtsref&docsetTarget=n1i8w2bwu1fn5kn1gpxj18xttbb0.htm&docsetVersion=9.4&locale=en; 

***********************************; 

data work.merged_car_sales; 

    merge work.cars (in=c) 

          work.car_sales (in=s); 

    by make model; 

 

    if c and s then output work.merged_car_sales;; 

run; 

 

title "work.merged_car_sales (obs=10)  heading=h width=min"; 

proc print data=work.merged_car_sales (obs=10); 

    var make model state sales; 

run; 

 

***********************************; 

* OR USE SQL TO JOIN (MERGE) FILES ; 

* Docn: https://go.documentation.sas.com/?cdcId=pgmsascdc&cdcVersion=9.4_3.4&docsetId=sqlproc&docsetTarget=n1oihmdy7om5rmn1aorxui3kxizl.htm&locale=en; 

***********************************; 

proc sql; 

    create table work.merged_car_sales  AS 

    (select c.make, c.model, cs.state, cs.sales format=comma12. 

     from work.cars c, 

          work.car_sales cs 

     where c.make = cs.make 

       and c.model = cs.model 

     )  

     order by make, model, state; 

quit; 

 

***********************************; 

* MERGE THAT WITH ONE MORE FILE... ; 

* but sort by the right vars first ; 

***********************************; 

proc sort data=work.merged_car_sales; 

    by state; 

run; 

 

proc sort data=work.state_populations; 

    by state; 

run; 

 

**************************************; 

* MERGE A 3rd FILE, ADD A COMMA FORMAT; 

* Write to the output only rows where ; 

* state_populations exists, whether or; 

* not theres a match by state         ; 

**************************************; 

data work.merged_car_sales_by_state; 

    merge work.merged_car_sales (in=m) 

          state_populations (in=s); 

    by state; 

 

    format sales  

           population comma11.; 

    if s then output work.merged_car_sales_by_state; 

run; 

 

title "work.merged_car_sales_by_state"; 

proc print data=work.merged_car_sales_by_state; 

    var make model state sales population; 

run; 

 

************************************************; 

* GET MEAN SALES PER MAKE AND MODEL and PRINT   ; 

* FYI: Proc Summary does almost exactly the same; 

* thing as Proc Means                           ; 

* Docn: https://go.documentation.sas.com/?cdcId=pgmsascdc&cdcVersion=9.4_3.4&docsetId=proc&docsetTarget=p0f0fjpjeuco4gn1ri963f683mi4.htm&locale=en; 

************************************************; 

title "work.merged_car_sales_by_state - Mean Sales by Make and Model"; 

proc means data=work.merged_car_sales_by_state; 

    class make model; 

    var sales; 

run; 

 

************************************************; 

* PUT THAT STATISTIC (MEAN) INTO A SAS DATASET  ; 

* ... by make and model                         ; 

************************************************; 

proc means data=work.merged_car_sales_by_state  NWAY NOPRINT; 

    class make model; 

    var sales; 

    output out=work.car_sales_means mean(sales)=mean_car_sales; 

run; 

 

title "work.car_sales_means"; 

proc print data=work.car_sales_means; 

run; 

 

************************************************; 

* GET A HANDY SET OF DISTRIBUTION STATISTICS    ; 

* Docn: https://go.documentation.sas.com/?cdcId=pgmsascdc&cdcVersion=9.4_3.4&docsetId=procstat&docsetTarget=procstat_univariate_toc.htm&locale=en; 

************************************************; 

title "work.merged_car_sales_by_state - Univariate Distribution"; 

proc univariate data=work.merged_car_sales_by_state; 

    var sales; 

run; 

 

************************************************; 

* ILLUSTRATE SOME SAS STATEMENTS & FUNCTIONS    ; 

* We will create a second dataset               ; 

* similar to work.cars, but make some changes   ; 

* to be illustrated in the later comparison.    ; 

* Note, on the Windows platform you may need to ; 

* add the Options statement below               ; 

* Docn: http://documentation.sas.com/?docsetId=allprodslang&docsetTarget=syntaxByProduct-statement.htm&docsetVersion=9.4&locale=en#n1swy5fhgz10y6n1q30uzqp7pd1j; 

* Docn: http://documentation.sas.com/?docsetId=allprodslang&docsetTarget=syntaxByProduct-function.htm&docsetVersion=9.4&locale=en#p115i1snlrmym5n19luzthoovsbx; 

************************************************; 

options formchar="|----|+|---+=|-/\<>*"; 

 

data work.cars2; 

    set work.cars; 

 

    length distributor $32 

           make_model  $64; 

    format weight comma6.; 

 

    **** Basic IF statement ***; 

    if make = "Acura"  

        then origin = "Mexico"; 

    if model = "Civic HX 2dr"  

        then model = "CIVIC HX 2DR"; 

    if model = "C70 LPT convertible 2dr"  

        then msrp = 40566; 

 

    **** Basic IF/DO block ***; 

    if make = "BMW" then do; 

        distributor = "Bayernco"; 

        type = upcase(type); 

    end; 

    else if make = "Audi" then do; 

        distributor = "Ingolstadtco"; 

        type = upcase(type); 

    end; 

    else do; 

        type = upcase(type); 

    end; 

 

    **** Concatenate ***; 

    make_model = cats(make,"-",model); 

 

    *** Another way to concatenate ***; 

    make_model2 = trim(make) || "-" || trim(model); 

 

    *** Get a 4-byte segment from a character string ***; 

    my_segment2 = substr(make_model,1,4); 

 

    *** Two features - use an input row counter _n_ ***; 

    ***  and "put" (write) a value to the SAS log ***; 

    if _n_ = 5 then put make= model= make_model2=; 

 

    *** Get a count of the number of "words" in a string ***; 

    word_count = countw(model); 

    if _n_ = 5 then put model= word_count=; 

 

    *** Find the first occurence of a character in string ***; 

    x_loc = index(upcase(model),"X"); 

    if x_loc > 0 then put make= model= x_loc=; 

run; 

 

************************************************; 

* COMPARE TWO SAS FILES, ROW BY ROW, COL BY COL ; 

* Docn: https://go.documentation.sas.com/?cdcId=pgmsascdc&cdcVersion=9.4_3.4&docsetId=proc&docsetTarget=n1nwxbchh5hpu1n1h28kmici2awd.htm&locale=en; 

************************************************; 

proc sort data=work.cars; 

    by make model; 

run; 

 

proc sort data=work.cars2; 

    by make model; 

run; 

 

title "Proc Compare"; 

title2 "Base=work.cars, Compare=work.cars2"; 

proc compare base=work.cars 

             compare=work.cars2 

             criterion=0.0001 

             listall 

             maxprint=(5,2000); 

    id make model; 

run; 

 

************************************************; 

* TRANSPOSE A FILE SO ROWS BECOME COLUMNS AND   ; 

*     COLUMNS BECOME ROWS.                      ; 

* var = variables that will rotate 90 degrees   ; 

* by = multiple rows/by-var become 1 row/by-var ; 

* id = values of this column become column names; 

* Also giving all numeric vars a comma12. format; 

* Note - we are writing the output to our MYLIB ; 

* "permanent" directory                         ; 

* Docn: https://go.documentation.sas.com/?cdcId=pgmsascdc&cdcVersion=9.4_3.4&docsetId=proc&docsetTarget=n1xno5xgs39b70n0zydov0owajj8.htm&locale=en; 

* Docn: https://www.lexjansen.com/pharmasug/2017/TT/PharmaSUG-2017-TT13.pdf; 

************************************************; 

proc sort data=work.merged_car_sales; 

    by make; 

run; 

 

proc transpose data=work.merged_car_sales 

               out=MYLIB.merged_car_sales_transp; 

    by make; 

    var sales; 

    id state; 

    format _numeric_ comma12.; 

run; 

 

title "MYLIB.merged_car_sales_transp"; 

proc print data=MYLIB.merged_car_sales_transp; 

run; 

 

************************************************; 

* WRITE A SAS DATASET TO A CSV FILE             ; 

* Docn: https://documentation.sas.com/?docsetId=proc&docsetTarget=n045uxf7ll2p5on1ly4at3vpd47e.htm&docsetVersion=9.4&locale=en; 

************************************************; 

proc export data=MYLIB.merged_car_sales_transp 

            outfile="C:\Users\n550513\Desktop\merged_car_sales_transp.csv" 

            dbms=csv 

            replace; 

run; 

 

 

************************************************; 

* SAS DATES AND TIMES                           ; 

* A SAS date is the # of days since Jan 1, 1960 ; 

* Assign a date literal like this: "ddmmmyyyy"d ; 

* A SAS time is the # of seconds since midnight ; 

* Assign a time literal like this: "09:45"t     ; 

* Docn: http://documentation.sas.com/?docsetId=allprodslang&docsetTarget=syntaxByCategory-format.htm&docsetVersion=9.4&locale=en; 

************************************************; 

data work.dates_and_times; 

 

    my_date_unformatted = "31oct2019"d; 

 

    format my_date_date9_format date9.; 

    my_date_date9_format = my_date_unformatted; 

 

    format my_date_monyy7_format monyy7.; 

    my_date_monyy7_format = my_date_unformatted; 

 

    my_time_unformatted = "13:05"t; 

 

    format my_time_time5_format time5.; 

    my_time_time5_format = my_time_unformatted; 

  

run; 

 

title "work.dates_and_times"; 

proc print data=work.dates_and_times; 

run; 

 

***********************************************; 

* Additional Documentation; 

* http://documentation.sas.com/?docsetId=lrcon&docsetTarget=titlepage.htm&docsetVersion=9.4&locale=en - SAS Concepts; 

* https://www.lexjansen.com/ - 1000s of user-friendly papers on SAS topics; 

* https://communities.sas.com/ - user help site, like Stack Overflow for SAS; 

* https://support.sas.com/en/support-home.html - official, awesome SAS Tech Support; 

***********************************************; 

 
