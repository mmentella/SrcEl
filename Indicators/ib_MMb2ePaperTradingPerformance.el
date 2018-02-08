input: ReleaseDate_Day(0), ReleaseDate_Month(0), ReleaseDate_Year(0);

var: id(0),EquityStart(0),EquityStop(0);

if EquityStart = 0 and 
   dayofmonth(d)  >= ReleaseDate_Day and
   Month(d)       =  ReleaseDate_Month and
   Year(d) + 1900 =  (ReleaseDate_Year - 1)
then begin
 
 EquityStart = i_OpenEquity;
 
 id    = text_new(0,0,0,"");
 
 text_setstyle(id,0,2);
 text_setsize(id,10);
 text_setcolor(id,white);
 text_setattribute(id,2,true);
 text_setattribute(id,1,true);
 
end;

if EquityStop = 0 and 
   dayofmonth(d)  = ReleaseDate_Day and
   Month(d)       = ReleaseDate_Month and
   Year(d) + 1900 = ReleaseDate_Year
then begin
 EquityStop = i_OpenEquity;
end;

if EquityStart <> EquityStop then begin

text_setstring(id,NumToStr(i_OpenEquity - EquityStop,2) + 
                  "(" + NumToStr(100*((i_OpenEquity - EquityStop)/(absvalue(EquityStop - EquityStart))),2) + "%)");

if i_OpenEquity < EquityStop then text_setcolor(id,red)
else                         text_setcolor(id,white);

text_setlocation(id,d,t,c);

end;
