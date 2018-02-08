Inputs: NoS(2),LenL(24),KL(1.81),LenS(30),KS(3.52),ADXLen(19),TOP(30);
Inputs: StopLoss(400),BRK(550),TL(600),TS(500),TRSL(1500),TRSS(700);

Vars: upperk(0,data2),lowerk(0,data2),adxval(0,data2);
Vars: maxposprof(0),bounce(false),SOD(800),EOD(2100);

upperk = KKeltnerChannel(h,lenl,kl)data2;
lowerk = KKeltnerChannel(l,lens,-ks)data2;
adxval = adx(adxlen)data2;

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
 if marketposition <> 0 then begin
  setstopshare;
  setstoploss(stoploss);
  //BreakEven Trailing Stop
  if maxposprof > brk/bigpointvalue then begin
   if marketposition = 1 then begin
    sell("brkl") next bar at entryprice + 100/bigpointvalue stop;    
    bounce = lowerk < entryprice + 100/bigpointvalue;
   end;
   if marketposition = -1 then begin
    buytocover("brks") next bar at entryprice - 100/bigpointvalue stop;    
    bounce = upperk > entryprice - 100/bigpointvalue;
   end;
  end;
  if marketposition = 1 then sell("trsl") next bar at entryprice + (maxposprof - trsl/bigpointvalue) stop;
  if marketposition = -1 then buytocover("trss") next bar at entryprice - (maxposprof - trss/bigpointvalue) stop;
  //Uscita Modale
  if currentcontracts = nos and nos > 1 then begin
   if marketposition = 1 then sell("tl") nos/2 shares next bar at entryprice + tl/bigpointvalue limit;
   if marketposition = -1 then buytocover("ts") nos/2 shares next bar at entryprice - ts/bigpointvalue limit;
  end;
 end;
 //Engine
 if adxval < top then begin
  if marketposition < 1 and c data2 < upperk then
   buy("long") nos shares next bar at upperk stop;
  if marketposition > -1 and c data2 > lowerk then
   sellshort("short") nos shares next bar at lowerk stop;
 end; 
end;
