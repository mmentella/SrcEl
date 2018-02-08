
Inputs: NoS(2),LenL(34),KL(1),LenS(30),KS(4.7),ADXLen(12),ADXLimit(28);
Inputs: StopLoss(2300),TargetL(4000),TargetS(4000),BRK(1200),TRSL(3600),TRSS(2100);

Inputs: DailyMaxLoss(3900);
Inputs: DayLimit("6500"), SettleTime(1930);   // $6,500 = ~10% off of $7,500 daily limit


Vars: upperk(0,data2),lowerk(0,data2),adxval(0,data2);
Vars: el(true),es(true),bounce(true);

Vars: tradecost((commission + slippage) * 2);
Vars: eqTotal(0), eqYestClose(0), eqDay(0);
Vars: dayMaxLoss(0), dayTrade(true), dayIdxStopL(0), dayIdxStopS(0);
Vars: stopVal(0), stopMin(0), stopMax(999999), SettlePrice(0);   
Vars: dayMax(0), dayPerc(false);


if currentbar <= 1 then begin
 if DailyMaxLoss > 0 then
  dayMaxLoss = (DailyMaxLoss - .5 * tradecost * NoS) / BigPointValue;
 if DayLimit <> "" then
  if RightStr(DayLimit, 1) = "%" then begin
   dayMax = StrToNum(LeftStr(DayLimit, StrLen(DayLimit) - 1)); dayPerc = true; end
  else begin
   dayMax = StrToNum(DayLimit)/bigpointvalue; dayPerc = false; end;
end;


eqTotal = NetProfit + PositionProfit;
if date > date[1] then begin
 { Day Position }
 if DailyMaxLoss <> 0 then begin
  eqYestClose = eqTotal[1]; dayTrade = true;
 end;
 { max/min Stop Update }
 if dayMax > 0 then begin
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
end;
if Time >= SettleTime and SettlePrice = 0 then SettlePrice = Close;


{ Strategy Analisys }
if barstatus(2) = 2 then begin
 upperk = KeltnerChannel(h,lenl,kl)data2;
 lowerk = KeltnerChannel(l,lens,-ks)data2;
 adxval = adx(adxlen)data2;
end;

el = true;
es = true;
bounce = false;

if marketposition(1) = 1 then
 el = positionprofit(1) < targetl*nos or positionprofit(1) >= targetl*nos and d > exitdate(1);
if marketposition(1) = -1 then
 es = positionprofit(1) < targets*nos or positionprofit(1) >= targets*nos and d > exitdate(1);

