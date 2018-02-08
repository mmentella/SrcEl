Inputs: NoS(2),LenL(45),KL(1),LenS(6),KS(1.85),ADXLen(14),ADXLimit(31);
Inputs: StopLoss(1000),BRK(300),TL(1000),TS(2200),TRSL(1000),TRSS(1000);


Vars: upperk(0,data2),lowerk(0,data2),adxval(0,data2);
Vars: underK(false,data2), overK(false,data2);
Vars: maxposprof(0),bounce(false),mp(0),trade(true);

{ Process Variables }
Vars: OpenTime(930), CloseTime(1945);

bounce = false;
mp = marketposition*currentcontracts;

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

if mp <> mp[1] then trade = false;
//if barstatus(2) = 2 then trade = true;

// New TimeFrame2 bar
if BarStatus(2) = 2 then begin
 upperk = KeltnerChannel(h,lenl,kl)data2;
 lowerk = KeltnerChannel(l,lens,-ks)data2;
 adxval = adx(adxlen)data2;
 underK = c data2 < upperk;
 overK = c data2 > lowerk;
 trade = true;
end;   // of new TimeFrame2 bar

//if time > 800 and time < 2300 then begin
if OpenTime <= time and time < CLoseTime then begin
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
    bounce = upperk > entryprice - 80/bigpointvalue;
   end;
  end;
  //Uscita Modale
  if currentcontracts = nos and nos > 1 then begin
   if marketposition = 1 then sell("tl") nos/2 shares next bar at entryprice + tl/bigpointvalue limit;
   if marketposition = -1 then buytocover("ts") nos/2 shares next bar at entryprice - ts/bigpointvalue limit;
  end;
 end;
 //Engine
 if adxval < adxlimit and trade and bounce = false then begin
  if marketposition < 1 and {c data2 < upperk} underK then
   buy("long") nos shares next bar at upperk stop;
  if marketposition > -1 and {c data2 > lowerk} overK then
   sellshort("short") nos shares next bar at lowerk stop;
 end;
end;
