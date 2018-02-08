vars: chart(0),broker(0),id(0),id1(0),position(""),ldp(0),tdp(0);

vars: starttime(FormatTime("HH:mm",eltimetodatetime(sessionstarttime(0,1)))),
      endtime  (FormatTime("HH:mm",eltimetodatetime(sessionendtime(0,1))));

if Year(d) = Year(currentdate) and Month(d) >= Month(currentdate) - 1 then begin

if d > d[1] then begin
 ldp = tdp;
end;

chart  = i_MarketPosition*i_CurrentContracts;
broker = i_MarketPosition_at_Broker_for_The_Strategy;

tdp = MM.DailyRunup;
 
if id = 0 then begin
 
 id  = text_new(d,t,c,"");
 id1 = text_new(d,t,c,"");
 
 text_setstring(id, "(" + starttime + " - " + endtime + ")");
 text_setstyle(id,2,1);
 text_setsize(id,10);
 text_setcolor(id,white);
 text_setattribute(id,2,true);
 text_setattribute(id,1,true);
 
 text_setstyle(id1,1,0);
 text_setsize(id1,10);
 text_setcolor(id1,white);
 text_setattribute(id1,2,true);
 text_setattribute(id1,1,true);
   
end else begin

 text_setlocation(id,d,time,getappinfo(ailowestdispvalue));
 
 position = "CHART: " + NumToStr(chart,0) + " BROKER: " + NumToStr(broker,0);
 
 text_setlocation(id1,d,time,getappinfo(aihighestdispvalue));
 text_setstring(id1, position + "\nPOSITION:      " + NumToStr(i_OpenEquity-i_ClosedEquity,2) + "\nDAILY:           " + NumToStr(tdp,2) + 
                                  "\nYESTERDAY: " + NumToStr(ldp,2));
 
end;

end;
