[IntraBarOrderGeneration = true];
Inputs: NoS(2),KLen(25),K(1.5),RLen(24),SLen(5);

Vars: lowerk(0,data2),upperk(0,data2),r100(0,data2),slope(0,data3);
Vars: fs(true),fl(true),rs(true),rl(true);

if barstatus(2) = 2 then begin
 lowerk = KeltnerChannel(l data2,klen,-k) data2; //Keltner Channel Low
 upperk = KeltnerChannel(h data2,klen,k) data2; //Keltner Channel Low
 r100 = PercentR(rlen) data2; // %R
 slope = LinearRegSlope(c data3,slen) data3; // Regressione Lineare 
end;

if time > 800 and time < 2230 then begin
 if slope > 0 and r100 < 10 then sellshort("fs") nos shares next bar at lowerk stop;
 if slope < 0 and r100 > 90 then buy("fl") nos shares next bar at upperk stop;
 if r100 > 20 and r100 < 80 then begin
  if slope < 0 and low > upperk then sellshort("rs") nos shares next bar at upperk stop;
  if slope > 0 and high < lowerk then buy("rl") nos shares next bar at lowerk stop;
 end;
end;
