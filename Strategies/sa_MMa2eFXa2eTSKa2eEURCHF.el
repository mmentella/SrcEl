{****** - MM.RA.TSK.TNOTE - ********
 Engine:    TSK - Trend Skewness Kurtosis
 Author:    Matteo Mentella
 Portfolio: FX
 Market:    EUR/CHF Cross Rate
 TimeFrame: 60 min
 Session 1: 00:00 23:00
 BackBars:  5
 Date:      12 Ago 2011
**************************************}
inputs: tal(0.190),sal(0.130),kal(0.530);
inputs: tas(0.180),sas(0.150),kas(0.025);

input: stopl(100000),funkl(100000),brkl(100000);
input: stops(100000),funks(100000),brks(100000);

var: trndl(0),trgrl(0),skewl(0),kurtl(0);
var: trnds(0),trgrs(0),skews(0),kurts(0);

var: trade(0),dru(0),mcp(0),mww(0),fnkl(false),fnks(false),stp(true),mkt(false),nos(1),bpv(1/bigpointvalue);
var: stpv(0),stpw(0),reason(0),stoploss(10),daystop(11),breakeven(12),target(20);
{***************************}
{**UPDATE SYSTEM VARIABLES**}
if t = sessionendtime(0,1) or d > d[1] then begin
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
MM.ITrend(medianprice,tal,trndl,trgrl);
skewl = MM.Smoother(medianprice - MM.Smoother(medianprice,sal),sal);
kurtl = MM.Smoother(medianprice - MM.Smoother(medianprice,kal),kal);
 
MM.ITrend(medianprice,tas,trnds,trgrs);
skews = MM.Smoother(medianprice - MM.Smoother(medianprice,sas),sas);
kurts = MM.Smoother(medianprice - MM.Smoother(medianprice,kas),kas);
{***************************}
{******MONEY MANAGEMENT*****
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
 
end;
***************************}
{***************************}
fnkl = dru <= -funkl*nos;
fnks = dru <= -funks*nos;
{***************************}
{***********ENGINE**********}
if trade < 1 then begin

if not fnkl and marketposition < 1 and trgrl > trndl and skewl < 0 then
 buy("el") next bar o;

if not fnks and marketposition > -1 and trgrs < trnds and skews > 0 then
 sell short("es") next bar o;

if not fnkl and marketposition = 1 and trgrs < trnds and skews < 0 and kurts < 0 then
 sell short("xles") next bar o;

if not fnks and marketposition = -1 and trgrl > trndl and skewl > 0 and kurtl < 0 then
 buy("xsel") next bar o;

end;
{***********END*************}
{***********END*************}
