*** Basic Merges; 

*Set up *******************************;
data data1;
input id col1 col2;
cards;
1 2 9 
2 5 6 
3 0 0 
8 7 4 
; 
proc print; run;

data data2;
input id var1 var2;
cards;
1 4 2 
3 0 0
3 4 2
5 4 3
proc print;
run;

proc sort data=data1;
by id;
run;

proc sort data=data2;
by id;
run;
***********************************;


* Inner Join;
Proc SQL;
Create table innerSql AS
Select * from data1 as o
join data2 as t on o.id=t.id;
quit;

proc print data=innerSql; run;

data innerMerge;
merge data1 (in=a) data2 (in=b);
by id;
if a and b;

proc print;
run;


* Outer Join;
Proc SQl;
Create table outerSql as
Select * from data1
full join data2 on data1.id=data2.id;
quit;

proc print data=outerSql; 
run;

data outerMerge;
merge data1 (in=a) data2 (in=b);
by id;
if a or b;
proc print;
run;



* Left Join;
Proc SQL;
Create table leftSql as
Select * from data1
left join data2 on data1.id=data2.id;
quit;

proc print data=leftSql; run;

data leftmerge;
merge data1 (in=a) data2 (in=b);
by id;
if a;    * alternatively: if (a and b) or (a and not b);
proc print;
run;









data m;
merge data1 (in=oo) data2 (in=tt);
If oo;
proc print;
run;


proc SQL;
Create table mergeTable AS
select * from data1 
left join data2 on data1.id=data2.id;
quit;

proc print data=mergeTable;
run;


