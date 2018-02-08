{****** - MM.RA.B.COPPER-L - ********
 Engine:    BOLLINGER
 Author:    Matteo Mentella
 Portfolio: RA
 Market:    HIGH GRADE COPPER
 TimeFrame: 60 min.
 BackBars:  50
 Date:      04 Lug 2011
**************************************}
inputs: lenl(11),kl(0.7);
inputs: stopl(1700000),funkl(212500),brkl(0375000),tl(2900000);

vars: upb(0),el(true),engine(true),nos(1);
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

engine = 700 < t  and t  < 2300;

if marketposition <> 0 and barssinceentry = 0 then begin
 trade = trade + 1;
 nos   = currentcontracts;
end;

dru = MM.DailyRunup;
mcp = MM.MaxContractProfit;
{***************************}
{***************************}
if 700 < t and t < 2300 then begin

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
  stpv = entryprice + 15*MinMove points;
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
  
 end;
end;
{***************************}
{***************************}
fnkl = dru <= - funkl*nos;
{***************************}
{***************************}
if trade < 1 and engine then begin
 
 if not fnkl and marketposition < 1 and el then
  buy("el") next bar upb stop;
 
end;
{***************************}
{***************************}
