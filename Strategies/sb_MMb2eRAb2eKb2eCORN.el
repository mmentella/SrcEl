{******** - MM.RA.K.CORN - ***********
 Engine:    Keltner
 Author:    Matteo Mentella
 Portfolio: RA
 Market:    CORN
 TimeFrame: 60 min.
 BackBars:  50
 Date:      10 Gen 2011
*************************************}
vars: lenl(19),kl(3.7),lens(24),ks(4.99),mnymngmnt(1);
vars: stopl(1800),funkl(1500),brkl(1100),modl(1200);
vars: stops(1050),funks(1950),brks(1800),mods(1200);

vars: upk(0),lok(0),el(true),es(true),engine(true),funk(false),settle(false),maxstp(0),minstp(0);
vars: trades(0),dru(0),mcp(0),stpv(0),stp(true),mkt(true);
{***************************}
{***************************}
if d <> d[1] then begin
 trades = 0;
 funk   = false;
 settle = false;
end;

if not settle and t >= 2015 then begin
 settle = true;
 maxstp = c + 30;
 minstp = c - 30;
end;

if marketposition <> 0 and barssinceentry = 0 then trades = trades + 1;
{***************************}
{***************************}
upk = KeltnerChannel(h,lenl,kl);
lok = KeltnerChannel(l,lens,-ks);

el = c < upk;
es = c > lok;

engine = 700 < t and t < 2000;

dru = MM.DailyRunup;
mcp = MM.MaxContractProfit;
{***************************}
{***************************}
if mnymngmnt = 1 and 700 < t and t < 2000 then begin
 
 if marketposition = 1 then begin
 
  //STOPLOSS
  stpv = entryprice - stopl/bigpointvalue;
  stp  = c > stpv and stpv > minstp;
  mkt  = c < stpv;
  
  if stp then sell("xl.stp") next bar stpv stop
  else if mkt then sell("xl.stp.m") this bar c;
  
  //DAILY STOPLOSS
  stpv = c - (dru + funkl*currentcontracts)/bigpointvalue;
  stp  = c > stpv and stpv > minstp;
  mkt  = c < stpv;
  
  if stp then sell("xl.funk") next bar stpv stop
  else if mkt then sell("xl.funk.m") this bar c;
  
  //BREAKEVEN
  stpv = entryprice + 16 points;
  stp  = mcp*bigpointvalue > brkl and c > stpv and stpv > minstp;
  mkt  = mcp*bigpointvalue > brkl and c < stpv;
  
  if stp then sell("xl.brk") next bar stpv stop
  else if mkt then sell("xl.brk.m") this bar c;
  
  //MODAL EXIT
  stpv = entryprice + modl/bigpointvalue;
  stp  = currentcontracts = 2 and c < stpv and stpv < maxstp;
  mkt  = currentcontracts = 2 and c > stpv;
  
  if stp then sell("xl.mod") 1 share next bar stpv limit
  else if mkt then sell("xl.mod.m") 1 share this bar c;
  
 end else if marketposition = -1 then begin
  
  //STOPLOSS
  stpv = entryprice + stops/bigpointvalue;
  stp  = c < stpv and stpv < maxstp;
  mkt  = c > stpv;
  
  if stp then buy to cover("xs.stp") next bar stpv stop
  else if mkt then buy to cover("xs.stp.m") this bar c;
  
  //DAILY STOPLOSS
  stpv = c + (dru + funks*currentcontracts)/bigpointvalue;
  stp  = c < stpv and stpv < maxstp;
  mkt  = c > stpv;
  
  if stp then buy to cover("xs.funk") next bar stpv stop
  else if mkt then buy to cover("xs.funk.m") this bar c;
  
  //BREAKEVEN
  stpv = entryprice - 16 points;
  stp  = mcp*bigpointvalue > brks and c < stpv and stpv < maxstp;
  mkt  = mcp*bigpointvalue > brks and c > stpv;
  
  if stp then buy to cover("xs.brk") next bar stpv stop
  else if mkt then buy to cover("xs.brk.m") this bar c;
  
  //MODAL EXIT
  stpv = entryprice - mods/bigpointvalue;
  stp  = currentcontracts = 2 and c > stpv and stpv > minstp;
  mkt  = currentcontracts = 2 and c < stpv;
  
  if stp then buy to cover("xs.mod") 1 share next bar stpv limit
  else if mkt then buy to cover("xs.mod.m") 1 share this bar c;
  
 end;
end;
{***************************}
{***************************}
funk = dru <= -minlist(funkl,funks);
{***************************}
{***************************}
if not funk and trades = 0 and engine then begin
 
 if marketposition < 1 then begin
  stp = el and upk < maxstp;
  mkt = c > upk;
  
  if stp then buy("el") 2 shares next bar upk stop
  else if mkt then buy("el.m") 2 shares this bar c;
 end;
 
 if marketposition > -1 then begin
  stp = es and lok > minstp;
  mkt = c < lok;
  
  if stp then sell short("es") 2 shares next bar lok stop
  else if mkt then sell short("es.m") 2 shares this bar c;
 end;
 
end;
{***************************}
{***************************}
