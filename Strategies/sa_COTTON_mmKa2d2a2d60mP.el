Inputs: NoS(6),LenL(8),KL(3),LenS(26),KS(3.7),ADXLen(14),ADXLimit(30);
Inputs: StopLoss(1500),TargetL(500),TargetS(500),BRK(1100),TRSL(2700),TRSS(1200);

Inputs: DayLimit("1350"), SettleTime(2015);   // $1,200 == 10% off of $1,500 daily limit


Vars: upperk(0,data2),lowerk(0,data2),adxval(0,data2);
Vars: underK(false,data2),overK(false,data2);
Vars: eltg(999999),estg(0);

Vars: maxposprof(0),bounce(false);

Vars: stopVal(0), stopMin(0), stopMax(999999), SettlePrice(0);   
Vars: dayMax(0), dayPerc(false);


//SettlementSafeStopOrder(0,0,2015);

if currentbar <= 1 then begin
 if DayLimit <> "" then
  if RightStr(DayLimit, 1) = "%" then begin
   dayMax = StrToNum(LeftStr(DayLimit, StrLen(DayLimit) - 1)); dayPerc = true; end
  else begin
   dayMax = StrToNum(DayLimit)/bigpointvalue; dayPerc = false; end;
end;

{ max/min Stop Update }
if dayMax > 0 then begin
 if Date > Date[1] then begin
  if SettleTime = 0 then SettlePrice = Close[1];
  if dayPerc then begin
   stopMin = SettlePrice*(1-dayMax/100);
   stopMax = SettlePrice*(1+dayMax/100);
  end else begin
   stopMin = SettlePrice-dayMax;
   stopMax = SettlePrice+dayMax;
  end;
  settlePrice = 0;
 end;
 if Time >= SettleTime and SettlePrice = 0 then SettlePrice = Close;
end;

{
upperk = KeltnerChannel(h,lenl,kl)data2;
lowerk = KeltnerChannel(l,lens,-ks)data2;
adxval = adx(adxlen)data2;
}
bounce = false;
if barstatus(2) = 2 then begin
 upperk = KeltnerChannel(h,lenl,kl)data2;
 lowerk = KeltnerChannel(l,lens,-ks)data2;
 adxval = adx(adxlen)data2;
 underK = c data2 < upperk;
 overK = c data2 > lowerk;
end;

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

