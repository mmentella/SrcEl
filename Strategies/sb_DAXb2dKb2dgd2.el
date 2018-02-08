
Inputs: NoS(2),LenL(5),KL(2),LenS(17),KS(2);
Inputs: ADXLen(16),ADXLimit(25);

Inputs: BRKL(1600),BRKS(600),TL(2200),TS(2000),TRSL(3400),TRSS(3100),XL(500),XS(700);

Inputs: DayLimit("0"), SettleTime(1700);
Inputs: DayMaxEntries(1), DailyMaxLoss(2500), DailyRestart(true);


Vars: upperk(0,data2),lowerk(0,data2),adxval(0,data2),T2(0,data2);
Vars: mpp(0),mp(0),trade(true),T1(0);

Vars: underK(false,data2),overK(false,data2);
Vars: eltg(999999),estg(0);

Vars: stopVal(0), stopMin(0), stopMax(999999), SettlePrice(0);   
Vars: lastEntry(0), dayEntries(0);
Vars: dayMax(0), dayPerc(false);
Vars: dayMaxLoss(DailyMaxLoss/BigPointValue), dayTrade(true), dayIdxStop(0);
Vars: eqTotal(0), eqYestClose(0), eqDay(0), dayPos(0), newDay(false);


if currentbar <= 1 then begin
 if DayLimit <> "" then
  if RightStr(DayLimit, 1) = "%" then begin
   dayMax = StrToNum(LeftStr(DayLimit, StrLen(DayLimit) - 1)) / 100.0; dayPerc = true; end
  else begin
   dayMax = StrToNum(DayLimit)/bigpointvalue; dayPerc = false; end;
end;


{ max/min Stop Update }
if dayMax > 0 then begin
 if Date > Date[1] then begin
  if SettleTime = 0 then SettlePrice = Close[1];
  if dayPerc then begin
   stopMin = SettlePrice*(1-dayMax);
   stopMax = SettlePrice*(1+dayMax);
  end else begin
   stopMin = SettlePrice-dayMax;
   stopMax = SettlePrice+dayMax;
  end;
  settlePrice = 0;
 end;
 if Time >= SettleTime and SettlePrice = 0 then SettlePrice = Close;
 if High > stopMax then stopMax = High;
 if Low < stopMin then stopMin = Low;
end;

{ Day Position }
eqTotal = NetProfit + PositionProfit;
if Date > Date[1] then begin
 if EntryPrice = 0 or lastEntry = EntryPrice then
  dayEntries = 0
 else
  dayEntries = 1;
 lastEntry = EntryPrice;
 if DailyMaxLoss <> 0 then begin
  eqYestClose = eqTotal[1]; newDay = true; end;
end;
if EntryPrice > 0 and EntryPrice <> lastEntry then begin
 dayEntries = dayEntries + 1; lastEntry = EntryPrice; end;

{ Market Position - Current }
mp = currentcontracts*marketposition;
if mp <> mp[1] then trade = false;

{ Engine Computation }
if not dayTrade then begin
 if adxval < adxlimit and trade then begin
  if underK and c[1] < upperk then
   if h >= upperk then dayPos = NoS;
  if overK and c[1] > lowerk then
   if l <= lowerk then dayPos = -NoS;
 end;
end;
if barstatus(2) = 2 then begin
 //trade = true;
 T2 = Time data2;
 upperk = KeltnerChannel(h,lenl,kl)data2;
 lowerk = KeltnerChannel(l,lens,-ks)data2;
 adxval = adx(adxlen)data2;
 underK = c data2 < upperk;
 overK = c data2 > lowerk;
end;
if T1 <> T2 then begin T1 = T2; trade = true; end;

{ MAX CONTRACT PROFIT }
if marketposition <> 0 then begin
 if barssinceentry = 0 then begin
  if marketposition = 1 then mpp = h - entryprice;
  if marketposition = -1 then mpp = entryprice - l;
 end else begin
  if marketposition = 1 then mpp = maxlist(mpp,h-entryprice);
  if marketposition = -1 then mpp = maxlist(mpp,entryprice-l);
 end;
