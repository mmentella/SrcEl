Inputs: nos(2),alphal(.65),flenl(19),rngpctl(.179),alphas(.348),flens(6),rngpcts(.179),moneymanagement(true);
Inputs: stopl(1700),stopdl(2300),brkl(1200),tl(1800),tdl(1200);

Inputs: OpenTime(0800), CloseTime(2212);
Inputs: DayLimit("4.5%"), SettleTime(2215);

vars: trendl(0,data2),trigl(0,data2),cycl(0,data2),fishl(0,data2),trends(0,data2),trigs(0,data2),cycs(0,data2),fishs(0,data2);
vars: entrylong(0,data2),entryshort(0,data2),stpv(0),stpw(0),stp(false),mkt(false),mcp(0),trade(true),mp(0),yc(0);
Vars: dayMax(0), dayPerc(false),bpv(1/bigpointvalue);
Vars: StopMin(0), StopMax(999999), SettlePrice(0);

vars: reason(0),position(0),stoploss(10),daystop(11),breakeven(12),target(20),daytarget(22),short1(true); 

{ INIT }
if currentbar <= 1 then begin
 if DayLimit <> "" then
  if RightStr(DayLimit, 1) = "%" then begin
   dayMax = StrToNum(LeftStr(DayLimit, StrLen(DayLimit) - 1)) / 100.0; dayPerc = true; end
  else begin
   dayMax = StrToNum(DayLimit) / BigPointValue; dayPerc = false;
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
 if High > stopMax then stopMax = High;
 if Low < stopMin then stopMin = Low;
end;

if d <> d[1] then begin trade = true; yc = c[1]; end;
mp = currentcontracts*marketposition;
if mp <> mp[1] then trade = false;

if barstatus(2) = 2 then begin
 MM.ITrend(medianprice,alphal,trendl,trigl)data2;
 cycl  = MM.Cycle(medianprice,alphal)data2;
 fishl = MM.FisherTransform(cycl,flenl,true)data2;
 
 MM.ITrend(medianprice,alphal,trends,trigs)data2;
 cycs  = MM.Cycle(medianprice,alphas)data2;
 fishs = MM.FisherTransform(cycs,flens,true)data2;
 
 entrylong  = c data2 - rngpctl*(h data2 - l data2);
 entryshort = c data2 + rngpcts*(h data2 - l data2);
end;

mcp = MM.MaxContractProfit;

if OpenTime <= Time and Time < CloseTime then begin // start of day operations

short1 = trade and marketposition = 1 and fishs < fishs[1] and trigs < trends and c < entryshort and entryshort < stopmax;

if moneymanagement and marketposition <> 0 then begin
  
 if marketposition = 1 then begin
  
  //STOPLOSS
  stpw   = entryprice - (stopl - (slippage+commission))/bigpointvalue;
  reason = stoploss;
  
  //STOPLOSS DAILY
  stpv = yc - stopdl/bigpointvalue;
  
  if d > entrydate and stpv > stpw then begin
   stpw   = stpv;
   reason = daystop;
  end;
  
  //BREAKEVEN
  stpv = entryprice + 20*MinMove points;
  
  if mcp > brkl*bpv and stpv > stpw then begin
   reason = breakeven;
   stpw   = stpv;
  end;
  
  stp = c >  stpw and stpw > StopMin;
  mkt = c <= stpw;
  
  if reason = stoploss then begin
   if stp then sell("xl.stp") next bar stpw stop
   else if mkt then sell("xl.stp.m") this bar c;
  end else
  if reason = daystop then begin
   if stp then sell("xl.funk") next bar stpw stop
   else if mkt then sell("xl.funk.m") this bar c;
  end else
  if reason = breakeven then begin
   if stp then sell("xl.brk") next bar stpw stop
   else if mkt then sell("xl.brk.m") this bar c;
  end;
  
  reason = position;
  stpw   = entryshort;
  
  //PROFIT TARGET
  stpv = entryprice + (tl + (slippage+commission))/bigpointvalue;
  
  if short1 then begin
   if stpv < stpw then begin
    stpw   = stpv;
    reason = target;
   end;
  end else begin
   stpw   = stpv;
   reason = target;
  end;
  
  //PROFIT TARGET DAILY
  stpv = yc + tdl*bpv;
  
  if d > entrydate and stpv < stpw then begin
   stpw   = stpv;
   reason = daytarget;
  end;
  
  if reason <> position then begin
   
   stp = c <  stpw and stpw < StopMax;
   mkt = c >= stpw;
   
   if reason = target then begin
    if stp then sell("xl.trgt") next bar stpw limit
    else if mkt then sell("xl.trgt.m") this bar c;
   end else
   if reason = daytarget then begin
    if stp then sell("xl.trgtd") next bar stpw limit
    else if mkt then sell("xl.trgtd.m") this bar c;
   end;
   
  end;
  
 end;

end;

if trade and marketposition < 1 and fishl > fishl[1] and trigl > trendl then begin
 if c <= entrylong then buy("el.m") nos shares next bar at market
 else if entrylong > StopMin then buy("el") nos shares next bar at entrylong limit;
end;

if trade and marketposition = 1 and fishs < fishs[1] and trigs < trends then begin
 if c >= entryshort then sell("es.m") next bar at market
 else if entryshort < StopMax then sell("es") nos shares next bar at entryshort limit;
end;

end; // of day operations
