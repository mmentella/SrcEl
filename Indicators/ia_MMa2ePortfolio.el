Inputs: Conversion(.81);

if currentbar = 1 then
 if getexchangename="EEI" or getexchangename="EUX" or getexchangename="IDEM" then value1 = 1
 else value1 = conversion;
 
if d <> d[1] then begin 
 value3 = minlist(value2,value3);
 if value3 < value3[1] then value4 = d[1];
end;

value2 = MM.Portfolio("","",value1);

plot1(value2,"MM.Portfolio");

if value2>0 then SetPlotColor(1,green) else SetPlotColor(1,red);

if LastBarOnChart then
 text_new(d,t,c,"Max Loss: "+NumToStr(value3,2)+" - "+MM.ELDateToString_IT(value4));
