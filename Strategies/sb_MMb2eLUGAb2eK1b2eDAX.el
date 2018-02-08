vars: id(0);

if currentbar > 1 then begin
 if d < 1120501 then begin
 
 
 {--------------------------}
 {--------------------------}
 
 {****** - MM. - ********
  Engine:    TF
  Author:    Matteo Mentella
  Portfolio: LUGANO
  Market:    DAX
  TimeFrame: 60 + 840 min.
  BackBars:  50
  Date:      17 Gen 2011
 *************************************}
vars: alphal(0.53),flenl(5),rngpctl(0.19),alphas(0.04),flens(33),rngpcts(.14),mnymngmnt(1);
vars: stopl(3000),funkl(2550),tl(4950);
vars: stops(2350),funks(3000),ts(4550);

vars: trendl(0,data2),triggerl(0,data2),cyclel(0,data2),fishl(0,data2);
vars: trends(0,data2),triggers(0,data2),cycles(0,data2),fishs(0,data2);

vars: engl(true,data2),engs(true,data2),entrylong(0,data2),entryshort(0,data2);

vars: stpv(0),mkt(true),stp(true),trades(0),dru(0),funk(false),nos(1);
{*************************************}
{*************************************}
if d <> d[1] then begin
 trades = 0;
 funk   = false;
end;

if marketposition <> 0 and barssinceentry = 0 then begin
 trades = trades + 1;
 nos = currentcontracts;
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
{*************************************}
{*************************************}
if mnymngmnt = 1 then begin
 
 if marketposition = 1 then begin
  
  //STOPLOSS
  stpv = entryprice - stopl/bigpointvalue;
  stp  = c > stpv;
  mkt  = c <= stpv;
  
  if stp then sell("xl.stpl") next bar stpv stop
  else if mkt then sell("xl.stpl.m") this bar c;
  
  //DAILY STOPLOSS
  stpv = c - (dru + funkl)/bigpointvalue;
  stp  = c > stpv;
  mkt  = c <= stpv;
  
  if stp then sell("xl.funk") next bar stpv stop
  else if mkt then sell("xl.funk.m") this bar c;
  
  //TAKE PROFIT
  stpv = entryprice + tl/bigpointvalue;
  stp  = c < stpv;
  mkt  = c >= stpv;
  
  if stp then sell("xl.tp") next bar stpv limit
  else if mkt then sell("xl.tp.m") this bar c;
  
 end else if marketposition = -1 then begin
  
  //STOPLOSS
  stpv = entryprice + stops/bigpointvalue;
  stp  = c < stpv;
  mkt  = c >= stpv;
  
  if stp then buy to cover("xs.stpl") next bar stpv stop
  else if mkt then buy to cover("xs.stpl.m") this bar c;
  
  //DAILY STOPLOSS
  stpv = c + (dru + funks)/bigpointvalue;
  stp  = c < stpv;
  mkt  = c >= stpv;
  
  if stp then buy to cover("xs.funk") next bar stpv stop
  else if mkt then buy to cover("xs.funk.m") this bar c;
  
  //TAKE PROFIT
  stpv = entryprice - ts/bigpointvalue;
  stp  = c > stpv;
  mkt  = c <= stpv;
  
  if stp then buy to cover("xs.tp") next bar stpv limit
  else if mkt then buy to cover("xs.tp.m") this bar c;
 
 end;
 
end;
{*************************************}
{*************************************}
funk = dru <= -minlist(funkl,funks)*nos;
{*************************************}
{*************************************}
if not funk and trades < 1 then begin

 if marketposition < 1 and engl then
  buy next bar entrylong limit;
  
 if marketposition > -1 and engs then
  sell short next bar entryshort limit;
  
end;

 
 {--------------------------}
 {--------------------------}
 
 
end else begin
 text_setlocation(id,d,t,c);
 text_setstring(id,"Periodo di Trading scaduto. Aggiornare la Licenza o contattare 'm.mentella@gmail.com'. " + 
                   "Potrebbero essere rimaste delle posizioni aperte in Banca.");
end;

end else begin
 id = text_new(d,t,c,"");
 text_setcolor(id,white);
 text_setsize(id,10);
 text_setstyle(id,1,1);
end;

