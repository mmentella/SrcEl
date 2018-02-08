{****** - MM.RA.TF.MINISP(V2) - ******
 Engine:    TF
 Author:    Matteo Mentella
 Portfolio: RA
 Market:    mini S&PP 500
 TimeFrame: 2 + 15 ore - Sessione 08:00 / 22:15
 BackBars:  50
 Date:      25 Lug 2011
 Update:    
*************************************}
inputs: alphal(0.50),flenl(22),rngpctl(0.06);
inputs: alphas(0.89),flens(49),rngpcts(1.00);
inputs: stopl(1900),funkl(1700),tl(4700);
inputs: stops(1800),funks(2000),ts(1600);

vars: trendl(0,data2),triggerl(0,data2),cyclel(0,data2),fishl(0,data2);
vars: trends(0,data2),triggers(0,data2),cycles(0,data2),fishs(0,data2);

vars: engl(true,data2),engs(true,data2),entrylong(0,data2),entryshort(0,data2),engine(true);

vars: mp(0),trades(0),intra(false),dru(0),fnkl(false),fnks(false),nos(1),bpv(1/bigpointvalue);
vars: stpv(0),mkt(true),stp(true),stpw(0),reason(0),position(0),stoploss(10),daystop(11),target(20);
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

mp = marketposition;
if mp <> mp[1] then intra = true;
if mod(t,100) = 0 then intra = false;

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

engine = 800 < t and t < 900 or 1658 < t;
{*************************************}
{*************************************}
 
 if marketposition = 1 then begin
  
  //STOPLOSS
  reason = stoploss;
  stpw   = entryprice - stopl*bpv;
    
  //DAILY STOPLOSS
  stpv = c - (dru/nos + funkl)*bpv;
  
  if stpv > stpw then begin
   reason = daystop;
   stpw   = stpv;
  end;
  
  stp = c >  stpw;
  mkt = c <= stpw;
  
  if reason = stoploss then begin
   if stp then sell("xl.stp") next bar stpw stop
   else if mkt then sell("xl.stp.m") this bar c;
  end else begin
   if stp then sell("xl.stpd") next bar stpw stop
   else if mkt then sell("xl.stpd.m") this bar c;
  end;
  
  reason = position;
  stpw   = entryshort;
  
  //TAKE PROFIT
  stpv = entryprice + tl*bpv;
  
  if stpv < stpw then begin
   reason = target;
   stpw   = stpv;
  end;
  
  if reason = target then begin
   stp = c <  stpw;
   mkt = c >= stpw;
   
   if stp then sell("xl.trgt") next bar stpw limit
   else if mkt then sell("xl.trgt.m") this bar c;
  end;
  
 end else if marketposition = -1 then begin
  
  //STOPLOSS
  reason = stoploss;
  stpw   = entryprice + stops*bpv;
    
  //DAILY STOPLOSS
  stpv = c + (dru/nos + funks)*bpv;
  
  if stpv < stpw then begin
   reason = daystop;
   stpw   = stpv;
  end;
  
  stp = c <  stpw;
  mkt = c >= stpw;
  
  if reason = stoploss then begin
   if stp then buy to cover("xs.stp") next bar stpw stop
   else if mkt then buy to cover("xs.stp.m") this bar c;
  end else begin
   if stp then buy to cover("xs.stpd") next bar stpw stop
   else if mkt then buy to cover("xs.stpd.m") this bar c;
  end;
  
  reason = position;
  stpw   = entrylong;
  
  //TAKE PROFIT
  stpv = entryprice - ts*bpv;
  
  if stpv > stpw then begin
   reason = target;
   stpw   = stpv;
  end;
  
  if reason = target then begin
   stp = c >  stpw;
   mkt = c <= stpw;
   
   if stp then buy to cover("xs.trgt") next bar stpw limit
   else if mkt then buy to cover("xs.trgt.m") this bar c;
  end;
 
 end;
 
{*************************************}
{*************************************}
fnkl = dru <= -funkl*nos;
fnks = dru <= -funks*nos;
{*************************************}
{*************************************}
if engine and trades < 1 then begin

 if not intra and not fnkl and marketposition < 1 and engl then
  buy next bar entrylong limit;
 
 if not fnks and marketposition > -1 and engs then
  sell short next bar entryshort limit;
  
end;
