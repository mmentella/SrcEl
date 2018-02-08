{******** - GD ........... - ********
 Engine: Keltner Channel
 Author: Matteo Montella
        (rev. Giulio D'Urso)
 Year: 2010
 Market: Crude Oil futures
 TimeFrame: 2 + 60 min.
 BackBars: 100
 Update: 21 May 2010
***********************************}


Inputs: NoS(2),LenL(19),KL(2.07),LenS(6),KS(4.85),ADXLen(24),ADXLimit(24);
Inputs: StopL(490),StopS(1700),BRKL(700),BRKS(700),TL(3100),TS(1900),TRSL(2100),TRSS(2900);
Inputs: StopLimitPerc(0), SettleTime(0);

Vars: upperk(0,data2),lowerk(0,data2),adxval(0,data2),mpp(0);
Vars: underK(false,data2),overK(false,data2);
Vars: stopVal(0), stopMin(0), stopMax(999999), SettlePrice(0);   

{ Process Variables }
Vars: OpenTime(0800), CloseTime(2200);


{ max/min Stop Update }
if StopLimitPerc > 0 then begin
 if Date > Date[1] then begin
  if SettleTime = 0 then SettlePrice = Close[1];
  stopMin = SettlePrice*(1-StopLimitPerc/100);
  stopMax = SettlePrice*(1+StopLimitPerc/100);
  settlePrice = 0; 
 end;
 if Time >= SettleTime and SettlePrice = 0 then SettlePrice = Close;
end;

//upperk = KeltnerChannel(h,lenl,kl)data2;
//lowerk = KeltnerChannel(l,lens,-ks)data2;
//adxval = adx(adxlen)data2;

// new TimeFrame2 bar
if BarStatus(2) = 2 then begin
 upperk = KeltnerChannel(h,lenl,kl)data2;
 lowerk = KeltnerChannel(l,lens,-ks)data2;
 adxval = adx(adxlen)data2;
 underK = c data2 < upperk;
 overK = c data2 > lowerk;
end; // of new TimeFrame2 bar

if marketposition <> 0 then begin
 //MAX CONTRACT PROFIT
 if barssinceentry = 0 then begin
  if marketposition = 1 then mpp = h - entryprice;
  if marketposition = -1 then mpp = entryprice - l;
 end else begin
  if marketposition = 1 then mpp = maxlist(mpp,h-entryprice);
  if marketposition = -1 then mpp = maxlist(mpp,entryprice-l);
 end;
end;

//if time > 800 and time < 2200 then begin
if OpenTime < Time and time < CloseTime then begin
 
 if marketposition <> 0 then begin

  setstopshare;
  stopVal = 0;
  
  //STOPLOSS
  if marketposition = 1 and stopl > 0 then begin
   stopVal = EntryPrice-stopl/BigPointValue;
   if StopMin < StopVal and StopVal < StopMax then
    if c > stopVal then setstoploss(stopl)
    else                sell("xl.stop.m") next bar at market;
  end else
  if marketposition = -1 and stops > 0 then begin
   stopVal = EntryPrice+stops/BigPointValue;
   if StopMin < StopVal and StopVal < StopMax then
    if c < stopVal then setstoploss(stops)
    else buytocover("xs.stop.m") next bar at market;
  end;

  //BREAKEVEN
  if mpp > brkl/bigpointvalue and brkl > 0 then
   if marketposition = 1 then begin
    stopVal = entryprice + 100/bigpointvalue;
    if StopMin < StopVal and StopVal < StopMax then
     if c > stopVal then sell("xl.brk.s") next bar at stopVal stop
     else                sell("xl.brk.m") next bar at market;
   end;
  //else
  //if mpp > brks/bigpointvalue then
   //if marketposition = -1 then buytocover("brks") next bar at entryprice - 100/bigpointvalue stop;
  
  //MODAL EXIT
  if currentcontracts = nos and nos > 1 then
   if marketposition = 1 and tl > 0 then begin
    //sell("tl") nos/2 shares next bar at entryprice + tl/bigpointvalue limit;
    stopVal = entryprice + tl/bigpointvalue;
    if StopMin < StopVal and StopVal < StopMax then
     if c < stopVal then sell("xl.mod1.s") nos/2 shares next bar at stopVal limit
     else                sell("xl.mod1.m") nos/2 shares next bar at market;
   end else
   if marketposition = -1 and ts > 0 then begin
    //buytocover("ts") nos/2 shares next bar at entryprice - ts/bigpointvalue limit;
    stopVal = entryprice - ts/bigpointvalue;
    if StopMin < StopVal and StopVal < StopMax then
     if c > stopVal then buytocover("xs.mod1.s") nos/2 shares next bar at stopVal limit
     else                buytocover("xs.mod1.m") nos/2 shares next bar at market;
   end;

  //TRAILING STOP
  if mpp > brkl/bigpointvalue and trsl > 0 then
   //if marketposition = 1 then sell("trsl") next bar at entryprice + (mpp - trsl/bigpointvalue) stop;
   if marketposition = 1 then begin
    stopVal = entryprice + (mpp - trsl/bigpointvalue);
    if StopMin < StopVal and StopVal < StopMax then
     if c > stopVal then sell("xl.trl.s") next bar at stopVal stop
     else                sell("xl.trl.m") next bar at market;
   end;
  //if mpp > brks/bigpointvalue then
   //if marketposition = -1 then buytocover("trss") next bar at entryprice - (mpp - trss/bigpointvalue) stop;
  
 end;

 //ENGINE
 if adxval < adxlimit then begin
  //if marketposition < 1 and c data2 < upperk and c < upperk then
  if marketposition < 1 and underK and c < upperk then
   buy("long") nos shares next bar at upperk stop;
  //if marketposition > -1 and c data2 > lowerk and c > lowerk then
  if marketposition > -1 and overK and c > lowerk then
   sellshort("short") nos shares next bar at lowerk stop;
 end;

end;
