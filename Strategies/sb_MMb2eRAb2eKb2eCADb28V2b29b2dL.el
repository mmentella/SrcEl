Inputs: nos(2),lenl(45),kl(.05),lens(35),ks(4.22),alpha(.14),adxlen(5),adxlimit(34),sod(800),eod(1900);
Inputs: stopl(1950),brkl(850),modl(1300),tl(4300);

vars: upk(0,data2),lok(0,data2),adxv(0,data2),engine(true,data2),bs(true,data2),ss(true,data2),mcp(0);
vars: bpv(1/bigpointvalue),stpv(0),stpw(0),stp(true),mkt(false),buy1(true),short1(true);

vars: reason(0),position(0),stoploss(1),breakeven(2),modal(3),target(33);
{***************************}
{***************************}
mcp = MM.MaxContractProfit;
{***************************}
{***************************}
if currentbar > 10 then begin

if barstatus(2) = 2 then begin
 
 upk   = KeltnerChannel(h,lenl,kl)data2;
 lok   = KeltnerChannel(l,lens,-ks)data2;
 
 upk   = MM.Smooth(upk,alpha)data2;
 lok   = MM.Smooth(lok,alpha)data2;
 
 bs    = c data2 < upk;
 ss    = c data2 > lok;
 
 adxv  = adx(adxlen)data2;
 
 engine = t data2 > sod and t data2 < eod;

end;
{***************************}
{***************************}
if t > 800 and t < 2200 then begin
{***************************}
{***************************}
 buy1   = adxv < adxlimit and engine and marketposition < 1 and bs and c < upk;
 short1 = adxv < adxlimit and engine and marketposition = 1 and ss and c > lok;

 if marketposition <> 0 then begin
  
  stpw   = lok;
  reason = position;
  
  //STOPLOSS
  stpv = entryprice - stopl*bpv;
  
  if short1 then begin
   if stpv > stpw then begin
    stpw   = stpv;
    reason = stoploss;
   end;
  end else begin
   stpw   = stpv;
   reason = stoploss;
  end;
  
  //BREAKEVEN
  stpv = entryprice + 10*MinMove points;
  
  if stpv > stpw and mcp > brkl*bpv then begin
   stpw   = stpv;
   reason = breakeven;
  end;
  
  if reason > position then begin
   
   stp = c >  stpw;
   mkt = c <= stpw;
   
   if reason = stoploss  then begin
    if stp then sell("xl.stp") next bar stpw stop
    else if mkt then sell("xl.stp.m") this bar c;
   end else
   if reason = breakeven then begin
    if stp then sell("xl.brk") next bar stpw stop
    else if mkt then sell("xl.brk.m") this bar c;
   end;
   
  end;
  
  //MODAL
  stpv = entryprice + modl*bpv;
  stp  = currentcontracts = nos and c <  stpv;
  mkt  = currentcontracts = nos and c >= stpv;
  
  if stp then sell("xl.mod") .5*nos shares next bar stpv limit
  else if mkt then sell("xl.mod.l") .5*nos shares this bar c;
  
  //TARGET
  stpv = entryprice + tl*bpv;
  stp  = c <  stpv;
  mkt  = c >= stpv;
  
  if stp then sell("xl.trgt") .5*nos shares next bar stpv limit
  else if mkt then sell("xl.trgt.l") .5*nos shares this bar c;
  
 end;
{***************************}
{***************************}
if buy1   then buy("el")  nos shares next bar at upk stop;
if short1 then sell("es") nos shares next bar at lok stop;
{***************************}
{***************************}
end;
{***************************}
{***************************}
end else begin
 upk   = KeltnerChannel(h,lenl,kl)data2;
 lok   = KeltnerChannel(l,lens,-ks)data2;
end;
