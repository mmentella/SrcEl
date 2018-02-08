Inputs: NoS(2),LenL(24),KL(1.81),LenS(30),KS(3.52),ADXLen(19),TOP(30);
Inputs: stopl(400),brkl(550),modl(600),trsl(1500);
Inputs: DayLimit(1100),SettleTime(2000);

Vars: upperk(0,data2),lowerk(0,data2),adxval(0,data2),el.s(true,data2),es.s(true,data2),el.m(true,data2),es.m(true,data2);
Vars: mcp(0),SOD(800),EOD(2100),maxstop(0),minstop(0);
vars: stpv(0),mkt(true),stp(true),trades(0),ys(0);

vars: short1(true),stpw(0),reason(0),position(0),stoploss(10),breakeven(11),trailing(12),modal(20),bpv(1/bigpointvalue);

if d <> d[1] then begin
 trades = 0;
 if ys = 0 then ys = c[1];
 maxstop = ys + DayLimit/bigpointvalue;
 minstop = ys - DayLimit/bigpointvalue;
 ys = 0;
end;

if DayLimit > 0 then begin
 if t > SettleTime and SettleTime > 0 then if ys = 0 then ys = c;
 if h > maxstop then maxstop = h;
 if l < minstop then minstop = l;
end;


if barstatus(2) = 2 then begin
 upperk = KKeltnerChannel(h,lenl,kl)data2;
 lowerk = KKeltnerChannel(l,lens,-ks)data2;
 
 el.s = c data2 < upperk and upperk < maxstop;
 es.s = c data2 > lowerk and lowerk > minstop;
 
 adxval = adx(adxlen)data2;
end;

short1 = trades < 1 and adxval < top and IFFLogic(dayofweek(d)=5,t<2050,true) and marketposition = 1 and es.s and c > lowerk and lowerk > minstop;

if marketposition <> 0 then begin
 if barssinceentry = 0 then begin
  trades = trades + 1;
  if marketposition = 1 then mcp = h - entryprice;
 end
 else begin
  if marketposition = 1 then mcp = maxlist(h - entryprice,mcp);
 end;
end;

if sod < time and time < eod then begin

 if marketposition <> 0 then begin

  reason = position;
  stpw   = lowerk;
  
  //STOPLOSS
  stpv = entryprice - (stopl - 2 * (commission + slippage))*bpv;
  
  if short1 then begin 
   if stpv > stpw then begin
    reason = stoploss;
    stpw   = stpv;
   end;
  end else begin
   reason = stoploss;
   stpw   = stpv;
  end;
  
  //BREAKEVEN
  stpv = entryprice + 10*MinMove points;
  
  if mcp > brkl*bpv and stpv > stpw then begin
   reason = breakeven;
   stpw   = stpv;
  end;
  
  //TRAILING STOP
  stpv = entryprice + mcp - trsl*bpv;
  
  if currentcontracts = .5*nos and stpv > stpw then begin
   reason = trailing;
   stpw   = stpv;
  end;
  
  if reason > position then begin
   
   stp = c >  stpw and stpw > minstop;
   mkt = c <= stpw;
   
   if reason = stoploss then begin
    if stp then sell("xl.stp") next bar stpw stop
    else if mkt then sell("xl.stp.m") this bar c;
   end else
   if reason = breakeven then begin
    if stp then sell("xl.brk") next bar stpw stop
    else if mkt then sell("xl.brk.m") this bar c;
   end else
   if reason = trailing then begin
    if stp then sell("xl.trls") next bar stpw stop
    else if mkt then sell("xl.trls.m") this bar c;
   end;
   
  end;
  
  //MODAL
  stpw = entryprice + modl*bpv;
  stp  = currentcontracts = nos and c <  stpw and stpw < maxstop;
  mkt  = currentcontracts = nos and c >= stpw;
  
  if stp then sell("xl.mod") .5*nos shares next bar stpw limit
  else if mkt then sell("xl.mod.m") .5*nos shares this bar c;
  
 end;
 
 //Engine
 if trades < 1 and adxval < top and IFFLogic(dayofweek(d)=5,t<2050,true) then begin
 
  if marketposition < 1 and el.s and c < upperk then
   if upperk < maxstop then
    buy("el") nos shares next bar at upperk stop;
    
  if marketposition = 1 and es.s and c > lowerk then
   if lowerk > minstop then
    sell("es") nos shares next bar at lowerk stop;
    
 end;

end;
