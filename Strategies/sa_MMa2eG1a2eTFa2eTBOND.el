{********* - MM.G1.TF.TBOND - **********
 Engine:    TF
 Author:    Matteo Mentella
 Portfolio: G1
 Market:    TBOND
 TimeFrame: 54 min. / 270 min.
 BackBars:  50
 Date:      14 Gen 2011
**************************************}
{*************************************}
{*************************************}
Inputs: alphal(0.06),flenl(17),rngpctl(0.3),alphas(0.07),flens(8),rngpcts(.1),mnymngmnt(0),sod(700),eod(2300);
Inputs: stopl(100000),funkl(100000),modl(100000),tl(100000);
Inputs: stops(100000),funks(100000),mods(100000),ts(100000);

vars: trndl(0,data2),trgl(0,data2),cycl(0,data2),fishl(0,data2),el(0,data2),golong(true,data2);
vars: trnds(0,data2),trgs(0,data2),cycs(0,data2),fishs(0,data2),es(0,data2),goshort(true,data2);
vars: trades(0),stpv(0),stp(true),mkt(true),dru(0),funk(false);
{*************************************}
{*************************************}
if d <> d[1] then begin 
 trades = 0;
 funk   = false;
end;

if marketposition  <> 0 and barssinceentry = 0 then trades = trades + 1;

dru = MM.DailyRunup;
{*************************************}
{*************************************}
if barstatus(2) = 2 then begin
 
 //MM.ITrend(medianprice,alphal,trndl,trgl)data2;
 cycl = MM.Cycle(medianprice,alphal)data2;
 fishl  = MM.FisherTransform(cycl,flenl,true)data2;
 
 //MM.ITrend(medianprice,alphas,trnds,trgs)data2;
 cycs = MM.Cycle(medianprice,alphas)data2;
 fishs  = MM.FisherTransform(cycs,flens,true)data2;
 
 golong  = fishl > fishl[1] {and trgl > trndl};
 goshort = fishs < fishs[1] {and trgs < trnds};
 
 el  = c data2 - rngpctl*(h data2 - l data2);
 es = c data2 + rngpcts*(h data2 - l data2);
 
end;
{*************************************}
{*************************************}
if mnymngmnt = 1 and 700 < t and t < 2300 and marketposition <> 0 then begin
 
 if marketposition = 1 then begin
  
  //FUNKL
  stpv = c - (dru + funkl)/bigpointvalue;
  stp  = c > stpv;
  mkt  = c < stpv;
  
  if stp then sell("xl.funk") next bar stpv stop
  else if mkt then sell("xl.funk.m") this bar c; 
  
 end else begin
  
  
 end;
 
end;
{*************************************}
{*************************************}
funk = dru <= -minlist(funkl,funks);
{*************************************}
{*************************************}
if not funk and trades < 1 and sod < t and t < eod then begin
 
 if golong and marketposition < 1 then begin
  stp = c > el;
  mkt = c < el;
  
  if stp then buy("el") next bar el limit
  else if mkt then buy("el.m") this bar c;
 end;
 
 if goshort and marketposition > -1 then begin
  stp = c < es;
  mkt = c > es;
  
  if stp then sell short("es") next bar es limit
  else if mkt then sell short("es.m") this bar c;
 end;
end;
{*************************************}
{*************************************}
