{********* - MM.TF.SCHATZ - **********
 Engine:    TF
 Author:    Matteo Mentella
 Portfolio: 1000
 Market:    SCHATZ
 TimeFrame: 2 min. / 14 ore
 BackBars:  50
 Date:      26 Gen 2011
**************************************}
{*************************************}
{*************************************}
vars: alphal(.70),flenl(29),rngpctl(.09);
vars: alphas(.76),flens(42),rngpcts(.36),mnymngmnt(1);
Inputs: stopl(435),funkl(165),tl(520);
Inputs: stops(215),funks(150),ts(510);

vars: trendl(0,data2),triggerl(0,data2),cyclel(0,data2),fishl(0,data2),engl(true,data2),entrylong(0,data2);
vars: trends(0,data2),triggers(0,data2),cycles(0,data2),fishs(0,data2),engs(true,data2),entryshort(0,data2);
vars: stopval(0),mkt(true),stp(true),dru(0),trade(true),fnkl(false),fnks(false),nos(1);
{*************************************}
{*************************************}
if d <> d[1] then begin
 trade = true; 
 fnkl  = false; 
 fnks  = false; 
end;

if marketposition <> 0 and barssinceentry = 0 then begin
 trade = false;
 nos   = currentcontracts;
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
{*************************************}
{*************************************}
if mnymngmnt = 1 and marketposition <> 0 then begin
 
 setstopshare;
 
 if marketposition = 1 then begin
  
  //STOPLOSS
  stopval = entryprice - stopl/bigpointvalue;
  stp     = c > stopval;
  mkt     = c <= stopval;
  
  if stp then setstoploss(stopl);
  if mkt then sell("xl.stpls") next bar at market;
  
  //DAILY STOPLOSS
  stopval = c - (dru/nos + funkl)/bigpointvalue;
  stp     = c > stopval;
  mkt     = c <= stopval;
  
  if d > entrydate then begin
   if stp then sell("xl.stpd") next bar at stopval stop;
   if mkt then sell("xl.stpd.m") next bar at market;
  end;
  
  //PROFIT TARGET
  stopval = entryprice + tl/bigpointvalue;
  stp     = c < stopval;
  mkt     = c >= stopval;
  
  if stp then setprofittarget(tl);
  if mkt then sell("xl.prftrgt") next bar at market;
  
 end else begin
  
  //STOPLOSS
  stopval = entryprice + stops/bigpointvalue;
  stp     = c < stopval;
  mkt     = c >= stopval;
  
  if stp then setstoploss(stops);
  if mkt then buytocover("xs.stpls") next bar at market;
  
  //DAILY STOPLOSS
  stopval = c + (dru + funks * nos)/bigpointvalue;
  stp     = c < stopval;
  mkt     = c >= stopval;
  
  if d > entrydate then begin
   if stp then buytocover("xs.stpd") next bar at stopval stop;
   if mkt then buytocover("xs.stpd.m") next bar at market;
  end;
  
  //PROFIT TARGET
  stopval = entryprice - ts/bigpointvalue;
  stp     = c > stopval;
  mkt     = c <= stopval;
  
  if stp then setprofittarget(ts);
  if mkt then buytocover("xs.prftrgt") next bar at market;

 end;
 
end;
{*************************************}
{*************************************}
fnkl = dru <= -funkl * nos;
fnks = dru <= -funks * nos;
{*************************************}
{*************************************}
if trade then begin
 if not fnkl and marketposition < 1 and engl then
  buy next bar entrylong limit; 
if not fnks and marketposition > -1 and engs then
 sellshort next bar entryshort limit;
end;
