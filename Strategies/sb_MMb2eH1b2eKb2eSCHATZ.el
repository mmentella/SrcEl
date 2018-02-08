{********* - MM.H1.K.SCHATZ - **********
 Engine:    KELTNER
 Author:    Matteo Mentella
 Portfolio: H1
 Market:    SCHATZ
 TimeFrame: 2 + 60 min.
 BackBars:  50
 Date:      18 Feb 2011
**************************************}
Inputs: lenl(20),kl(4.9),lens(14),ks(5),mnymngmnt(1);
Inputs: stopl(745),funkl(660),tl(4140);
Inputs: stops(680),funks(900),ts(750);

vars: upk(0),lok(0),el(true),es(true),engine(true),trades(0);
vars: dru(0),mcp(0),bpv(1/bigpointvalue),stpv(0),stp(true),mkt(true),funk(true);
{***************************}
{***************************}
if d <> d[1] then begin
 trades = 0;
 funk   = false;
end;

if marketposition <> 0 and barssinceentry = 0 then trades = trades + 1;

dru = MM.DailyRunup;
mcp = MM.MaxContractProfit;
{***************************}
{***************************}
upk = KeltnerChannel(h,lenl,kl);
lok = KeltnerChannel(l,lens,-ks);
 
el = c  < upk;
es = c  > lok;
 
engine = 800 < t  and t  < 1600;
{***************************}
{***************************}
if mnymngmnt = 1 and 730 < t and t < 2300 then begin
 
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
  
  if stp then buy to cover("xs.stp") next bar at stpv stop
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
  
  if stp then buy to cover("xs.prft") next bar at stpv limit
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
