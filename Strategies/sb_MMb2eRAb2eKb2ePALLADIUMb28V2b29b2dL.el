Inputs: nos(2),lenl(16),kl(2.02),lens(6),ks(3.8),adxlen(6),adxlimit(28);
Inputs: stopl(1300),mcpl(500),brkl(1900);
Inputs: modl(1500),tl(7900);

vars: upk(0,data2),lok(0,data2),adxv(0,data2),bsetup(false,data2),ssetup(false,data2);
vars: trade(true),mcp(0),bar2(false),nbar2(false,data2);

vars: short1(true),stp(true),mkt(false),stpv(0),stpw(0),reason(0),position(0),stoploss(10),trstoploss(11),breakeven(12),bpv(1/bigpointvalue);

mcp = MM.MaxContractProfit;
if nbar2 <> bar2 then trade = true;

if barstatus(2) = 2 then begin
 
 nbar2 = not nbar2;
 
 upk = KeltnerChannel(h,lenl,kl)data2;
 lok = KeltnerChannel(l,lens,-ks)data2;
 
 bsetup = c data2 < upk and t data2 >= 800;
 ssetup = c data2 > lok and t data2 >= 800;
 
 adxv = adx(adxlen)data2;
end;

short1 = adxv < adxlimit and trade and marketposition = 1 and ssetup and c > lok;

if t >= 800 and t < 2200 then begin
 
 if marketposition <> 0 then begin
  
  if barssinceentry = 0 then trade = false;
  
  reason = position;
  stpw   = lok;  
  
  //STOPLOSS
  stpv = entryprice - stopl*bpv;
  
  if short1 then begin
   if stpv > stpw then begin
    reason = stoploss;
    stpw   = stpv;
   end;
  end else begin
   reason = stoploss;
   stpw   = stpv;
  end;
  
  //TRAILING STOPLOSS
  stpv = entryprice + (mcpl - stopl)*bpv;
  
  if mcp > mcpl*bpv and stpv > stpw then begin
   reason = trstoploss;
   stpw   = stpv;
  end;
  
  //BREAK EVEN
  stpv = entryprice + 20*MinMove points;
  
  if mcp > brkl and stpv < stpw then begin
   reason = breakeven;
   stpw   = stpv;
  end;
  
  if reason > position then begin
  
  stp = c >  stpw;
  mkt = c <= stpw;
  
  if reason = stoploss then begin
   if stp then sell("xl.stp") next bar stpw stop
   else if mkt then sell("xl.stp.m") this bar c;
  end else
  if reason = trstoploss then begin
   if stp then sell("xl.stptr") next bar stpw stop
   else if mkt then sell("xl.stptr.m") this bar c;
  end else
  if reason = breakeven then begin
   if stp then sell("xl.brk") next bar stpw stop
   else if mkt then sell("xl.brk.m") this bar c;
  end;
  
  end;
  
  //MODAL EXIT
  stpv = entryprice + modl*bpv;
  
  stp = currentcontracts = nos and c <  stpv;
  mkt = currentcontracts = nos and c >= stpv;
  
  if stp then sell("xl.mod") .5*nos shares next bar stpv limit
  else if mkt then sell("xl.mod.m") .5*nos shares this bar c;
  
  //TARGET
  stpv = entryprice + tl*bpv;
  
  stp = currentcontracts = .5*nos and c <  stpv;
  mkt = currentcontracts = .5*nos and c >= stpv;
  
  if stp then sell("xl.trgt") .5*nos shares next bar stpv limit
  else if mkt then sell("xl.trgt.m") .5*nos shares this bar c;
  
 end;
 
 //ENGINE
 if adxv < adxlimit and trade then begin
 
  if marketposition < 1 and bsetup then
   if c < upk then buy("el.s") nos shares next bar at upk stop;
   
  if marketposition = 1 and ssetup then
   if c > lok then sell("es.s") nos shares next bar at lok stop;
    
 end;
   
end;

if barstatus(2) <> 2 then bar2 = nbar2;
