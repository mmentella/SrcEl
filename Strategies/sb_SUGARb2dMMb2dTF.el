Inputs: nos(2),alphal(.013),flenl(11),rngpctl(.148),alphas(.685),flens(21),rngpcts(.15),mnymngmnt(1);
Inputs: stopl(1100),funkl(750 ),brkl(800 ),modl(1200),tl(5400);
Inputs: stops(1100),funks(1150),brks(1200),mods(1050),ts(2700);

vars: trendl(0,data2),trigl(0,data2),cycl(0,data2),fishl(0,data2),trends(0,data2),trigs(0,data2),cycs(0,data2),fishs(0,data2),el(true,data2),es(true,data2);
vars: entrylong(0,data2),entryshort(0,data2),stopval(0),minstop(-1),maxstop(999999),stp(false),mkt(false),mcp(0),trade(true),mp(0),yc(0),funk(true),dru(0);

if d <> d[1] then begin
 trade = true; 
 yc = c[1];
 funk = false;
end;
mp = currentcontracts*marketposition;
if mp <> mp[1] then trade = false;

if barstatus(2) = 2 then begin
 MM.ITrend(medianprice,alphal,trendl,trigl)data2;
 cycl  = MM.Cycle(medianprice,alphal)data2;
 fishl = MM.FisherTransform(cycl,flenl,true)data2;
 
 MM.ITrend(medianprice,alphal,trends,trigs)data2;
 cycs  = MM.Cycle(medianprice,alphas)data2;
 fishs = MM.FisherTransform(cycs,flens,true)data2;
 
 el = fishl > fishl[1] and trigl > trendl;
 es = fishs < fishs[1] and trigs < trends;
 
 entrylong  = c data2 - rngpctl*(h data2 - l data2);
 entryshort = c data2 + rngpcts*(h data2 - l data2);
end;

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
  if not funk then funk = dru < -funkl*currentcontracts;
  if funk and barssinceentry > 0 then sell("xl.funk") this bar c;
  
  //PROFIT TARGET
  stopval = entryprice + (tl + (slippage+commission))/bigpointvalue;
  stp     = c < stopval and stopval < maxstop;
  mkt     = c >= stopval;
  
  if stp then setprofittarget(tl);
  if mkt then sell("xl.prftrgt") next bar at market;
  
  //BREAKEVEN
  stopval = entryprice + 100/bigpointvalue;
  stp     = mcp > brkl/bigpointvalue and minstop < stopval and stopval < c;
  mkt     = mcp > brkl/bigpointvalue and stopval >= c;
  
  if stp then sell("xl.brk") next bar at stopval stop;
  if mkt then sell("xl.brk.m") next bar at market;
  
  //MODAL EXIT
  stopval = entryprice + modl/bigpointvalue;
  stp     = nos > 1 and currentcontracts = nos and c < stopval and stopval < maxstop;
  mkt     = nos > 1 and currentcontracts = nos and c >= stopval;
  
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
  if not funk then funk = dru < -funks*currentcontracts;
  if funk and barssinceentry > 0 then buytocover("xs.funk") this bar c;
  
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
  stp     = nos > 1 and currentcontracts = nos and c > stopval and stopval > minstop;
  mkt     = nos > 1 and currentcontracts = nos and c <= stopval;
  
  if stp then buytocover("xs.modl") nos/2 shares next bar at stopval limit;
  if mkt then buytocover("xs.modl.m") nos/2 shares next bar at market;
  
 end;
  
end;

if not funk then begin
 if marketposition < 1 and el and c > entrylong then
  buy nos shares next bar at entrylong limit; 
 if marketposition > -1 and es and c < entryshort then
  sellshort nos shares next bar at entryshort limit;
end;
