Inputs: NoS(2),LenL(34),KL(1),LenS(30),KS(4.7),ADXLen(12),ADXLimit(28);
Inputs: StopLoss(2300),TargetL(8700),TargetS(8300),BRK(1200),TRSL(3600),TRSS(2100);

Vars: upperk(0,data2),lowerk(0,data2),adxval(0,data2);
Vars: el(true),es(true),bounce(true);

upperk = KeltnerChannel(h,lenl,kl)data2;
lowerk = KeltnerChannel(l,lens,-ks)data2;
adxval = adx(adxlen)data2;

el = true;
es = true;
bounce = false;

if marketposition(1) = 1 then
 el = positionprofit(1) < targetl*nos or positionprofit(1) >= targetl*nos and d > exitdate(1);
if marketposition(1) = -1 then
 es = positionprofit(1) < targets*nos or positionprofit(1) >= targets*nos and d > exitdate(1);

if time > 800 and time < 2300 then begin
 if marketposition <> 0 then begin
  //StopLoss and Target
  setstopshare;
  setstoploss(stoploss);
  if nos = 1 then begin
   if marketposition = 1 then setprofittarget(targetl);
   if marketposition = -1 then setprofittarget(targets);
  end;
  if nos > 1 and currentcontracts = nos/2 then begin
   if marketposition = 1 then setprofittarget(targetl+1000);
   if marketposition = -1 then setprofittarget(targets+1000);
  end;
  //BreakEven and Trailing Stop
  if maxpositionprofit/nos > brk then begin
   if marketposition = 1 then begin
    sell("brkl") next bar at entryprice + .02 stop;
    sell("trsl") next bar at entryprice + (maxpositionprofit/nos - trsl)/bigpointvalue stop;
    bounce = lowerk < entryprice + .02;
    if bounce = false then bounce = lowerk < entryprice + (maxpositionprofit/nos - trsl)/bigpointvalue;
   end;
   if marketposition = -1 then begin
    buytocover("brks") next bar at entryprice - .02 stop;
    buytocover("trss") next bar at entryprice - (maxpositionprofit/nos - trss)/bigpointvalue stop;
    bounce = upperk > entryprice - .02;
    if bounce = false then bounce = upperk > entryprice - (maxpositionprofit/nos - trss)/bigpointvalue;
   end;
  end;
  //Trailing StopLoss
  if maxpositionprofit/nos > 0 and maxpositionprofit/nos < brk then begin
   if marketposition = 1 then begin
    sell("xl") next bar at entryprice + (maxpositionprofit/nos - stoploss)/bigpointvalue stop;
    if bounce = false then bounce = lowerk < entryprice + (maxpositionprofit/nos - stoploss)/bigpointvalue;
   end;
   if marketposition = -1 then begin
    buytocover("xs") next bar at entryprice - (maxpositionprofit/nos - stoploss)/bigpointvalue stop;
    if bounce = false then bounce = upperk > entryprice - (maxpositionprofit/nos - stoploss)/bigpointvalue;
   end;
  end;
  //Uscita Modale
  if currentcontracts = nos and nos > 1 then begin
   if marketposition = 1 then begin
    sell("tl") nos/2 shares next bar at entryprice + TargetL/bigpointvalue limit;
   end;
   if marketposition = -1 then begin
    buytocover("ts") nos/2 shares next bar at entryprice - TargetS/bigpointvalue limit;
   end;
  end;
 end;
 //Engine
 if adxval < adxlimit and bounce = false then begin
  if el and marketposition < 1 and c < upperk then
   buy("long") nos shares next bar at upperk stop;
  if es and marketposition > -1 and c > lowerk then
   sellshort("short") nos shares next bar at lowerk stop;
 end;
end;
