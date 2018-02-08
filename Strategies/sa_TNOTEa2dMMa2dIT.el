Inputs: alphal(.16),flenl(27),rngpctl(.154),alphas(.13),flens(34),rngpcts(.718);
Inputs: stopl(100000),stops(100000),brkl(100000),brks(100000),tl(3600),ts(4200 ),trsl(100000),trss(100000);

vars: trendl(0),triggerl(0),cyclel(0),fishl(0),trends(0),triggers(0),cycles(0),fishs(0);
vars: stopval(0),minstop(-1),maxstop(999999),mkt(true),stp(true),mcp(0);

MM.ITrend(medianprice,alphal,trendl,triggerl);
cyclel = MM.Cycle(medianprice,alphal);
fishl = MM.FisherTransform(cyclel,flenl,true);

MM.ITrend(medianprice,alphas,trends,triggers);
cycles = MM.Cycle(medianprice,alphas);
fishs = MM.FisherTransform(cycles,flens,true);

mcp = MM.MaxContractProfit;

if marketposition <> 0 then begin
 
 setstopshare;
 
 if marketposition = 1 then begin
  
  //STOPLOSS
  setstoploss(stopl);
  
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

if fishl > fishl[1] and triggerl > trendl then
 buy next bar at c - rngpctl*range limit; 

if fishs < fishs[1] and triggers < trends then
 sellshort next bar at c + rngpcts*range limit;
