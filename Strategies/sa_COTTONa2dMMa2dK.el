Inputs: NoS(2),LenL(8),KL(3),LenS(26),KS(3.7),ADXLen(14),ADXLimit(30),mnymngmnt(1);
Inputs: StopLoss(1500),modl(850),mods(300),tl(4600),ts(2300),BRK(1150),TRSL(2700),TRSS(1200);

Vars: upperk(0,data2),lowerk(0,data2),adxval(0,data2),el(true,data2),es(true,data2),engine(true,data2),trades(0),settlement(false);
Vars: mcp(0),bounce(false),daylimit(1500/bigpointvalue),minstop(0),maxstop(0),stopval(0),stp(false),mkt(false);

if d <> d[1] then begin
 settlement = false;
 trades = 0;
end;

if not settlement and t > 2015 then begin
 maxstop = c[1] + daylimit;
 minstop = c[1] - daylimit;
 settlement = true;
end;

if barstatus(2) = 2 then begin
 upperk = KeltnerChannel(h,lenl,kl)data2;
 lowerk = KeltnerChannel(l,lens,-ks)data2;
 
 el = c data2 < upperk;
 es = c data2 > lowerk;
 
 engine = 800 < t data2 and t data2 < 2030;
 
 adxval = adx(adxlen)data2;
end;
bounce = false;

mcp = MM.MaxContractProfit;
if marketposition <> 0 and barssinceentry = 0 then trades = trades + 1;

if mnymngmnt = 1 and time > 800 and time < 2026 then begin
 if marketposition <> 0 then begin
 
  setstopshare;
  
  //STOPLOSS
  if marketposition = 1 then begin
   stopval = entryprice - (StopLoss - (slippage+commission))/bigpointvalue;
   stp     = c > stopval and stopval > minstop;
   mkt     = c <= stopval;
   
   if stp then setstoploss(StopLoss);
   if mkt then sell("xl.stpls") next bar at market;
  end else if marketposition = -1 then begin
   stopval = entryprice + (StopLoss - (slippage+commission))/bigpointvalue;
   stp     = c < stopval and stopval < maxstop;
   mkt     = c >= stopval;
   
   if stp then setstoploss(StopLoss);
   if mkt then buytocover("xs.stpls") next bar at market;
  end;
  
  //BREAKEVEN
  if marketposition = 1 then begin
   stopval = entryprice + 100/bigpointvalue;
   stp     = mcp > brk/bigpointvalue and minstop < stopval and stopval < c;
   mkt     = mcp > brk/bigpointvalue and stopval >= c;
   
   if stp then sell("xl.brk") next bar at stopval stop;
   if mkt then sell("xl.brk.m") next bar at market;
  end else if marketposition = -1 then begin
   stopval = entryprice - 100/bigpointvalue;
   stp     = mcp > brk/bigpointvalue and maxstop > stopval and stopval > c;
   mkt     = mcp > brk/bigpointvalue and stopval <= c;
   
   if stp then buytocover("xs.brk") next bar at stopval stop;
   if mkt then buytocover("xs.brk.m") next bar at market;
  end;
  
  //TRAILING STOP
  if marketposition = 1 then begin
   stopval = entryprice + (mcp - trsl/bigpointvalue);
   stp     = currentcontracts = nos/2 and minstop < stopval and stopval < c;
   mkt     = currentcontracts = nos/2 and c <= stopval;
   
   if stp then sell("xl.trs") next bar at stopval stop;
   if mkt then sell("xl.trs.m") next bar at market;
  end else if marketposition = -1 then begin
   stopval = entryprice - (mcp - trss/bigpointvalue);
   stp     = currentcontracts = nos/2 and maxstop > stopval and stopval > c;
   mkt     = currentcontracts = nos/2 and c >= stopval;
   
   if stp then buytocover("xs.trs") next bar at stopval stop;
   if mkt then buytocover("xs.trs.m") next bar at market;
  end;
  
  //MODAL EXIT
  if marketposition = 1 then begin
   stopval = entryprice + modl/bigpointvalue;
   stp     = currentcontracts = nos and c < stopval and stopval < maxstop;
   mkt     = currentcontracts = nos and c >= stopval;
   
   if stp then sell("xl.modl") nos/2 shares next bar at stopval limit;
   if mkt then sell("xl.modl.m") nos/2 shares next bar at market;
  end else if marketposition = -1 then begin
   stopval = entryprice - mods/bigpointvalue;
   stp     = currentcontracts = nos and c > stopval and stopval > minstop;
   mkt     = currentcontracts = nos and c <= stopval;
   
   if stp then buytocover("xs.modl") nos/2 shares next bar at stopval limit;
   if mkt then buytocover("xs.modl.m") nos/2 shares next bar at market;
  end;
  
  if marketposition = 1 then begin
   stopval = entryprice + (tl + (slippage+commission))/bigpointvalue;
   stp     = c < stopval and stopval < maxstop;
   mkt     = c >= stopval;
   
   if stp then setprofittarget(tl);
   if mkt then sell("xl.prftrgt") next bar at market;
  end else if marketposition = -1 then begin
   stopval = entryprice - (ts + (slippage+commission))/bigpointvalue;
   stp     = c > stopval and stopval > minstop;
   mkt     = c <= stopval;
   
   if stp then setprofittarget(ts);
   if mkt then buytocover("xs.prftrgt") next bar at market;
  end;
  
 end;
 
end;

//Engine
if engine and adxval < adxlimit and trades < 1 then begin
 if marketposition < 1 and el and c < upperk then
  buy("el.s") nos shares next bar at upperk stop;
 if marketposition > -1 and es and c > lowerk then
  sellshort("es.s") nos shares next bar at lowerk stop;
end;
