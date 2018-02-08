Inputs: nos(2),lenl(14),kl(1.15),lens(11),ks(2.4),alpha(.2),adxlen(18),adxlimit(30),mnymngmnt(1);
Inputs: stopl(900 ),stopdl(1150),brkl(650),modl(1400),tl(2600),tld(2800);
Inputs: stops(1000),stopds(2050),brks(900),mods(1650),ts(7600),tsd(3550);

vars: upk(0,data2),lok(0,data2),adxv(0,data2),bst(false,data2),sst(false,data2),engine(false,data2),mcp(0),trades(0),yc(0);
vars: sod(1000),eod(1800),daylimit(3500/bigpointvalue),minstop(0),maxstop(0),stopval(0),stp(true),mkt(true),settlement(false);

if d <> d[1] then begin
 yc = c[1];
 settlement = false;
 trades = 0;
end;

if not settlement and t > 2015 then begin
 maxstop = c[1] + daylimit;
 minstop = c[1] - daylimit;
 settlement = true;
end;

mcp = MM.MaxContractProfit;

if currentbar > 10 then begin

if barstatus(2) = 2 then begin
 upk = KeltnerChannel(h,lenl,kl)data2;
 lok = KeltnerChannel(l,lens,-ks)data2;
 
 upk = MM.Smooth(upk,alpha);
 lok = MM.Smooth(lok,alpha);
 
 bst = c data2 < upk;
 sst = c data2 > lok;
 
 adxv = adx(adxlen)data2;
 
 engine = t data2 > sod and t data2 < eod;
end;

if marketposition <> 0 and barssinceentry = 0 then trades = trades + 1;

if t > 800 and t < 2000 then begin
 
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
   
   //DAILY PROFIT TARGET
   stopval = yc + tld/bigpointvalue;
   stp     = c < stopval and stopval < maxstop;
   mkt     = c >= stopval;
   
   if d > entrydate then begin
    if stp then sell("xl.trgtd") next bar at stopval limit;
    if mkt then sell("xl.trgtd.m") next bar at market;
   end;
   
   //BREAKEVEN
   stopval = entryprice + 100/bigpointvalue;
   stp     = mcp > brkl/bigpointvalue and minstop < stopval and stopval < c;
   mkt     = mcp > brkl/bigpointvalue and stopval >= c;
   
   if stp then sell("xl.brk") next bar at stopval stop;
   if mkt then sell("xl.brk.m") next bar at market;
   
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
   
   //BREAKEVEN
   stopval = entryprice - 100/bigpointvalue;
   stp     = mcp > brks/bigpointvalue and maxstop > stopval and stopval > c;
   mkt     = mcp > brks/bigpointvalue and stopval <= c;
   
   if stp then buytocover("xs.brk") next bar at stopval stop;
   if mkt then buytocover("xs.brk.m") next bar at market;
   
   //MODAL EXIT
   stopval = entryprice - mods/bigpointvalue;
   stp     = currentcontracts = nos and c > stopval and stopval > minstop;
   mkt     = currentcontracts = nos and c <= stopval;
   
   if stp then buytocover("xs.modl") nos/2 shares next bar at stopval limit;
   if mkt then buytocover("xs.modl.m") nos/2 shares next bar at market;
   
  end;
   
 end;
 
 if adxv < adxlimit and engine and trades < 1 then begin
  if marketposition < 1 and c < upk and bst and upk < maxstop then
   buy("el") nos shares next bar at upk stop;
  if marketposition > -1 and c > lok and sst and lok > minstop then
   sellshort("es") nos shares next bar at lok stop;
 end;

end;

end else begin
 upk = KeltnerChannel(h,lenl,kl)data2;
 lok = KeltnerChannel(l,lens,-ks)data2;
end;
