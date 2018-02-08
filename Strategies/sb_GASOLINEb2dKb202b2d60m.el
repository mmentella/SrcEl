Inputs: NoS(2),LenL(16),KL(1),LenS(12),KS(1),ADXLen(15),ADXLimit(28),BarWait(21);
Inputs: StopLoss(1500),TargetL(4000),TargetS(4000),BRK(900),TRSL(2300),TRSS(2400);

Vars: upperk(0,data2),lowerk(0,data2),hs(0),ls(0),adxval(0,data2);
Vars: el(true),es(true),bounce(false),trade(true),counter(0),lt2(0),lt(0);

upperk = KeltnerChannel(h,lenl,kl)data2;
lowerk = KeltnerChannel(l,lens,-ks)data2;
adxval = adx(adxlen)data2;

 trade = true;
 if marketposition <> 0 then begin
  el = marketposition = -1;
  es = marketposition = 1;
 end;
 if marketposition = 0 then begin
  el = marketposition(1) = 1;
  es = marketposition(1) = -1;
 end;
 if marketposition(1) = 0 then begin
  el = true;
  es = true;
 end;
 if marketposition(1) <> 0 and positionprofit(1) < 0 then begin
  if barssinceexit(1) = 0 then begin
   counter = 1;
   lt = time data2;
  end;
  if lt <> time data2 then begin
   counter = counter + 1;
   lt = time data2;
  end;
  trade = counter >= barwait;
 end;
 bounce = false;

if time > 800 and time < 2300 then begin
 if marketposition <> 0 then begin//Uscite Statistiche
  //StopLoss
  setstopshare;
  setstoploss(stoploss);
  //BreakEven
  if maxpositionprofit/nos > brk then begin
   if marketposition = 1 then begin
    sell("brkl") next bar at entryprice + 25 points stop;
    sell("trsl") next bar at entryprice + (maxpositionprofit/nos - trsl)/bigpointvalue stop;
    bounce = lowerk < entryprice + 25 points;
    if bounce = false then bounce = lowerk < entryprice + (maxpositionprofit/nos - trsl)/bigpointvalue;
   end;
   if marketposition = -1 then begin
    buytocover("brks") next bar at entryprice - 25 points stop;
    buytocover("trss") next bar at entryprice - (maxpositionprofit/nos - trss)/bigpointvalue stop;
    bounce = upperk > entryprice - 25 points;
    if bounce = false then bounce = upperk > entryprice - (maxpositionprofit/nos - trss)/bigpointvalue;
   end;
  end;//BreakEven
  //Uscita Modale
  if currentcontracts = nos and nos > 1 then begin
   if marketposition = 1 then sell("tl") nos/2 shares next bar at entryprice + TargetL/bigpointvalue limit;
   if marketposition = -1 then buytocover("ts") nos/2 shares next bar at entryprice - targets/bigpointvalue limit;
  end;
 end;//Uscite Statistiche
 if bounce = false then begin
  if marketposition = 1 then bounce = lowerk < entryprice - stoploss/bigpointvalue;
  if marketposition = -1 then bounce = upperk > entryprice + stoploss/bigpointvalue;
 end;
 //Engine
 if adxval < adxlimit and bounce = false and trade then begin
  if el and marketposition < 1 and c data2 < upperk then
   buy("long") nos shares next bar at upperk stop;
  if es and marketposition > -1 and c data2 > lowerk then
   sellshort("short") nos shares next bar at lowerk stop;
 end;
end;
