Inputs: nos(2),lenl(59),kl(3.68),lens(66),ks(3.27),adxlen(14),adxlimit(31),mnymngmnt(1);
Inputs: stopl(1400),funkl(3100),tl(2050);
Inputs: stops(1750),funks(3100),ts(1250);

vars: upk(0,data2),lok(0,data2),adxval(0,data2),el(true,data2),es(true,data2);
vars: stopval(0),minstop(-1),maxstop(999999),stp(false),mkt(false),mcp(0),yc(0),mp(0),funk(false),dru(0),trades(0);

if d <> d[1] then begin
 trades = 0;
 yc = c[1];
 funk = false;
end;

if barstatus(2) = 2 then begin
 upk = KeltnerChannel(h,lenl,kl)data2;
 lok = KeltnerChannel(l,lens,-ks)data2;
 
 el = c data2 < upk;
 es = c data2 > lok;
 
 adxval = adx(adxlen)data2;
end;

mp = currentcontracts*marketposition;
if mp <> mp[1] then trades = trades + 1;

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
  
 end;
 
 if not funk then funk = dru <= -minlist(funkl,funks);
  
end;

if not funk and trades = 0 and adxval < adxlimit then begin
 if marketposition < 1 and c < upk and el then
  buy("el") nos shares next bar at upk stop;
 if marketposition > -1 and c > lok and es then
  sellshort("es") nos shares next bar at lok stop;
end;
