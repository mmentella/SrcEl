
Inputs: NoS(2),LenL(16),KL(1),LenS(12),KS(1),ADXLen(15),ADXLimit(28),BarWait(21);
Inputs: StopLoss(1500),TargetL(4000),TargetS(4000),BRK(900),TRSL(2300),TRSS(2400);

Inputs: DailyMaxLoss(4000);
Inputs: DayLimit("9500"), SettleTime(2030);


Vars: upperk(0,data2),lowerk(0,data2),hs(0),ls(0),adxval(0,data2);
Vars: el(true),es(true),bounce(false),trade(true), barCounter(0), lastTime2(0), MP(0), runTrade(true);

Vars: tradecost((commission + slippage) * 2);
Vars: eqTotal(0), eqYestClose(0), eqDay(0);
Vars: dayMaxLoss(0), dayTrade(true), dayStop(0);
Vars: dayMax(0), dayPerc(false);
Vars: stopVal(0), stopMin(0.0), stopMax(999999.0), settlePrice(0.0);    { Points }


{ INIT }
if currentbar <= 1 then begin
 if DailyMaxLoss > 0 then
  dayMaxLoss = (DailyMaxLoss - .5 * tradecost * NoS) / BigPointValue;
 if DayLimit <> "" then
  if RightStr(DayLimit, 1) = "%" then begin
   dayMax = StrToNum(LeftStr(DayLimit, StrLen(DayLimit) - 1)); dayPerc = true; end
  else begin
   dayMax = StrToNum(DayLimit) / BigPointValue; dayPerc = false;
  end;
end;

{ Day Position }
eqTotal = NetProfit + PositionProfit;
if date > date[1] then begin
 if DailyMaxLoss <> 0 then begin
  eqYestClose = eqTotal[1]; dayTrade = true;
 end;
end;

{ Daily Limits }
if dayMax > 0 then begin
 if Date > Date[1] then begin
  if settlePrice = 0 then settlePrice = Close[1];
  if dayPerc then begin
   stopMax = settlePrice * (1 + dayMax);
   stopMin = settlePrice * (1 - dayMax);
  end else begin
   stopMax = settlePrice + dayMax;
   stopMin = settlePrice - dayMax;
  end;
  settlePrice = 0;
 end else
  if SettleTime > 0 then
   if Time >= SettleTime and settlePrice = 0 then settlePrice = Close;
end;


if barstatus(2) = 2 then begin
 upperk = KeltnerChannel(h data2,lenl,kl) data2;
 lowerk = KeltnerChannel(l data2,lens,-ks) data2;
 adxval = adx(adxlen) data2;
end;

trade = true;
if marketposition <> 0 then begin
 el = marketposition = -1;
 es = marketposition = 1;
end;
if marketposition = 0 then begin
 el = true;
 es = true;
end;
if marketposition(1) = 0 then begin
 el = true;
 es = true;
end;

//if marketposition(1) <> 0 and positionprofit(1) < 0 then trade = barssinceexit(1)/30 > barwait;
MP = marketposition;
if MP <> MP[1] then begin
	lastTime2 = time data2;
	barCounter = 0;
	runTrade = false;
end;
if time data2 <> lastTime2 then begin
	lastTime2 = time data2;
	barCounter = barCounter + 1;
	runTrade = true;
end;
if marketposition(1) <> 0 and positionprofit(1) < 0 then trade = barCounter > barwait;

bounce = false;

