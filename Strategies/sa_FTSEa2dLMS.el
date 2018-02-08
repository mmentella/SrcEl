Inputs: NoS(2),LenL(3),PreL(2),LenS(11),PreS(2);
Inputs: ATRLenL(11),ATRLenS(12),VolLen(28),mnymngmnt(1);

Inputs: stopl(100000),funkl(100000),brkl(900),modl(100000),tl(100000),tld(100000);
Inputs: stops(100000),funks(100000),brks(750),mods(100000),ts(100000);

Vars: LSSigH(0,data2),LSSigL(0,data2),ATRs(0,data2),ATRl(0,data2),VAR0(0,data2),VAR1(0,data2),el(true,data2),es(true,data2);
vars: trades(0),stopval(0),minstop(-1),maxstop(999999),stp(false),mkt(false),mcp(0),yc(0),dru(0),funk(true);

{******BASIC SETTINGS******}

if d <> d[1] then begin
 trades = 0;
 funk = false;
 yc = c[1];
end;

if barstatus(2) = 2 then begin
 LSSigH = lms(High,LenL,PreL,.25)data2;
 LSSigL = lms(Low,LenS,PreS,.25)data2;
 
 ATRl = AvgTrueRange(ATRLenL)data2;
 ATRs = AvgTrueRange(ATRLenS)data2;
 
 el = Range data2 < ATRl and Low data2 > LSSigH;
 es = Range data2 < ATRs and High data2 < LSSigL;
 
 VAR0 = VolatilityStdDev(VolLen)data2;
 VAR1 = Average(VAR0,VolLen)data2;
end;

{******MONEY MANAGEMENT******}
mcp = MM.MaxContractProfit;
dru = MM.DailyRunup;

if mnymngmnt = 1 and marketposition <> 0 then begin
  
 setstopshare;  
 
 if marketposition = 1 then begin
  
  //STOPLOSS
  stopval = entryprice - (stopl - (slippage+commission))/bigpointvalue;
  stp     = c > stopval and stopval > minstop;
  mkt     = c <= stopval;
  
  if stp then setstoploss(stopl);
  if mkt then sell("xl.stpls") next bar at market;
  
  //DAILY STOPLOSS  
  if not funk then funk = dru < -funkl;
  if funk then sell("xl.funk") this bar c;
  
  //PROFIT TARGET
  stopval = entryprice + (tl + (slippage+commission))/bigpointvalue;
  stp     = c < stopval and stopval < maxstop;
  mkt     = c >= stopval;
  
  if stp then setprofittarget(tl);
  if mkt then sell("xl.prftrgt") next bar at market;
  
  //DAILY PROFIT TARGET
  stopval = yc + tld/bigpointvalue;
  stp     = c < stopval and stopval < maxstop;
  mkt     = c >= stopval;
  
  if d > entrydate then begin
   if stp then sell("xl.trgtd") next bar at stopval limit;
   if mkt then sell("xl.trgtd.m") next bar at market;
  end;
  
  //BREAKEVEN
  stopval = entryprice + 100/bigpointvalue;
  stp     = mcp > brkl/bigpointvalue and minstop < stopval and stopval < c;
  mkt     = mcp > brkl/bigpointvalue and stopval >= c;
  
  if stp then sell("xl.brk") next bar at stopval stop;
  if mkt then sell("xl.brk.m") next bar at market;
  
  //MODAL EXIT
  stopval = entryprice + modl/bigpointvalue;
  stp     = currentcontracts = nos and c < stopval and stopval < maxstop;
  mkt     = currentcontracts = nos and c >= stopval;
  
  if stp then sell("xl.modl") nos/2 shares next bar at stopval limit;
  if mkt then sell("xl.modl.m") nos/2 shares next bar at market;
  
 end else begin
  
  //STOPLOSS
  stopval = entryprice + (stops - (slippage+commission))/bigpointvalue;
  stp     = c < stopval and stopval < maxstop;
  mkt     = c >= stopval;
  
  if stp then setstoploss(stops);
  if mkt then buytocover("xs.stpls") next bar at market;
  
  //DAILY STOPLOSS  
  if not funk then funk = dru < -funks;
  if funk then buytocover("xs.funk") this bar c;
  
  //PROFIT TARGET
  stopval = entryprice - (ts + (slippage+commission))/bigpointvalue;
  stp     = c > stopval and stopval > minstop;
  mkt     = c <= stopval;
  
  if stp then setprofittarget(ts);
  if mkt then buytocover("xs.prftrgt") next bar at market;
  
  //BREAKEVEN
  stopval = entryprice - 100/bigpointvalue;
  stp     = mcp > brks/bigpointvalue and maxstop > stopval and stopval > c;
  mkt     = mcp > brks/bigpointvalue and stopval <= c;
  
  if stp then buytocover("xs.brk") next bar at stopval stop;
  if mkt then buytocover("xs.brk.m") next bar at market;
  
  //MODAL EXIT
  stopval = entryprice - mods/bigpointvalue;
  stp     = currentcontracts = nos and c > stopval and stopval > minstop;
  mkt     = currentcontracts = nos and c <= stopval;
  
  if stp then buytocover("xs.modl") nos/2 shares next bar at stopval limit;
  if mkt then buytocover("xs.modl.m") nos/2 shares next bar at market;
  
 end;
  
end;

{******ENGINE******}

//condition1 = 1040614 < d and d < 1050818;
//if not condition1 then setexitonclose;

if not funk and trades < 2 and VAR0 > VAR1 then begin

 if marketposition < 1 and el then begin
  Buy("long") NoS shares next bar market;
  trades = trades + 1;
 end;
 
 if marketposition > -1 and es then begin
  sellshort("short") NoS shares next bar  market;
  trades = trades + 1;
 end;
 
end;
