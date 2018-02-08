vars: id(0),curr("$");

if currentbar = 1 then begin
 id = text_new(d,t,c,"");
 text_setcolor(id,lightgray);
 text_setsize(id,16);
 if getexchangename="EEI" or getexchangename="EUX" or getexchangename="IDEM" then curr = "Euro";
end;

if LastBarOnChart then begin
 NoPlot(1);
 text_setstring(id,"Tick Value: "+NumToStr((1*MinMove points)*bigpointvalue,2)+" "+curr);
 text_setlocation(id,d,t,h+TrueRange);
 plot1(c*bigpointvalue,"Contract Value");
end;
