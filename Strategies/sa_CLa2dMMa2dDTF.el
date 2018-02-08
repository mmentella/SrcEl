Inputs: nos(2),alpha(.07),cyclelimit(60),sod(800),eod(2300);

vars: trend(0),trigger(0),cycle(0),bs(true),ss(true);

if d <> d[1] then begin bs = true; ss = true; end;

MM.ITrend(medianprice,alpha,trend,trigger);

if t > sod and t < eod then begin
 
if bs and trigger > trend then begin buy nos shares next bar at market; bs = false; end;
if ss and trigger < trend then begin sellshort nos shares next bar at market; ss = false; end;

end;

setexitonclose;
