Inputs: nos(2),lenl(39),kl(0.2),lens(3),ks(3.6);
Inputs: stopl(2300),funkl(2800),modl(2500),tl(3000);

vars: upb(0,data2),el(true,data2);
vars: lob(0,data2),es(true,data2);
vars: stpv(0),stpw(0),stp(false),mkt(false);
vars: mcp(0),yc(0),trade(0),funk(false),dru(0),engine(true,data2);
vars: mp(0),engine2(true),upb2(0),lob2(0),el2(true),es2(true);

vars: reason(0),position(0),stoploss(1),daystop(11),modal(2),target(22);
{***************************}
{***************************}
if d <> d[1] then begin
 trade = 0;
 yc = c[1];
 funk = false;
end;

if barstatus(2) = 2 then begin
 upb = BollingerBand(h,lenl,kl)data2;
 lob = BollingerBand(l,lens,-ks)data2;
 
 el = c data2 < upb;
 es = c data2 > lob;
 
 engine = 800 < t data2 and t data2 < 2300;
end;

if marketposition <> 0 and barssinceentry = 0 then trade = trade + 1;
{***************************}
{***************************}
mp = marketposition; upb2 = upb; lob2 = lob; el2 = el; es2 = es; engine2 = engine;
if mp = 0 and mp[1] = 1 and barssinceexit(1) = 0 and engine2[1] and not funk[1] and 
 trade[1] < 1 and es2[1] and c[1] > lob then trade = trade + 1;

mcp = MM.MaxContractProfit;
dru = MM.DailyRunup;
{***************************}
{***************************}
if 800 < t and t < 2250 then begin
  
 if marketposition = 1 then begin
  
  stpw   = lob;
  reason = position;
  
  //STOPLOSS
  stpv = entryprice - (stopl - (slippage+commission))/bigpointvalue;
  
  if stpv > stpw or not ( not funk and trade < 1 and engine and marketposition = 1 and es and c > lob ) then begin
   stpw   = stpv;
   reason = stoploss;
  end;
  
  //DAILY STOPLOSS
  stpv = c - ( dru/currentcontracts + funkl )/bigpointvalue;
  
  if reason = 1 and stpv > stpw or reason = 0 and not ( not funk and trade < 1 and engine and marketposition = 1 and es and c > lob ) then begin
   stpw = stpv;
   reason = daystop;
  end;
  
  if reason <> 0 then begin
   
   stp = c >  stpw;
   mkt = c <= stpw;
   
   if reason = stoploss then begin
    if stp then sell("xl.stp") next bar stpw stop
    else if mkt then sell("xl.stp.m") this bar c;
   end else
   if reason = daystop then begin
    if stp then sell("xl.funk") next bar stpw stop
    else if mkt then sell("xl.funk.m") this bar c;
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
  
  if stp then sell("xl.modl") .5*nos shares next bar at stpv limit;
  if mkt then sell("xl.modl.m") .5*nos shares next bar at market;
  
 end;
  
end;
{***************************}
{***************************}
if not funk and trade < 1 and engine then begin

 if marketposition < 1 and el and c < upb then
  buy("el") nos shares next bar at upb stop;
  
 if marketposition = 1 and es and c > lob then
  sell("es") nos shares next bar at lob stop;
  
end;
{***************************}
{***************************}
