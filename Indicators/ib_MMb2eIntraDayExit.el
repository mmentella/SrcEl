Inputs: EL_StartDate(1100419),Conversion(.81),Export(false);

vars: max(-1),min(999999),summax(0),summin(0),mmp(0),start(0);

if currentbar = 1 then
 if getexchangename="EEI" or getexchangename="EUX" or getexchangename="IDEM" then value1 = 1
 else value1 = conversion;

if d <> d[1] and d >= EL_StartDate then begin
 if max >= 0 then summax = summax + max;
 if min <= 0 then summin = summin + min;
 
 max = -1;
 min = 9999999;
 
 if d = EL_StartDate or (d > EL_StartDate and start  = 0) then start = i_OpenEquity;
end;

mmp = MM.Portfolio("","",value1);

max = maxlist(max,mmp);
min = minlist(min,mmp);

if Export then begin
  print(File("C:\EquityIndex.txt"),MM.ELDateToString_IT(d),",",MM.TimeToStr_IT(time),",",NumToStr(i_openequity,2));
end;

if LastBarOnChart then begin
 plot1(summax,"Run Up",green);
 plot2(summin,"Drawdown",red);
 plot3((i_OpenEquity-start)*value1,"Net Profit");
 if plot3 <= 0 then SetPlotColor(3,red) else SetPlotColor(3,green);
end;
