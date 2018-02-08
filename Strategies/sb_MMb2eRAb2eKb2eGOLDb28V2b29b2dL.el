Inputs: nos(2),lenl(13),kl(2.93),lens(21),ks(4.75),adxlen(18),adxlimit(30);
Inputs: stopl(1700),stopdl(1800),modl(1400);

Vars: upk(0,data2),lok(0,data2),adxval(0,data2),el(true,data2),es(true,data2),engine(true,data2);
vars: trades(0),stpv(0),stpw(0),stp(false),mkt(false),mcp(0),yc(0),mp(0);

vars: reason(0),position(0),stoploss(1),daystop(11),modal(2);

if d <> d[1] then begin
 trades = 0;
 yc = c[1];
end;

if barstatus(2) = 2 then begin
 upk = KeltnerChannel(h,lenl,kl)data2;
 lok = KeltnerChannel(l,lens,-ks)data2;
 
 el = c data2 < upk;
 es = c data2 > lok;
 
 engine = 800 < t data2 and t data2 < 2300;
 
 adxval = ADX(adxlen)data2;
end;

mp = currentcontracts*marketposition;
if mp <> mp[1] then trades = trades + 1;

mcp = MM.MaxContractProfit;

if 800 < t and t < 2250 and marketposition <> 0 then begin
  
 if marketposition = 1 then begin
  
  stpw   = lok;
  reason = position;
  
  //STOPLOSS
  stpv = entryprice - (stopl - (slippage+commission))/bigpointvalue;
  
  if stpv > stpw or not ( trades < 1 and engine and adxval < adxlimit and es and c > lok  ) then begin
   stpw   = stpv;
   reason = stoploss;
  end;
    
  //DAILY STOPLOSS
  stpv = yc - stopdl/bigpointvalue;
  
  if stpv > stpw or not ( trades < 1 and engine and adxval < adxlimit and es and c > lok  ) then begin
   stpw   = stpv;
   reason = daystop;
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
  
  //MODAL EXIT
  stpv = entryprice + modl/bigpointvalue;
  stp  = currentcontracts = nos and c < stpv;
  mkt  = currentcontracts = nos and c >= stpv;
  
  if stp then sell("xl.modl") nos/2 shares next bar at stpv limit;
  if mkt then sell("xl.modl.m") nos/2 shares next bar at market;
  
 end;
  
end;

//ENGINE
if trades < 1 and engine and adxval < adxlimit then begin

 if marketposition < 1 and el and c < upk then 
  buy nos shares next bar at upk stop;
  
 if marketposition = 1 and es and c > lok then
  sell nos shares next bar at lok stop;
  
end;
