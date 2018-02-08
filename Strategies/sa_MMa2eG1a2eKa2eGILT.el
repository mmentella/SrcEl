Inputs: nos(2),lenl(59),kl(3.68),lens(66),ks(3.27),adxlen(14),adxlimit(31),mnymngmnt(1);
Inputs: stopl(1400),funkl(3100),tl(2050);
Inputs: stops(1750),funks(3100),ts(1250);

vars: upk(0),lok(0),adxval(0),el(true),es(true);
vars: stopval(0),minstop(-1),maxstop(999999),stp(false),mkt(false),mcp(0),yc(0),mp(0),funk(false),dru(0),trades(0);

if d <> d[1] then begin
 trades = 0;
 yc = c[1];
 funk = false;
end;

upk = KeltnerChannel(h,lenl,kl);
lok = KeltnerChannel(l,lens,-ks);
 
el = c  < upk;
es = c  > lok;
 
adxval = adx(adxlen);

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
  stopval = c - (dru + funkl)/bigpointvalue;
  stp     = c > stopval;
  mkt     = c < stopval;
  
  if stp then sell("xl.funk") next bar stopval stop
  else if mkt then sell("xl.funk.m") this bar c;
  
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
  stopval = c + (dru + funks)/bigpointvalue;
  stp     = c < stopval;
  mkt     = c > stopval;
  
  if stp then buy to cover("xs.funk") next bar stopval stop
  else if mkt then buy to cover("xs.funk.m") this bar c;
  
  //PROFIT TARGET
  stopval = entryprice - (ts + (slippage+commission))/bigpointvalue;
  stp     = c > stopval and stopval > minstop;
  mkt     = c <= stopval;
  
  if stp then setprofittarget(ts);
  if mkt then buytocover("xs.prftrgt") next bar at market;
  
 end;
  
end;

if not funk then funk = dru <= -minlist(funkl,funks);

if not funk and trades = 0 and adxval < adxlimit then begin
 if marketposition < 1 and el then
  buy("el") nos shares next bar at upk stop;
 if marketposition > -1 and es then
  sellshort("es") nos shares next bar at lok stop;
end;
