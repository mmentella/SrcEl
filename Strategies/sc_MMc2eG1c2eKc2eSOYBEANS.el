{******* - MM.G1.K.SOYBEANS - *********
 Engine:    Keltner
 Author:    Matteo Mentella
 Portfolio: G1
 Market:    SOYBEANS
 TimeFrame: 60 min.
 BackBars:  50
 Date:      10 Gen 2011
*************************************}
Inputs: lenl(8),kl(1.5),lens(6),ks(4.5),mnymngmnt(1);
Inputs: stopl(700),funkl(2400),tl(2700);
Inputs: stops(2000),funks(2350),ts(4500);

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
 maxstp = c + 70;
 minstp = c - 70;
end;

if marketposition <> 0 and barssinceentry = 0 then trades = trades + 1;
{***************************}
{***************************}
upk = KeltnerChannel(h,lenl,kl);
lok = KeltnerChannel(l,lens,-ks);

el = c < upk;
es = c > lok;

engine = 1000 < t and t < 1800;

dru = MM.DailyRunup;
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
  stpv = c - (dru + funkl)/bigpointvalue;
  stp  = c > stpv and stpv > minstp;
  mkt  = c < stpv;
  
  if stp then sell("xl.funk") next bar stpv stop
  else if mkt then sell("xl.funk.m") this bar c;
  
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
  mkt  = c > stpv;
  
  if stp then buy to cover("xs.stp") next bar stpv stop
  else if mkt then buy to cover("xs.stp.m") this bar c;
  
  //DAILY STOPLOSS
  stpv = c + (dru + funks)/bigpointvalue;
  stp  = c < stpv and stpv < maxstp;
  mkt  = c > stpv;
  
  if stp then buy to cover("xs.funk") next bar stpv stop
  else if mkt then buy to cover("xs.funk.m") this bar c;
  
  //PROFIT TARGET
  stpv = entryprice - ts/bigpointvalue;
  stp  = c > stpv and stpv > minstp;
  mkt  = c < stpv;
  
  if stp then buy to cover("xs.prft") next bar stpv limit
  else if mkt then buy to cover("xs.prft.m") this bar c;
  
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
  
  if stp then buy("el") next bar upk stop
  else if mkt then buy("el.m") this bar c;
 end;
 
 if marketposition > -1 then begin
  stp = es and lok > minstp;
  mkt = c < lok;
  
  if stp then sell short("es") next bar lok stop
  else if mkt then sell short("es.m") this bar c;
 end;
 
end;
