Inputs: nos(2),lenl(13),kl(2.93),lens(21),ks(4.75),adxlen(18),adxlimit(30),mnymngmnt(1);
Inputs: stopl(1700),stopdl(1800),modl(1400);
Inputs: stops(1800),stopds(300),mods(1500);

Vars: upk(0,data2),lok(0,data2),adxval(0,data2),el(true,data2),es(true,data2),engine(true,data2);
vars: trades(0),stopval(0),minstop(-1),maxstop(999999),stp(false),mkt(false),mcp(0),yc(0),mp(0);

if d <> d[1] then begin
 trades = 0;
 yc = c[1];
end;

if barstatus(2) = 2 then begin
 upk = KeltnerChannel(h,lenl,kl)data2;
 lok = KeltnerChannel(l,lens,-ks)data2;
 
 el = c data2 < upk;
 es = c data2 > lok;
 
 engine = 800 < t data2 and t data2 < 2300;
 
 adxval = ADX(adxlen)data2;
end;

mp = currentcontracts*marketposition;
if mp <> mp[1] then trades = trades + 1;

mcp = MM.MaxContractProfit;

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
  stopval = yc - stopdl/bigpointvalue;
  stp     = c > stopval and stopval > minstop;
  mkt     = c <= stopval;
  
  if d > entrydate then begin
   if stp then sell("xl.stpd") next bar at stopval stop;
   if mkt then sell("xl.stpd.m") next bar at market;
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
  stopval = yc + stopds/bigpointvalue;
  stp     = c < stopval and stopval < maxstop;
  mkt     = c >= stopval;
  
  if d > entrydate then begin
   if stp then buytocover("xs.stpd") next bar at stopval stop;
   if mkt then buytocover("xs.stpd.m") next bar at market;
  end;
  
  //MODAL EXIT
  stopval = entryprice - mods/bigpointvalue;
  stp     = currentcontracts = nos and c > stopval and stopval > minstop;
  mkt     = currentcontracts = nos and c <= stopval;
  
  if stp then buytocover("xs.modl") nos/2 shares next bar at stopval limit;
  if mkt then buytocover("xs.modl.m") nos/2 shares next bar at market;
  
 end;
  
end;

//ENGINE
if trades < 1 and engine and adxval < adxlimit then begin
 if marketposition < 1 and el and c < upk then 
  buy nos shares next bar at upk stop;
 if marketposition > -1 and es and c > lok then
  sellshort nos shares next bar at lok stop;
end;
