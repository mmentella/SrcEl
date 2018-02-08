{****** - MM.RA.TF.DAX(V2)-L - *******
 Engine:    TF
 Author:    Matteo Mentella
 Portfolio: RA
 Market:    DAX
 TimeFrame: 2 min. / 840 min.
 BackBars:  50
 Date:      17 Gen 2011
 Update:    12 Lug 2011
**************************************}
Inputs: alphal(0.53),flenl(5),rngpctl(0.19);
Inputs: alphas(0.04),flens(33),rngpcts(.14);
Inputs: stopl(3000),funkl(2550),tl(4950);

vars: trendl(0,data2),triggerl(0,data2),cyclel(0,data2),fishl(0,data2),engl(true,data2),entrylong(0,data2);
vars: trends(0,data2),triggers(0,data2),cycles(0,data2),fishs(0,data2),engs(true,data2),entryshort(0,data2);

vars: stpv(0),stpw(0),mkt(true),stp(true),trades(0),dru(0),funk(false);
vars: reason(0),position(0),stoploss(1),daystop(11),target(2);
{*************************************}
{*************************************}
if d <> d[1] then begin
 trades = 0;
 funk   = false;
end;

if marketposition <> 0 and barssinceentry = 0 then trades = trades + 1;

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
{*************************************}
{*************************************}
if marketposition = 1 then begin
 
 //STOPLOSS
 stpw   = entryprice - stopl/bigpointvalue;
 reason = stoploss;
 
 //DAILY STOPLOSS
 stpv = c - (dru + funkl)/bigpointvalue;
 
 if stpv > stpw then begin
  reason = daystop;
  stpw   = stpv;
 end;
 
 if reason <> position then begin
  
  stp = c >  stpw;
  mkt = c <= stpw;
  
  if reason = stoploss then begin
   if stp then sell("xl.stp") next bar stpw stop
   else if mkt then sell("xl.stp.m") this bar c;
  end else
  if reason = daystop then begin
   if stp then sell("xl.funk") next bar stpw stop
   else if mkt then sell("xl.funk.m") this bar c;
  end;
  
 end;
 
 reason = position;
 stpw   = entryshort;  
 
 //TAKE PROFIT
 stpv = entryprice + tl/bigpointvalue;
 
 if stpv < stpw or not ( not funk and trades < 1 and engs) then begin
  stpw   = stpv;
  reason = target;
 end;
 
 if reason <> position then begin
  
  stp = c <  stpw;
  mkt = c >= stpw;
  
  if stp then sell("xl.trgt") next bar stpw limit
  else if mkt then sell("xl.trgt.m") this bar c;
  
 end;
 
end;
{*************************************}
{*************************************}
funk = dru <= -funkl;
{*************************************}
{*************************************}
if not funk and trades < 1 then begin

 if marketposition < 1 and engl then
  buy next bar entrylong limit;
  
 if marketposition = 1 and engs then
  sell next bar entryshort limit;
  
end;
