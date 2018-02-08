{****** - MM.RA.B.GASOLINE - ********
 Engine:    Bollinger
 Author:    Matteo Mentella
 Portfolio: RA
 Market:    RBOB GASOLINE FUTURES
 TimeFrame: 2 + 60 min.
 BackBars:  50
 Date:      22 Ago 2011
*************************************}
input: lenl(17),kl(0.073),lens(3),ks(2.706);

input: stopl(3276),funkl(4200),brkl(2856),tl(6500);
input: stops(4410),funks(4494),brks(2604),ts(5426);

var: upk(0,data2),lok(0,data2),engine(true,data2),el(true,data2),es(true,data2);

var: trades(0),dru(0),mcp(0),nos(1),fnkl(false),fnks(false),canlong(true),canshort(true);

var: stpw(0),stpv(0),stp(true),mkt(true),bpv(1/bigpointvalue),mp(0),work(true);
var: reason(0),position(0),stoploss(10),daystop(11),breakeven(12),target(20);
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
{***************************}
{***************************}
if barstatus(2) = 2 then begin
 upk = BollingerBand(h,lenl,kl)data2;
 lok = BollingerBand(l,lens,-ks)data2;

 el = c  data2 < upk;
 es = c  data2 > lok;

 engine = 700 < t data2 and t data2 < 2300;
end;

dru = MM.DailyRunup;
mcp = MM.MaxContractProfit;
{***************************}
{***************************}
fnkl = dru <= -funkl*nos;
fnks = dru <= -funks*nos;
{***************************}
{***************************}
canlong  = (trades = 0 and engine and not fnkl and el and c < upk);
canshort = (trades = 0 and engine and not fnks and es and c > lok);
{***************************}
{***************************}
if 800 < t and t < 2200 then begin

if marketposition = 1 then begin
 
 reason = position;
 stpw   = lok;
 
 //STOPLOSS
 stpv = entryprice - stopl*bpv;
 
 if not canshort then begin
  reason = stoploss;
  stpw   = stpv;
 end else if stpv > stpw then begin
  reason = stoploss;
  stpw   = stpv;
 end;
 
 //DAILY STOP
 stpv = c - (dru/nos + funkl)*bpv;
 
 if stpv > stpw then begin
  reason = daystop;
  stpw   = stpv;
 end;
 
 //BREAKEVEN
 stpv = entryprice + 15*MinMove points;
 
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
 
 stpw = entryprice + tl*bpv;
 stp  = c <  stpw;
 mkt  = c >= stpw;
 
 if stp then sell("xl.trgt") next bar stpw limit
 else if mkt then sell("xl.trgt.m") this bar c;
 
end else if marketposition = -1 then begin
 
 reason = position;
 stpw   = upk;
 
 //STOPLOSS
 stpv = entryprice + stops*bpv;
 
 if not canlong then begin
  reason = stoploss;
  stpw   = stpv;
 end else if stpv < stpw then begin
  reason = stoploss;
  stpw   = stpv;
 end;
 
 //DAILY STOP
 stpv = c + (dru/nos + funks)*bpv;
 
 if stpv < stpw then begin
  reason = daystop;
  stpw   = stpv;
 end;
 
 //BREAKEVEN
 stpv = entryprice - 15*MinMove points;
 
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
 
 stpw = entryprice - ts*bpv;
 stp  = c >  stpw;
 mkt  = c <= stpw;
 
 if stp then buy to cover("xs.trgt") next bar stpw limit
 else if mkt then buy to cover("xs.trgt.m") this bar c;
 
end;

end;
{***************************}
{***************************}
if work and trades = 0 and engine then begin

 if not fnkl and marketposition < 1 and el {and c < upk} then
  buy("el") next bar at upk stop;
  
 if not fnks and marketposition > -1 and es {and c > lok} then
 sell short("es") next bar at lok stop;
 
end;
{***************************}
{***************************}
if d = 1110826 then setexitonclose;
