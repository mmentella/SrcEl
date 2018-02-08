Inputs: nos(2),alphal(.143),flenl(14),rngpctl(.163),alphas(.172),flens(34),rngpcts(.908);
Inputs: stopl(1900),stops(2000),modl(1500),mods(1800),tl(5800),ts(7300),trsl(3400),trss(1800);

vars: trendl(0,data2),triggerl(0,data2),cyclel(0,data2),fishl(0,data2),trends(0,data2),triggers(0,data2),cycles(0,data2),fishs(0,data2);
vars: entrylong(0,data2),entryshort(0,data2),stopval(0),minstop(-1),maxstop(999999),mkt(true),stp(true),mcp(0),sod(900),eod(2200),mp(0),trade(true);

mp = currentcontracts*marketposition;

if d <> d[1] then trade = true;

if mp <> mp[1] then trade = false;

if barstatus(2) = 2 then begin

 MM.ITrend(medianprice data2,alphal,trendl,triggerl)data2;
 cyclel = MM.Cycle(medianprice data2,alphal)data2;
 fishl = MM.FisherTransform(cyclel,flenl,true)data2;
 
 MM.ITrend(medianprice data2,alphas,trends,triggers)data2;
 cycles = MM.Cycle(medianprice data2,alphas)data2;
 fishs = MM.FisherTransform(cycles,flens,true)data2;
 
 entrylong = c data2 - rngpctl*(h data2 - l data2);
 entryshort = c data2 + rngpcts*(h data2 - l data2);

end;

mcp = MM.MaxContractProfit;

if marketposition <> 0 and 800 < t and t < 2300 then begin
 
 setstopshare;
 
 if marketposition = 1 then begin
  
  //STOPLOSS
  setstoploss(stopl);
  
  //PROFIT TARGET
  setprofittarget(tl);
  
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
     
 end else begin
  
  //STOPLOSS
  setstoploss(stops);
  
  //PROFIT TARGET
  setprofittarget(ts);
  
  //MODAL EXIT
  stopval = entryprice - mods/bigpointvalue;
  stp     = currentcontracts = nos and c > stopval and stopval > minstop;
  mkt     = currentcontracts = nos and c <= stopval;
   
  if stp then buytocover("xs.modl") nos/2 shares next bar at stopval limit;
  if mkt then buytocover("xs.modl.m") nos/2 shares next bar at market;
  
  //TRAILING STOP
  stopval = entryprice - (mcp - trss/bigpointvalue);
  stp     = currentcontracts = nos/2 and maxstop > stopval and stopval > c;
  mkt     = currentcontracts = nos/2 and c >= stopval;
  
  if stp then buytocover("xs.trs") next bar at stopval stop;
  if mkt then buytocover("xs.trs.m") next bar at market;
  
 end;
 
end;

if sod < t and t < eod and trade then begin

 if fishl > fishl[1] and triggerl > trendl and marketposition < 1 then
  buy nos shares next bar at entrylong limit; 
 
 if fishs < fishs[1] and triggers < trends and marketposition > -1 then
  sellshort nos shares next bar at entryshort limit;

end;
