{********* - MM.H1.K.DOWJ - **********
 Engine:    KELTNER
 Author:    Matteo Mentella
 Portfolio: H1
 Market:    mini Dow Jones
 TimeFrame: 2 + 60 min.
 BackBars:  50
 Date:      10 Feb 2011
**************************************}
Inputs: lenl(9),kl(2.9),lens(22),ks(4.9),mnymngmnt(0);
Inputs: stopl(2800),funkl(3100),tl(4400);
Inputs: stops(1700),funks(3100),ts(5200);

vars: upk(0,data2),lok(0,data2),el(true,data2),es(true,data2),engine(true,data2),trades(0);
vars: dru(0),mcp(0),bpv(1/bigpointvalue),stpv(0),stp(true),mkt(true),funk(true);
{***************************}
{***************************}
if d <> d[1] then begin
 trades = 0;
 funk   = false;
end;

if marketposition <> 0 and barssinceentry = 0 then trades = trades + 1;

//dru = MM.DailyRunup;
//mcp = MM.MaxContractProfit;
{***************************}
{***************************}
if barstatus(2) = 2 then begin
 upk = KeltnerChannel(h,lenl,kl)data2;
 lok = KeltnerChannel(l,lens,-ks)data2;
 
 el = c data2 < upk;
 es = c data2 > lok;
 
 engine = 700 < t data2 and t data2 < 2300;
end;
{***************************}
{***************************
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
{***************************}}
//condition1 = d < 1070227 or 1110227 < d;
//if not condition1 then setexitonclose;

if not funk and trades = 0 and engine then begin
 
 if marketposition < 1 and el and c < upk then
  buy("el") next bar upk stop;
 
 if marketposition > -1 and es and c > lok then
  sell short("es") next bar lok stop;
   
end;
{***************************}
{***************************}
