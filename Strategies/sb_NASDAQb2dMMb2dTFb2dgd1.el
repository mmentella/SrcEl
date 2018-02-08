Inputs: nos(2),alphal(.65),flenl(19),rngpctl(.179),alphas(.348),flens(6),rngpcts(.179),moneymanagement(true);
Inputs: stopl(1700),stopdl(2300),stops(1300),stopds(1600),brkl(1200),brks(1700),mods(2500),tl(1800),tdl(1200),ts(3300),tds(2300);
Inputs: OpenTime(0800), CloseTime(2212);
Inputs: DayLimit("4.5%"), SettleTime(2215);

vars: trendl(0,data2),trigl(0,data2),cycl(0,data2),fishl(0,data2),trends(0,data2),trigs(0,data2),cycs(0,data2),fishs(0,data2);
vars: entrylong(0,data2),entryshort(0,data2),stopval(0),stp(false),mkt(false),mcp(0),trade(true),mp(0),yc(0);
Vars: dayMax(0), dayPerc(false);
Vars: StopMin(0), StopMax(999999), SettlePrice(0);   

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
//if 1101029 <= date and date <= 1101101 then print(StrNow, ": settlePrice = ", settlePrice, ", limits = [", stopMin, " - ", StopMax, "]");
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

if moneymanagement and marketposition <> 0 then begin
  
 setstopshare;  
 
 if marketposition = 1 then begin
  
  //STOPLOSS
  stopval = entryprice - (stopl - (slippage+commission))/bigpointvalue;
  stp     = c > stopval and stopval > stopMin;
  mkt     = c <= stopval;
//if 1101029 <= date and date <= 1101101 and (stopval <= StopMin or stopval >= StopMax) then print(StrNow, ": StopLoss - stopval = ", stopval, ", limits = [", stopMin, " - ", StopMax, "]");
  
  if stp then setstoploss(stopl);
  if mkt then sell("xl.stpls") next bar at market;
  
  //STOPLOSS DAILY
  stopval = yc - stopdl/bigpointvalue;
  stp     = c > stopval and stopval > stopMin;
  mkt     = c <= stopval;
//if 1101029 <= date and date <= 1101101 and (stopval <= StopMin or stopval >= StopMax) then print(StrNow, ": StopDaily - stopval = ", stopval, ", limits = [", stopMin, " - ", StopMax, "]");
  
//  if d > entrydate then begin
   if stp then sell("xl.stpd") next bar at stopval stop;
   if mkt then sell("xl.stpd.m") next bar at market;
//  end;
  
  //PROFIT TARGET
  stopval = entryprice + (tl + (slippage+commission))/bigpointvalue;
  stp     = c < stopval and stopval < stopMax;
  mkt     = c >= stopval;
  
  if stp then setprofittarget(tl);
  if mkt then sell("xl.prftrgt") next bar at market;
  
  //PROFIT TARGET DAILY
  stopval = yc + tdl/bigpointvalue;
  stp     = c < stopval and stopval < stopMax;
  mkt     = c >= stopval;
  
  if d > entrydate then begin
   if stp then sell("xl.trgtd") next bar at stopval limit;
   if mkt then sell("xl.trgtd.m") next bar at market;
  end;
  
  //BREAKEVEN
  stopval = entryprice + 100/bigpointvalue;
  stp     = mcp > brkl/bigpointvalue and stopMin < stopval and stopval < c;
  mkt     = mcp > brkl/bigpointvalue and stopval >= c;
//if 1101029 <= date and date <= 1101101 and (stopval <= StopMin or stopval >= StopMax) then print(StrNow, ": BreakEven - stopval = ", stopval, ", limits = [", stopMin, " - ", StopMax, "]");
  
  if stp then sell("xl.brk") next bar at stopval stop;
  if mkt then sell("xl.brk.m") next bar at market;
  
 end else begin
  
  //STOPLOSS
  stopval = entryprice + (stops - (slippage+commission))/bigpointvalue;
  stp     = c < stopval and stopval < stopMax;
  mkt     = c >= stopval;
  
  if stp then setstoploss(stops);
  if mkt then buytocover("xs.stpls") next bar at market;
  
  //STOPLOSS DAILY
  stopval = yc + stopds/bigpointvalue;
  stp     = c < stopval and stopval < stopMax;
  mkt     = c >= stopval;
//if date = 1100510 then print(StrNow, ": stopval = ", stopval);
//  if d > entrydate then begin
// if mkt then buytocover("xs.stpd") next bar at stopval stop;
   if stp then buytocover("xs.stpd") next bar at stopval stop;
   if mkt then buytocover("xs.stpd.m") next bar at market;
//  end;
  
  //PROFIT TARGET
  stopval = entryprice - (ts + (slippage+commission))/bigpointvalue;
  stp     = c > stopval and stopval > stopMin;
  mkt     = c <= stopval;
  
  if stp then setprofittarget(ts);
  if mkt then buytocover("xs.prftrgt") next bar at market;
  
  //PROFIT TARGET DAILY
  stopval = yc - tds/bigpointvalue;
  stp     = c > stopval and stopval > stopMin;
  mkt     = c <= stopval;
  
  if d > entrydate then begin
   if stp then buytocover("xs.trgtd") next bar at stopval limit;
   if mkt then buytocover("xs.trgtd.m") next bar at market;
  end;
  
  //BREAKEVEN
  stopval = entryprice - 100/bigpointvalue;
  stp     = mcp > brks/bigpointvalue and stopMax > stopval and stopval > c;
  mkt     = mcp > brks/bigpointvalue and stopval <= c;
  
  if stp then buytocover("xs.brk") next bar at stopval stop;
  if mkt then buytocover("xs.brk.m") next bar at market;
  
  //MODAL EXIT
  stopval = entryprice - mods/bigpointvalue;
  stp     = currentcontracts = nos and c > stopval and stopval > stopMin;
  mkt     = currentcontracts = nos and c <= stopval;
  
  if stp then buytocover("xs.modl") nos/2 shares next bar at stopval limit;
  if mkt then buytocover("xs.modl.m") nos/2 shares next bar at market;
  
 end;

end;

if trade and marketposition < 1 and fishl > fishl[1] and trigl > trendl then begin
// if c > entrylong then buy("el") nos shares next bar at entrylong limit
// else buy("el.m") nos shares next bar at market;
 if c <= entrylong then buy("el.m") nos shares next bar at market
 else if entrylong > StopMin then buy("el") nos shares next bar at entrylong limit;
end;

if trade and marketposition > -1 and fishs < fishs[1] and trigs < trends then begin
// if c < entryshort then sellshort("es") nos shares next bar at entryshort limit
// else sellshort("es.m") next bar at market;
 if c >= entryshort then sellshort("es.m") next bar at market
 else if entryshort < StopMax then sellshort("es") nos shares next bar at entryshort limit;
end;

end; // of day operations
