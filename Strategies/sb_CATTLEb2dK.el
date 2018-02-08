Inputs: NoS(2),LenL(24),KL(1.45),LenS(30),KS(1.55),ADXLen(19),TOP(30),SOD(800),EOD(2100);
Inputs: StopLoss(1000),BRK(1000),TL(600),TS(500),TRSL(200),TRSS(500);

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

if time > sod and time < eod then begin
 setstopshare;
 setstoploss(stoploss);
 //BreakEven Trailing Stop
 if maxposprof > brk/bigpointvalue then begin
  if marketposition = 1 then begin
   sell("brkl") next bar at entryprice + 100/bigpointvalue stop;
   sell("trsl") next bar at entryprice + (maxposprof - trsl/bigpointvalue) stop;
   bounce = lowerk < entryprice + 100/bigpointvalue;
  end;
  if marketposition = -1 then begin
   buytocover("brks") next bar at entryprice - 100/bigpointvalue stop;
   buytocover("trss") next bar at entryprice - (maxposprof - trss/bigpointvalue) stop;
   bounce = upperk > entryprice - 100/bigpointvalue;
  end;
 end;
 //Uscita Modale
  if currentcontracts = nos and nos > 1 then begin
   if marketposition = 1 then sell("tl") nos/2 shares next bar at entryprice + tl/bigpointvalue limit;
   if marketposition = -1 then buytocover("ts") nos/2 shares next bar at entryprice - ts/bigpointvalue limit;
  end;
 //Engine
 if adxval < top then begin
  if marketposition < 1 and c < upperk then
   buy("long") nos shares next bar at upperk stop;
  if marketposition > -1 and c > lowerk then
   sellshort("short") nos shares next bar at lowerk stop;
 end;
 
end;
