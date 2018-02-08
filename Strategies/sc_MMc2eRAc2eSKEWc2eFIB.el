{****** - MM.RA.SKEW.FIB - ********
 Engine:    SKEW
 Author:    Matteo Mentella
 Portfolio: RA
 Market:    FTSE MIB FUTURES
 TimeFrame: 1 min + 52 min
 Session 1: 09:00 17:40
 Session 2: 09:00 17:40
 BackBars:  5
 Date:      13 Set 2011
**************************************}
input: tal(0.87),sal(0.59);
input: tas(0.04),sas(0.72);

input: stopl(2500),funkl(3350),brkl(2500),tl(2000);
input: stops(4500),funks(3100),brks(4500),ts(4100); 

var: trndl(0,data2),trgrl(0,data2),skewl(0,data2);
var: trnds(0,data2),trgrs(0,data2),skews(0,data2);

var: trade(0),dailySet(false),fnkl(false),fnks(false),nos(1),bpv(1/bigpointvalue);

var: stpv(0),stpw(0),stp(true),mkt(false),dru(0),mcp(0);
var: reason(0),stoploss(10),daystop(11),breakeven(12);
{***************************}
{***************************}
if d > d[1] then begin
 dailySet = false;
 fnkl     = false;
 fnks     = false;
end;

if not dailySet then begin
 if t >= 952 then begin 
  if d > entrydate then trade = 0;
  dailySet = true;
 end;
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
 MM.ITrend(medianprice,tal,trndl,trgrl)data2;
 skewl = MM.Smoother(medianprice - MM.Smoother(medianprice,sal),sal)data2;
 
 MM.ITrend(medianprice,tas,trnds,trgrs)data2;
 skews = MM.Smoother(medianprice - MM.Smoother(medianprice,sas),sas)data2;
end;
{***************************}
{***************************}
fnkl = dru <= -funkl*nos;
fnks = dru <= -funks*nos;
{***************************}
{***************************}
if trade = 0 then begin

if not fnkl and marketposition < 1 and trgrl > trndl and skewl < 0 then
 buy("el") next bar o;

if not fnks and  marketposition > -1 and trgrs < trnds and skews > 0 then 
 sell short("es") next bar o;

end;
{***************************}
{***************************}
if marketposition = 1 then begin

 //STOPLOSS
 reason = stoploss;
 stpw   = entryprice - stopl*bpv;
 
 //DAILY STOP
 stpv = c - (dru/nos + funkl)*bpv;
 
 if stpv > stpw then begin
  reason = daystop;
  stpw   = stpv;
 end;
 
 //BREAKEVEN
 stpv = entryprice + 20*MinMove points;
 
 if mcp >= brkl*bpv and stpv > stpw then begin
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
  if stp then sell("xl.fnk") next bar stpw stop
  else if mkt then sell("xl.fnk.m") this bar c;
 end else
 if reason = breakeven then begin
  if stp then sell("xl.brk") next bar stpw stop
  else if mkt then sell("xl.brk.m") this bar c;
 end;
 
 stpw = c + tl*bpv;
 stp  = c <  stpw;
 mkt  = c >= stpw;
 
 if stp then sell("xl.trgt") next bar stpw limit
 else if mkt then sell("xl.trgt.m") this bar c;

end else if marketposition = -1 then begin

 //STOPLOSS
 reason = stoploss;
 stpw   = entryprice + stops*bpv;
 
 //DAILY STOP
 stpv = c + (dru/nos + funks)*bpv;
 
 if stpv < stpw then begin
  reason = daystop;
  stpw   = stpv;
 end;
 
 //BREAKEVEN
 stpv = entryprice - 20*MinMove points;
 
 if mcp >= brks*bpv and stpv < stpw then begin
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
  if stp then buy to cover("xs.fnk") next bar stpw stop
  else if mkt then buy to cover("xs.fnk.m") this bar c;
 end else
 if reason = breakeven then begin
  if stp then buy to cover("xs.brk") next bar stpw stop
  else if mkt then buy to cover("xs.brk.m") this bar c;
 end;
 
 stpw = c - ts*bpv;
 stp  = c >  stpw;
 mkt  = c <= stpw;
 
 if stp then buy to cover("xs.trgt") next bar stpw limit
 else if mkt then buy to cover("xs.trgt.m") this bar c;

end;
