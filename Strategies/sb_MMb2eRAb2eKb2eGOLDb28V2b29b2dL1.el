{********* - MM.G1.K.GOLD - ***********
 Engine:    Keltner
 Author:    Matteo Mentella
 Portfolio: G1
 Market:    GOLD
 TimeFrame: 60 min.
 BackBars:  50
 Date:      03 Gen 2011
**************************************}
Inputs: NoS(1);

Inputs: lenl(29),kl(1.2),lens(2),ks(4.1),mnymngmnt(1);
Inputs: stopl(3500),funkl(3400),tl(4450);

Inputs: DayLimits(7000),SettleTime(1900);
Inputs: OpenTime(0800),CloseTime(2300);
Inputs: StartEngine(0800),StopEngine(2100);

vars: upk(0,data2),lok(0,data2),engine(true,data2),el(true,data2),es(true,data2);
vars: trades(0),dru(0),stpv(0),stp(true),mkt(true);

vars: daylimit(DayLimits/bigpointvalue),settleprice(0),minstop(0),maxstop(0);

vars: stpw(0),reason(0),position(0),stoploss(10),funkstop(11),short1(true);

{***************************}
{***************************}
if settleprice = 0 and t > SettleTime then settleprice = c[1];
if d <> d[1] then begin
 trades = 0;
 if settleprice = 0 then settleprice = c[1];
 maxstop = settleprice + daylimit;
 minstop = settleprice - daylimit;
 settleprice = 0;
end;
if h > maxstop then maxstop = h;
if l < minstop then minstop = l;

if marketposition <> 0 and barssinceentry = 0 then trades = trades + 1;

{***************************}
{***************************}
if BarStatus(2) = 2 then begin

 upk = KeltnerChannel(h,lenl,kl) data2;
 lok = KeltnerChannel(l,lens,-ks) data2;

 el = c data2 < upk;
 es = c data2 > lok;
 
 engine = StartEngine <= t data2 and t data2 < StopEngine;

end;

dru = MM.DailyRunup;
{***************************}
{***************************}
short1 = trades = 0 and engine and marketposition = 1 and es and c > lok;
{***************************}
{***************************}
if mnymngmnt = 1 and OpenTime < t and t < CloseTime then begin
 
 if marketposition = 1 then begin
  
  reason = position;
  stpw   = stpv;
  
  //STOPLOSS
  stpv = entryprice - stopl/bigpointvalue;
  
  if short1 then begin
   if stpv > stpw then begin
    reason = stoploss;
    stpw   = stpv;
   end;
  end else begin
   reason = stoploss;
   stpw   = stpv;
  end;
  
  //DAILY STOPLOSS
  stpv = c - (dru + funkl*currentcontracts)/bigpointvalue;
  
  if stpv > stpw then begin
   reason = funkstop;
   stpw   = stpv;
  end;
  
  if reason > position then begin
   
   stp = c >  stpw and stpw > maxstop;
   mkt = c <= stpw;
   
   if reason = stoploss then begin
    if stp then sell("xl.stp") next bar stpw stop
    else if mkt then sell("xl.stp.m") this bar c;
   end else
   if reason = funkstop then begin
    if stp then sell("xl.funk") next bar stpw stop
    else if mkt then sell("xl.funk.m") this bar c;
   end;
  end;
  
  //PROFIT TARGET
  stpv = entryprice + tl/bigpointvalue;
  stp  = c < stpv and stpv < maxstop;
  mkt  = c > stpv;
  
  if stp then sell("xl.trgt") next bar at stpv limit;
  if mkt then sell("xl.trgt.m") this bar c;
  
 end;
end;

{***************************}
{***************************}
if trades = 0 and engine then begin

 if marketposition < 1 and el and c < upk then
  if upk < maxstop then
   buy("el") next bar at upk stop;
   
 if marketposition = 1 and es and c > lok then
  if lok > minstop then
   sell("es") next bar at lok stop;
   
end;
