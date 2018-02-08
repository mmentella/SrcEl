{******** - MM.RA.K.COCOA - **********
 Engine:    KELTNER
 Author:    Matteo Mentella
 Portfolio: RA
 Market:    COCOA
 TimeFrame: 60 min.
 BackBars:  50
 Date:      04 Gen 2011
**************************************}
vars: lenl(36),kl(1),lens(5),ks(3);
vars: stopl(1900),funkl(1800),tl(4450);
vars: stops(1100),funks(1650),brks(1500),ts(3850);

vars: upk(0),el(true),lok(0),es(true),engine(true),trades(0);
vars: dru(0),mcp(0),stpv(0),stp(true),mkt(true),fnkl(true),fnks(false),nos(1),bpv(1/bigpointvalue);
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

dru = MM.DailyRunup;
mcp = MM.MaxContractProfit;
{***************************}
{***************************}
upk = KeltnerChannel(h,lenl,kl);
lok = KeltnerChannel(l,lens,-ks);

el = c < upk;
es = c > lok;

engine = 1200 < t;
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
 
end else if marketposition = -1 then begin
  
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
 
 //BREKEVEN
 stpv = entryprice - 150*bpv;
 stp  = mcp > brks*bpv and c < stpv;
 mkt  = mcp > brks*bpv and c >= stpv;
 
 if stp then buy to cover("xs.brk") next bar stpv stop
 else if mkt then buy to cover("xs.brk.m") this bar c;
 
 //PROFIT TARGET
 stpv = entryprice - ts*bpv;
 stp  = c > stpv;
 mkt  = c <= stpv;
 
 if stp then buy to cover("xs.prft") next bar at stpv limit;
 if mkt then buy to cover("xs.prft.m") this bar c;
 
end;
{***************************}
{***************************}
fnkl = dru <= - funkl * nos;
fnks = dru <= - funks * nos;
{***************************}
{***************************}
if trades = 0 and engine then begin
 
 if not fnkl and marketposition < 1 and el then
  buy("el") next bar upk stop;
 
 if not fnks and marketposition > -1 and es then
  sell short("es") next bar lok stop;
  
end;
{***************************}
{***************************}
