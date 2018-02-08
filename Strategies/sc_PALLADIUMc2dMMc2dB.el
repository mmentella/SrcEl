inputs: nos(1),lenl(47),kl(2.0),lens(25),ks(4.81),mnymngmnt(1);
Inputs: stopl(1625),funkl(100000),modl(100000),tl(100000),tld(100000);
Inputs: stops(2150),funks(100000),mods(100000),ts(100000),tsd(100000);

vars: upb(0,data2),lob(0,data2),el(true,data2),es(true,data2),engine(true,data2);
vars: stopval(0),minstop(-1),maxstop(999999),stp(false),mkt(false),mcp(0),yc(0),trades(0),dru(0),funk(false);

if d <> d[1] then begin
 yc = c[1];
 trades = 0;
 funk = false;
end;

if barstatus(2) = 2 then begin
 upb = BollingerBand(h,lenl,kl)data2;
 lob = BollingerBand(l,lens,-ks)data2;
 
 el = c data2 < upb;
 es = c data2 > lob;
 
 engine = 800 < t data2 and t data2 < 2300;
end;

if marketposition <> 0 and barssinceentry = 0 then trades = trades + 1;

mcp = MM.MaxContractProfit;
dru = MM.DailyRunup;

if mnymngmnt = 1 and 800 < t and t < 2250 and marketposition <> 0 then begin
  
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
  
  //DAILY PROFIT TARGET
  stopval = yc - tsd/bigpointvalue;
  stp     = c > stopval and stopval > minstop;
  mkt     = c <= stopval;
  
  if d > entrydate then begin
   if stp then buytocover("xs.trgtd") next bar at stopval limit;
   if mkt then buytocover("xs.trgtd.m") next bar at market;
  end;
  
  //MODAL EXIT
  stopval = entryprice - mods/bigpointvalue;
  stp     = currentcontracts = nos and c > stopval and stopval > minstop;
  mkt     = currentcontracts = nos and c <= stopval;
  
  if stp then buytocover("xs.modl") nos/2 shares next bar at stopval limit;
  if mkt then buytocover("xs.modl.m") nos/2 shares next bar at market;
  
 end;
  
end;

if not funk and trades < 1 and engine then begin
 if marketposition < 1 and el and c < upb then
  buy("el") nos shares next bar at upb stop;
 if marketposition > -1 and es and c > lob then
  sellshort("es") nos shares next bar at lob stop;
end;