if time > 800 and time < 2300 then begin
 //Daily Equity
 if DailyMaxLoss > 0 then begin
  eqDay = eqTotal - eqYestClose;
  if eqDay < -DailyMaxLoss then dayTrade = false;
 end;
 if marketposition <> 0 then begin
  //Day Position Check
  if DailyMaxLoss > 0 then begin
   if not dayTrade then begin
    if MarketPosition > 0 then Sell ("XL-DayAbort.m") next bar at Market;
    if MarketPosition < 0 then BuyToCover ("XS-DayAbort.m") next bar at Market;
   end
   else
    if MarketPosition > 0 then begin
     dayStop = Close - (eqDay / BigPointValue + dayMaxLoss) / CurrentContracts;
     if c <= dayStop then Sell ("XL-DayStop.m") next bar at Market
     else Sell ("XL-DayStop.s") next bar at dayStop Stop;
    end else begin
     dayStop = Close + (eqDay / BigPointValue + dayMaxLoss) / CurrentContracts;
     if c >= dayStop then BuyToCover ("XS-DayStop.m") next bar at Market
     else BuyToCover ("XS-DayStop.s") next bar at dayStop Stop;
    end;
  end;
  //Uscite Statistiche
  if (Date > entrydate or Time data2 > entrytime) then begin
   if dayTrade then begin
    setstopshare;
    //StopLoss
    stopVal = entryprice - Sign(marketposition) * (stoploss - tradecost)/bigpointvalue;
    if marketposition = 1 then begin
     if c <= stopVal then Sell("xl-stop.m") next bar at Market
     else if stopMin < stopVal and stopVal < stopMax then setstoploss(stoploss);
    end else
    if marketposition = -1 then
     if c >= stopVal then BuyToCover("xs-stop.m") next bar at Market
     else if stopMin < stopVal and stopVal < stopMax then setstoploss(stoploss);
    //BreakEven
    if maxpositionprofit/nos > brk then begin
     if marketposition = 1 then begin
      stopVal = entryprice + 25 points;
      if c <= stopVal then Sell("brkl.m") next bar at Market
      else if stopMin < stopVal and stopVal < stopMax then sell("brkl.s") next bar at stopVal stop;      
      stopVal = entryprice + (maxpositionprofit/nos - trsl)/bigpointvalue;
      if c <= stopVal then Sell("trsl.m") next bar at Market
      else if stopMin < stopVal and stopVal < stopMax then sell("trsl.s") next bar at stopVal stop;      
      bounce = lowerk < entryprice + 25 points;
      if bounce = false then bounce = lowerk < entryprice + (maxpositionprofit/nos - trsl)/bigpointvalue;
     end;
     if marketposition = -1 then begin
      stopVal = entryprice - 25 points;
//if Date = 1090603 then
// Print(StrNow, "(new): BRK stop @ ", stopVal:1:4, ", Close = ", c:1:4, " (stop Min-Max: ", stopMin:1:4, "-", stopMax:1:4, ")");
      if c >= stopVal then buytocover("brks.m") next bar at Market
      else if stopMin < stopVal and stopVal < stopMax then buytocover("brks.s") next bar at stopVal stop;      
      stopVal = entryprice - (maxpositionprofit/nos - trss)/bigpointvalue;
      if c >= stopVal then buytocover("trss.m") next bar at Market
      else if stopMin < stopVal and stopVal < stopMax then buytocover("trss.s") next bar at stopVal stop;      
      bounce = upperk > entryprice - 25 points;
      if bounce = false then bounce = upperk > entryprice - (maxpositionprofit/nos - trss)/bigpointvalue;
     end;
    end;//BreakEven
    //Uscita Modale
    if currentcontracts = nos and nos > 1 then begin
     if marketposition = 1 then begin
      stopVal = entryprice + TargetL/bigpointvalue;
      if h >= stopVal then sell("tl.m") nos/2 shares next bar at market
      else if stopMin < stopVal and stopVal < stopMax then sell("tl.s") nos/2 shares next bar at stopVal limit;
     end;
     if marketposition = -1 then begin
      stopVal = entryprice - targets/bigpointvalue;
      if l <= stopVal then buytocover("ts.m") nos/2 shares next bar at market
      else if stopMin < stopVal and stopVal < stopMax then buytocover("ts.s") nos/2 shares next bar at stopVal limit;
     end;
    end;
   end;//Uscite Statistiche
   if bounce = false then begin
    if marketposition = 1 then bounce = lowerk < entryprice - stoploss/bigpointvalue;
    if marketposition = -1 then bounce = upperk > entryprice + stoploss/bigpointvalue;
   end;
  end;
 end;
 //Engine
 if dayTrade then
  if runTrade then
   if adxval < adxlimit and bounce = false and trade then begin
    if el and marketposition < 1 and c data2 <= upperk then
     if stopMin < upperk and upperk < stopMax then
      buy("long") nos shares next bar at upperk stop;
    if es and marketposition > -1 and c data2 >= lowerk then
     if stopMin < lowerk and lowerk < stopMax then
      sellshort("short") nos shares next bar at lowerk stop;
   end;

end;
