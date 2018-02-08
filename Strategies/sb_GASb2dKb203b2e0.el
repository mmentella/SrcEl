Inputs: NoS(2),KLen(25),K(1.5),RLen(24),SLen(5);
Inputs: TL(250),TS(250),PctL(.5),PctS(.5);

Vars: lowerk(0,data2),upperk(0,data2),r100(0,data2),slope(0,data3);
Vars: fl(false),fs(false),rl(false),rs(false);

fl = false;fs = false;rl = false;rs = false;

lowerk = KeltnerChannel(l data2,klen,-k) data2;
upperk = KeltnerChannel(h data2,klen,k) data2;
r100 = PercentR(rlen) data2;
slope = LinearRegSlope(c data3,slen) data3;

if slope > 0 and r100 < 10 then fs = true;
if slope < 0 and r100 > 90 then fl = true;
if slope < 0 and low > upperk then rs = true;
if slope > 0 and high < lowerk then rl = true;

if time > 800 and time < 2230 then begin 
  
 if fs then sellshort("fs") nos shares next bar at lowerk stop;
 if fl then buy("fl") nos shares next bar at upperk stop;
 if r100 > 20 and r100 < 80 then begin
  if rs then sellshort("rs") nos shares next bar at upperk stop;
  if rl then buy("rl") nos shares next bar at lowerk stop;
 end;
 
 if marketposition <> 0 then begin
  
 end;
  
end;
