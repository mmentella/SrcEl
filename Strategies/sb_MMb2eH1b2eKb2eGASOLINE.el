{********* - MM.H1.K.DOWJ - **********
 Engine:    KELTNER
 Author:    Matteo Mentella
 Portfolio: H1
 Market:    mini Dow Jones
 TimeFrame: 2 + 60 min.
 BackBars:  50
 Date:      11 Feb 2011
**************************************}
Inputs: lenl(17),kl(.1),lens(3),ks(2.7),mnymngmnt(1);
Inputs: stopl(2394),funkl(100000),tl(100000);
Inputs: stops(100000),funks(100000),ts(100000);

vars: upk(0,data2),lok(0,data2),el(true,data2),es(true,data2),engine(true,data2),trades(0);
vars: dru(0),bpv(1/bigpointvalue),stpv(0),stp(true),mkt(true),funk(true);
{***************************}
{***************************}
if d <> d[1] then begin
 trades = 0;
 funk   = false;
end;

if marketposition <> 0 and barssinceentry = 0 then trades = trades + 1;

dru = MM.DailyRunup;
{***************************}
{***************************}
if barstatus(2) = 2 then begin
 upk = BollingerBand(h,lenl,kl)data2;
 lok = BollingerBand(l,lens,-ks)data2;
 
 el = c data2 < upk;
 es = c data2 > lok;
 
 engine = 700 < t data2 and t data2 < 2100;
end;
{***************************}
{***************************}
if mnymngmnt = 1 and 800 < t and t < 2300 then begin
 
 if marketposition = 1 then begin
 
  //STOPLOSS
  stpv = entryprice - stopl*bpv;
  stp  = c > stpv;
  mkt  = c <= stpv;
  
  if stp then sell("xl.stp") next bar at stpv stop
  else if mkt then sell("xl.stp.m") this bar c;
  
  //DAILY STOPLOSS
  stpv = c - (dru + funkl*currentcontracts)*bpv;
  stp  = c > stpv;
  mkt  = c <= stpv;
  
  if stp then sell("xl.funk") next bar at stpv stop
  else if mkt then sell("xl.funk.m") this bar c;
  
  //PROFIT TARGET
  stpv = entryprice + tl*bpv;
  stp  = c < stpv;
  mkt  = c >= stpv;
  
  if stp then sell("xl.prft") next bar at stpv limit
  else if mkt then sell("xl.prft.m") this bar c;
  
 end else if marketposition = -1 then begin
  
  //STOPLOSS
  stpv = entryprice + stops*bpv;
  stp  = c < stpv;
  mkt  = c >= stpv;
  
  if stp then buy to cover("xs.stp") next bar stpv stop
  else if mkt then buy to cover("xs.stp.m") this bar c;
  
  //DAILY STOPLOSS
  stpv = c + (dru + funks*currentcontracts)*bpv;
  stp  = c < stpv;
  mkt  = c >= stpv;
  
  if stp then buy to cover("xs.funk") next bar stpv stop
  else if mkt then buy to cover("xs.funk.m") this bar c;
  
  //PROFIT TARGET
  stpv = entryprice - ts*bpv;
  stp  = c > stpv;
  mkt  = c <= stpv;
  
  if stp then buy to cover("xs.prft") next bar stpv limit
  else if mkt then buy to cover("xs.prft.m") this bar c;
  
 end;
end;
{***************************}
{***************************}
funk = (dru <= - maxlist(funkl,funks));
{***************************}
{***************************}
if not funk and trades = 0 and engine then begin
 
 if marketposition < 1 and el and c < upk then
  buy("el") next bar upk stop;
 
 if marketposition > -1 and es and c > lok then
  sell short("es") next bar lok stop;
   
end;
{***************************}
{***************************}
