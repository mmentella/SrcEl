Inputs: NoS(4),LenL(15),KL(1.5),LenS(20),KS(3.9),ADXLen(15),ADXLimit(30);
Inputs: StopLoss(700),BRK(900),TRSL(1900),TRSS(1900),TL(1700),TS(1900);

Vars: upperk(0,data2),lowerk(0,data2),adxval(0,data2),posprofit(0);
Vars: bounce(false);

upperk = KeltnerChannel(h,lenl,kl)data2;
lowerk = KeltnerChannel(l,lens,-ks)data2;
adxval = adx(adxlen)data2;

bounce = false;

if marketposition <> 0 then begin
 if barssinceentry = 0 then posprofit = 0
 else begin
  if marketposition = 1 then posprofit = maxlist(posprofit,(h-entryprice));
  if marketposition = -1 then posprofit = maxlist(posprofit,(entryprice-l));
 end;
end;

if time > 800 and time < 2300 then begin 
 if marketposition <> 0 then begin
  //StopLoss
  setstopshare;
  setstoploss(stoploss);
  //BreakEven Trailing Stop
  if posprofit > brk/bigpointvalue then begin
   if marketposition = 1 then begin
    sell("brkl") next bar at entryprice + 100/bigpointvalue stop;
    sell("trsl") next bar at entryprice + (posprofit - trsl/bigpointvalue) stop;
    bounce = lowerk < entryprice + 100/bigpointvalue;
    if bounce = false then bounce = lowerk < entryprice + (posprofit - trsl/bigpointvalue);
   end;
   if marketposition = -1 then begin
    buytocover("brks") next bar at entryprice - 100/bigpointvalue stop;
    buytocover("trss") next bar at entryprice - (posprofit - trss/bigpointvalue) stop;
    bounce = upperk > entryprice - 100/bigpointvalue;
    if bounce = false then bounce = upperk > entryprice - (posprofit - trss/bigpointvalue);
   end;
  end;
  //Profit Target
  if currentcontracts = nos and nos > 1 then begin
   if marketposition = 1 then sell("tl") nos/2 shares next bar at entryprice + tl/bigpointvalue limit;
   if marketposition = -1 then buytocover("ts") nos/2 shares next bar at entryprice - ts/bigpointvalue limit;
  end;
 end;

 if adxval < adxlimit and bounce = false then begin
  if marketposition < 1 and c data2 < upperk and h > upperk then
   buy("long") nos shares next bar at market;
  if marketposition > -1 and c data2 > lowerk and l < lowerk then
   sellshort("short") nos shares next bar at market;
 end;
end;
