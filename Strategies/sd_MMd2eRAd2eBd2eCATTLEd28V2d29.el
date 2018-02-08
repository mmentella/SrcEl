{******** - MM.RA.B.CATTLE(V2) - ******
 Engine:    BOLLINGER
 Author:    Matteo Mentella
 Portfolio: RA
 Market:    LIVE CATTLE
 TimeFrame: 2 + 60 min.
 BackBars:  50
 Date:      07 Gen 2011
**************************************}
vars: lenl(48),kl(1.1),lens(28),ks(3.2);
vars: stopl(1850),funkl(1600),tl(3950);
vars: stops(1300),funks(1700),brks(750),ts(1750);

vars: upb(0,data2),lob(0,data2),el(true,data2),es(true,data2),engine(true,data2),nos(1);
vars: trade(0),fnkl(false),fnks(false),stpv(0),stp(true),mkt(true);
vars: maxstp(0),minstp(0),settle(false),mcp(0),dru(0),bpv(1/bigpointvalue);
{***************************}
{***************************}
if d <> d[1] then begin
 trade  = 0;
 fnkl   = false;
 fnks   = false;
 settle = false;
end;

if not settle and t >= 2000 then begin
 settle = true;
 maxstp = c + 3;
 minstp = c - 3;
end;
{***************************}
{***************************}
if barstatus(2) = 2 then begin

upb = BollingerBand(h,lenl,kl)data2;
lob = BollingerBand(l,lens,-ks)data2;

el = c data2 < upb;
es = c data2 > lob;

engine = 700 < t data2  and t data2  < 2300;

end;

if marketposition <> 0 and barssinceentry = 0 then begin
 trade = trade + 1;
 nos   = currentcontracts;
end;

dru = MM.DailyRunup;
mcp = MM.MaxContractProfit;
{***************************}
{***************************}


 if marketposition = 1 then begin
  
  //STOPLOSS
  stpv = entryprice - stopl*bpv;
  stp  = c > stpv and stpv > minstp;
  mkt  = c <= stpv;
  
  if stp then sell("xl.stp") next bar stpv stop
  else if mkt then sell("xl.stp.m") this bar c;
  
  //DAILY STOP
  stpv = c - (dru/nos + funkl)*bpv;
  stp  = c > stpv and stpv > minstp;
  mkt  = c <= stpv;
  
  if stp then sell("xl.funk") next bar stpv stop
  else if mkt then sell("xl.funk.m") this bar c;
  
  //PROFIT TARGET
  stpv = entryprice + tl*bpv;
  stp  = c < stpv and stpv < maxstp;
  mkt  = c >= stpv;
  
  if stp then sell("xl.prft") next bar stpv limit
  else if mkt then sell("xl.prft.m") this bar c;
  
 end else if marketposition = -1 then begin
  
  //STOPLOSS
  stpv = entryprice + stops*bpv;
  stp  = c < stpv and stpv < maxstp;
  mkt  = c >= stpv;
  
  if stp then buy to cover("xs.stp") next bar stpv stop
  else if mkt then buy to cover("xs.stp.m") this bar c;
  
  //DAILY STOP
  stpv = c + (dru/nos + funks)*bpv;
  stp  = c < stpv and stpv < maxstp;
  mkt  = c >= stpv;
  
  if stp then buy to cover("xs.funk") next bar stpv stop
  else if mkt then buy to cover("xs.funk.m") this bar c;
  
  //BREAKEVEN
  stpv = entryprice - (15 points)*MinMove;
  stp  = mcp > brks*bpv and c < stpv and stpv < maxstp;
  mkt  = mcp > brks*bpv and c >= stpv;
  
  if stp then buy to cover("xs.brk") next bar stpv stop
  else if mkt then buy to cover("xs.brk.s") this bar c;  

  //PROFIT TARGET
  stpv = entryprice - ts*bpv;
  stp  = c > stpv and stpv > minstp;
  mkt  = c <= stpv;
  
  if stp then buy to cover("xs.prft") next bar stpv limit
  else if mkt then buy to cover("xs.prft.m") this bar c;
  
 end;
 

{***************************}
{***************************}
fnkl = dru <= - funkl*nos;
fnks = dru <= - funks*nos;
{***************************}
{***************************}
if trade < 1 and engine then begin
 
 if not fnkl and marketposition < 1 and el and c < upb then
  buy("el") next bar upb stop;
 
 if not fnks and marketposition > -1 and es and c > lob then
  sell short("es") next bar lob stop;
 
end;
{***************************}
{***************************}
