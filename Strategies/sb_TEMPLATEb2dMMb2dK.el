Inputs: nos(2),lenl(20),kl(2),alphal(.2),lens(20),ks(2),alphas(.2),adxlen(14),adxlimit(30);
Inputs: stopl(100000),stopdl(100000),brkl(100000),modl(100000),tl(100000),tld(100000),trsl(100000);
Inputs: stops(100000),stopds(100000),brks(100000),mods(100000),ts(100000),tsd(100000),trss(100000);

vars: upk(0,data2),lok(0,data2),adxval(0,data2),el(true,data2),es(true,data2),engine(true,data2);
vars: trades(0),stopval(0),mkt(true),stp(true),yc(0),mcp(0),orderval(0),label("");

if currentbar data2 > maxlist(lenl,lens) then begin

if d <> d[1] then begin
 trades = 0;
 yc = c[1];
end;

if barstatus(2) = 2 then begin
 upk = KeltnerChannel(h,lenl,kl)data2;
 lok = KeltnerChannel(l,lens,-ks)data2;
 
 upk = MM.Smooth(upk,alphal)data2;
 lok = MM.Smooth(lok,alphas)data2;
 
 el = c data2 < upk;
 es = c data2 > lok;
 
 adxval = adx(adxlen)data2;
 
 engine = 800 < t data2 and t data2 < 2200;
end;

if marketposition <> 0 and barssinceentry = 0 then trades = trades + 1;

mcp = MM.MaxContractProfit;

if 800 < t and t < 2245 and marketposition <> 0 then begin
  
 setstopshare;  
 
 if marketposition = 1 then begin
  
  orderval = lok; label = "es.s";
  
  //STOPLOSS
  stopval = entryprice - (stopl - (slippage+commission))/bigpointvalue;
  if stopval > orderval then begin orderval = stopval; label = "xl.stpls"; end;
  
  //DAILY STOPLOSS
  stopval = yc - stopdl/bigpointvalue;
  if stopval > orderval then begin orderval = stopval; label = "xl.stpd"; end;
  
  //PROFIT TARGET
  stopval = entryprice + (tl + (slippage+commission))/bigpointvalue;
  stp     = c < stopval {and stopval < maxstop};
  mkt     = c >= stopval;
  
  if stp then setprofittarget(tl);
  if mkt then sell("xl.prftrgt") next bar at market;
  
  //DAILY PROFIT TARGET
  stopval = yc + tld/bigpointvalue;
  stp     = c < stopval {and stopval < maxstop};
  mkt     = c >= stopval;
  
  if d > entrydate then begin
   if stp then sell("xl.trgtd") next bar at stopval limit;
   if mkt then sell("xl.trgtd.m") next bar at market;
  end;
  
  //BREAKEVEN
  stopval = entryprice + 100/bigpointvalue;
  if stopval > orderval then begin orderval = stopval; label = "xl.brk"; end;
  
  //MODAL EXIT
  stopval = entryprice + modl/bigpointvalue;
  stp     = currentcontracts = nos and c < stopval {and stopval < maxstop};
  mkt     = currentcontracts = nos and c >= stopval;
  
  if stp then sell("xl.modl") nos/2 shares next bar at stopval limit;
  if mkt then sell("xl.modl.m") nos/2 shares next bar at market;
  
  //TRAILING STOP
  stopval = entryprice + (mcp - trsl/bigpointvalue);
  if stopval > orderval then begin orderval = stopval; label = "xl.trs"; end;
  
 end else begin
  
  orderval = upk; label = "el.s";
  
  //STOPLOSS
  stopval = entryprice + (stops - (slippage+commission))/bigpointvalue;
  if stopval < orderval then begin orderval = stopval; label = "xs.stpls"; end;
  
  //DAILY STOPLOSS
  stopval = yc + stopds/bigpointvalue;
  if stopval < orderval then begin orderval = stopval; label = "xs.stpd"; end;
  
  //PROFIT TARGET
  stopval = entryprice - (ts + (slippage+commission))/bigpointvalue;
  stp     = c > stopval {and stopval > minstop};
  mkt     = c <= stopval;
  
  if stp then setprofittarget(ts);
  if mkt then buytocover("xs.prftrgt") next bar at market;
  
  //DAILY PROFIT TARGET
  stopval = yc - tsd/bigpointvalue;
  stp     = c > stopval {and stopval > minstop};
  mkt     = c <= stopval;
  
  if d > entrydate then begin
   if stp then buytocover("xs.trgtd") next bar at stopval limit;
   if mkt then buytocover("xs.trgtd.m") next bar at market;
  end;
  
  //BREAKEVEN
  stopval = entryprice - 100/bigpointvalue;
  if stopval < orderval then begin orderval = stopval; label = "xs.brk"; end;
  
  //MODAL EXIT
  stopval = entryprice - mods/bigpointvalue;
  stp     = currentcontracts = nos and c > stopval {and stopval > minstop};
  mkt     = currentcontracts = nos and c <= stopval;
  
  if stp then buytocover("xs.modl") nos/2 shares next bar at stopval limit;
  if mkt then buytocover("xs.modl.m") nos/2 shares next bar at market;
  
  //TRAILING STOP
  stopval = entryprice - (mcp - trss/bigpointvalue);
  stp     = currentcontracts = nos/2 {and maxstop > stopval} and stopval > c;
  mkt     = currentcontracts = nos/2 and c >= stopval;
  
  if stp then buytocover("xs.trs") next bar at stopval stop;
  if mkt then buytocover("xs.trs.m") next bar at market;
  
 end;
  
end;

//ENGINE
if condition1 and engine and trades < 1 and adxval < adxlimit then begin
 if marketposition < 1 and el and c < upk then
  buy("el.s") nos shares next bar at upk stop;
 if marketposition > -1 and es and c > lok then
  sellshort("es.s") nos shares next bar at lok stop;
end;

end else begin
 upk = KeltnerChannel(h,lenl,kl)data2;
 lok = KeltnerChannel(l,lens,-ks)data2;
end;
