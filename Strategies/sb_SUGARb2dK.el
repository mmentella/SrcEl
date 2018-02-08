Inputs: NoS(2),LenL(45),KL(1),LenS(6),KS(1.85),ADXLen(14),ADXLimit(31);
Inputs: StopLoss(1000),BRK(300),TL(1000),TS(2200),TRSL(1000),TRSS(1000);

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
  //BreakEven Trailing Stop
  if maxposprof > brk/bigpointvalue then begin
   if marketposition = 1 then begin
    sell("brkl") next bar at entryprice + 80/bigpointvalue stop;
    //sell("trsl") next bar at entryprice + (maxposprof - trsl/bigpointvalue) stop;
    bounce = lowerk < entryprice + 80/bigpointvalue;
   end;
   if marketposition = -1 then begin
    buytocover("brks") next bar at entryprice - 80/bigpointvalue stop;
    //buytocover("trss") next bar at entryprice - (maxposprof - trss/bigpointvalue) stop;
    bounce = upperk > entryprice - 100/bigpointvalue;
   end;
  end;
  //Uscita Modale
  if currentcontracts = nos and nos > 1 then begin
   if marketposition = 1 then sell("tl") nos/2 shares next bar at entryprice + tl/bigpointvalue limit;
   if marketposition = -1 then buytocover("ts") nos/2 shares next bar at entryprice - ts/bigpointvalue limit;
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
