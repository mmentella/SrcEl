{****** - MM.DICICCO.CATTLE - ********
 Engine:    BOLLINGER
 Author:    Matteo Mentella
 Portfolio: DI CICCO
 Market:    CATTLE
 TimeFrame: 60 min.
 BackBars:  100
 Date:      07 Gen 2011
**************************************}
vars: lenl(50),kl(1.1),lens(18),ks(4.4),mnymngmnt(1);
vars: stopl(1800),funkl(2200),brkl(4000),tl(5700);
vars: stops(450 ),funks(2300),brks(800),ts(8300);

vars: upb(0),lob(0),el(true),es(true),engine(true);
vars: trade(0),dru(0),funk(false),stpv(0),stp(true),mkt(true);
vars: maxstp(0),minstp(0),settle(false),mcp(0);
{***************************}
{***************************}
if MM.TradingRights then begin
{***************************}
{***************************}
if d <> d[1] then begin
 trade = 0;
 funk = false;
 settle = false;
end;

if not settle and t >= 2000 then begin
 settle = true;
 maxstp = c + 3;
 minstp = c - 3;
end;
{***************************}
{***************************}
upb = BollingerBand(h,lenl,kl);
lob = BollingerBand(l,lens,-ks);

el = c < upb;
es = c > lob;

engine = 1000 < t  and t  < 2300;

if marketposition <> 0 and barssinceentry = 0 then trade = trade + 1;

dru = MM.DICICCO.DailyRunup;
mcp = MM.DICICCO.MaxContractProfit;
{***************************}
{***************************}
if mnymngmnt = 1 and 700 < t and t < 2300 then begin
 
 if marketposition = 1 then begin
  
  //STOPLOSS
  stpv = entryprice - stopl/bigpointvalue;
  stp  = c > stpv and stpv > minstp;
  mkt  = c <= stpv;
  
  if stp then sell("xl.stp") next bar stpv stop
  else if mkt then sell("xl.stp.m") this bar c;
  
  //DAILY STOP
  stpv = c - (dru + funkl*currentcontracts)/bigpointvalue;
  stp  = c > stpv and stpv > minstp;
  mkt  = c <= stpv;
  
  if stp then sell("xl.funk") next bar stpv stop
  else if mkt then sell("xl.funk.m") this bar c;
  
  //BREAKEVEN
  stpv = entryprice + (10 points)*MinMove;
  stp  = mcp*bigpointvalue > brkl and c > stpv and stpv > minstp;
  mkt  = mcp*bigpointvalue > brkl and c <= stpv;
  
  if stp then sell("xl.brk") next bar stpv stop
  else if mkt then sell("xl.brk.m") this bar c;
  
  //PROFIT TARGET
  stpv = entryprice + tl/bigpointvalue;
  stp  = c < stpv and stpv < maxstp;
  mkt  = c > stpv;
  
  if stp then sell("xl.prft") next bar stpv limit
  else if mkt then sell("xl.prft.m") this bar c;
  
 end else if marketposition = -1 then begin
  
  //STOPLOSS
  stpv = entryprice + stops/bigpointvalue;
  stp  = c < stpv and stpv < maxstp;
  mkt  = c >= stpv;
  
  if stp then buy to cover("xs.stp") next bar stpv stop
  else if mkt then buy to cover("xs.stp.m") this bar c;
  
  //DAILY STOP
  stpv = c + (dru + funks*currentcontracts)/bigpointvalue;
  stp  = c < stpv and stpv < maxstp;
  mkt  = c >= stpv;
  
  if stp then buy to cover("xs.funk") next bar stpv stop
  else if mkt then buy to cover("xs.funk.m") this bar c;
  
  //BREAKEVEN
  stpv = entryprice - (10 points)*MinMove;
  stp  = mcp*bigpointvalue > brks and c < stpv and stpv < maxstp;
  mkt  = mcp*bigpointvalue > brks and c >= stpv;
  
  if stp then buy to cover("xs.brk") next bar stpv stop
  else if mkt then buy to cover("xs.brk.s") this bar c;
  
  //PROFIT TARGET
  stpv = entryprice - ts/bigpointvalue;
  stp  = c > stpv and stpv > minstp;
  mkt  = c <= stpv;
  
  if stp then buy to cover("xs.prft") next bar stpv limit
  else if mkt then buy to cover("xs.prft.m") this bar c;
  
 end;
  
end;
{***************************}
{***************************}
funk = dru <= -minlist(funkl,funks);
{***************************}
{***************************}
if not funk and trade < 1 and engine then begin
 
 if marketposition < 1 then begin
  stp = el and upb < maxstp;
  mkt = c > upb;
  
  if stp then buy("el") next bar upb stop
  else if mkt then buy("el.m") this bar c;
 end;
 
 if marketposition > -1 then begin
  stp = es and lob > minstp;
  mkt = c < lob;
  
  if stp then sell short("es") next bar lob stop
  else if mkt then sell short("es.m") this bar c;
 end;
 
end;
{***************************}
{***************************}
end;
{***************************}
{***************************}
