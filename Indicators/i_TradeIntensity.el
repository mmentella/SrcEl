Input: TimeWindow(500);

DEFINEDLLFUNC: "kernel32.dll", int, "GetTickCount";

var: intrabarpersist ms(0), intrabarpersist now(0), intrabarpersist vol(0), intrabarpersist lastVol(0), intrabarpersist ba(0);

var: id(0);

once (getappinfo(airealtimecalc) = 1) begin 
 ms  = GetTickCount;
 now = ms;
 
 id = text_new(d,t,c,"");
 text_setstyle(id,1,1);
 text_setsize(id,10);
 text_setcolor(id,white);
 text_setattribute(id,2,true);
 text_setattribute(id,1,true);
end;

if getappinfo(airealtimecalc) = 1 then begin
 
 if d > d[1] then begin 
  vol     = Ticks;
  lastVol = vol;
  ba      = 0;
 end; 

 now = GetTickCount;
 
 if now <= ms + TimeWindow then begin
  
  vol = vol + Ticks;
  
  if c = insideask then ba = ba + Ticks
  else if c = insidebid then ba = ba - Ticks;
  
 end else begin
  
  plot1(vol - lastVol,"Intensity");
  
  if ba > 0 then SetPlotColor(1,green)
  else if ba < 0 then SetPlotColor(1,red)
  else SetPlotColor(1,white);
  {
  text_setstring(id,NumToStr(ba,0));
  text_setlocation_s(id,d,time_s,getappinfo(ailowestdispvalue));
  }
  lastVol = vol;
  ms      = now;
  ba      = 0;
  
 end;

end;
