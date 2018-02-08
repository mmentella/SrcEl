Inputs: nos(2),lenl(38),kl(.97),lens(6),ks(1.83),adxlen(14),adxlimit(31);
Inputs: stopl(1500),stopdl(1100),modl(1200),tl(3500);

Vars: upk(0,data2),lok(0,data2),el(true,data2),es(true,data2),buy1(true),short1(true),adxval(0,data2);
vars: stpv(0),stpw(0),stp(false),mkt(false),mcp(0),yc(0),mp(0),trades(0);

vars: reason(0),position(0),stoploss(1),daystop(11);
{***************************}
{***************************}
if d <> d[1] then begin
 trades = 0;
 yc     = c[1];
end;
{***************************}
{***************************}
if barstatus(2) = 2 then begin
 upk = KeltnerChannel(h,lenl,kl)data2;
 lok = KeltnerChannel(l,lens,-ks)data2;
 
 el = c data2 < upk;
 es = c data2 > lok;
   
 adxval = adx(adxlen)data2;
end;
{***************************}
{***************************}
mp = marketposition*currentcontracts;
if mp <> mp[1] then trades = trades + 1;

buy1   = adxval < adxlimit and trades < 1 and marketposition < 1 and el and c < upk;
short1 = adxval < adxlimit and trades < 1 and marketposition = 1 and es and c > lok;

mcp = MM.MaxContractProfit;
{***************************}
{***************************} 
if marketposition = 1 then begin
 
 stpw   = lok;
 reason = position;
 
 //STOPLOSS
 stpv = entryprice - (stopl - (slippage+commission))/bigpointvalue;
 
 if short1 then begin  
  if stpv > stpw then begin
   stpw   = stpv;
   reason = stoploss;
  end;  
 end else begin
  stpw   = stpv;
  reason = stoploss;
 end;
 
 //DAILY STOPLOSS
 stpv = yc - stopdl/bigpointvalue;
 
 if reason = stoploss then begin
  if stpv > stpw then begin
   stpw   = stpv;
   reason = daystop;
  end;
 end else begin
  if stpv > stpw then begin
   stpw   = stpv;
   reason = daystop;
  end;
 end;
 
 if reason > position then begin
  
  stp = c >  stpw;
  mkt = c <= stpw;
  
  if reason = stoploss then begin 
    
   if stp then sell("xl.stp") next bar stpw stop
   else if mkt then sell("xl.stp.m") this bar c; 
    
  end else
  if reason = daystop then begin  
   
   if d > entrydate then begin    
    if stp then sell("xl.funk") next bar stpw stop
    else if mkt then sell("xl.funk.m") this bar c;
   end;
   
  end;
 end;
 
 //PROFIT TARGET
 stpv = entryprice + (tl + (slippage+commission))/bigpointvalue;
 stp  = c < stpv;
 mkt  = c >= stpv;
 
 if stp then sell("xl.trgt") .5*nos shares next bar stpv limit
 else if mkt then sell("xl.trgt.m") .5*nos shares this bar c;
 
 //MODAL EXIT
 stpv = entryprice + modl/bigpointvalue;
 stp  = currentcontracts = nos and c < stpv;
 mkt  = currentcontracts = nos and c >= stpv;
  
 if stp then sell("xl.mod")   .5*nos shares next bar stpv limit
 else if mkt then sell("xl.mod.m") .5*nos shares this bar c;
  
end;
{***************************}
{***************************}
//Engine
if buy1   then buy("long")   nos shares next bar at upk stop;
if short1 then sell("short") nos shares next bar at lok stop;
{***************************}
{***************************}
