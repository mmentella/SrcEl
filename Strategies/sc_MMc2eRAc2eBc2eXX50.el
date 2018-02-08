{****** - MM.RA.B.XX50 - ********
 Engine:    BOLLINGER
 Author:    Matteo Mentella
 Portfolio: RA
 Market:    XX50
 TimeFrame: 60 min.
 BackBars:  50
 Date:      04 Lug 2011
**************************************}
inputs: lenl(7),kl(2.3),lens(8),ks(0.5);
inputs: stopl(100000),funkl(100000),brkl(100000),tl(100000);
inputs: stops(100000),funks(100000),brks(100000),ts(100000);

vars: upb(0),lob(0),el(true),es(true),engine(true),nos(1);
vars: trade(0),fnkl(false),fnks(false),stpv(0),stp(true),mkt(true);
vars: mcp(0),dru(0),bpv(1/bigpointvalue);
{***************************}
{***************************}
if d <> d[1] then begin
 trade  = 0;
 fnkl   = false;
 fnks   = false;
end;
{***************************}
{***************************}
upb = KeltnerChannel(h,lenl,kl);
lob = KeltnerChannel(l,lens,-ks);

el = c < upb;
es = c > lob;

if marketposition <> 0 and barssinceentry = 0 then begin
 trade = trade + 1;
 nos   = currentcontracts;
end;

dru = MM.DailyRunup;
mcp = MM.MaxContractProfit;
{***************************}
{***************************}


if marketposition = 1 then begin
 
 //STOPLOSS
 stpv = entryprice - stopl*bpv;
 stp  = c > stpv;
 mkt  = c <= stpv;
 
 if stp then sell("xl.stp") next bar stpv stop
 else if mkt then sell("xl.stp.m") this bar c;

 //DAILY STOP
 stpv = c - (dru/nos + funkl)*bpv;
 stp  = c > stpv;
 mkt  = c <= stpv;
 
 if stp then sell("xl.funk") next bar stpv stop
 else if mkt then sell("xl.funk.m") this bar c;
 
 //BREAKEVEN
 stpv = entryprice + (10 points)*MinMove;
 stp  = mcp > brkl*bpv and c > stpv;
 mkt  = mcp > brkl*bpv and c <= stpv;
 
 if stp then sell("xl.brk") next bar stpv stop
 else if mkt then sell("xl.brk.s") this bar c;

 //PROFIT TARGET
 stpv = entryprice + tl*bpv;
 stp  = c < stpv;
 mkt  = c >= stpv;
 
 if stp then sell("xl.prft") next bar stpv limit
 else if mkt then sell("xl.prft.m") this bar c;
 
end else if marketposition = -1 then begin
  
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
 stpv = entryprice - (10 points)*MinMove;
 stp  = mcp > brks*bpv and c < stpv;
 mkt  = mcp > brks*bpv and c >= stpv;
 
 if stp then buy to cover("xs.brk") next bar stpv stop
 else if mkt then buy to cover("xs.brk.s") this bar c;  

 //PROFIT TARGET
 stpv = entryprice - ts*bpv;
 stp  = c > stpv;
 mkt  = c <= stpv;
 
 if stp then buy to cover("xs.prft") next bar stpv limit
 else if mkt then buy to cover("xs.prft.m") this bar c;
 
end;

{***************************}
{***************************}
fnkl = dru <= - funkl*nos;
fnks = dru <= - funks*nos;
{***************************}
{***************************}
if trade < 10 and engine then begin
 
 if not fnkl and marketposition < 1 and el then
  buy("el") next bar upb stop;
 
 if not fnks and marketposition > -1 and es then
  sell short("es") next bar lob stop;
 
end;
{***************************}
{***************************}
