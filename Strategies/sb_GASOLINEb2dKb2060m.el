Inputs: NoS(2),LenL(16),KL(1),LenS(12),KS(1),ADXLen(15),ADXLimit(28),BarWait(21);
Inputs: StopLoss(1500),stopdl(10000),stopds(10000),TargetL(4000),TargetS(4000),BRK(900),TRSL(2300),TRSS(2400);

Vars: upperk(0),lowerk(0),hs(0),ls(0),adxval(0);
Vars: el(true),es(true),bounce(false),trade(true);

upperk = KeltnerChannel(h,lenl,kl);
lowerk = KeltnerChannel(l,lens,-ks);
adxval = adx(adxlen);

trade = true;
if marketposition <> 0 then begin
 el = marketposition = -1;
 es = marketposition = 1;
end;
if marketposition = 0 then begin
 el = marketposition(1) = 1 and exitdate(1) < d;
 es = marketposition(1) = -1 and exitdate(1) < d;
end;
if marketposition(1) = 0 then begin
 el = true;
 es = true;
end;
if marketposition(1) <> 0 and positionprofit(1) < 0 then trade = barssinceexit(1) > barwait; 
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
   end;
   if marketposition = -1 then begin
    buytocover("brks") next bar at entryprice - 25 points stop;
    buytocover("trss") next bar at entryprice - (maxpositionprofit/nos - trss)/bigpointvalue stop;
    bounce = upperk > entryprice - 25 points;
   end;
  end;//BreakEven
  //Uscita Modale
  if currentcontracts = nos and nos > 1 then begin
   if marketposition = 1 then sell("tl") nos/2 shares next bar at entryprice + TargetL/bigpointvalue limit;
   if marketposition = -1 then buytocover("ts") nos/2 shares next bar at entryprice - targets/bigpointvalue limit;
  end;
  if bounce = false then begin
   if marketposition = 1 then bounce = lowerk < entryprice + (maxpositionprofit/nos - stoploss)/bigpointvalue;
   if marketposition = -1 then bounce = upperk > entryprice - (maxpositionprofit/nos - stoploss)/bigpointvalue;
  end;
 end;//Uscite Statistiche
 //Engine
 if adxval < adxlimit and bounce = false and trade then begin
  if el and marketposition < 1 and c < upperk then
   buy("long") nos shares next bar at upperk stop;
  if es and marketposition > -1 and c > lowerk then
   sellshort("short") nos shares next bar at lowerk stop;
 end;
end;
