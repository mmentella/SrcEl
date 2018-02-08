vars: id(0);

if currentbar > 1 then begin
 if d < 1120601 then begin
 
 
 {--------------------------}
 {--------------------------}
 
 {****** - MM.LUGA.GILT - ********
  Engine:    TF
  Author:    Matteo Mentella
  Portfolio: LUGANO
  Market:    GILT
  TimeFrame: 60 + 600 min.
  BackBars:  50
  Date:      29 Apr 2011
 *************************************}
Inputs: alphal(0.55),flenl(2),rngpctl(0.92),alphas(0.02),flens(42),rngpcts(.43);
vars: stopl(100000),funkl(100000),tl(100000);
vars: stops(100000),funks(100000),ts(100000);

vars: trendl(0),triggerl(0),cyclel(0),fishl(0);
vars: trends(0),triggers(0),cycles(0),fishs(0);

vars: engl(true),engs(true),entrylong(0),entryshort(0);

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
 
 MM.ITrend(medianprice,alphal,trendl,triggerl);
 cyclel = MM.Cycle(medianprice,alphal);
 fishl  = MM.FisherTransform(cyclel,flenl,true);
 
 MM.ITrend(medianprice,alphas,trends,triggers);
 cycles = MM.Cycle(medianprice,alphas);
 fishs  = MM.FisherTransform(cycles,flens,true);
 
 engl = fishl > fishl[1] and triggerl > trendl;
 engs = fishs < fishs[1] and triggers < trends;
 
 entrylong  = c  - rngpctl*(h  - l );
 entryshort = c  + rngpcts*(h  - l ); 
{
{*************************************}
{*************************************} 
 if marketposition = 1 then begin
  
  //STOPLOSS
  stpv = entryprice - stopl * bpv;
  stp  = c > stpv;
  mkt  = c <= stpv;
  
  if stp then sell("xl.stpl") next bar stpv stop
  else if mkt then sell("xl.stpl.m") this bar c;
  
  //DAILY STOPLOSS
  stpv = c - (dru + funkl*nos) * bpv;
  stp  = c > stpv;
  mkt  = c <= stpv;
  
  if stp then sell("xl.funk") next bar stpv stop
  else if mkt then sell("xl.funk.m") this bar c;
  
  //TAKE PROFIT
  stpv = entryprice + tl * bpv;
  stp  = c < stpv;
  mkt  = c >= stpv;
  
  if stp then sell("xl.tp") next bar stpv limit
  else if mkt then sell("xl.tp.m") this bar c;
  
 end else if marketposition = -1 then begin
  
  //STOPLOSS
  stpv = entryprice + stops * bpv;
  stp  = c < stpv;
  mkt  = c >= stpv;
  
  if stp then buy to cover("xs.stpl") next bar stpv stop
  else if mkt then buy to cover("xs.stpl.m") this bar c;
  
  //DAILY STOPLOSS
  stpv = c + (dru + funks*nos) * bpv;
  stp  = c < stpv;
  mkt  = c >= stpv;
  
  if stp then buy to cover("xs.funk") next bar stpv stop
  else if mkt then buy to cover("xs.funk.m") this bar c;
  
  //TAKE PROFIT
  stpv = entryprice - ts * bpv;
  stp  = c > stpv;
  mkt  = c <= stpv;
  
  if stp then buy to cover("xs.tp") next bar stpv limit
  else if mkt then buy to cover("xs.tp.m") this bar c;
 
 end;
{*************************************}
{*************************************}
fnkl = dru <= - funkl * nos;
fnks = dru <= - funks * nos;
{*************************************}
{*************************************}}
if trades < 100 then begin

 if not fnkl and marketposition < 1 and engl then
  buy next bar entrylong limit;
  
 if not fnks and marketposition > -1 and engs then
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
