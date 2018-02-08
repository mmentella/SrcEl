Inputs: nos(2),lenl(48),kl(2.91),lens(24),ks(3.5),mnymngmnt(1);
Inputs: stopl(1600),funkl(4700),modl(1300);
Inputs: stops(1800),funks(4100),mods(700);

vars: upb(0,data2),lob(0,data2),el(true,data2),es(true,data2),engine(true,data2);
vars: stopval(0),minstop(-1),maxstop(999999),stp(false),mkt(false),mcp(0),yc(0),trade(0),funk(false),dru(0),settle(false);

if d <> d[1] then begin
 trade = 0;
 settle = false;
 funk = false;
end;
{
if not settle and t > 2015 then begin
 settle = true;
 yc = c[1];
 maxstop = yc + 1500/bigpointvalue;
 minstop = yc - 1500/bigpointvalue;
end;
}
if barstatus(2) = 2 then begin
 upb = BollingerBand(h,lenl,kl)data2;
 lob = BollingerBand(l,lens,-ks)data2;
 
 el = c data2 < upb;
 es = c data2 > lob;
 
 engine = 730 < t data2 and t data2 < 2000;
end;

if marketposition <> 0 and barssinceentry = 0 then trade = trade + 1;

mcp = MM.MaxContractProfit;
dru = MM.DailyRunup;

if mnymngmnt = 1 and 730 < t and t < 2000 then begin
  
 setstopshare;  
 
 if marketposition = 1 then begin
  
  //STOPLOSS
  stopval = entryprice - (stopl - (slippage+commission))/bigpointvalue;
  stp     = c > stopval and stopval > minstop;
  mkt     = c <= stopval;
  
  if stp then setstoploss(stopl);
  if mkt then sell("xl.stpls") next bar at market;
  
  //DAILY STOPLOSS
  if not funk then funk = dru < -funkl/currentcontracts;
  if funk then sell("xl.funk") this bar c;
  
  //MODAL EXIT
  stopval = entryprice + modl/bigpointvalue;
  stp     = currentcontracts = nos and c < stopval and stopval < maxstop;
  mkt     = currentcontracts = nos and c >= stopval;
  
  if stp then sell("xl.modl") nos/2 shares next bar at stopval limit;
  if mkt then sell("xl.modl.m") nos/2 shares next bar at market;
  
 end else if marketposition = -1 then begin
  
  //STOPLOSS
  stopval = entryprice + (stops - (slippage+commission))/bigpointvalue;
  stp     = c < stopval and stopval < maxstop;
  mkt     = c >= stopval;
  
  if stp then setstoploss(stops);
  if mkt then buytocover("xs.stpls") next bar at market;
  
  //DAILY STOPLOSS  
  if not funk then funk = dru < -funks/currentcontracts;
  if funk then buytocover("xs.funk") this bar c;
  
  //MODAL EXIT
  stopval = entryprice - mods/bigpointvalue;
  stp     = currentcontracts = nos and c > stopval and stopval > minstop;
  mkt     = currentcontracts = nos and c <= stopval;
  
  if stp then buytocover("xs.modl") nos/2 shares next bar at stopval limit;
  if mkt then buytocover("xs.modl.m") nos/2 shares next bar at market;
  
 end;
  
end;

if not funk and trade < 1 and engine then begin
 if marketposition < 1 and upb < maxstop and el and c < upb then
  buy("el") nos shares next bar at upb stop;
 if marketposition > -1 and lob > minstop and es and c > lob then
  sellshort("es") nos shares next bar at lob stop;
end;
