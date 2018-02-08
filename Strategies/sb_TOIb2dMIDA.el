Inputs: nos(2),alphal(.2),flenl(4),pctrngl(.164);
Inputs: stopl(2950),stopdl(2300),brkl(750),modl(8500),tl(11200),tld(2700),trsl(5500),trslbr(1700),minmcp(10000);

vars: trendl(0,data2),trigl(0,data2),cycl(0,data2),fishl(0,data2);
vars: entrylong(0,data2),stopval(0),minstop(99999),maxstop(0),stp(true),mkt(true),mcp(0),yc(0),mp(0),trade(true);

if d <> d[1] then begin yc = c[1]; trade = true; end;
mp = currentcontracts*marketposition;
if mp <> mp[1] then trade = false;

if barstatus(1) = 2 then begin
 MM.ITrend(medianprice,alphal,trendl,trigl)data2;
 cycl  = MM.Cycle(medianprice,alphal)data2;
 fishl = MM.FisherTransform(cycl,flenl,true)data2;

 entrylong = c data2 - pctrngl*(h data2 - l data2);
end;

mcp = MM.MaxContractProfit;

if marketposition <> 0 then begin
  
 setstopshare;  
 
 if marketposition = 1 then begin
  
  //STOPLOSS
  stopval = entryprice - (stopl - (slippage+commission))/bigpointvalue;
  stp     = c > stopval and stopval > minstop;
  mkt     = c <= stopval;
  
  if stp then setstoploss(stopl);
  if mkt then sell("xl.stpls") next bar at market;
  
  //DAILY STOPLOSS
  stopval = yc - stopdl/bigpointvalue;
  stp     = c > stopval and stopval > minstop;
  mkt     = c <= stopval;
  
  if d > entrydate then begin
   if stp then sell("xl.stpd") next bar at stopval stop;
   if mkt then sell("xl.stpd.m") next bar at market;
  end;
  
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
   if stp then sell("xl.trgtd") next bar at stopval stop;
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
  
  //TRAILING STOP
  stopval = entryprice + (mcp - trsl/bigpointvalue);
  stp     = currentcontracts = nos/2 and minstop < stopval and stopval < c;
  mkt     = currentcontracts = nos/2 and c <= stopval;
  
  if stp then sell("xl.trs") next bar at stopval stop;
  if mkt then sell("xl.trs.m") next bar at market;
  
  //ALGEBRIC TRAILING STOP
  stopval = entryprice + (mcp - trslbr/bigpointvalue);
  stp     = mcp > minmcp/bigpointvalue and minstop < stopval and stopval < c;
  mkt     = mcp > minmcp/bigpointvalue and c <= stopval;
  
  if stp then sell("xl.trsbr") next bar at stopval stop;
  if mkt then sell("xl.trsbr.m") next bar at market;
  
 end;

end;

//ENGINE
if trade and marketposition < 1 and trigl > trendl and fishl > fishl[1] then
 buy("el") nos shares next bar at entrylong limit;
