{******** - MM.RA.B.COFFEE - **********
 Engine:    BOLLINGER
 Author:    Matteo Mentella
 Portfolio: RA
 Market:    COFFEE
 TimeFrame: 60 min.
 BackBars:  50
 Date:      27 Mag 2011
**************************************}
Inputs: lenl(2),kl(2.3),lens(3),ks(4.3);
Inputs: stopl(100000),funkl(100000),tl(100000);
Inputs: stops(100000),funks(100000),brks(100000),ts(100000);

vars: upb(0),el(true),lob(0),es(true),trades(0);
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
upb = BollingerBand(h,lenl,kl);
lob = BollingerBand(l,lens,-ks);

el = c < upb;
es = c > lob;
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
if trades < 10 then begin
 
 if not fnkl and marketposition < 1 and el then
  buy("el") next bar upb stop;
 
 if not fnks and marketposition > -1 and es then
  sell short("es") next bar lob stop;
  
end;
{***************************}
{***************************}
