Inputs: nos(2),alphal(0.395),flenl(10),rngpctl(0.342),alphas(0.02),flens(15),rngpcts(.278),mnymngmnt(1);
Inputs: stopl(2000),stopdl(850 ),modl(1700),tld(3600),tl(4800);

vars: trendl(0,data2),triggerl(0,data2),cyclel(0,data2),fishl(0,data2),trends(0,data2),triggers(0,data2),cycles(0,data2),fishs(0,data2);
vars: engl(true,data2),engs(true,data2),entrylong(0,data2),entryshort(0,data2);
vars: stpv(0),minstop(-1),maxstop(999999),mkt(true),stp(true),mcp(0),trade(true),mp(0),yc(0);

vars: short1(true), stpw(0),reason(0),position(0),stoploss(10),daystop(11),modal(20),target(21),daytarget(22);

if d <> d[1] then begin trade = true; yc = c[1]; end;
mp = currentcontracts*marketposition;
if mp <> mp[1] then trade = false;

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

mcp = MM.MaxContractProfit;

short1 = 800 < t and t < 2245 and trade and marketposition > 0 and engs;

if mnymngmnt = 1 and marketposition <> 0 and 800 < t and t < 2250 then begin
 
 if marketposition = 1 then begin
  
  //STOPLOSS
  reason = stoploss;
  stpw   = entryprice - (stopl - (slippage+commission))/bigpointvalue;
    
  //DAILY STOPLOSS
  stpv = yc - stopdl/bigpointvalue;
    
  if d > entrydate and stpv > stpw then begin
   reason = daystop;
   stpw   = stpv;
  end;
  
  stp = c >  stpw;
  mkt = c <= stpw;
  
  if reason = stoploss then begin
   if stp then sell("xl.stp") next bar stpw stop
   else if mkt then sell("xl.stp.m") this bar c;
  end else
  if reason = daystop then begin
   if stp then sell("xl.stpd") next bar stpw stop
   else if mkt then sell("xl.stpd.m") this bar c;
  end;
  
  reason = position;
  stpw   = entryshort;
  
  //MODAL EXIT
  stpv = entryprice + modl/bigpointvalue;
  
  if short1 and currentcontracts = nos and stpv < stpw then begin
   reason = modal;
   stpw   = stpv;
  end else if currentcontracts = nos then begin
   reason = modal;
   stpw   = stpv;
  end;
  
  //PROFIT TARGET
  stpv = entryprice + (tl + (slippage+commission))/bigpointvalue;
  
  if currentcontracts = .5*nos and stpv < stpw then begin
   reason = target;
   stpw   = stpv;
  end;  
  
  //DAILY PROFIT TARGET
  stpv = yc + tld/bigpointvalue;
  
  if d > entrydate and stpv < stpw then begin
   reason = daystop;
   stpw   = stpv;
  end;
  
  if reason > position then begin
   
   stp = c <  stpw;
   mkt = c >= stpw;
   
   if reason = modal then begin
    if stp then sell("xl.mod") .5*nos shares next bar stpw limit
    else if mkt then sell("xl.mod.m") .5*nos shares this bar c;
   end else
   if reason = target then begin
    if stp then sell("xl.trgt") .5*nos shares next bar stpw limit
    else if mkt then sell("xl.trgt.m") .5*nos shares this bar c;
   end else
   if reason = daytarget then begin
    if stp then sell("xl.trgtd") next bar stpw limit
    else if mkt then sell("xl.trgtd.m") this bar c;
   end;
  end;
  
 end;
 
end;

if 800 < t and t < 2245 then begin
 if trade and marketposition < 1 and engl then buy nos shares next bar at entrylong limit; 
 if trade and marketposition > 0 and engs then sell nos shares next bar at entryshort limit;
end;
