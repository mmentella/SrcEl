[IntrabarOrderGeneration = true]
Inputs: len(2);

vars: level(0,data1);

if getappinfo(airealtimecalc) = 1 then
 MM.SendControlMessage("");

if barstatus(1) = 1 then begin
 level = XAverage(c,len);

 buy next bar at level stop;
 sellshort next bar at level stop;
end;
