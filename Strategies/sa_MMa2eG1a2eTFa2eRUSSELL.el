{
 Strumento    : miini Russell 2000
 Time Frame   : 15h con sessione 8-23 nominata "romana"
 Vettore      : 60 min con sessione 8-23 nominata "romana"
              
 Data Consegna: 03/08/2010
}

Inputs: nos(2),alphtl(.583),alphcl(.502),rngpctl(.739),alphts(.097),alphcs(.343),rngpcts(.452),mnymngmnt(1);
Inputs: stopl(2000),stopdl(1800),modl(2750),tl(5400),trsl(3500);
Inputs: stops(2500),stopds(2550),mods(2300),ts(8600),trss(3750);
Inputs: stopperc(.1);

vars: trendl(0,data2),triggerl(0,data2),cyclel(0,data2),trends(0,data2),triggers(0,data2),cycles(0,data2),el(true,data2),es(true,data2);
vars: entrylong(0,data2),entryshort(0,data2),stopval(0),minstop(-1),maxstop(999999),mkt(true),stp(true),mcp(0),trade(true),yc(0),mp(0);

if d <> d[1] then begin 
 yc = c[1]; 
 trade = true;
 if stopperc <> 0 and Month(d) <> Month(d[1]) then begin
  maxstop = yc*(1+stopperc);
  minstop = yc*(1-stopperc);
 end; 
end;

mp = currentcontracts*marketposition;
if mp <> mp[1] then trade = false;

if barstatus(2) = 2 then begin
 
 MM.ITrend(medianprice,alphtl,trendl,triggerl)data2;
 cyclel = MM.Cycle(medianprice,alphcl)data2;
 
 MM.ITrend(medianprice,alphts,trends,triggers)data2;
 cycles = MM.Cycle(medianprice,alphcs)data2;
 
 el = triggerl > trendl and cyclel > cyclel[1];
 es = triggers > trends and cycles > cycles[1];
 
 entrylong = c data2 - rngpctl*(h data2 - l data2);
 entryshort = c data2 + rngpcts*(h data2 - l data2);
 
end;

mcp = MM.MaxContractProfit;

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
  stopval = entryprice + (stops - (slippage+commission))/bigpointvalue;
  stp     = c < stopval and stopval < maxstop;
  mkt     = c >= stopval;
  
  if stp then setstoploss(stops);
  if mkt then buytocover("xs.stpls") next bar at market;
  
  //DAILY STOPLOSS
  stopval = yc + stopds/bigpointvalue;
  stp     = c < stopval and stopval < maxstop;
  mkt     = c >= stopval;
  
  if d > entrydate then begin
   if stp then buytocover("xs.stpd") next bar at stopval stop;
   if mkt then buytocover("xs.stpd.m") next bar at market;
  end;
  
  //PROFIT TARGET
  stopval = entryprice - (ts + (slippage+commission))/bigpointvalue;
  stp     = c > stopval and stopval > minstop;
  mkt     = c <= stopval;
  
  if stp then setprofittarget(ts);
  if mkt then buytocover("xs.prftrgt") next bar at market;
  
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

if trade then begin
 if marketposition < 1 and el then buy nos shares next bar at entrylong limit; 
 if marketposition > -1 and es then sellshort nos shares next bar at entryshort limit;
end;
