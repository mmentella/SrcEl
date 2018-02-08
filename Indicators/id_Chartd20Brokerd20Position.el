Inputs: ShowPlot(false),GuardTime(10000),RepeatTime(60000),SendMail(false);

DEFINEDLLFUNC: "kernel32.dll", int, "GetTickCount";

vars: intrabarpersist start(0), intrabarpersist now(0), intrabarpersist started(false), intrabarpersist firstAlert(true),
      intrabarpersist modAlert(false);
      
vars: id(0),id1(0);

vars: starttime(FormatTime("HH:mm",eltimetodatetime(sessionstarttime(0,1)))),
      endtime  (FormatTime("HH:mm",eltimetodatetime(sessionendtime(0,1))));

if ShowPlot then begin
 
 plot1(i_MarketPosition*i_CurrentContracts,"Chart",cyan);
 plot2(i_MarketPosition_at_Broker,"Broker",red);
 
end;

if plot1 <> plot2 then begin
 
 if not started then begin
  
  started = true;
  start = GetTickCount;
  
 end else begin
  
  now = GetTickCount;
  
  if SendMail and now - start >= GuardTime then begin 
   
   if firstAlert then begin
    alert;
    firstAlert = false;
   end else begin
    if not modAlert and Mod(now,RepeatTime) < 350 then begin
     alert;
     modAlert = true;
    end else modAlert = false;
   end;
  end;
  
 end;
 
end else begin

 started = false;
 firstAlert = true;

end;

//if LastBarOnChart then begin
 
 if id = 0 then begin
  
  id  = text_new(d,t,c,"");
  id1 = text_new(d,t,c,"");
  
  text_setstring(id, starttime + " - " + endtime);
  text_setstyle(id,2,1);
  text_setsize(id,10);
  text_setcolor(id,white);
  text_setattribute(id,2,true);
  text_setattribute(id,1,true);
  
  text_setstyle(id1,2,0);
  text_setsize(id1,10);
  text_setcolor(id1,white);
  text_setattribute(id1,2,true);
  text_setattribute(id1,1,true);
    
 end else begin
 
  text_setlocation(id,d,time,getappinfo(ailowestdispvalue));
  text_setstring(id, starttime + " - " + endtime );
  
  text_setlocation(id1,d,time,getappinfo(aihighestdispvalue));
  text_setstring(id1, NumToStr(i_OpenEquity-i_ClosedEquity,2));
 
 end;
//end;
