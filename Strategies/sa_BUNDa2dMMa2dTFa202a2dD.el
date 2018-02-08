Inputs: nos(2),alphal(0.832),flenl(6),rngpctl(0.16),alphas(0.175),flens(9),rngpcts(.271);
Inputs: stopl(690),stops(1200),brkl(1000),brks(800),tl(3600),ts(2200),mnymngmnt(0);

vars: trendl(0,data2),triggerl(0,data2),cyclel(0,data2),fishl(0,data2),trends(0,data2),triggers(0,data2),cycles(0,data2),fishs(0,data2),engl(true,data2),engs(true,data2);
vars: entrylong(0,data2),entryshort(0,data2),stopval(0),minstop(-1),maxstop(999999),mkt(true),stp(true),mcp(0),trade(true),mp(0),yc(0);

if d <> d[1] then begin trade = true; yc = c[1]; end;
mp = currentcontracts*marketposition;
if mp <> mp[1] then trade = false;

if barstatus(2) = 2 then begin
 
 MM.ITrend(medianprice,alphal,trendl,triggerl)data2;
 cyclel = MM.Cycle(medianprice,alphal)data2;
 fishl  = MM.FisherTransform(cyclel,flenl,true)data2;
 
 MM.ITrend(medianprice,alphas,trends,triggers)data2;
 cycles = MM.Cycle(medianprice,alphas)data2;
 fishs  = MM.FisherTransform(cycles,flens,true)data2;
 
 engl = fishl > fishl[1] and triggerl > trendl;
 engs = fishs < fishs[1] and triggers < trends;
 
 entrylong  = c data2 - rngpctl*(h data2 - l data2);
 entryshort = c data2 + rngpcts*(h data2 - l data2);
 
end;

mcp = MM.MaxContractProfit;

if mnymngmnt = 1 and marketposition <> 0 then begin
 
 setstopshare;
 
 if marketposition = 1 then begin
  
  //STOPLOSS
  setstoploss(stopl);
  if d > entrydate then sell("xl.stpd") next bar at yc - 1150/bigpointvalue stop;
  
  //PROFIT TARGET
  setprofittarget(tl);
  
  //BREAKEVEN
  stopval = entryprice + 100/bigpointvalue;
  stp     = mcp > brkl/bigpointvalue and minstop < stopval and stopval < c;
  mkt     = mcp > brkl/bigpointvalue and stopval >= c;
   
  if stp then sell("xl.brk") next bar at stopval stop;
  if mkt then sell("xl.brk.m") next bar at market;
  
 end else begin
  
  //STOPLOSS
  setstoploss(stops);
  if d > entrydate then buytocover("xs.stpd") next bar at yc + 1150/bigpointvalue stop;
  
  //PROFIT TARGET
  setprofittarget(ts);
  
  //BREAKEVEN
  stopval = entryprice - 100/bigpointvalue;
  stp     = mcp > brks/bigpointvalue and maxstop > stopval and stopval > c;
  mkt     = mcp > brks/bigpointvalue and stopval <= c;
   
  if stp then buytocover("xs.brk") next bar at stopval stop;
  if mkt then buytocover("xs.brk.m") next bar at market;
  
 end;
 
end;

if trade and marketposition < 1 and engl then buy nos shares next bar at entrylong limit; 
if trade and marketposition > -1 and engs then sellshort nos shares next bar at entryshort limit;
