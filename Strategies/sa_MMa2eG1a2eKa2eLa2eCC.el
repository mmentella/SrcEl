{******** - MM.G1.K.L.CC - **********
 Engine:    KELTNER
 Author:    Matteo Mentella
 Portfolio: G1
 Market:    COCOA
 TimeFrame: 60 min.
 BackBars:  50
 Date:      04 Gen 2011
**************************************}
Inputs: lenl(6),kl(4.5);
Inputs: stopl(450),funkl(100000),tl(1500);

vars: upk(0),el(true),engine(true),trades(0);
vars: dru(0),mcp(0),stpv(0),stp(true),mkt(true),fnkl(true),nos(1),bpv(1/bigpointvalue);
{***************************}
{***************************}
if d <> d[1] then begin
 trades = 0;
 fnkl   = false;
end;

if marketposition <> 0 and barssinceentry = 0 then begin
 trades = trades + 1;
 nos    = currentcontracts;
end;

dru = MM.DailyRunup;
{***************************}
{***************************}
upk = KeltnerChannel(h,lenl,kl);

el = c < upk;

engine = 700 < t and t < 2030;
{***************************}
{***************************} 
if marketposition = 1 then begin

 //STOPLOSS
 stpv = entryprice - stopl*bpv;
 stp  = c > stpv;
 mkt  = c <= stpv;
 
 if stp then sell("xl.stp") next bar at stpv stop;
 if mkt then sell("xl.stp.m") this bar c;
 
 //DAILY STOPLOSS
 stpv = c - (dru/nos + funkl)*bpv;
 stp  = c > stpv;
 mkt  = c <= stpv;
 
 if stp then sell("xl.funk") next bar at stpv stop;
 if mkt then sell("xl.funk.m") this bar c;
 
 //PROFIT TARGET
 stpv = entryprice + tl*bpv;
 stp  = c < stpv;
 mkt  = c >= stpv;
 
 if stp then sell("xl.prft") next bar at stpv limit;
 if mkt then sell("xl.prft.m") this bar c;
 
end;
{***************************}
{***************************}
fnkl = dru <= - funkl * nos;
{***************************}
{***************************}
if trades = 0 and engine then begin
 
 if not fnkl and marketposition < 1 and el then
  buy("el") next bar upk stop;
  
end;
{***************************}
{***************************}
