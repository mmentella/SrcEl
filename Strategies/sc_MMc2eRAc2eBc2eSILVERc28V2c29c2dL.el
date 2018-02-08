Inputs: lenl(17),kl(3.67),lens(90),ks(1.95);
Inputs: stopl(2700),stopdl(2400),tl(4950);

vars: upb(0,data2),lob(0,data2),el(true,data2),es(true,data2),engine(true,data2),buy1(true),short1(true);
vars: stpv(0),stpw(0),stp(false),mkt(false),yc(0),trade(0);

vars: reason(0),position(0),stoploss(1),daystop(11);
{***************************}
{***************************}
if d <> d[1] then begin
 trade = 0;
 yc = c[1];
end;
{***************************}
{***************************}
if barstatus(2) = 2 then begin
 upb = BollingerBand(h,lenl,kl)data2;
 lob = BollingerBand(l,lens,-ks)data2;
 
 el = c data2 < upb;
 es = c data2 > lob;
 
 engine = 800 < t data2 and t data2 < 2300;
end;

if marketposition <> 0 and barssinceentry = 0 then trade = trade + 1;

buy1   = trade < 1 and engine and marketposition < 1 and el and c < upb;
short1 = trade < 1 and engine and marketposition = 1 and es and c > lob;
{***************************}
{***************************}
if 800 < t and t < 2250 then begin 
 
 if marketposition = 1 then begin
  
  stpw   = lob;
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
  
   stp = c  > stpw;
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
  
  if stp then sell("xl.trgt") next bar stpv limit
  else if mkt then sell("xl.trgt.m") this bar c;
  
 end;
 
end;
{***************************}
{***************************}
if buy1   then buy("el")  next bar at upb stop;
if short1 then sell("es") next bar at lob stop;
{***************************}
{***************************}
