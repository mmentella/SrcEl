{****** - MM.RA.SKEW.EURO - ********
 Engine:    SKEW
 Author:    Matteo Mentella
 Portfolio: RA
 Market:    EURO DOLLAR FUTURES
 TimeFrame: 2 min + 24 h
 Session 1: 08:00 23:00
 Session 2: 00:00 23:00
 BackBars:  22
 Date:      13 Ago 2011
**************************************}
input: alphal(0.44),alpml(0.80),alpdl(0.41);
input: alphas(0.86),alpms(0.12),alpds(0.38);
input: stopl(3700),funkl(3650),brkl(2600),modl(1.44),tl(2.08);
input: stops(3200),funks(1700),brks(1700),mods(1.74),ts(2.87);

vars: skewl(0,data2),trndl(0,data2),trgrl(0,data2);
vars: skews(0,data2),trnds(0,data2),trgrs(0,data2);

vars: trade(0),dru(0),mcp(0),mww(0,data2),fnkl(false),fnks(false),stp(true),mkt(false),nos(1),bpv(1/bigpointvalue);
vars: stpv(0),stpw(0),reason(0),stoploss(10),daystop(11),breakeven(12),target(20);
{***************************}
{**UPDATE SYSTEM VARIABLES**}
if t = sessionendtime(0,1) then begin
 trade = 0;
end;

if marketposition <> 0 and barssinceentry = 0 then begin
 trade = trade + 1;
 nos   = currentcontracts;
end;

mcp = MM.MaxContractProfit;
dru = MM.DailyRunup;
{***************************}
{**UPDATE ENGINE VARIABLES**}
if barstatus(2) = 2 then begin
 
 MM.ITrend(medianprice,alphal,trndl,trgrl)data2;
 MM.ITrend(medianprice,alphas,trnds,trgrs)data2;
 
 skewl = MM.Skewness(medianprice,alpml,alpdl)data2;
 skews = MM.Skewness(medianprice,alpms,alpds)data2;
 
 mww = MM.MovingWeeklyWave data2;

end;
{***************************}
{******MONEY MANAGEMENT*****}
if marketposition = 1 then begin
 
 //STOPLOSS
 reason = stoploss;
 stpw   = entryprice - stopl*bpv;
 
 //DAILY STOP
 stpv = c - (dru/nos + funkl)*bpv;
 
 if t < sessionendtime(0,1) and stpv > stpw then begin
  reason = daystop;
  stpw   = stpv;
 end;
 
 //BREAKEVEN
 stpv = entryprice + 12*MinMove points;
 
 if mcp > brkl*bpv and stpv > stpw then begin
  reason = breakeven;
  stpw   = stpv;
 end;
 
 stp = c >  stpw;
 mkt = c <= stpw;
 
 if reason = stoploss then begin
  if stp then sell("xl.stp") next bar stpw stop
  else if mkt then sell("xl.stp.m") this bar c;
 end else
 if reason = daystop then begin
  if stp then sell("xl.funk") next bar stpw stop
  else if mkt then sell("xl.funk.m") this bar c;
 end else
 if reason = breakeven then begin
  if stp then sell("xl.brk") next bar stpw stop
  else if mkt then sell("xl.brk.m") this bar c;
 end;
 
 //MODAL
 stpw = Round(entryprice + modl*mww,4);
 stp  = (nos > 1 and currentcontracts = nos) and c <  stpw;
 mkt  = (nos > 1 and currentcontracts = nos) and c >= stpw;
 
 if stp then sell("xl.mod") .5*nos shares next bar stpw limit
 else if mkt then sell("xl.mod.m") .5*nos shares this bar c;
 
 //TARGET
 stpw = Round(entryprice + tl*mww,4);
 stp  = (nos = 1 or currentcontracts = .5*nos) and c <  stpw;
 mkt  = (nos = 1 or currentcontracts = .5*nos) and c >= stpw;
 
 if stp then sell("xl.trgt") next bar stpw limit
 else if mkt then sell("xl.trgt.m") this bar c;
 
end else if marketposition = -1 then begin
 
 //STOPLOSS
 reason = stoploss;
 stpw   = entryprice + stops*bpv;
 
 //DAILY STOP
 stpv = c + (dru/nos + funks)*bpv;
 
 if t < sessionendtime(0,1) and stpv < stpw then begin
  reason = daystop;
  stpw   = stpv;
 end;
 
 //BREAKEVEN
 stpv = entryprice - 12*MinMove points;
 
 if mcp > brks*bpv and stpv < stpw then begin
  reason = breakeven;
  stpw   = stpv;
 end;
 
 stp = c <  stpw;
 mkt = c >= stpw;
 
 if reason = stoploss then begin
  if stp then buy to cover("xs.stp") next bar stpw stop
  else if mkt then buy to cover("xs.stp.m") this bar c;
 end else
 if reason = daystop then begin
  if stp then buy to cover("xs.funk") next bar stpw stop
  else if mkt then buy to cover("xs.funk.m") this bar c;
 end else
 if reason = breakeven then begin
  if stp then buy to cover("xs.brk") next bar stpw stop
  else if mkt then buy to cover("xs.brk.m") this bar c;
 end;
 
 //MODAL
 stpw = Round(entryprice - mods*mww,4);
 stp  = (nos > 1 and currentcontracts = nos) and c > stpw;
 mkt  = (nos > 1 and currentcontracts = nos) and c <= stpw;
 
 if stp then buy to cover("xs.mod") .5*nos shares next bar stpw limit
 else if mkt then buy to cover("xs.mod.m") .5*nos shares this bar c;
 
 //TARGET
 stpw = Round(entryprice - ts*mww,4);
 stp  = (nos = 1 or currentcontracts = .5*nos) and c > stpw;
 mkt  = (nos = 1 or currentcontracts = .5*nos) and c <= stpw;
 
 if stp then buy to cover("xs.trgt") next bar stpw limit
 else if mkt then buy to cover("xs.trgt.m") this bar c;
 
end;
{***************************}
{***************************}
fnkl = dru <= -funkl*nos;
fnks = dru <= -funks*nos;
{***************************}
{***********ENGINE**********}
if trade < 1 then begin 
 //LONG ENTRY
 if not fnkl and marketposition < 1 and trgrl > trndl and skewl < 0 then  
  buy next bar o;  
 //SHORT ENTRY
 if not fnks and marketposition > -1 and trgrs < trnds and skews > 0 then
  sell short next bar o;
end;
{***********END*************}
{***********END*************}
