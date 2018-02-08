{******** - MM.G1.K.S.XX - **********
 Engine:    KELTNER
 Author:    Matteo Mentella
 Portfolio: G1
 Market:    XX50
 TimeFrame: 60 min.
 BackBars:  50
 Date:      04 Gen 2011
**************************************}
Inputs: lens(46),ks(1.1),mnymngmnt(1);
Inputs: stops(1250),funks(100000),ts(1700);

vars: lok(0),es(true),engine(true),trades(0);
vars: dru(0),mcp(0),stpv(0),stp(true),mkt(true),fnks(true),nos(1),bpv(1/bigpointvalue);
{***************************}
{***************************}
if d <> d[1] then begin
 trades = 0;
 fnks   = false;
end;

if marketposition <> 0 and barssinceentry = 0 then begin
 trades = trades + 1;
 nos    = currentcontracts;
end;

dru = MM.DailyRunup;
{***************************}
{***************************}
lok = KeltnerChannel(l,lens,-ks);

es = c > lok;

engine = 700 < t and t < 2030;
{***************************}
{***************************}
if mnymngmnt = 1 and 700 < t and t < 2030 then begin
 
 if marketposition = -1 then begin
  
  //STOPLOSS
  stpv = entryprice + stops*bpv;
  stp  = c < stpv;
  mkt  = c >= stpv;
  
  if stp then buy to cover("xs.stp") next bar at stpv stop;
  if mkt then buy to cover("xs.stp.m") this bar c;
  
  //DAILY STOPLOSS
  stpv = c + (dru/nos + funks)*bpv;
  stp  = c < stpv;
  mkt  = c >= stpv;
  
  if stp then buy to cover("xs.funk") next bar stpv stop;
  if mkt then buy to cover("xs.funk.m") this bar c;
  
  //PROFIT TARGET
  stpv = entryprice - ts*bpv;
  stp  = c > stpv;
  mkt  = c <= stpv;
  
  if stp then buy to cover("xs.prft") next bar at stpv limit;
  if mkt then buy to cover("xs.prft.m") this bar c;
  
 end;
end;
{***************************}
{***************************}
fnks = dru <= - funks * nos;
{***************************}
{***************************}
if trades = 0 and engine then begin
 
 if not fnks and marketposition > -1 and es then
  sell short("es") next bar lok stop;
  
end;
{***************************}
{***************************}