if time > 800 and time < 2300 then begin

 if DailyMaxLoss > 0 then begin
  eqDay = eqTotal - eqYestClose;
  if eqDay < -DailyMaxLoss then dayTrade = false;
 end;

 if marketposition <> 0 then begin

  { Day Position }
  if DailyMaxLoss > 0 then begin
   if not dayTrade then begin
    if MarketPosition > 0 then Sell ("XL-DayAbort.m") next bar at Market;
    if MarketPosition < 0 then BuyToCover ("XS-DayAbort.m") next bar at Market;
   end
   else
    if MarketPosition > 0 then begin
     dayIdxStopL = Close - (eqDay / BigPointValue + dayMaxLoss) / CurrentContracts;
     Sell ("XL-DayStop.s") next bar at dayIdxStopL Stop;
    end else begin
     dayIdxStopS = Close + (eqDay / BigPointValue + dayMaxLoss) / CurrentContracts;
     BuyToCover ("XS-DayStop.s") next bar at dayIdxStopS Stop;
    end;
  end;

  if dayTrade then begin

   setstopshare;
   
   //StopLoss
   //setstoploss(stoploss);
   if marketposition = 1 and stoploss > 0 then begin
    stopVal = entryprice - (stoploss - tradecost * currentcontracts)/bigpointvalue;
    if c <= stopVal then
     sell("xl.stop.m") next bar at market
    else if StopMin < StopVal and StopVal < StopMax then
     setstoploss(stoploss);
   end else
   if marketposition = -1 and stoploss > 0 then begin
    stopVal = entryprice + (stoploss - tradecost * currentcontracts)/bigpointvalue;
    if c >= stopVal then
     buytocover("xs.stop.m") next bar at market
    else if StopMin < StopVal and StopVal < StopMax then
     setstoploss(stoploss);
   end;

   //Target
   if nos = 1 then begin
    if marketposition = 1 and targetl > 0 then begin
     stopVal = entryprice + targetl/bigpointvalue;
     if h >= stopVal then
      sell ("xl.prof.m") next bar at market
     else if StopMin < StopVal and StopVal < StopMax then
      setprofittarget(targetl);
    end;
    if marketposition = -1 and targets > 0 then begin
     stopVal = entryprice - targets/bigpointvalue;
     if l <= stopVal then
      buytocover ("xs.prof.m") next bar at market
     else if StopMin < StopVal and StopVal < StopMax then
      setprofittarget(targets);
    end;
   end;
   if nos > 1 and currentcontracts = nos/2 then begin
    if marketposition = 1 and targetl > 0 then begin
     stopVal = entryprice + (targetl + 1000 + tradecost * currentcontracts)/bigpointvalue;
     if h >= stopVal then
      sell ("xl.mod2.m") next bar at market
     else if StopMin < StopVal and StopVal < StopMax then
      setprofittarget(targetl+1000);
    end;
    if marketposition = -1 and targets > 0 then begin
     stopVal = entryprice - (targets + 1000 + tradecost * currentcontracts)/bigpointvalue;
     if l <= stopVal then
      buytocover ("xs.mod2.m") next bar at market
     else if StopMin < StopVal and StopVal < StopMax then
      setprofittarget(targets+1000);
    end;
   end;

   //BreakEven and Trailing Stop
   if brk > 0 and maxpositionprofit/nos > brk then begin
    if marketposition = 1 then begin
     //sell("brkl") next bar at entryprice + .02 stop;
     stopVal = entryprice + .02;
     if c <= stopVal then
      sell("xl.brk.m") next bar at market
     else if StopMin < StopVal and StopVal < StopMax then
      sell("xl.brk.s") next bar at stopVal stop;
     //sell("trsl") next bar at entryprice + (maxpositionprofit/nos - trsl)/bigpointvalue stop;
     if trsl > 0 then begin
      stopVal = entryprice + (maxpositionprofit/nos - trsl)/bigpointvalue;
      if c <= stopVal then
       sell("xl.trl.m") next bar at market
      else if StopMin < StopVal and StopVal < StopMax then
       sell("xl.trl.s") next bar at stopVal stop;
     end;
     bounce = lowerk < entryprice + .02;
     if bounce = false then
      bounce = lowerk < entryprice + (maxpositionprofit/nos - trsl)/bigpointvalue;
    end;
    if marketposition = -1 then begin
     //buytocover("brks") next bar at entryprice - .02 stop;
     stopVal = entryprice - .02;
     if c >= stopVal then
      buytocover("xs.brk.m") next bar at market
     else if StopMin < StopVal and StopVal < StopMax then
      buytocover("xs.brk.s") next bar at stopVal stop;
     //buytocover("trss") next bar at entryprice - (maxpositionprofit/nos - trss)/bigpointvalue stop;
     if trss > 0 then begin
      stopVal = entryprice - (maxpositionprofit/nos - trss)/bigpointvalue;
      if c >= stopVal then
       buytocover("xs.trl.m") next bar at market
      else if StopMin < StopVal and StopVal < StopMax then
       buytocover("xs.trl.s") next bar at stopVal stop;
     end;
     bounce = upperk > entryprice - .02;
     if bounce = false then bounce = upperk > entryprice - (maxpositionprofit/nos - trss)/bigpointvalue;
    end;
   end;

   //Trailing StopLoss
   if brk > 0 and stoploss > 0 and maxpositionprofit/nos > 0 and maxpositionprofit/nos < brk then begin
    if marketposition = 1 then begin
     //sell("xl") next bar at entryprice + (maxpositionprofit/nos - stoploss)/bigpointvalue stop;
     stopVal = entryprice + (maxpositionprofit/nos - stoploss)/bigpointvalue;
     if c <= stopVal then
      sell("xl.stbrk.m") next bar at market
     else if StopMin < stopVal and stopVal < StopMax then
      sell("xl.stbrk.s") next bar at stopVal stop;
     if bounce = false then bounce = lowerk < entryprice + (maxpositionprofit/nos - stoploss)/bigpointvalue;
    end;
    if marketposition = -1 then begin
     //buytocover("xs") next bar at entryprice - (maxpositionprofit/nos - stoploss)/bigpointvalue stop;
     stopVal = entryprice - (maxpositionprofit/nos - stoploss)/bigpointvalue;
     if c >= stopVal then
      buytocover("xs.stbrk.m") next bar at market
     else if StopMin < stopVal and stopVal < StopMax then
      buytocover("xs.stbrk.s") next bar at stopVal stop;
     if bounce = false then bounce = upperk > entryprice - (maxpositionprofit/nos - stoploss)/bigpointvalue;
    end;
   end;

   //Uscita Modale
   if currentcontracts = nos and nos > 1 then begin
    //if marketposition = 1 then begin
    // sell("tl") nos/2 shares next bar at entryprice + TargetL/bigpointvalue limit;
    //end;
    //if marketposition = -1 then begin
    // buytocover("ts") nos/2 shares next bar at entryprice - TargetS/bigpointvalue limit;
    //end;
    if marketposition = 1 and targetl > 0 then begin
     stopVal = entryprice + targetl/bigpointvalue;
     if h >= stopVal then
      sell("xl.mod1.m") nos/2 shares next bar at market
     else if StopMin < StopVal and StopVal < StopMax then
      sell("xl.mod1.s") nos/2 shares next bar at stopVal limit;
    end
    else
    if marketposition = -1 and targets > 0 then begin
     stopVal = entryprice - targets/bigpointvalue;
     if l <= stopVal then
      buytocover("xs.mod1.m") nos/2 shares next bar at market
     else if StopMin < StopVal and StopVal < StopMax then
      buytocover("xs.mod1.s") nos/2 shares next bar at stopVal limit;
    end;
   end;

  end; // of market
 end;  // position management

 if dayTrade then begin
  //Engine
  if adxval < adxlimit and bounce = false then begin
   if el and marketposition < 1 and h >= upperk then
    buy("el.m") nos shares next bar at market;
   if es and marketposition > -1 and l <= lowerk then
    sellshort("es.m") nos shares next bar at market;
  end;
 end;

end; // of daily operations
