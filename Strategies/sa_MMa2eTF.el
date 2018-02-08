vars: id(0);

if currentbar > 1 then begin
 if d < 1120501 then begin
 
 
{--------------------------}
{--------------------------}

{********** - MM.TF.    - ************
 Engine:    TF
 Author:    Matteo Mentella - matteo.mentella@ingpec.eu
 Portfolio: 
 Market:    
 TimeFrame: 60 + 720 min.
 BackBars:  50
 Date:      24 Mag 2011
*************************************}
Inputs: alphal(0.07),flenl(8),rngpctl(0.1);
Inputs: alphas(0.07),flens(8),rngpcts(0.1);
vars: stopl(100000),funkl(100000),tl(100000);
vars: stops(100000),funks(100000),ts(100000);

vars: trndl(0,data2),trgrl(0,data2),cyclel(0,data2),fishl(0,data2);
vars: trnds(0,data2),trgrs(0,data2),cycles(0,data2),fishs(0,data2);

vars: engl(true,data2),engs(true,data2),entrylong(0,data2),entryshort(0,data2);

vars: stpv(0),mkt(true),stp(true),trades(0),dru(0),fnkl(false),fnks(false);
vars: bpv(1/bigpointvalue),nos(1),nos_1(1);
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
 nos_1  = 1/currentcontracts;
end;

dru = MM.DailyRunup;
{*************************************}
{*************************************}
if barstatus(2) = 2 then begin
 
 MM.ITrend(medianprice,alphal,trndl,trgrl)data2;
 cyclel = MM.Cycle(medianprice,alphal)data2;
 fishl  = MM.FisherTransform(cyclel,flenl,true)data2;
 
 MM.ITrend(medianprice,alphas,trnds,trgrs)data2;
 cycles = MM.Cycle(medianprice,alphas)data2;
 fishs  = MM.FisherTransform(cycles,flens,true)data2;
 
 engl = fishl > fishl[1] and trgrl > trndl;
 engs = fishs < fishs[1] and trgrs < trnds;
 
 entrylong  = c data2 - rngpctl*(h data2 - l data2);
 entryshort = c data2 + rngpcts*(h data2 - l data2);
 
end;
{*************************************}
{*************************************}
if marketposition = 1 then begin
  
 //STOPLOSS
 stpv = entryprice - stopl*bpv;
 stp  = c > stpv;
 mkt  = c <= stpv;
 
 if stp then sell("xl.stpl") next bar stpv stop
 else if mkt then sell("xl.stpl.m") this bar c;
 
 //DAILY STOPLOSS
 stpv = c - (dru*nos_1 + funkl)*bpv;
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
 stpv = c + (dru*nos_1 + funks)*bpv;
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
{*************************************}
{*************************************}
fnkl = dru <= -funkl * nos;
fnks = dru <= -funks * nos;
{*************************************}
{*************************************}
if trades < 1 then begin

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

