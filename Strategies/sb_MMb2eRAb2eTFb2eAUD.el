{****** - MM. - ********
 Engine:    TF
 Author:    Matteo Mentella
 Portfolio: LUGANO
 Market:    DAX
 TimeFrame: 60 + 840 min.
 BackBars:  50
 Date:      17 Gen 2011
*************************************}
inputs: alphal(0.53),flenl(5),rngpctl(0.19),alphas(0.04),flens(33),rngpcts(.14),mnymngmnt(1);
inputs: stopl(100000),funkl(100000),tl(100000);
inputs: stops(100000),funks(100000),ts(100000);

vars: trendl(0,data2),triggerl(0,data2),cyclel(0,data2),fishl(0,data2);
vars: trends(0,data2),triggers(0,data2),cycles(0,data2),fishs(0,data2);

vars: engl(true,data2),engs(true,data2),entrylong(0,data2),entryshort(0,data2),engine(true);

vars: stpv(0),mkt(true),stp(true),trades(0),dru(0),fnkl(false),fnks(false),nos(1),bpv(1/bigpointvalue);
{*************************************}
{*************************************}
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

engine = 700 < t and t < 2300;
{*************************************}
{*************************************}
if mnymngmnt = 1 then begin
 
 if marketposition = 1 then begin
  
  //STOPLOSS
  stpv = entryprice - stopl*bpv;
  stp  = c > stpv;
  mkt  = c <= stpv;
  
  if stp then sell("xl.stpl") next bar stpv stop
  else if mkt then sell("xl.stpl.m") this bar c;
  
  //DAILY STOPLOSS
  stpv = c - (dru/nos + funkl)*bpv;
  stp  = c > stpv;
  mkt  = c <= stpv;
  
  if stp then sell("xl.funk") next bar stpv stop
  else if mkt then sell("xl.funk.m") this bar c;
  
  //TAKE PROFIT
  stpv = entryprice + tl*bpv;
  stp  = c < stpv;
  mkt  = c >= stpv;
  
  if stp then sell("xl.tp") next bar stpv limit
  else if mkt then sell("xl.tp.m") this bar c;
  
 end else if marketposition = -1 then begin
  
  //STOPLOSS
  stpv = entryprice + stops*bpv;
  stp  = c < stpv;
  mkt  = c >= stpv;
  
  if stp then buy to cover("xs.stpl") next bar stpv stop
  else if mkt then buy to cover("xs.stpl.m") this bar c;
  
  //DAILY STOPLOSS
  stpv = c + (dru/nos + funks)*bpv;
  stp  = c < stpv;
  mkt  = c >= stpv;
  
  if stp then buy to cover("xs.funk") next bar stpv stop
  else if mkt then buy to cover("xs.funk.m") this bar c;
  
  //TAKE PROFIT
  stpv = entryprice - ts*bpv;
  stp  = c > stpv;
  mkt  = c <= stpv;
  
  if stp then buy to cover("xs.tp") next bar stpv limit
  else if mkt then buy to cover("xs.tp.m") this bar c;
 
 end;
 
end;
{*************************************}
{*************************************}
fnkl = dru <= -funkl*nos;
fnks = dru <= -funks*nos;
{*************************************}
{*************************************}
if engine and trades < 1 then begin

 if not fnkl and marketposition < 1 and engl then
  buy next bar entrylong limit;
  
 if not fnks and marketposition > -1 and engs then
  sell short next bar entryshort limit;
  
end;
