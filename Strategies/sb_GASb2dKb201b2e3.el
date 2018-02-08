[IntraBarOrderGeneration = true];
Inputs: NoS(2),KLen(25),K(1.5),RLen(24),SLen(5);
Inputs:StopL(2100),StopS(1100),Step1L(500),Step1S(500),Step2L(750),Step2S(750);

Vars: lowerk(0,data2),upperk(0,data2),r100(0,data2),slope(0,data3);
Vars: Step(0),level(0),stopp(0),n(0);
Vars: fl(false),fs(false),rl(false),rs(false);

fl = false;
fs = false;
rl = false;
rs = false;

if barstatus(2) = 2 then begin 
 lowerk = KeltnerChannel(l data2,klen,-k) data2;
 upperk = KeltnerChannel(h data2,klen,k) data2;
 r100 = PercentR(rlen) data2;
 slope = LinearRegSlope(c data3,slen) data3;
 
 if slope > 0 and r100 < 10 then fs = true;
 if slope < 0 and r100 > 90 then fl = true;
 if slope < 0 and low > upperk then rs = true;
 if slope > 0 and high < lowerk then rl = true;
end;

if time > 800 and time < 2230 then begin
 
 if fs then sellshort("fs") nos shares next bar at lowerk stop;
 if fl then buy("fl") nos shares next bar at upperk stop;
 if r100 > 20 and r100 < 80 then begin
  if rs then sellshort("rs") nos shares next bar at upperk stop;
  if rl then buy("rl") nos shares next bar at lowerk stop;
 end;
 
 setstopshare;
 step = (High - entryprice)*bigpointvalue;
 if marketposition = 1 then begin  
  setstoploss(stopl);
  if step > 0 then begin
   n = step/step1l;
   n = iff(n>=1,n,1);
   stopp = Floor(step1l*(1 + 1/n));
   level = (n*step - stopp)/bigpointvalue;
   if fl = false then sell("flx") entry("fl") next bar at entryprice + level stop;
   if rl = false then sell("rlx") entry("rl") next bar at entryprice + level stop;
  end;
 end;
 step = (entryprice - low)*bigpointvalue;
 if marketposition = -1 then begin 
  setstoploss(stops);
  if step > 0 then begin
   n = step/step1s;
   n = iff(n>=1,n,1);
   stopp = Floor(step1s*(1 + 1/n));
   level = (stopp - n*step)/bigpointvalue;
   if fs = false then buytocover("fsx") entry("fs") next bar at entryprice + level stop;
   if rs = false then buytocover("rsx") entry("rs") next bar at entryprice + level stop;
  end;
 end;
  
end;
