Inputs: nos(2),lenl(11),kl(0.61),lens(46),ks(2.73),alpha(.1),adxlen(14),adxlimit(29),sod(1000),eod(2000),maxtrades(10);
Inputs: stopl(800),stops(800),brkl(500),brks(600),modl(900),mods(800),tl(2600),ts(4700);

vars: upk(0,data2),lok(0,data2),entryl(0,data2),entrys(0,data2),bst(false,data2),engine(false,data2),sst(false,data2),adxv(0,data2),mcp(0),trades(0);
vars: trade(true),bar2(false),nbar2(false,data2),daylimit(1500/bigpointvalue),stopval(0),minstop(0),maxstop(0),stp(false),mkt(false);

mcp = MM.MaxContractProfit;

if bar2 <> nbar2 then trade = true;

if currentbar > 10 then begin

if d <> d[1] then begin
 maxstop = c[1] + daylimit;
 minstop = c[1] - daylimit;
 trades = 0;
end;

if barstatus(2) = 2 then begin
 
 nbar2 = not nbar2;
 
 upk = KeltnerChannel(h,lenl,kl)data2;
 lok = KeltnerChannel(l,lens,-ks)data2;
 
 upk = MM.Smooth(upk,alpha);
 lok = MM.Smooth(lok,alpha);
 
 entryl = upk + (.25 - Mod(upk,.25));
 entrys = lok - Mod(lok,.25);
 
 bst = c data2 < upk;
 sst = c data2 > lok;
 
 adxv = adx(adxlen)data2;
 
 engine = t data2 > sod and t data2 < eod;
end;

if t > 800 and t < eod then begin
 
 if marketposition <> 0 then begin
  
  if barssinceentry = 0 then begin trade = false; trades = trades + 1; end;
  
  setstopshare;
  
  //STOPLOSS
  if marketposition = 1 then begin
   stopval = entryprice - (stopl - (slippage+commission))/bigpointvalue;
   stopval = stopval - Mod(stopval,.25);
   stp     = c > stopval and stopval > minstop;
   mkt     = c <= stopval;
  
   if stp then setstoploss(stopl);
   if mkt then sell("xl.stpls") next bar at market;
  end else if marketposition = -1 then begin
   stopval = entryprice + (stops - (slippage+commission))/bigpointvalue;
   stopval = stopval + (.25 - Mod(stopval,.25));
   stp     = c < stopval and stopval < maxstop;
   mkt     = c >= stopval;
   
   if stp then setstoploss(stops);
   if mkt then buytocover("xs.stpls") next bar at market;
  end;
  
  //PROFIT TARGET
  if marketposition = 1 then begin
   stopval = entryprice + (tl + (slippage+commission))/bigpointvalue;
   stopval = stopval + (.25 - Mod(stopval,.25));
   stp     = c < stopval and stopval < maxstop;
   mkt     = c >= stopval;
   
   if stp then setprofittarget(tl);
   if mkt then sell("xl.prftrgt") next bar at market;
  end else if marketposition = -1 then begin
   stopval = entryprice - (ts + (slippage+commission))/bigpointvalue;
   stopval = stopval - Mod(stopval,.25);
   stp     = c > stopval and stopval > minstop;
   mkt     = c <= stopval;
   
   if stp then setprofittarget(ts);
   if mkt then buytocover("xs.prftrgt") next bar at market;
  end;
  
  //BREAK EVEN
  if marketposition = 1 then begin
   stopval = entryprice + 100/bigpointvalue;
   stopval = stopval - Mod(stopval,.25);
   stp     = mcp > brkl/bigpointvalue and minstop < stopval and stopval < c;
   mkt     = mcp > brkl/bigpointvalue and stopval >= c;
   
   if stp then sell("xl.brk") next bar at stopval stop;
   if mkt then sell("xl.brk.m") next bar at market;
  end else if marketposition = -1 then begin
   stopval = entryprice - 100/bigpointvalue;
   stopval = stopval + (.25 - Mod(stopval,.25));
   stp     = mcp > brks/bigpointvalue and maxstop > stopval and stopval > c;
   mkt     = mcp > brks/bigpointvalue and stopval <= c;
   
   if stp then buytocover("xs.brk") next bar at stopval stop;
   if mkt then buytocover("xs.brk.m") next bar at market;
  end;
   
  //MODAL EXIT
  if currentcontracts = nos and nos > 1 then begin
   if marketposition = 1 then begin
    stopval = entryprice + modl/bigpointvalue;
    stopval = stopval + (.25 - Mod(stopval,.25));
    stp     = currentcontracts = nos and c < stopval and stopval < maxstop;
    mkt     = currentcontracts = nos and c >= stopval;
    
    if stp then sell("xl.modl") nos/2 shares next bar at stopval limit;
    if mkt then sell("xl.modl.m") nos/2 shares next bar at market;
   end else if marketposition = -1 then begin
    stopval = entryprice - mods/bigpointvalue;
    stopval = stopval - Mod(stopval,.25);
    stp     = currentcontracts = nos and c > stopval and stopval > minstop;
    mkt     = currentcontracts = nos and c <= stopval;
    
    if stp then buytocover("xs.modl") nos/2 shares next bar at stopval limit;
    if mkt then buytocover("xs.modl.m") nos/2 shares next bar at market;
   end;   
  end;
  
 end;

 if adxv < adxlimit and engine and trade and trades < maxtrades then begin
  if marketposition < 1 and bst then
   buy("el") nos shares next bar at entryl stop;
  if marketposition > -1 and sst then
   sellshort("es") nos shares next bar at entrys stop;
 end;

end;

end else begin
 upk = KeltnerChannel(h,lenl,kl)data2;
 lok = KeltnerChannel(l,lens,-ks)data2;
end;

if barstatus(2) <> 2 then bar2 = nbar2;
