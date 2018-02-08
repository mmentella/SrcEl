{******** - MM.RA.K.PALLADIUM(V2) - ***
 Engine:    KELTNER
 Author:    Matteo Mentella
 Portfolio: RA
 Market:    PALLADIUM
 TimeFrame: 5 + 60 min.
 BackBars:  100
 Date:      04 Gen 2011
**************************************}
inputs: lenl(5),kl(2.2),lens(100),ks(2.53),mnymngmnt(1);
inputs: stopl(3500),funkl(3500),tl(2400);
inputs: stops(1750),funks(2800),ts(4000);

vars: upk(0,data2),lok(0,data2),el(true,data2),es(true,data2),engine(true,data2),trades(0);
vars: dru(0),stpv(0),stp(true),mkt(true),fnkl(false),fnks(false),nos(1),bpv(1/bigpointvalue);
{***************************}
{***************************}
if d <> d[1] then begin
 trades = 0;
 fnkl   = false;
 fnks   = false;
end;

if marketposition <> 0 and barssinceentry = 0 then begin
 trades = trades + 1;
 nos    = currentcontracts;
end;

dru = MM.DailyRunup;
{***************************}
{***************************}
if barstatus(2) = 2 then begin

upk = KeltnerChannel(h,lenl,kl)data2;
lok = KeltnerChannel(l,lens,-ks)data2;

el = c data2 < upk;
es = c data2 > lok;

engine = 700 < t data2 and t data2 < 2000;

end;
{***************************}
{***************************}
if mnymngmnt = 1 and 800 < t and t < 2300 then begin
 
 if marketposition = 1 then begin
 
  //STOPLOSS
  stpv = entryprice - stopl*bpv;
  stp  = c > stpv;
  mkt  = c < stpv;
  
  if stp then sell("xl.stp") next bar at stpv stop;
  if mkt then sell("xl.stp.m") this bar c;
  
  //DAILY STOPLOSS
  stpv = c - (dru/nos + funkl)*bpv;
  stp  = c > stpv;
  mkt  = c < stpv;
  
  if stp then sell("xl.funk") next bar at stpv stop;
  if mkt then sell("xl.funk.m") this bar c;
  
  //PROFIT TARGET
  stpv = entryprice + tl*bpv;
  stp  = c < stpv;
  mkt  = c > stpv;
  
  if stp then sell("xl.prft") next bar at stpv limit;
  if mkt then sell("xl.prft.m") this bar c;
  
 end else if marketposition = -1 then begin
  
  //STOPLOSS
  stpv = entryprice + stops*bpv;
  stp  = c < stpv;
  mkt  = c > stpv;
  
  if stp then buy to cover("xs.stp") next bar at stpv stop;
  if mkt then buy to cover("xs.stp.m") this bar c;
  
  //DAILY STOPLOSS
  stpv = c + (dru/nos + funks)*bpv;
  stp  = c < stpv;
  mkt  = c > stpv;
  
  if mkt then buy to cover("xs.funk") next bar stpv stop;
  if mkt then buy to cover("xs.funk.m") this bar c;
  
  //PROFIT TARGET
  stpv = entryprice - ts*bpv;
  stp  = c > stpv;
  mkt  = c < stpv;
  
  if stp then buy to cover("xs.prft") next bar at stpv limit;
  if mkt then buy to cover("xs.prft.m") this bar c;
  
 end;
end;
{***************************}
{***************************}
fnkl = dru <= - funkl * nos;
fnks = dru <= - funks * nos;
{***************************}
{***************************}
if trades = 0 and engine then begin
 
 if not fnkl and marketposition < 1 and el and c < upk then
  buy("el") next bar upk stop;
  
 if not fnks and marketposition > -1 and es and c > lok then
  sell short("es") next bar lok stop;
  
end;
{***************************}
{***************************}
