{****** - MM.RA.TSK.CATTLE - *********
 Engine:    TSK - Trend Skewness Kurtosis
 Author:    Matteo Mentella
 Portfolio: RA
 Market:    LIVE CATTLE FUTURES
 TimeFrame: 2 min + 24 h
 Session 1: 08:00 23:00
 Session 2: 00:00 23:00
 BackBars:  5
 BT Period: 24/03/2004 - 25/08/2011
 Date:      25 Ago 2011
**************************************}
var: tal(0.06),sal(0.13),kal(0.501);
var: tas(0.99),sas(0.27),kas(0.043);

input: stopl(0950),funkl(1500),brkl(100000),tl(2100);
input: stops(2700),funks(1900),brks(100000),ts(2050);

var: trndl(0,data2),trgrl(0,data2),skewl(0,data2),kurtl(0,data2);
var: trnds(0,data2),trgrs(0,data2),skews(0,data2),kurts(0,data2);

var: trade(0),stpv(0),stpw(0),stp(true),mkt(false),dru(0),fnkl(true),fnks(true),mp(0),mcp(0);
var: reason(0),position(0),stoploss(10),daystop(11),breakeven(12),bpv(1/bigpointvalue),nos(1),mww(0,data2);
{***************************}
{***************************}
if t = sessionendtime(0,1) or d > d[1] then begin
 trade = 0;
 fnkl  = false;
 fnks  = false; 
end;

if marketposition <> 0 and barssinceentry = 0 then begin
 trade = trade + 1;
 nos   = currentcontracts;
end;

dru = MM.DailyRunup;
mcp = MM.MaxContractProfit;
{***************************}
{***************************}
if barstatus(2) = 2 then begin

 mww = MM.MovingWave(5,22)data2;

 MM.ITrend(medianprice,tal,trndl,trgrl)data2;
 skewl = MM.Smoother(medianprice - MM.Smoother(medianprice,sal),sal)data2;
 kurtl = MM.Smoother(medianprice - MM.Smoother(medianprice,kal),kal)data2;
 
 MM.ITrend(medianprice,tas,trnds,trgrs)data2;
 skews = MM.Smoother(medianprice - MM.Smoother(medianprice,sas),sas)data2;
 kurts = MM.Smoother(medianprice - MM.Smoother(medianprice,kas),kas)data2;

end;
{***************************}
{***************************}
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
 
 //TARGET
 stpw = entryprice + tl*bpv;
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
 
 if mcp > brks*bpv and stpv > stpw then begin
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
 end; 
 
 //TARGET
 stpw = entryprice - ts*bpv;
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
{***************************}
if trade < 1 then begin

if not fnkl and marketposition < 1 and trgrl > trndl and skewl < 0 then
 buy("el") next bar o;

if not fnks and marketposition > -1 and trgrs < trnds and skews > 0 then 
 sell short("es") next bar o;

if not fnks and marketposition < 1 and trgrs < trnds and skews < 0 and kurts < 0 then
 sell short("xles") next bar o;

if not fnkl and marketposition > -1 and trgrl > trndl and skewl > 0 and kurtl > 0 then
 buy("xsel") next bar o;

end;
