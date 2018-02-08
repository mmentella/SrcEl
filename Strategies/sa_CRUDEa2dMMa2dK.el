Inputs: NoS(2),LenL(19),KL(2.07),LenS(6),KS(4.85),ADXLen(24),ADXLimit(24);
Inputs: StopL(490),StopS(1700),BRKL(700),BRKS(700),TL(3100),TS(1900),TRSL(2100),TRSS(2900);

Vars: upperk(0,data2),lowerk(0,data2),adxval(0,data2),el(true,data2),es(true,data2),mpp(0),stopval(0),stp(false),mkt(false);

if barstatus(2) = 2 then begin
 upperk = KeltnerChannel(h,lenl,kl)data2;
 lowerk = KeltnerChannel(l,lens,-ks)data2;
 
 el = c data2 < upperk;
 es = c data2 > lowerk;
 
 adxval = adx(adxlen)data2;
end;

mpp = MM.MaxContractProfit;

if time > 800 and time < 2200 then begin
 
 if marketposition <> 0 then begin
  
  //STOPLOSS
  setstopshare;
  if marketposition = 1 then begin
   stopval = entryprice - (stopl - (slippage+commission))/bigpointvalue;
   stp     = c > stopval;
   mkt     = c <= stopval;
   
   if stp then setstoploss(stopl);
   if mkt then sell("xl.stpls") next bar at market;
  end;
  if marketposition = -1 then begin
   stopval = entryprice + (stops - (slippage+commission))/bigpointvalue;
   stp     = c < stopval;
   mkt     = c >= stopval;
   
   if stp then setstoploss(stops);
   if mkt then buytocover("xs.stpls") next bar at market;
  end;  
  
  //BREAKEVEN
  stopval = entryprice + 100/bigpointvalue;
  stp     = mpp > brkl/bigpointvalue and stopval < c;
  mkt     = mpp > brkl/bigpointvalue and stopval >= c;
  
  if stp then sell("xl.brk") next bar at stopval stop;
  if mkt then sell("xl.brk.m") next bar at market;
  
  //MODAL EXIT
  if currentcontracts = nos and nos > 1 then begin
   if marketposition = 1 then begin
    stopval = entryprice + tl/bigpointvalue;
    stp     = currentcontracts = nos and c < stopval;
    mkt     = currentcontracts = nos and c >= stopval;
    
    if stp then sell("xl.modl") nos/2 shares next bar at stopval limit;
    if mkt then sell("xl.modl.m") nos/2 shares next bar at market;
   end;
   if marketposition = -1 then begin
    stopval = entryprice - ts/bigpointvalue;
    stp     = currentcontracts = nos and c > stopval;
    mkt     = currentcontracts = nos and c <= stopval;
    
    if stp then buytocover("xs.modl") nos/2 shares next bar at stopval limit;
    if mkt then buytocover("xs.modl.m") nos/2 shares next bar at market;
   end;
  end;
  
  //TRAILING STOP  
  if mpp > brkl/bigpointvalue then begin
   stopval = entryprice + (mpp - trsl/bigpointvalue);
   stp     = currentcontracts = nos/2 and stopval < c;
   mkt     = currentcontracts = nos/2 and c <= stopval;
   
   if stp then sell("xl.trs") next bar at stopval stop;
   if mkt then sell("xl.trs.m") next bar at market;
  end;
    
 end;

 //ENGINE
 if adxval < adxlimit and TradesToday(d) < 1 then begin
  if marketposition < 1 and el and c < upperk then
   buy("long") nos shares next bar at upperk stop;
  if marketposition > -1 and es and c > lowerk then
   sellshort("short") nos shares next bar at lowerk stop;
 end;

end;
