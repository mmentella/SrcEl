{********* - MM.RA.B.DOWJ - **********
 Engine:    BOLLINGER
 Author:    Matteo Mentella
 Portfolio: RA
 Market:    mini Dow Jones
 TimeFrame: 2 + 60 min.
 Session1:  08:00 - 23:00
 Session2:  00:00 - 23:00
 BackBars:  50
 Date:      20 Set 2011
**************************************}
input: lenl(1),kl(0.1),lens(1),ks(0.1);

var: stopl(100000),funkl(100000),brkl(100000),tl(100000);
var: stops(100000),funks(100000),brks(100000),ts(100000);

var: upk(0,data2),lok(0,data2),el(true,data2),es(true,data2),engine(true,data2),trades(0);
var: dru(0),mcp(0),bpv(1/bigpointvalue),fnkl(true),fnks(false),nos(1);

var: stpv(0),stpw(0),stp(true),mkt(false),reason(0),stoploss(10),daystop(11),breakeven(12),target(20);
{***************************}
{***************************}
if d <> d[1] then begin
 trades = 0;
 fnkl   = false;
 fnks   = false;
end;

if marketposition <> 0 and barssinceentry = 0 then begin
 trades = trades + 1;
 nos    = currentcontracts;
end;

dru = MM.DailyRunup;
mcp = MM.MaxContractProfit;
{***************************}
{***************************}
if barstatus(2) = 2 then begin
 upk = BollingerBand(h,lenl,kl)data2;
 lok = BollingerBand(l,lens,-ks)data2;
 
 el  = c data2 < upk;
 es  = c data2 > lok;
 
 engine = 700 < t and t < 2400;
end;

fnkl = dru <= -funkl*nos;
fnks = dru <= -funks*nos;
{***************************}
{***************************}
if trades = 0 and engine then begin
 
 if not fnkl and marketposition < 1 and el and c < upk then
  buy("el") next bar upk stop;
 
 if not fnks and marketposition > -1 and es and c > lok then
  sell short("es") next bar lok stop;
   
end;
{***************************}
{***************************}{
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
 stpv = entryprice + 40*MinMove points;
 
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
 stpv = entryprice - 40*MinMove points;
 
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
{***************************}
{***************************}
}
