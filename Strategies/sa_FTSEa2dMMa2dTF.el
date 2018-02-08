Inputs: nos(2),alpha(0.07);

vars: trend(0,data2),trig(0,data2);

if barstatus(2) = 2 then begin
 MM.ITrend(medianprice,alpha,trend,trig)data2;
end;

if trig < trend and c < trend then
 buy next bar at trend stop;
if trig > trend and c > trend then
 sellshort next bar at trend stop;
