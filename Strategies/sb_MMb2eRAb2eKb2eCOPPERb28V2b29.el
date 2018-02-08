{****** - MM.RA.K.COPPER(V2) - ********
 Engine:    Keltner
 Author:    Matteo Mentella
 Portfolio: RA
 Market:    HG COPPER
 TimeFrame: 2 + 60 min.
 BackBars:  50
 Date:      03 Gen 2011
*************************************}
inputs: lenl(5),kl(.2),lens(40),ks(1.2);
inputs: stopl(1800),funkl(2150),brkl(1825),tl(3400);
inputs: stops(1600),funks(3000),brks(1300),ts(3600);

vars: upk(0,data2),lok(0,data2),engine(true,data2),el(true,data2),es(true,data2);
vars: trades(0),dru(0),mcp(0),stpv(0),stp(true),mkt(true),nos(1),fnkl(false),fnks(false),bpv(1/bigpointvalue);
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
{***************************}
{***************************}
if barstatus(2) = 2 then begin

upk = KeltnerChannel(h,lenl,kl)data2;
lok = KeltnerChannel(l,lens,-ks)data2;

el = c  data2 < upk;
es = c  data2 > lok;

engine = 700 < t data2  and t data2  < 1900;

end;

dru = MM.DailyRunup;
mcp = MM.MaxContractProfit;
{***************************}
{***************************}
if 700 < t and t < 2300 then begin
 
 if marketposition = 1 then begin
 
  //STOPLOSS
  stpv = entryprice - stopl*bpv;
  stp  = c > stpv;
  mkt  = c < stpv;
  
  if stp then sell("xl.stp") next bar stpv stop
  else if mkt then sell("xl.stp.m") this bar c;
  
  //DAILY STOPLOSS
  stpv = c - (dru/nos + funkl)*bpv;
  stp  = c > stpv;
  mkt  = c < stpv;
  
  if stp then sell("xl.funk") next bar stpv stop
  else if mkt then sell("xl.funk.m") this bar c;
  
  //BREAKEVEN
  stpv = entryprice + 12*MinMove points;
  stp  = mcp >= brkl*bpv and c > stpv;
  mkt  = mcp >= brkl*bpv and c <= stpv;
  
  if stp then sell("xl.brk") next bar stpv stop
  else if mkt then sell("xl.brk.m") this bar c;
  
  //PROFIT TARGET
  stpv = entryprice + tl*bpv;
  stp  = c < stpv;
  mkt  = c > stpv;
  
  if stp then sell("xl.prft") next bar stpv limit
  else if mkt then sell("xl.prft.m") this bar c;
  
 end else if marketposition = -1 then begin
  
  //STOPLOSS
  stpv = entryprice + stops*bpv;
  stp  = c < stpv;
  mkt  = c > stpv;
  
  if stp then buy to cover("xs.stp") next bar stpv stop
  else if mkt then buy to cover("xs.stp.m") this bar c;
  
  //DAILY STOPLOSS
  stpv = c + (dru/nos + funks)*bpv;
  stp  = c < stpv;
  mkt  = c > stpv;
  
  if stp then buy to cover("xs.funk") next bar stpv stop
  else if mkt then buy to cover("xs.funk.m") this bar c;
  
  //BREAKEVEN
  stpv = entryprice - 12*MinMove points;
  stp  = mcp >= brks*bpv and c < stpv;
  mkt  = mcp >= brks*bpv and c >= stpv;
  
  if stp then buy to cover("xs.brk") next bar stpv stop
  else if mkt then buy to cover("xs.brk.m") this bar c;
  
  //PROFIT TARGET
  stpv = entryprice - ts*bpv;
  stp  = c > stpv;
  mkt  = c < stpv;
  
  if stp then buy to cover("xs.prft") next bar stpv limit
  else if mkt then buy to cover("xs.prft.m") this bar c;
  
 end;
end;
{***************************}
{***************************}
fnkl = dru <= -funkl*nos;
fnks = dru <= -funks*nos;
{***************************}
{***************************}
if trades = 0 and engine then begin

 if not fnkl and marketposition < 1 and el then
  buy("el") next bar at upk stop;
  
 if not fnks and marketposition > -1 and es then
  sell short("es") next bar at lok stop;
 
end;
{***************************}
{***************************}
