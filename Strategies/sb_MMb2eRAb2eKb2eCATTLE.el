{****** - MM.DICICCO.CATTLE - ********
 Engine:    KELTNER
 Author:    Matteo Mentella
 Portfolio: RA
 Market:    CATTLE
 TimeFrame: 60 min.
 BackBars:  50
 Date:      14 Giu 2011
**************************************}
inputs: lenl(28),kl(2.2),lens(13),ks(4.5);
inputs: stopl(1000),funkl(900),brkl(1050),tl(1600);
inputs: stops(1400),funks(1400),brks(650),ts(1800);

vars: upk(0),lok(0),el(true),es(true),engine(true),nos(1);
vars: trade(0),fnkl(false),fnks(false),stpv(0),stp(true),mkt(true);
vars: maxstp(0),minstp(0),settle(false),mcp(0),dru(0),bpv(1/bigpointvalue);
{***************************}
{***************************}
if d <> d[1] then begin
 trade  = 0;
 fnkl   = false;
 fnks   = false;
 settle = false;
end;

if not settle and t >= 2000 then begin
 settle = true;
 maxstp = c + 3;
 minstp = c - 3;
end;
{***************************}
{***************************}
upk = KeltnerChannel(h,lenl,kl);
lok = KeltnerChannel(l,lens,-ks);

el = c < upk;
es = c > lok;

engine = 700 < t  and t  < 2300;

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
 stp  = c > stpv and stpv > minstp;
 mkt  = c <= stpv;
 
 if stp then sell("xl.stp") next bar stpv stop
 else if mkt then sell("xl.stp.m") this bar c;
 
 //DAILY STOP
 stpv = c - (dru/nos + funkl)*bpv;
 stp  = c > stpv and stpv > minstp;
 mkt  = c <= stpv;
 
 if stp then sell("xl.funk") next bar stpv stop
 else if mkt then sell("xl.funk.m") this bar c;
 
 //BREAKEVEN
 stpv = entryprice + (15 points)*MinMove;
 stp  = mcp > brkl*bpv and c > stpv and stpv > minstp;
 mkt  = mcp > brkl*bpv and c <= stpv;
 
 if stp then sell("xl.brk") next bar stpv stop
 else if mkt then sell("xl.brk.s") this bar c;
 
 //PROFIT TARGET
 stpv = entryprice + tl*bpv;
 stp  = c < stpv and stpv < maxstp;
 mkt  = c >= stpv;
 
 if stp then sell("xl.prft") next bar stpv limit
 else if mkt then sell("xl.prft.m") this bar c;
 
end else if marketposition = -1 then begin
 
 //STOPLOSS
 stpv = entryprice + stops*bpv;
 stp  = c < stpv and stpv < maxstp;
 mkt  = c >= stpv;
 
 if stp then buy to cover("xs.stp") next bar stpv stop
 else if mkt then buy to cover("xs.stp.m") this bar c;
 
 //DAILY STOP
 stpv = c + (dru/nos + funks)*bpv;
 stp  = c < stpv and stpv < maxstp;
 mkt  = c >= stpv;
 
 if stp then buy to cover("xs.funk") next bar stpv stop
 else if mkt then buy to cover("xs.funk.m") this bar c;
 
 //BREAKEVEN
 stpv = entryprice - (15 points)*MinMove;
 stp  = mcp > brks*bpv and c < stpv and stpv < maxstp;
 mkt  = mcp > brks*bpv and c >= stpv;
 
 if stp then buy to cover("xs.brk") next bar stpv stop
 else if mkt then buy to cover("xs.brk.s") this bar c;

 //PROFIT TARGET
 stpv = entryprice - ts*bpv;
 stp  = c > stpv and stpv > minstp;
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
if trade < 1 and engine then begin
 
 if not fnkl and marketposition < 1 and el then
  buy("el") next bar upk stop;
 
 if not fnks and marketposition > -1 and es then
  sell short("es") next bar lok stop;
 
end;
{***************************}
{***************************}
