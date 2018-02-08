{******* - MM.RA.K.SOYBEANS - *********
 Engine:    Keltner
 Author:    Matteo Mentella
 Portfolio: RA
 Market:    SOYBEANS
 TimeFrame: 33 min.
 BackBars:  50
 Date:      08 Lug 2011
*************************************}
Inputs: lenl(5),kl(2.4),lens(32),ks(4.8);
Inputs: stopl(0700),funkl(2300),tl(3000);
Inputs: stops(1500),funks(2100);

vars: upk(0,data2),lok(0,data2),el(true,data2),es(true,data2),engine(true,data2);
vars: fnkl(false),fnks(false),settle(false),maxstp(0),minstp(0);
vars: trades(0),dru(0),mcp(0),stpv(0),stp(true),mkt(true),nos(1),bpv(1/bigpointvalue);
{***************************}
{***************************}
if d <> d[1] then begin
 trades = 0;
 fnkl   = false;
 fnks   = false;
 settle = false;
end;

if not settle and t >= 2015 then begin
 settle = true;
 maxstp = c + 70;
 minstp = c - 70;
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
 
 el = c data2 < upk;
 es = c data2 > lok;
 
 engine = 730 < t and t < 2015;
end;

dru = MM.DailyRunup;
{***************************}
{***************************}
if 730 < t and t < 2015 then begin
 
 if marketposition = 1 then begin
 
  //STOPLOSS
  stpv = entryprice - stopl*bpv;
  stp  = c > stpv and stpv > minstp;
  mkt  = c < stpv;
  
  if stp then sell("xl.stp") next bar stpv stop
  else if mkt then sell("xl.stp.m") this bar c;
  
  //DAILY STOPLOSS
  stpv = c - (dru/nos + funkl)*bpv;
  stp  = c > stpv and stpv > minstp;
  mkt  = c < stpv;
  
  if stp then sell("xl.funk") next bar stpv stop
  else if mkt then sell("xl.funk.m") this bar c;
  
  //PROFIT TARGET
  stpv = entryprice + tl*bpv;
  stp  = c < stpv and stpv < maxstp;
  mkt  = c > stpv;
  
  if stp then sell("xl.prft") next bar stpv limit
  else if mkt then sell("xl.prft.m") this bar c;
  
 end else if marketposition = -1 then begin
  
  //STOPLOSS
  stpv = entryprice + stops*bpv;
  stp  = c < stpv and stpv < maxstp;
  mkt  = c > stpv;
  
  if stp then buy to cover("xs.stp") next bar stpv stop
  else if mkt then buy to cover("xs.stp.m") this bar c;
  
  //DAILY STOPLOSS
  stpv = c + (dru/nos + funks)*bpv;
  stp  = c < stpv and stpv < maxstp;
  mkt  = c > stpv;
  
  if stp then buy to cover("xs.funk") next bar stpv stop
  else if mkt then buy to cover("xs.funk.m") this bar c;
  
 end;
end;
{***************************}
{***************************}
fnkl = dru <= -funkl*nos;
fnks = dru <= -funks*nos;
{***************************}
{***************************}
if trades < 1 and engine then begin
 
 if not fnkl and marketposition < 1 then begin
  stp = el and c < upk and upk < maxstp;
  mkt = c > upk;
  
  if stp then buy("el") next bar upk stop
  else if mkt then buy("el.m") this bar c;
 end;
 
 if not fnks and marketposition > -1 then begin
  stp = es and c > lok and lok > minstp;
  mkt = c < lok;
  
  if stp then sell short("es") next bar lok stop
  else if mkt then sell short("es.m") this bar c;
 end;
 
end;
{***************************}
{***************************}
