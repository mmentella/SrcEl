{****** - MM.RA.B.GOLD - ********
 Engine:    BOLLINGER
 Author:    Matteo Mentella
 Portfolio: RA
 Market:    LONG GILT
 TimeFrame: 60 min.
 BackBars:  50
 Date:      20 Giu 2011
**************************************}
inputs: lens(1),ks(.1);
inputs: stops(100000),funks(100000),brks(100000),ts(100000);

vars: lob(0),es(true),nos(1);
vars: trade(0),fnks(false),stpv(0),stp(true),mkt(true);
vars: mcp(0),dru(0),bpv(1/bigpointvalue);
{***************************}
{***************************}
if d <> d[1] then begin
 trade  = 0;
 fnks   = false;
end;
{***************************}
{***************************}
lob = BollingerBand(h,lens,ks);

es = c < lob;

if marketposition <> 0 and barssinceentry = 0 then begin
 trade = trade + 1;
 nos   = currentcontracts;
end;

dru = MM.DailyRunup;
mcp = MM.MaxContractProfit;
{***************************}
{***************************}
if marketposition = -1 then begin
 
 //STOPLOSS
 stpv = entryprice + stops*bpv;
 stp  = c < stpv;
 mkt  = c >= stpv;
 
 if stp then buy to cover("xs.stp") next bar stpv stop
 else if mkt then buy to cover("xs.stp.m") this bar c;
 
 //DAILY STOP
 stpv = c + (dru/nos + funks)*bpv;
 stp  = c < stpv;
 mkt  = c >= stpv;
 
 if stp then buy to cover("xs.funk") next bar stpv stop
 else if mkt then buy to cover("xs.funk.m") this bar c;
 
  //BREAKEVEN
 stpv = entryprice - (15 points)*MinMove;
 stp  = mcp > brks*bpv and c < stpv;
 mkt  = mcp > brks*bpv and c >= stpv;
 
 if stp then buy to cover("xs.brk") next bar stpv stop
 else if mkt then buy to cover("xs.brk.m") this bar c;
 
 //PROFIT TARGET
 stpv = entryprice - ts*bpv;
 stp  = c > stpv;
 mkt  = c <= stpv;
 
 if stp then buy to cover("xs.prft") next bar stpv limit
 else if mkt then buy to cover("xs.prft.m") this bar c;
 
end;
{***************************}
{***************************}
fnks = dru <= - funks*nos;
{***************************}
{***************************}
if trade < 1 then begin
 
 if not fnks and marketposition > -1 and es then
  sell short("es") next bar lob stop;
 
end;
{***************************}
{***************************}
