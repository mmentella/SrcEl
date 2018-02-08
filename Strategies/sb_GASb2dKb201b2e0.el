[IntraBarOrderGeneration = true];
Inputs: NoS(2),KLen(25),K(1.5),RLen(24),SLen(5);
Inputs:StopL(2100),StopS(1100),Step1L(500),Step1S(500),Step2L(750),Step2S(750);

Vars: lowerk(0,data2),upperk(0,data2),r100(0,data2),slope(0,data3);
Vars: Step(0),level(0),stopp(0),n(0);

if barstatus(2) = 2 then begin
 lowerk = KeltnerChannel(l data2,klen,-k) data2;
 upperk = KeltnerChannel(h data2,klen,k) data2;
 r100 = PercentR(rlen) data2;
 slope = LinearRegSlope(c data3,slen) data3; 
end;

if time > 800 and time < 2230 then begin
 if slope > 0 and r100 < 10 then sellshort("fs") nos shares next bar at lowerk stop;
 if slope < 0 and r100 > 90 then buy("fl") nos shares next bar at upperk stop;
 if r100 > 20 and r100 < 80 then begin
  if slope < 0 and low > upperk then sellshort("rs") nos shares next bar at upperk stop;
  if slope > 0 and high < lowerk then buy("rl") nos shares next bar at lowerk stop;
 end;
 
 setstopshare;
 step = (High - entryprice)*bigpointvalue;
 if marketposition = 1 then begin  
  setstoploss(stopl);
  if step > 0 then begin
   if currentcontracts = nos then begin
    n = step/step1l;
    n = iff(n>=1,n,1);
    stopp = Floor(step1l*(1 + 1/n));
    level = (n*step - stopp)/bigpointvalue;
    sell("s1l") (nos/2) shares next bar at entryprice + level stop;
   end;//currentcontracts = nos
   if currentcontracts = nos/2 then begin
    n = step/step2l;
    n = iff(n>=1,n,1);
    stopp = Floor(step2l*(1 + 1/n));
    level = (n*step - stopp)/bigpointvalue;
    sell("s2l") next bar at entryprice + level stop;
   end;//currentcontracts = nos/2
  end;//step>0
 end;//marketposition = 1
 step = (entryprice - low)*bigpointvalue;
 if marketposition = -1 then begin 
  setstoploss(stops);
  if step > 0 then begin
   if currentcontracts = nos then begin
    n = step/step1s;
    n = iff(n>=1,n,1);
    stopp = Floor(step1s*(1 + 1/n));
    level = (stopp - n*step)/bigpointvalue;
    buytocover("s1s") (nos/2) shares next bar at entryprice + level stop;
   end;//currentcontracts = nos
   if currentcontracts = nos/2 then begin
    n = step/step2s;
    n = iff(n>=1,n,1);
    stopp = Floor(step2s*(1 + 1/n));
    level = (stopp - n*step)/bigpointvalue;
    buytocover("s2s") (nos/2) shares next bar at entryprice + level stop;
   end;//currentcontracts = nos/2
  end;//step>0
 end;//marketposition = -1
  
end;
