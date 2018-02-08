Input: TimeWindow(500);

DEFINEDLLFUNC: "kernel32.dll", int, "GetTickCount";

var: ms(0), now(0), vol(0), lastVol(0), ba(0);

once (getappinfo(airealtimecalc) = 1) begin 
 ms  = GetTickCount;
 now = ms;
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
  
  
  
  lastVol = vol;
  ms      = now;
  ba      = 0;
  
 end;

end;

