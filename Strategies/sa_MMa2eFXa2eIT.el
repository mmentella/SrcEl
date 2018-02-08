Inputs: alpha(0.08),len(37),rng(.86);
Inputs: stoploss(100000),target(100000);

vars: trend(0),trig(0),cycle(0),fish(0);

MM.ITrend(c,alpha,trend,trig);
cycle = MM.Cycle(medianprice,alpha);
fish = MM.FisherTransform(cycle,len,true);

if marketposition <> 0 then begin
 setstoploss(stoploss);
 setprofittarget(target);
end;

if marketposition < 1 and trig > trend and fish > fish[1] then
 buy next bar c - rng*range limit;
 
if marketposition > -1 and trig < trend and fish < fish[1] then
 sell short next bar c + rng*range limit;
