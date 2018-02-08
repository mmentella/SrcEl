Inputs: NoS(2),LenL(24),KL(1.81),LenS(30),KS(3.52),ADXLen(19),TOP(30);
Inputs: StopLoss(400),BRK(550),TL(600),TS(500),TRSL(1500),TRSS(700);
Inputs: DayLimit(1200);

Vars: upperk(0,data2),lowerk(0,data2),adxval(0,data2),el.s(true,data2),es.s(true,data2),el.m(true,data2),es.m(true,data2);
Vars: mcp(0),bounce(false),SOD(800),EOD(2100),maxstop(0),minstop(0);
vars: stopval(0),mkt(true),stp(true),trades(0);

if d <> d[1] then begin
 maxstop = c[1] + DayLimit/bigpointvalue;
 minstop = c[1] - DayLimit/bigpointvalue;
 trades = 0;
end;

if barstatus(2) = 2 then begin
 upperk = KKeltnerChannel(h,lenl,kl)data2;
 lowerk = KKeltnerChannel(l,lens,-ks)data2;
 
 el.s = c data2 < upperk and upperk < maxstop;
 es.s = c data2 > lowerk and lowerk > minstop;
 
 adxval = adx(adxlen)data2;
end;

bounce = false;

if marketposition <> 0 then begin
 if barssinceentry = 0 then begin
  trades = trades + 1;
  if marketposition = 1 then mcp = h - entryprice;
  if marketposition = -1 then mcp = entryprice - l;
 end
 else begin
  if marketposition = 1 then mcp = maxlist(h - entryprice,mcp);
  if marketposition = -1 then mcp = maxlist(entryprice - l,mcp);
 end;
end;

if sod < time and time < eod then begin
 if marketposition <> 0 then begin
  setstopshare;
  setstoploss(stoploss);
  //BreakEven Trailing Stop
  if mcp > brk/bigpointvalue then begin
   if marketposition = 1 then begin
    stopval = entryprice + 100/bigpointvalue;
    stp     = mcp > brk/bigpointvalue and minstop < stopval and stopval < c;
    mkt     = mcp > brk/bigpointvalue and stopval >= c;
  
    if stp then sell("xl.brk") next bar at stopval stop;
    if mkt then sell("xl.brk.m") next bar at market;
      
    bounce = lowerk < stopval;
   end;
   if marketposition = -1 then begin
    stopval = entryprice - 100/bigpointvalue;
    stp     = mcp > brk/bigpointvalue and maxstop > stopval and stopval > c;
    mkt     = mcp > brk/bigpointvalue and stopval <= c;
    
    if stp then buytocover("xs.brk") next bar at stopval stop;
    if mkt then buytocover("xs.brk.m") next bar at market;
      
    bounce = upperk > stopval;
   end;
  end;
  //TRAILING STOP
  if marketposition = 1 then begin
   stopval = entryprice + (mcp - trsl/bigpointvalue);
   stp     = currentcontracts = nos/2 and minstop < stopval and stopval < c;
   mkt     = currentcontracts = nos/2 and c <= stopval;
   
   if stp then sell("xl.trs") next bar at stopval stop;
   if mkt then sell("xl.trs.m") next bar at market;
  end;
  if marketposition = -1 then begin
   stopval = entryprice - (mcp - trss/bigpointvalue);
   stp     = currentcontracts = nos/2 and maxstop > stopval and stopval > c;
   mkt     = currentcontracts = nos/2 and c >= stopval;
   
   if stp then buytocover("xs.trs") next bar at stopval stop;
   if mkt then buytocover("xs.trs.m") next bar at market;
  end;
  //Uscita Modale
  if currentcontracts = nos and nos > 1 then begin
   if marketposition = 1 then begin
    stopval = entryprice + tl/bigpointvalue;
    stp     = currentcontracts = nos and c < stopval and stopval < maxstop;
    mkt     = currentcontracts = nos and c >= stopval;
    
    if stp then sell("xl.modl") nos/2 shares next bar at stopval limit;
    if mkt then sell("xl.modl.m") nos/2 shares next bar at market;
   end;
   if marketposition = -1 then begin
    stopval = entryprice - ts/bigpointvalue;
    stp     = currentcontracts = nos and c > stopval and stopval > minstop;
    mkt     = currentcontracts = nos and c <= stopval;
    
    if stp then buytocover("xs.modl") nos/2 shares next bar at stopval limit;
    if mkt then buytocover("xs.modl.m") nos/2 shares next bar at market;
   end;
  end;
 end;
 //Engine
 if trades < 1 and adxval < top and IFFLogic(dayofweek(d)=5,t<2050,true) then begin
  if marketposition < 1 and el.s and c < upperk then
   buy("el.s") nos shares next bar at upperk stop;
  if marketposition > -1 and es.s and c > lowerk then
   sellshort("es.s") nos shares next bar at lowerk stop;  
 end; 
end;
