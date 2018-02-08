{****** - MM.RA.B.GASOLINE - ********
 Engine:    Bollinger
 Author:    Matteo Mentella
 Portfolio: RA
 Market:    RBOB GASOLINE FUTURES
 TimeFrame: 60 min.
 BackBars:  50
 Date:      22 Ago 2011
*************************************}
input: lenl(17),kl(0.073),lens(3),ks(2.706);

input: stopl(3276),funkl(4200),brkl(2856),tl(6500);
input: stops(4410),funks(4494),brks(2604),ts(5426);

var: upk(0),lok(0),engine(true),el(true),es(true),canshort(false),canlong(false);

var: trades(0),dru(0),mcp(0),nos(1),fnkl(false),fnks(false);
var: stpw(0),stpv(0),stp(true),mkt(true),bpv(1/bigpointvalue);

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
upk = BollingerBand(h,lenl,kl);
lok = BollingerBand(l,lens,-ks);

el = c  < upk;
es = c  > lok;

engine = 700 < t  and t  < 2300;

dru = MM.DailyRunup;
mcp = MM.MaxContractProfit;
{***************************}
{***************************}
fnkl = dru <= -funkl*nos;
fnks = dru <= -funks*nos;
{***************************}
{***************************}
canlong  = (trades = 0 and engine and not fnkl and el);
canshort = (trades = 0 and engine and not fnks and es);
{***************************}
{***************************}
if 700 < t and t < 2300 then begin

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
if trades = 0 and engine then begin

 if not fnkl and marketposition < 1 and el then
  buy("el") next bar at upk stop;
  
 if not fnks and marketposition > -1 and es then
 sell short("es") next bar at lok stop;
 
end;
{***************************}
{***************************}
if d = 1110826 then setexitonclose;
