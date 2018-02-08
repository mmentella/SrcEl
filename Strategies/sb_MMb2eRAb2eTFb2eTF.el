{****** - MM. - ********
 Engine:    TF
 Author:    Matteo Mentella
 Portfolio: RA
 Market:    RUSSELL 2000 MINI FUTURE
 TimeFrame: 60 + 900 min.
 BackBars:  50
 Date:      11 Mar 2011
*************************************}
vars: alphtl(.17),alphcl(.53),rngpctl(.46),alphts(.13),alphcs(.34),rngpcts(.57);
inputs: stopl(100000),funkl(100000),tl(100000);
inputs: stops(100000),funks(100000),ts(100000);

vars: trendl(0,data2),triggerl(0,data2),cyclel(0,data2),el(true,data2),entrylong(0,data2);
vars: trends(0,data2),triggers(0,data2),cycles(0,data2),es(true,data2),entryshort(0,data2);
vars: trade(0),dru(0),fnkl(false),fnks(false),stpv(0),stp(true),mkt(false);
vars: bpv(1/bigpointvalue),nos(1);

if d <> d[1] then begin 
 trade = 0;
 fnkl  = false;
 fnks  = false;
end; 

if barstatus(2) = 2 then begin

 MM.ITrend(medianprice,alphtl,trendl,triggerl)data2;
 cyclel = MM.Cycle(medianprice,alphcl)data2;

 MM.ITrend(medianprice,alphts,trends,triggers)data2;
 cycles = MM.Cycle(medianprice,alphcs)data2;
 
 el = triggerl > trendl and cyclel > cyclel[1];
 es = triggers > trends and cycles > cycles[1];
 
 entrylong = c data2 - rngpctl*(h data2 - l data2);
 entryshort = c data2 + rngpcts*(h data2 - l data2);
 
end;
 
if marketposition <> 0 and barssinceentry = 0 then begin
 trade = trade + 1;
 nos   = currentcontracts;
end;
 
dru = MM.DailyRunup;
 
if marketposition <> 0 and 700 < t and t < 2300 then begin
 
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
     
 end else begin
  
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
 
fnkl = dru <= -funkl*nos;
fnks = dru <= -funks*nos;

if 1000 < t and t < 2200 and trade < 1 then begin

 if not fnkl and marketposition < 1 and el then
  buy next bar entrylong limit;
 
 if not fnks and marketposition > -1 and es then
  sell short next bar entryshort limit;
 
end;