//if time > 800 and time < 2300 then begin
if time > 800 and time < 2015 then begin

 if marketposition <> 0 then begin

  //StopLoss
  setstopshare;
  //if marketposition = 1 then value1 = entryprice - stoploss/bigpointvalue;
  //if marketposition = -1 then value1 = entryprice + stoploss/bigpointvalue;
  //if SettlementSafeStopOrder(value1,300,2015) then setstoploss(stoploss);
  if marketposition = 1 and stoploss > 0 then begin
   stopVal = entryprice - stoploss/bigpointvalue;
   if c <= stopVal then
    sell("xl.stop.m") next bar at market
   else if StopMin < StopVal and StopVal < StopMax then
    setstoploss(stoploss);
  end else
  if marketposition = -1 and stoploss > 0 then begin
   stopVal = entryprice + stoploss/bigpointvalue;
   if c >= stopVal then
    buytocover("xs.stop.m") next bar at market
   else if StopMin < StopVal and StopVal < StopMax then
    setstoploss(stoploss);
  end;

  //BreakEven
  //if maxposprof > brk/bigpointvalue then begin
  // if marketposition = 1 then begin
  //  sell("brkl") next bar at entryprice + 100/bigpointvalue stop;
  //  if SettlementSafeStopOrder(entryprice + (maxposprof - trsl/bigpointvalue),300,2015) then
  //   sell("trsl") next bar at entryprice + (maxposprof - trsl/bigpointvalue) stop;
  //  bounce = lowerk < entryprice + 100/bigpointvalue;
  //  if bounce = false then bounce = lowerk < entryprice + (maxposprof - trsl/bigpointvalue);
  // end;
  // if marketposition = -1 then begin
  //  buytocover("brks") next bar at entryprice - 100/bigpointvalue stop;
  //  if SettlementSafeStopOrder(entryprice - (maxposprof - trss/bigpointvalue),300,2015) then
  //   buytocover("trss") next bar at entryprice - (maxposprof - trss/bigpointvalue) stop;
  //  bounce = upperk > entryprice - 100/bigpointvalue;
  //  if bounce = false then bounce = upperk > entryprice - (maxposprof - trss/bigpointvalue);
  // end;
  //end;
  if marketposition = 1 and maxposprof > brk/bigpointvalue and brk > 0 then begin
   stopVal = entryprice + 100/bigpointvalue;
   if c <= stopVal then
    sell("xl.brk.m") next bar at market
   else if StopMin < StopVal and StopVal < StopMax then
    sell("xl.brk.s") next bar at stopVal stop;
   bounce = lowerk < entryprice + 100/bigpointvalue;
   if bounce = false then bounce = lowerk < entryprice + (maxposprof - trsl/bigpointvalue);
  end
  else
  if marketposition = -1 and maxposprof > brk/bigpointvalue and brk > 0 then begin
   stopVal = entryprice - 100/bigpointvalue;
   if c >= stopVal then
    buytocover("xs.brk.m") next bar at market
   else if StopMin < StopVal and StopVal < StopMax then
    buytocover("xs.brk.s") next bar at stopVal stop;
   bounce = upperk > entryprice - 100/bigpointvalue;
   if bounce = false then bounce = upperk > entryprice - (maxposprof - trss/bigpointvalue);
  end;
  //Trailing Stop
  if marketposition = 1 and maxposprof > brk/bigpointvalue and brk > 0 and trsl > 0 then begin
   stopVal = entryprice + (maxposprof - trsl/bigpointvalue);
   if c <= stopVal then
    sell("xl.trl.m") next bar at market
   else if StopMin < StopVal and StopVal < StopMax then
    sell("xl.trl.s") next bar at stopVal stop;
  end
  else
  if marketposition = -1 and maxposprof > brk/bigpointvalue and brk > 0 and trss > 0 then begin
   stopVal = entryprice - (maxposprof - trss/bigpointvalue);
   if c >= stopVal then
    buytocover("xs.trl.m") next bar at market
   else if StopMin < StopVal and StopVal < StopMax then
    buytocover("xs.trl.s") next bar at stopVal stop;
  end;

  //Uscita Modale
  //if currentcontracts = nos and nos > 1 then begin
  // if marketposition = 1 then sell("tl") nos/2 shares next bar at entryprice + targetl/bigpointvalue limit;
  // if marketposition = -1 then buytocover("ts") nos/2 shares next bar at entryprice - targets/bigpointvalue limit;
  //end;
  if currentcontracts = nos and nos > 1 then begin
   if marketposition = 1 and targetl > 0 then begin
    stopVal = entryprice + targetl/bigpointvalue;
    if c >= stopVal then
     sell("xl.mod1.m") nos/2 shares next bar at market
    else if StopMin < StopVal and StopVal < StopMax then
     sell("xl.mod1.s") nos/2 shares next bar at stopVal limit;
   end
   else
   if marketposition = -1 and targets > 0 then begin
    stopVal = entryprice - targets/bigpointvalue;
    if c <= stopVal then
     buytocover("xs.mod1.m") nos/2 shares next bar at market
    else if StopMin < StopVal and StopVal < StopMax then
     buytocover("xs.mod1.s") nos/2 shares next bar at stopVal limit;
   end;
  end;
  //if currentcontracts = nos/2 then begin
  // setprofittarget(targets+1000);
  //end;
  if currentcontracts = nos/2 then begin
   if marketposition = 1 and targets > 0 then begin
    stopVal = entryprice + (targets+1000+2*(commission + slippage))/bigpointvalue;
    if c >= stopVal then
     sell("xl.prof.m") nos/2 shares next bar at market
    else if StopMin < StopVal and StopVal < StopMax then
     setprofittarget(targets+1000);
   end
   else
   if marketposition = -1 and targets > 0 then begin
    stopVal = entryprice - (targets+1000-2*(commission + slippage))/bigpointvalue;
if Date = 1100621 then Print(StrNow, ": Day Low Limit = ", stopMin, ", stopVal = ", stopVal);
    if c <= stopVal then
     buytocover("xs.prof.m") nos/2 shares next bar at market
    else if StopMin < StopVal and StopVal < StopMax then
     setprofittarget(targets+1000);
   end;
  end;

 end;

 //Engine
 if adxval < adxlimit and bounce = false then begin
  //if marketposition < 1 and c data2 < upperk {and h > upperk} then
  //if marketposition < 1 and underK {and h > upperk} then
  // buy("long") nos shares next bar at upperk stop;
  //if marketposition > -1 and c data2 > lowerk {and l < lowerk} then
  //if marketposition > -1 and overK {and l < lowerk} then
  // sellshort("short") nos shares next bar at lowerk stop;
  if h > eltg then begin
   buy("el.m") nos shares next bar at market;
   eltg = 999999;
  end
  else begin
   eltg = 999999;
   if marketposition < 1 then
    if underK {and h > upperk} then
     if StopMin < upperk and upperk < stopMax then
      buy("el.s") nos shares next bar at upperk stop
     else
      eltg = upperk;
  end;
  if l < estg then begin
   sellshort("es.m") nos shares next bar at market;
   estg = 0;
  end
  else begin
   estg = 0;
   if marketposition > -1 then
    if overK {and l < lowerk} then
     if StopMin < lowerk and lowerk < StopMax then
      sellshort("es.s") nos shares next bar at lowerk stop
     else
      estg = lowerk;
  end;
 end

 else begin
  eltg = 999999;
  estg = 0;

 end;

end

else begin
 eltg = 999999;
 estg = 0;

end;
