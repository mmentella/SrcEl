[IntraBarOrderGeneration = true];
Inputs: NoS(2),KLen(25),K(1.5),RLen(24),SLen(5);
Inputs:StopL(2400),StopS(1000),BKS(3100),BKL(4500),TL(.49),TS(.36);

Vars: lowerk(0,data2),upperk(0,data2),r100(0,data2),slope(0,data3);
Vars: Step(0),level(0),stopp(0),n(0),posprofit(0);
Vars: fl(false),fs(false),rl(false),rs(false);
Vars: _fl(true),_fs(true),_rl(true),_rs(true);

fl = false;
fs = false;
rl = false;
rs = false;

if barstatus(2) = 2 then begin 
 lowerk = KeltnerChannel(l data2,klen,-k) data2;
 upperk = KeltnerChannel(h data2,klen,k) data2;
 r100 = PercentR(rlen) data2;
 slope = LinearRegSlope(c data3,slen) data3;
end;

if slope > 0 and r100 < 10 then fs = true;
if slope < 0 and r100 > 90 then fl = true;
if slope < 0 and low > upperk then rs = true;
if slope > 0 and high < lowerk then rl = true;

if time > 800 and time < 2230 then begin 
 
 setstopshare;
 if marketposition = 1 then begin 
  _fs = true;
  _rs = true;
  _fl = false;
  _rl = false;
  setstoploss(stopl);
 end;
 if marketposition = -1 then begin
  _fl = true;
  _rl = true;
  _fs = false;
  _rs = false;
  setstoploss(stops);
 end;
 if marketposition <> marketposition(1) then posprofit = 0;
  
 if fs and _fs then sellshort("fs") nos shares next bar at lowerk stop;
 if fl and _fl then buy("fl") nos shares next bar at upperk stop;
 if r100 > 20 and r100 < 80 then begin
  if rs and _rs then sellshort("rs") nos shares next bar at upperk stop;
  if rl and _rl then buy("rl") nos shares next bar at lowerk stop;
 end;
 
 //sell("rlx") entry("rl") (nos/2) shares next bar at upperk limit;
 //if positionprofit < 0 then sell("flxs") entry("fl") next bar at lowerk stop;
 //if positionprofit > 0 then sell("flxp") entry("fl") (nos/2) shares next bar at lowerk stop;
 //buytocover("rsx") entry("rs") (nos/2) shares next bar at lowerk limit;
 //if positionprofit < 0 then buytocover("fsxs") entry("fs") next bar at upperk stop;
 //if positionprofit > 0 then buytocover("fsxp") entry("fs") (nos/2) shares next bar at upperk stop;
 
 if marketposition = 1 then begin
  if maxpositionprofit > bkl then sell("bkl") next bar at entryprice + 10 point stop;
  if currentcontracts = nos then sell("tl") (nos/2) shares next bar at entryprice + tl limit;
 end;
 if marketposition = -1 then begin
  if maxpositionprofit > bks then buytocover("bks") next bar at entryprice - 10 point stop;
  if currentcontracts = nos then buytocover("ts") (nos/2) shares next bar at entryprice - ts limit;
 end;
  
end;
