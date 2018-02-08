Inputs: NoS(6),LenL(8),KL(3),LenS(26),KS(3.7),ADXLen(14),ADXLimit(30);
Inputs: StopLoss(1500),TargetL(3900),TargetS(3600),BRK(1100),TRSL(2700),TRSS(1200);

Vars: upperk(0),lowerk(0),adxval(0);
Vars: maxposprof(0),bounce(false);

upperk = KeltnerChannel(h,lenl,kl);
lowerk = KeltnerChannel(l,lens,-ks);
adxval = adx(adxlen);

bounce = false;

if marketposition <> 0 then begin
 if barssinceentry = 0 then begin
  if marketposition = 1 then maxposprof = h - entryprice;
  if marketposition = -1 then maxposprof = entryprice - l;
 end
 else begin
  if marketposition = 1 then maxposprof = maxlist(h - entryprice,maxposprof);
  if marketposition = -1 then maxposprof = maxlist(entryprice - l,maxposprof);
 end;
end;

if time > 800 and time < 2300 then begin
 if marketposition <> 0 then begin
  //StopLoss
  setstopshare;
  setstoploss(stoploss);
  //BreakEven
  if maxposprof > brk/bigpointvalue then begin
   if marketposition = 1 then begin
    sell("brkl") next bar at entryprice + 100/bigpointvalue stop;
    sell("trsl") next bar at entryprice + (maxposprof - trsl/bigpointvalue) stop;
    bounce = lowerk < entryprice + 100/bigpointvalue;
    if bounce = false then bounce = lowerk < entryprice + (maxposprof - trsl/bigpointvalue);
   end;
   if marketposition = -1 then begin
    buytocover("brks") next bar at entryprice - 100/bigpointvalue stop;
    buytocover("trss") next bar at entryprice - (maxposprof - trss/bigpointvalue) stop;
    bounce = upperk > entryprice - 100/bigpointvalue;
    if bounce = false then bounce = upperk > entryprice - (maxposprof - trss/bigpointvalue);
   end;
  end;
  //Uscita Modale
  if currentcontracts = nos and nos > 1 then begin
   if marketposition = 1 then sell("tl") nos/2 shares next bar at entryprice + targetl/bigpointvalue limit;
   if marketposition = -1 then buytocover("ts") nos/2 shares next bar at entryprice - targets/bigpointvalue limit;
  end;
  if currentcontracts = nos/2 then begin
   if marketposition = 1 then setprofittarget(targetl+1000);
   if marketposition = -1 then setprofittarget(targets+1000);
  end;
 end;
 //Engine
 if adxval < adxlimit and bounce = false then begin
  if marketposition < 1 and c < upperk then
   buy("long") nos shares next bar at upperk stop;
  if marketposition > -1 and c > lowerk then
   sellshort("short") nos shares next bar at lowerk stop;
 end;
end;
