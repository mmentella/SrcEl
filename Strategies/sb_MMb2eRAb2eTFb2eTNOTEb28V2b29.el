{******* - MM.RA.TF.TNOTE(V2) - *******
 Engine:    TF
 Author:    Matteo Mentella
 Portfolio: RA
 Market:    T-NOTE
 TimeFrame: 2 + 1410 min.
 Session 1: 08:00 - 23:00
 Session2:  00:30 - 23:00 (Default)
 BackBars:  50
 Date:      13 Ago 2011
**************************************}
{*************************************}
{*************************************}
input: alphal(0.15),flenl(20),rngpctl(0.16);
input: alphas(0.21),flens(17),rngpcts(0.92);

input: mnymngmnt(1);

input: stopl(3000),funkl(3000)           ,tl(3900);
input: stops(2000),funks(1300),brks(1250),ts(4350);

var: trendl(0,data2),triggerl(0,data2),cyclel(0,data2),fishl(0,data2),engl(true,data2),entrylong(0,data2);
var: trends(0,data2),triggers(0,data2),cycles(0,data2),fishs(0,data2),engs(true,data2),entryshort(0,data2);

vars: stpv(0),mkt(true),stp(true),trade(0),dru(0),mcp(0),fnkl(false),fnks(false),bpv(1/bigpointvalue),nos(1);
{*************************************}
{*************************************}
if d <> d[1] then begin  
 trade = 0;
 fnkl  = false;
 fnks  = false;
end;
{*************************************}
{*************************************}
if barstatus(2) = 2 then begin
 
 MM.ITrend(medianprice,alphal,trendl,triggerl)data2;
 cyclel = MM.Cycle(medianprice,alphal)data2;
 fishl  = MM.FisherTransform(cyclel,flenl,true)data2;
 
 MM.ITrend(medianprice,alphas,trends,triggers)data2;
 cycles = MM.Cycle(medianprice,alphas)data2;
 fishs  = MM.FisherTransform(cycles,flens,true)data2;
 
 engl = fishl > fishl[1] and triggerl > trendl;
 engs = fishs < fishs[1] and triggers < trends;
 
 entrylong  = c data2 - rngpctl*(h data2 - l data2);
 entryshort = c data2 + rngpcts*(h data2 - l data2);
 
end; 

dru = MM.DailyRunup;
mcp = MM.MaxContractProfit;
{*************************************}
{*************************************}
if mnymngmnt = 1 then begin

if marketposition <> 0 then begin
 
 if barssinceentry = 0 then begin
  trade = trade + 1;
  nos   = currentcontracts;
 end;

 if marketposition = 1 then begin
  
  //STOPLOSS
  stpv = entryprice - stopl*bpv;
  stp  = c > stpv;
  mkt  = c <= stpv;
  
  if stp then sell("xl.stp") next bar stpv stop
  else if mkt then sell("xl.stp.m") this bar c;
  
  //DAILY STOPLOSS
  stpv = c - (dru + funkl*currentcontracts)*bpv;
  stp  = c > stpv;
  mkt  = c <= stpv;
   
  if stp then sell("xl.funk") next bar stpv stop
  else if mkt then sell("xl.funk.m") this bar c;
  
  //PROFIT TARGET
  stpv = entryprice + tl*bpv;
  stp  = c < stpv;
  mkt  = c >= stpv;
  
  if stp then sell("xl.trgt") next bar stpv limit
  else if mkt then sell("xl.trgt.m") this bar c;
  
 end else begin
  
  //STOPLOSS
  stpv = entryprice + stops*bpv;
  stp  = c < stpv;
  mkt  = c >= stpv;
  
  if stp then buy to cover("xs.stp") next bar stpv stop
  else if mkt then buy to cover("xs.stp.m") this bar c;
  
  //DAILY STOPLOSS
  stpv = c + (dru + funks*currentcontracts)*bpv;
  stp  = c < stpv;
  mkt  = c >= stpv;
   
  if stp then buy to cover("xs.funk") next bar stpv stop
  else if mkt then buy to cover("xs.funk.m") this bar c;
  
  //BREAKEVEN
  stpv = entryprice - 10*MinMove points;
  stp  = mcp > brks*bpv and c < stpv;
  mkt  = mcp > brks*bpv and c >= stpv;
  
  if stp then buy to cover("xs.brk") next bar stpv stop
  else if mkt then buy to cover("xs.brk.m") this bar c;
  
  //PROFIT TARGET
  stpv = entryprice - ts*bpv;
  stp  = c > stpv;
  mkt  = c <= stpv;
  
  if stp then buy to cover("xs.trgt") next bar stpv limit
  else if mkt then buy to cover("xs.trgt.m") this bar c;

 end;
 
end;

end;
{*************************************}
{*************************************}
fnkl = dru <= -funkl*nos;
fnks = dru <= -funks*nos;
{*************************************}
{*************************************}
if trade = 0 then begin
 if not fnkl and marketposition < 1 and engl then
  buy("el") next bar entrylong limit; 
if not fnks and marketposition > -1 and engs then
 sellshort("es") next bar entryshort limit;
end;
