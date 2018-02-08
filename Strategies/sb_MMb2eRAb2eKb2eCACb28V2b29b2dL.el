Inputs: nos(2),lenl(24),kl(1.958),lens(99),ks(3.534),alphal(.267),alphas(.247),adxlen(13),adxlimit(30),moneymanagement(true);
Inputs: stopl(1350),stopdl(700),brkl(1700),modl(1000);
Inputs: tl(3500);

vars: upk(0,data2),lok(0,data2),adxval(0,data2),el(true,data2),es(true,data2),trade(true);
vars: stpv(0),minstop(-1),maxstop(999999),stp(false),mkt(false),mcp(0),yc(0);
vars: stpw(0),reason(0),position(0),stoploss(10),daystop(11),breakeven(12),short1(true);

if d <> d[1] then begin trade = true; yc = c[1]; end;

mcp = MM.MaxContractProfit;

if currentbar > maxlist(lenl,lens) then begin
 
if barstatus(2) = 2 then begin
 upk = KeltnerChannel(h,lenl,kl)data2;
 lok = KeltnerChannel(l,lens,-ks)data2;
 
 upk = MM.Smooth(upk,alphal);
 lok = MM.Smooth(lok,alphas);
 
 adxval = adx(adxlen)data2;
 
 el = c data2 < upk;
 es = c data2 > lok;
end;

short1 = 1100 < t and t < 2100 and trade and adxval < adxlimit and marketposition = 1 and es and c > lok;

if moneymanagement and marketposition <> 0 then begin
  
 setstopshare;
 
 if barssinceentry = 0 then trade = false;
 
 if marketposition = 1 then begin
  
  reason = position;
  stpw   = lok;
  
  //STOPLOSS
  stpv = entryprice - (stopl - (slippage+commission))/bigpointvalue;
  
  if short1 then begin
   if stpv > stpw then begin
    reason = stoploss;
    stpw   = stpv;
   end;
  end else begin
   reason = stoploss;
   stpw   = stpv;
  end;
  
  //DAYSTOP
  stpv = yc - stopdl/bigpointvalue;
  
  if d > entrydate and stpv > stpw then begin
   reason = daystop;
   stpw   = stpv;
  end;
  
  //BREAKEVEN
  stpv = entryprice + 100/bigpointvalue;
  
  if mcp > brkl/bigpointvalue and stpv > stpw then begin
   reason = breakeven;
   stpv   = stpw;
  end;
  
  if reason > position then begin
  
   stp = c >  stpw and stpw > minstop;
   mkt = c <= stpw;
   
   if reason = stoploss then begin
    if stp then sell("xl.stp") next bar stpw stop
    else if mkt then sell("xl.stp.m") this bar c;
   end else
   if reason = daystop then begin
    if stp then sell("xl.stpd") next bar stpw stop
    else if mkt then sell("xl.stpd.m") this bar c;
   end else
   if reason = breakeven then begin
    if stp then sell("xl.brk") next bar stpw stop
    else if mkt then sell("xl.brk.m") this bar c;
   end;
  
  end;
  
  //MODAL
  stpw = entryprice + modl/bigpointvalue;
  stp  = currentcontracts = nos and c <  stpw and stpw < maxstop;
  mkt  = currentcontracts = nos and c >= stpw;
  
  if  stp then sell("xl.mod") .5*nos shares next bar stpw limit
  else if mkt then sell("xl.mod.m") .5*nos shares this bar c;
  
  //TARGET
  stpw = entryprice + tl/bigpointvalue;
  stp  = currentcontracts = .5*nos and c <  stpw and stpw < maxstop;
  mkt  = currentcontracts = .5*nos and c >= stpw;
  
  if  stp then sell("xl.trgt") .5*nos shares next bar stpw limit
  else if mkt then sell("xl.trgt.m") .5*nos shares this bar c;
  
 end;
  
end;

//ENGINE
if 1100 < t and t < 2100 and trade and adxval < adxlimit then begin

 if marketposition < 1 and el and c < upk then 
  buy("el") nos shares next bar at upk stop;
  
 if marketposition = 1 and es and c > lok then
  sell("es") nos shares next bar at lok stop;
  
end;
 
end else begin
 
upk = KeltnerChannel(h,lenl,kl)data2;
lok = KeltnerChannel(l,lens,-ks)data2;
 
end;
