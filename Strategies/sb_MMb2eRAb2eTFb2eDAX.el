{****** - MM.RA.TF.DAX - ********
 Engine:    TF
 Author:    Matteo Mentella
 Portfolio: RA
 Market:    DAX FUTURES
 TimeFrame: 1 min + 14 h
 Session1:  08:00 - 22:00
 Session2:  08:00 - 22:00
 BackBars:  50
 Date:      29 Set 2011
*************************************}
input: alphal(.55),flenl(11),rngpctl(.5);
input: alphas(.28),flens(07),rngpcts(.9);

input: stopl(1150),funkl(2450),brkl(2650),tl(06300);
input: stops(1700),funks(1900){,brks(100000)},ts(13750);

var: trendl(0,data2),trigl(0,data2),cycl(0,data2),fishl(0,data2),el(true,data2),fillL(0,data2);
var: trends(0,data2),trigs(0,data2),cycs(0,data2),fishs(0,data2),es(true,data2),fillS(0,data2);

var: trade(0),orderL(false),orderS(false),dru(0),mcp(0),fnkl(false),fnks(false),nos(1),bpv(1/bigpointvalue);

var: stpw(0),stpv(0),stp(true),mkt(false),reason(0),position(0);
var: stoploss(10),daystop(11),breakeven(12),target(20);
{***************************}
{***************************}
if d > d[1] then begin
 trade = 0;
end;

if marketposition <> 0 and barssinceentry = 0 then begin
 trade = trade + 1;
 nos   = currentcontracts;
end;

dru = MM.DailyRunup;
mcp = MM.MaxContractProfit;
{***************************}
{***************************}
fnkl = dru <= -funkl*nos;
fnks = dru <= -funks*nos;
{***************************}
{***************************}
if barstatus(2) = 2 then begin
 MM.ITrend(medianprice,alphal,trendl,trigl)data2;
 cycl  = MM.Cycle(medianprice,alphal)data2;
 fishl = MM.FisherTransform(cycl,flenl,true)data2;
 
 MM.ITrend(medianprice,alphal,trends,trigs)data2;
 cycs  = MM.Cycle(medianprice,alphas)data2;
 fishs = MM.FisherTransform(cycs,flens,true)data2;
 
 el = fishl > fishl[1] and trigl > trendl;
 es = fishs < fishs[1] and trigs < trends;
 
 fillL = c data2 - rngpctl*(range data2);
 fillS = c data2 + rngpcts*(range data2);
end;
{***************************}
{***************************}
if trade < 1 then begin

 if not fnkl and marketposition < 1 and el then begin
  buy next bar fillL limit;
  orderL = true;
 end else
  orderL = false;
 
 if not fnks and marketposition > -1 and es then begin
  sell short next bar fillS limit;
  orderS = true;
 end else
  orderS = false;
 
end;
{***************************}
{***************************}
if marketposition = 1 then begin
 
 //STOPLOSS
 reason = stoploss;
 stpw   = entryprice - stopl*bpv;
 
 //DAYSTOP
 stpv = c - (dru/nos + funkl)*bpv;
 
 if t < sessionendtime(0,1) and stpv > stpw then begin
  reason = daystop;
  stpw   = stpv;
 end;
 
 //BREAKEVEN
 stpv = entryprice + 40*MinMove points;
 
 if mcp >= brkl*bpv and stpv > stpw then begin
  reason = breakeven;
  stpw   = stpv;
 end;
 
 stp = c >  stpw;
 mkt = c <= stpw;
 
 if reason = stoploss then begin
  if stp then sell("xl.stp") next bar stpw stop
  else if mkt then sell("xl.stp.m") this bar c;
 end else if reason = daystop then begin
  if stp then sell("xl.fnk") next bar stpw stop
  else if mkt then sell("xl.fnk.m") this bar c;
 end else if reason = breakeven then begin
  if stp then sell("xl.brk") next bar stpw stop
  else if mkt then sell("xl.brk.m") this bar c;
 end;
 
 //TARGET
 reason = position;
 
 if not orderS then begin
  reason = target;
  stpw   = entryprice + tl*bpv;
 end else begin
  stpv = entryprice + tl*bpv;  
  if stpv < fillS then begin
   reason = target;
   stpw   = stpv;
  end;
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
 
 //DAYSTOP
 stpv = c + (dru/nos + funks)*bpv;
 
 if t < sessionendtime(0,1) and stpv < stpw then begin
  reason = daystop;
  stpw   = stpv;
 end;{
 
 //BREAKEVEN
 stpv = entryprice - 40*MinMove points;
 
 if mcp >= brks*bpv and stpv < stpw then begin
  reason = breakeven;
  stpw   = stpv;
 end;
 }
 stp = c <  stpw;
 mkt = c >= stpw;
 
 if reason = stoploss then begin
  if stp then buy to cover("xs.stp") next bar stpw stop
  else if mkt then buy to cover("xs.stp.m") this bar c;
 end else if reason = daystop then begin
  if stp then buy to cover("xs.fnk") next bar stpw stop
  else if mkt then buy to cover("xs.fnk.m") this bar c;
 end{ else if reason = breakeven then begin
  if stp then buy to cover("xs.brk") next bar stpw stop
  else if mkt then buy to cover("xs.brk.m") this bar c;
 end};
 
 //TARGET
 reason = position;
 
 if not orderL then begin
  reason = target;
  stpw   = entryprice - ts*bpv;
 end else begin
  stpv = entryprice - ts*bpv;  
  if stpv > fillL then begin
   reason = target;
   stpw   = stpv;
  end;
 end;
 
 if reason = target then begin
  stp = c >  stpw;
  mkt = c <= stpw;
  
  if stp then buy to cover("xs.trgt") next bar stpw limit
  else if mkt then buy to cover("xs.trgt.m") this bar c;
 end;
 
end;
