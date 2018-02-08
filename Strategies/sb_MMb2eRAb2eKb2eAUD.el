Inputs: nos(2),lenl(3),kl(0.15),lens(3),ks(3.57),adxlen(21),adxlimit(26),alfa(.2);
Inputs: stopl(1700),brkl(1500),tl(1500),tl1(10000);
Inputs: stops(0900),brks(0500),ts(1900),ts1(15000);
Inputs: minmcp(250);
{***************************}
{***************************}
Vars: upperk(0,data2),lowerk(0,data2),adxval(0,data2),mcp(0);
Vars: underK(false,data2),overK(false,data2),t2(0),engine(true);

vars: stpv(0),stpw(0),stp(true),mkt(false),reason(0),bpv(1/bigpointvalue);
vars: position(0),stoploss(1),tr_stoploss(11),daystop(2),breakeven(3);
{***************************}
{***************************}
if barstatus(2) = 2 then begin
 upperk = KeltnerChannel(h,lenl,kl)data2;
 lowerk = KeltnerChannel(l,lens,-ks)data2;
 
 upperk = alfa*upperk + (1-alfa)*upperk[1];
 lowerk = alfa*lowerk + (1-alfa)*lowerk[1];
 
 adxval = adx(adxlen)data2;
 
 underK = c data2 < upperk;
 overK = c data2 > lowerk;
 
 t2 = t data2;
end;

engine = adxval < adxlimit and 800 < t2 and t2 < 2200;

mcp = MM.MaxContractProfit;
{***************************}
{***************************}
if t > 800 and t < 2200 then begin
 
 if marketposition = 1 then begin
  
  stpw   = lowerk;
  reason = position;
  
  //STOPLOSS
  stpv = entryprice - stopl*bpv;
  
  if stpv > stpw or not (engine and overK and c > lowerk) then begin
   reason = stoploss;
   stpw   = stpv;
   stp    = c > stpv;
   mkt    = c <= stpv;
 
  end;
  
  //TRAILING STOPLOSS
  stpv = entryprice + mcp - stopl*bpv;
  
  if mcp < minmcp*bpv and stpv > stpw then begin
   reason = tr_stoploss;
   stpw   = stpv;
   stp    = mcp < minmcp*bpv and c > stpv;
   mkt    = mcp < minmcp*bpv and c <= stpv;
  end;
  
  //BREAKEVEN
  stpv = entryprice + 100*bpv;
  
  if mcp > brkl*bpv and stpv > stpw then begin
   reason = breakeven;
   stpw   = stpv;
   stp    = mcp > brkl*bpv and c > stpv;
   mkt    = mcp > brkl*bpv and c <= stpv;
  end;
  
  if reason <> position then begin
   
   if reason = stoploss then begin
    if stp then sell("xl.stp") next bar stpw stop
    else if mkt then sell("xl.stp.m") this bar c;
    
   end else if reason = tr_stoploss then begin
    if stp then sell("xl.stptr") next bar stpw stop
    else if mkt then sell("xl.stptr.m") this bar c;
    
   end else if reason = breakeven then begin
    if stp then sell("xl.brk") next bar stpw stop
    else if mkt then sell("xl.brk.m") this bar c;   
     
   end;
   
  end;
  
  //MODAL
  stpv = entryprice + tl*bpv;
  stp  = nos > 1 and currentcontracts = nos and c < stpv;
  mkt  = nos > 1 and currentcontracts = nos and c >= stpv;
  
  if stp then sell("xl.mod") nos - 1 shares next bar stpv limit
  else if mkt then sell("xl.mod.m") nos - 1 shares this bar c;
  
  //TARGET
  stpv = entryprice + tl1*bpv;
  stp  = currentcontracts < nos and c < stpv;
  mkt  = currentcontracts < nos and c >= stpv;
  
  if stp then sell("xl.trgt") next bar stpv limit
  else if mkt then sell("xl.trgt.m") this bar c;
  
 end else if marketposition = -1 then begin
  
  stpw   = upperk;
  reason = position;
  
  //STOPLOSS
  stpv = entryprice + stops*bpv;
  
  if stpv < stpw {and engine and underK and c < upperk} then begin
   reason = stoploss;
   stpw   = stpv;
   stp    = c < stpv;
   mkt    = c >= stpv;
  end;
  
  //TRAILING STOPLOSS
  stpv = entryprice - mcp + stops*bpv;
  
  if stpv < stpw then begin
   reason = tr_stoploss;
   stpw   = stpv;
   stp    = mcp < minmcp*bpv and c < stpv;
   mkt    = mcp < minmcp*bpv and c >= stpv;
  end;
  
  //BREAKEVEN
  stpv = entryprice - 100*bpv;
  
  if stpv < stpw then begin
   reason = breakeven;
   stpw   = stpv;
   stp    = mcp > brks*bpv and c < stpv;
   mkt    = mcp > brks*bpv and c >= stpv;
  end;
  
  if reason <> position then begin
   
   if reason = stoploss then begin
    if stp then buy to cover("xs.stp") next bar stpw stop
    else if mkt then buy to cover("xs.stp.m") this bar c;   
    
   end else if reason = tr_stoploss then begin
    if stp then buy to cover("xs.stptr") next bar stpw stop
    else if mkt then buy to cover("xs.stptr.m") this bar c;
    
   end else if reason = breakeven then begin
    if stp then buy to cover("xs.brk") next bar stpw stop
    else if mkt then buy to cover("xs.brk.m") this bar c;   
     
   end;
   
  end;
  
  //MODAL
  stpv = entryprice - ts*bpv;
  stp  = nos > 1 and currentcontracts = nos and c > stpv;
  mkt  = nos > 1 and currentcontracts = nos and c <= stpv;
  
  if stp then buy to cover("xs.mod") nos - 1 shares next bar stpv limit
  else if mkt then buy to cover("xs.mod.m") nos - 1 shares this bar c;
  
  //TARGET
  stpv = entryprice - tl1*bpv;
  stp  = currentcontracts < nos and c > stpv;
  mkt  = currentcontracts < nos and c <= stpv;
  
  if stp then buy to cover("xs.trgt") next bar stpv limit
  else if mkt then buy to cover("xs.trgt.m") this bar c;
  
 end;

end;
{***************************}
{***************************}
//ENGINE
if engine then begin
 
 if marketposition < 1 and underK and c < upperk then
  buy("long") nos shares next bar at upperk stop;
 
 if marketposition > -1 and overK and c > lowerk then
  sellshort("short") nos shares next bar at lowerk stop;

end;
