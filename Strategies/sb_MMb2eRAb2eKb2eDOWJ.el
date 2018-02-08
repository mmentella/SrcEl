{********* - MM.RA.K.DOWJ - **********
 Engine:    KELTNER
 Author:    Matteo Mentella
 Portfolio: RA
 Market:    mini Dow Jones
 TimeFrame: 2 + 60 min.
 BackBars:  50
 Date:      31 Ago 2011
**************************************}
var: lenl(9),kl(2.7),lens(13),ks(4.6);

input: stopl(2400),funkl(2900),brkl(100000),tl(100000);
input: stops(2000),funks(2500),brks(100000),ts(100000);

var: upk(0,data1),lok(0,data1),el(true,data1),es(true,data1),engine(true,data1),trades(0);
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
if barstatus(1) = 2 then begin
 upk = KeltnerChannel(h,lenl,kl)data1;
 lok = KeltnerChannel(l,lens,-ks)data1;
 
 el = c data1 < upk;
 es = c data1 > lok;
 
 engine = 700 < t and t < 2100;
end;
{***************************}
{***************************}
if 700 < t and t < 2300 then begin
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
end;
{***************************}
{******DAILY MAX LOSS*******}
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
{***************************}
