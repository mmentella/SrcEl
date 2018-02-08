{******** - MM.RA.K.GAS - *********
 Engine:    Keltner
 Author:    Matteo Mentella
 Portfolio: RA
 Market:    NATURAL GAS FEATURES
 TimeFrame: 2 + 60 min.
 Session1:  08:00 - 23:00
 Session2:  Default
 BackBars:  50
 Date:      14 Set 2011
*************************************}
input: lenl(44),kl(.6),lens(8),ks(.6);

input: stopl(1800),funkl(2300),brkl(1400),modl(3900),tl(3800);
input: stops(0850),funks(1900),brks(1800),mods(4950),ts(4850);

var: upk(0,data2),lok(0,data2),el(true,data2),es(true,data2),engine(true,data2);
var: trades(0),dru(0),mcp(0),nos(1),fnkl(false),fnks(false),bpv(1/bigpointvalue);

var: orderL(true),orderS(true);

var: stpw(0),stpv(0),stp(true),mkt(true),reason(0),position(0),stoploss(10),daystop(11),breakeven(12);
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
 upk = KeltnerChannel(h,lenl,kl)data2;
 lok = KeltnerChannel(l,lens,-ks)data2;
 
 el = c data2 < upk;
 es = c data2 > lok;
 
 engine = 1100 < t data2 and t data2 < 2200;
end;
{***************************}
{***************************}
dru = MM.DailyRunup;
mcp = MM.MaxContractProfit;

fnkl = dru <= -funkl*nos;
fnks = dru <= -funks*nos;
{***************************}
{***************************}
if trades < 1 and engine then begin

 if not fnkl and marketposition < 1 and el and c < upk then begin
  buy("el") next bar upk stop;
  orderL = true;
 end else orderL = false;
  
 if not fnks and marketposition > -1 and es and c > lok then begin
  sell short("es") next bar lok stop;
  orderS = true;
 end else orderS = false;
 
end;
{***************************}
{***************************}
if marketposition = 1 then begin
 
 reason = position;
 stpw   = lok;
 
 //STOPLOSS
 stpv = entryprice - stopl*bpv;
 
 if orderL and stpv > stpw then begin
  reason = stoploss;
  stpw   = stpv;
 end else begin
  reason = stoploss;
  stpw   = stpv;
 end;
 
 //DAILY STOP
 stpv = c - (dru/currentcontracts + funkl)*bpv;
 
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
 
 //MODAL
 stpv = entryprice + modl*bpv;
 stp  = (nos > 1 and currentcontracts = nos) and c <  stpv;
 mkt  = (nos > 1 and currentcontracts = nos) and c >= stpv;
 
 if stp then sell("xl.mod") nos - 1 shares next bar stpv limit
 else if mkt then sell("xl.mod.m") nos - 1 shares this bar c;
 
 //TARGET
 stpv = entryprice + tl*bpv;
 stp  = c <  stpv;
 mkt  = c >= stpv;
 
 if stp then sell("xl.tp") 1 shares next bar stpv limit
 else if mkt then sell("xl.tp.m") 1 shares this bar c;
 
end else if marketposition = -1 then begin
 
 reason = position;
 stpw   = upk;
 
 //STOPLOSS
 stpv = entryprice + stops*bpv;
 
 if orderS and stpv < stpw then begin
  reason = stoploss;
  stpw   = stpv;
 end else begin
  reason = stoploss;
  stpw   = stpv;
 end;
 
 //DAILY STOP
 stpv = c + (dru/currentcontracts + funks)*bpv;
 
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
 stpv = entryprice - mods*bpv;
 stp  = (nos > 1 and currentcontracts = nos) and c >  stpv;
 mkt  = (nos > 1 and currentcontracts = nos) and c <= stpv;
 
 if stp then buy to cover("xs.mod") nos - 1 shares next bar stpv limit
 else if mkt then buy to cover("xs.mod.m") nos - 1 shares this bar c;
 
 //TARGET
 stpv = entryprice - ts*bpv;
 stp  = c >  stpv;
 mkt  = c <= stpv;
 
 if stp then buy to cover("xs.tp") 1 shares next bar stpv limit
 else if mkt then buy to cover("xs.tp.m") 1 shares this bar c;
 
end;
{***************************}
{***************************}
