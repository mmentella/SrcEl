{******* - MM.RA.TF.BUND(V2)-L - ******
 Engine:    TF
 Author:    Matteo Mentella
 Portfolio: RA
 Market:    BUND
 TimeFrame: 2 min + 14 h
 BackBars:  50
 Date:      
**************************************}
Inputs: nos(2),alphal(0.762),flenl(13),rngpctl(0.16),alphas(0.172),flens(9),rngpcts(.273),mnymngmnt(1);
Inputs: stopl(1350),stopdl(1200),modl(1200),tl(1700);

vars: trendl(0,data2),triggerl(0,data2),cyclel(0,data2),fishl(0,data2),engl(true,data2),entrylong(0,data2);
vars: trends(0,data2),triggers(0,data2),cycles(0,data2),fishs(0,data2),engs(true,data2),entryshort(0,data2);

vars: stpv(0),stpw(0),mkt(true),stp(true),mcp(0),trade(true),mp(0),yc(0),bpv(1/bigpointvalue);
vars: reason(0),position(0),stoploss(1),daystop(11),modal(2),target(22);
{**************************}
{**************************}
if d <> d[1] then begin
 trade = true; 
 yc    = c[1]; 
end;

mp = currentcontracts*marketposition;
if mp <> mp[1] then trade = false;
{**************************}
{**************************}
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
{**************************}
{**************************}
if mnymngmnt = 1 and marketposition <> 0 then begin
 
 if marketposition = 1 then begin
  
  //STOPLOSS
  stpw   = entryprice - (stopl - (slippage+commission))*bpv;
  reason = stoploss;
  
  //DAILY STOPLOSS
  stpv = yc - stopdl/bigpointvalue;
  
  if d > entrydate then begin
   if stpv > stpw then begin
    stpw   = stpv;
    reason = daystop;
   end;
  end;
  if d = 1110629 and t = 1014 then text_new(d,t,h,NumToStr(reason,0));
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
  
  stpw   = entryshort;
  reason = position;
  
  //PROFIT TARGET
  stpv = entryprice + (tl + (slippage+commission))*bpv;
  
  if stpv < stpw or not (trade and marketposition > -1 and engs and c < entryshort) then begin
   stpw   = stpv;
   reason = target;
  end;
  
  //MODAL EXIT
  stpv = entryprice + modl*bpv;
  
  if currentcontracts = nos and ( stpv < stpw or not (trade and marketposition > -1 and engs and c < entryshort) ) then begin
   stpw   = stpv;
   reason = modal;
  end;
  
  if reason <> position then begin
   
   stp = c <  stpw;
   mkt = c >= stpw;
   
   if reason = modal then begin
    if stp then sell("xl.mod") .5*nos shares next bar stpw limit
    else if mkt then sell("xl.mod.m") .5*nos shares this bar c;
   end else if reason = target then begin
    if stp then sell("xl.trgt") .5*nos shares next bar stpw limit
    else if mkt then sell("xl.trgt.m") .5*nos shares this bar c;
   end;
   
  end;
  
 end;
 
end;
{**************************}
{**************************}
if trade and marketposition < 1 and engl then begin
 if c <= entrylong then
  buy("el") nos shares next bar at market
 else
  buy("el.m") nos shares next bar at entrylong limit;
end;
if trade and marketposition > -1 and engs then begin
 if c >= entryshort then
  sell("xl") nos shares next bar at market
 else
  sell("xl.m") nos shares next bar at entryshort limit;
end;
{**************************}
{**************************}
