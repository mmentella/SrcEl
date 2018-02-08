Inputs: nos(2),lenl(45),kl(1.971),lens(27),ks(3.307),alphal(.202),alphas(.2),adxlen(14),adxlimit(30),modex(false);
Inputs: stopl(1100),stopdl(1500),stops(800),stopds(1400),brkl(700),brks(800),modl(2000),mods(2000),tl(3500),ts(2600);

vars: upk(0,data2),lok(0,data2),adxval(0,data2),trade(true),el(true,data2),es(true,data2),engine(true,data2);
vars: stopval(0),minstop(-1),maxstop(999999),stp(false),mkt(false),mcp(0),yc(0);

if d <> d[1] then begin trade = true; yc = c[1]; end;

if barstatus(2) = 2 then begin
 upk = KeltnerChannel(h,lenl,kl)data2;
 lok = KeltnerChannel(l,lens,-ks)data2;
 
 upk = MM.Smooth(upk,alphal);
 lok = MM.Smooth(lok,alphas);
 
 el = c data2 < upk;
 es = c data2 > lok;
 
 adxval = adx(adxlen)data2;
 
 engine = 800 < t data2 and t data2 < 2200;
end;

mcp = MM.MaxContractProfit;

if t > 800 and t < 2200 then begin
 
 if marketposition <> 0 then begin
  
  if barssinceentry = 0 then trade = false;
  
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
      
   //BREAKEVEN
   stopval = entryprice + 100/bigpointvalue;
   stp     = mcp > brkl/bigpointvalue and minstop < stopval and stopval < c;
   mkt     = mcp > brkl/bigpointvalue and stopval >= c;
   
   if stp then sell("xl.brk") next bar at stopval stop;
   if mkt then sell("xl.brk.m") next bar at market;
   
   //MODAL EXIT
   stopval = entryprice + modl/bigpointvalue;
   stp     = modex and currentcontracts = nos and c < stopval and stopval < maxstop;
   mkt     = modex and currentcontracts = nos and c >= stopval;
   
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
   
   //PROFIT TARGET
   stopval = entryprice - (ts + (slippage+commission))/bigpointvalue;
   stp     = c > stopval and stopval > minstop;
   mkt     = c <= stopval;
   
   if stp then setprofittarget(ts);
   if mkt then buytocover("xs.prftrgt") next bar at market;
      
   //BREAKEVEN
   stopval = entryprice - 100/bigpointvalue;
   stp     = mcp > brks/bigpointvalue and maxstop > stopval and stopval > c;
   mkt     = mcp > brks/bigpointvalue and stopval <= c;
   
   if stp then buytocover("xs.brk") next bar at stopval stop;
   if mkt then buytocover("xs.brk.m") next bar at market;
   
   //MODAL EXIT
   stopval = entryprice - mods/bigpointvalue;
   stp     = modex and currentcontracts = nos and c > stopval and stopval > minstop;
   mkt     = modex and currentcontracts = nos and c <= stopval;
   
   if stp then buytocover("xs.modl") nos/2 shares next bar at stopval limit;
   if mkt then buytocover("xs.modl.m") nos/2 shares next bar at market;
   
  end;
  
 end;
 
 //ENGINE
 if trade and engine and adxval < adxlimit then begin
  if marketposition < 1 and el and c < upk then 
   buy nos shares next bar at upk stop;
  if marketposition > -1 and es and c > lok then
   sellshort nos shares next bar at lok stop;
 end;
 
end;