end;

{ Open Hours }
if Sess1StartTime <= t and t < Sess1EndTime then begin

 { Day Position Check }
 if DailyMaxLoss > 0 then begin
  eqDay = eqTotal - eqYestClose;
  if newDay then begin
   newDay = false; dayIdxStop = 0;
   if not dayTrade then begin
    dayTrade = true;
    if DailyRestart then
     if dayPos > 0 then begin
      Buy ("EL-Restart.m") dayPos shares next bar at Market;
      dayEntries = dayEntries - 1; end
     else
     if dayPos < 0 then begin
      SellShort ("ES-Restart.m") -dayPos shares next bar at Market;
      dayEntries = dayEntries - 1; end;
   end;
  end;
  if dayTrade then begin
   if eqDay <= -DailyMaxLoss then
    dayTrade = false
   else
    dayPos = Sign(MarketPosition) * CurrentContracts;
  end;
  dayIdxStop = 0;
  if MarketPosition <> 0 then begin
   if dayTrade then begin
    if MarketPosition > 0 then begin
     dayIdxStop = Close - (eqDay / BigPointValue + dayMaxLoss) / CurrentContracts;
     if c <= dayIdxStop then Sell ("XL-DayStop.m") next bar at Market
     else Sell ("XL-DayStop.s") next bar at dayIdxStop Stop;
    end else begin
     dayIdxStop = Close + (eqDay / BigPointValue + dayMaxLoss) / CurrentContracts;
     if c >= dayIdxStop then BuyToCover ("XS-DayStop.m") next bar at Market
     else BuyToCover ("XS-DayStop.s") next bar at dayIdxStop Stop;
    end;
   end
   else begin
    if MarketPosition > 0 then begin
     dayPos = CurrentContracts;
     Sell ("XL-DayAbort.m") next bar at Market;
    end
    else begin
     dayPos = -CurrentContracts;
     BuyToCover ("XS-DayAbort.m") next bar at Market;
    end;
   end;
  end;
 end;

 if marketposition <> 0 then begin

  //STOPLOSS
  setstopshare;
  //if marketposition = 1 then sell("xl") next bar at entryprice - xl/bigpointvalue stop;
  //if marketposition = -1 then buytocover("xs") next bar at entryprice + xs/bigpointvalue stop;
  if marketposition = 1 and xl > 0 then begin
   stopVal = entryprice - xl/bigpointvalue;
   if c <= stopVal then 
    sell("xl.stop.m") next bar at market
   else if StopMin < StopVal and StopVal < StopMax then
    //setstoploss(xl);
    sell("xl.stop.s") next bar at StopVal stop;
  end else
  if marketposition = -1 and xs > 0 then begin
   stopVal = entryprice + xs/bigpointvalue;
   if c >= stopVal then
    buytocover("xs.stop.m") next bar at market
   else if StopMin < StopVal and StopVal < StopMax then
    //setstoploss(xs);
    buytocover("xs.stop.s") next bar at StopVal stop;
  end;

  //BREAKEVEN
  //if mpp > brkl/bigpointvalue and marketposition = 1 then
  // sell("brkl") next bar at entryprice + 100/bigpointvalue stop;
  //if mpp > brks/bigpointvalue and marketposition = -1 then
  // buytocover("brks") next bar at entryprice - 100/bigpointvalue stop;
  if marketposition = 1 and mpp > brkl/bigpointvalue and brkl > 0 then begin
   stopVal = entryprice + 100/bigpointvalue;
   if c <= stopVal then
    sell("xl.brk.m") next bar at market
   else if StopMin < StopVal and StopVal < StopMax then
    sell("xl.brk.s") next bar at stopVal stop;
  end
  else
  if marketposition = -1 and mpp > brks/bigpointvalue and brks > 0 then begin
   stopVal = entryprice - 100/bigpointvalue;
   if c >= stopVal then
    buytocover("xs.brk.m") next bar at market
   else if StopMin < StopVal and StopVal < StopMax then
    buytocover("xs.brk.s") next bar at stopVal stop;
  end;

  //MODAL EXIT
  //if currentcontracts = nos and nos > 1 then begin
  // if marketposition = 1 then sell("tl") nos/2 shares next bar at entryprice + tl/bigpointvalue limit;
  // if marketposition = -1 then buytocover("ts") nos/2 shares next bar at entryprice - ts/bigpointvalue limit;
  //end;
  if currentcontracts = nos and nos > 1 then begin
   if marketposition = 1 and tl > 0 then begin
    stopVal = entryprice + tl/bigpointvalue;
    if h >= stopVal then
     sell("xl.mod1.m") nos/2 shares next bar at market
    else if StopMin < StopVal and StopVal < StopMax then
     sell("xl.mod1.s") nos/2 shares next bar at stopVal limit;
   end
   else
   if marketposition = -1 and ts > 0 then begin
    stopVal = entryprice - ts/bigpointvalue;
    if l <= stopVal then
     buytocover("xs.mod1.m") nos/2 shares next bar at market
    else if StopMin < StopVal and StopVal < StopMax then
     buytocover("xs.mod1.s") nos/2 shares next bar at stopVal limit;
   end;
  end;

  //TRAILING STOP
  //if marketposition = 1 then sell("trsl") next bar at entryprice + (mpp - trsl/bigpointvalue) stop;
  //if marketposition = -1 then buytocover("trss") next bar at entryprice - (mpp - trss/bigpointvalue) stop;
  if marketposition = 1 and trsl > 0 then begin
   stopVal = entryprice + (mpp - trsl/bigpointvalue);
   if c <= stopVal then
    sell("xl.trl.m") next bar at market
   else if StopMin < StopVal and StopVal < StopMax then
    sell("xl.trl.s") next bar at stopVal stop;
  end
  else
  if marketposition = -1 and trss > 0 then begin
   stopVal = entryprice - (mpp - trss/bigpointvalue);
   if c >= stopVal then
    buytocover("xs.trl.m") next bar at market
   else if StopMin < StopVal and StopVal < StopMax then
    buytocover("xs.trl.s") next bar at stopVal stop;
  end;

 end;

 //ENGINE
 if dayTrade and adxval < adxlimit and trade then begin
  //if marketposition < 1 and c data2 < upperk and c < upperk then 
  // buy nos shares next bar at upperk stop;
  if marketposition < 1 then
   if h > eltg then begin
    if dayEntries < DayMaxEntries then
     buy("el.m") nos shares next bar at market
    else
     buytocover("xs.m") nos shares next bar at market;
    eltg = 999999;
   end
   else begin
    eltg = 999999;
    if underK and c < upperk then
     if StopMin < upperk and upperk < stopMax then begin
      if dayEntries < DayMaxEntries then
       buy("el.s") nos shares next bar at upperk stop
      else
       buytocover("xs.s") nos shares next bar at upperk stop;
     end else
      eltg = upperk;
   end;
  //if marketposition > -1 and c data2 > lowerk and c > lowerk then
  // sellshort nos shares next bar at lowerk stop;
  if marketposition > -1 then
//if date=1100520 then print(StrNow, ": estg = ", estg, ", l = ", l, ", dayEntries = ", dayEntries:1:0);
   if l < estg then begin
    if dayEntries < DayMaxEntries then
     sellshort("es.m") nos shares next bar at market
    else
     sell("xl.m") nos shares next bar at market;
    estg = 0;
   end
   else begin
    estg = 0;
    if overK and c > lowerk then
     if StopMin < lowerk and lowerk < StopMax then begin
      if dayEntries < DayMaxEntries then
       sellshort("es.s") nos shares next bar at lowerk stop
      else
       sell("xl.s") nos shares next bar lowerk stop;
     end else
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
