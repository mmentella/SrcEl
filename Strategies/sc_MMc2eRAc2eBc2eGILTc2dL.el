{****** - MM.RA.B.GOLD - ********
 Engine:    BOLLINGER
 Author:    Matteo Mentella
 Portfolio: RA
 Market:    LONG GILT
 TimeFrame: 60 min.
 BackBars:  50
 Date:      20 Giu 2011
**************************************}
inputs: lenl(22),kl(4.2);
inputs: stopl(1300),funkl(1350),brkl(2000),tl(2800);

vars: upb(0),el(true),nos(1);
vars: trade(0),fnkl(false),stpv(0),stp(true),mkt(true);
vars: mcp(0),dru(0),bpv(1/bigpointvalue);
{***************************}
{***************************}
if d <> d[1] then begin
 trade  = 0;
 fnkl   = false;
end;
{***************************}
{***************************}
upb = BollingerBand(h,lenl,kl);

el = c < upb;

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
 stpv = entryprice + (15 points)*MinMove;
 stp  = mcp > brkl*bpv and c > stpv;
 mkt  = mcp > brkl*bpv and c <= stpv;
 
 if stp then sell("xl.brk") next bar stpv stop
 else if mkt then sell("xl.brk.m") this bar c;
 
 //PROFIT TARGET
 stpv = entryprice + tl*bpv;
 stp  = c < stpv;
 mkt  = c >= stpv;
 
 if stp then sell("xl.prft") next bar stpv limit
 else if mkt then sell("xl.prft.m") this bar c;
 
end;
{***************************}
{***************************}
fnkl = dru <= - funkl*nos;
{***************************}
{***************************}
if trade < 1 then begin
 
 if not fnkl and marketposition < 1 and el then
  buy("el") next bar upb stop;
 
end;
{***************************}
{***************************}
