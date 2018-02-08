Input: TimeWindow_MS(500);

DEFINEDLLFUNC: "kernel32.dll", int, "GetTickCount";

if bartype > 0 or bartype_ex > 1 then raiseruntimeerror("Use Study only with Tick bar!!");

var: ms(0),now(0),vol(0),counter(0),tc(0),max(1),min(-1);

once (getappinfo(airealtimecalc) = 1) begin 
 ms  = GetTickCount;
 now = ms;
end;

if d = currentdate then begin
 
 if d > d[1] then begin
  counter =  0;
  min     =  1;
  max     = -1;
 end else begin
  
  if c > c[1] then counter = counter + 1 
  else if c < c[1] then counter = counter - 1;
  
  if counter > 0 then  begin
   tc = counter / max;
  end else begin
   tc = -counter / min;
  end;
 
  if getappinfo(airealtimecalc) = 1 then begin
  
   now = GetTickCount;
   
   if now <= ms + TimeWindow_MS then begin
    vol = vol + Ticks;
   end else begin
    
    if tc < -.5 then begin
     
     if vol > iff(t<1400,500,1000) then
      arw_new_s(d,time_s,c,false);

    end;
    
    vol = 0;
    ms  = now;
    max = maxlist(max,counter);
    min = minlist(min,counter);
    
   end;
   
  end;
 
 end;
 
end;
