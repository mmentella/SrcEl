Inputs: nos(2),lenl(6),kl(2.227),lens(199),ks(3.253),adxlen(11),adxlimit(30),mnymngmnt(1);
Inputs: stopl(1100),stopdl(1200),modl(1350),tl(3900),tld(1350);
Inputs: stops(1450),stopds(1600),mods(1600),ts(2200),tsd(1600);
Inputs: stopperc(0);

vars: upk(0,data2),lok(0,data2),adxval(0,data2),el(true,data2),es(true,data2),trade(true);
vars: stopval(0),minstop(-1),maxstop(999999),stp(false),mkt(false),mcp(0),yc(0);

if currentbar > maxlist(lenl,lens) then begin
 
 if d <> d[1] then begin
  trade = true;
  yc = c[1];
  if stopperc <> 0 then begin  
   maxstop = c[1]*(1+stopperc);
   minstop = c[1]*(1-stopperc);
  end;
 end;
 
 if barstatus(2) = 2 then begin
  upk = KeltnerChannel(h,lenl,kl)data2;
  lok = KeltnerChannel(l,lens,-ks)data2;
  
  el = c data2 < upk;
  es = c data2 > lok;
  
  adxval = adx(adxlen)data2;
 end;
 
 if marketposition <> 0 then begin
  
  if barssinceentry = 0 then trade = false;
  
  mcp = MM.MaxContractProfit;
  
  setstopshare;  
 
  if mnymngmnt = 1 and marketposition = 1 then begin
  
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
   
   //MODAL EXIT
   stopval = entryprice + modl/bigpointvalue;
   stp     = currentcontracts = nos and c < stopval and stopval < maxstop;
   mkt     = currentcontracts = nos and c >= stopval;
   
   if stp then sell("xl.modl") nos/2 shares next bar at stopval limit;
   if mkt then sell("xl.modl.m") nos/2 shares next bar at market;
   
  end else if mnymngmnt = 1 then begin
   
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
   
   //MODAL EXIT
   stopval = entryprice - mods/bigpointvalue;
   stp     = currentcontracts = nos and c > stopval and stopval > minstop;
   mkt     = currentcontracts = nos and c <= stopval;
   
   if stp then buytocover("xs.modl") nos/2 shares next bar at stopval limit;
   if mkt then buytocover("xs.modl.m") nos/2 shares next bar at market;
   
  end;
  
 end;
 
 if trade and adxval < adxlimit then begin
  if marketposition < 1 and el and c < upk then
   buy("el") nos shares next bar upk stop;
  if marketposition > -1 and es and c > lok then
   sellshort("es") nos shares next bar lok stop;
 end;
 
end else begin
 upk = KeltnerChannel(h,lenl,kl);
 lok = KeltnerChannel(l,lens,-ks); 
end;
