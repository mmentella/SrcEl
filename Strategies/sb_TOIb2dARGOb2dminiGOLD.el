inputs: nos(2),lenl(28),kl(1.01),lens(49),ks(3.79),mnymngmnt(1);
Inputs: stopl(170),funkl(285),modl(260),tl(430);
Inputs: stops(125),funks(250),ts(140);

vars: upb(0),lob(0),el(true),es(true);
vars: stopval(0),minstop(-1),maxstop(999999),stp(false),mkt(false),mcp(0),yc(0),trade(0),dru(0),funk(false);

if d <> d[1] then begin
 yc = c[1];
 trade = 0;
 funk = false;
end;

//if barstatus(2) = 2 then begin
 upb = BollingerBand(h,lenl,kl);
 lob = BollingerBand(l,lens,-ks);
 
 el = c < upb;
 es = c > lob; 
//end;

if marketposition <> 0 and barssinceentry = 0 then trade = trade + 1;

mcp = MM.MaxContractProfit;
dru = MM.DailyRunup;

if mnymngmnt = 1 and 800 < t and t < 2200 then begin
  
 setstopshare;  
 
 if marketposition = 1 then begin
  
  //STOPLOSS
  stopval = entryprice - (stopl*MinMove points) - (slippage+commission)/bigpointvalue;
  stp     = c > stopval and stopval > minstop;
  mkt     = c <= stopval;
  
  if stp then sell("xl.stp") next bar stopval stop;
  if mkt then sell("xl.stpls") next bar at market;
  
  //DAILY STOPLOSS
  if not funk then funk = dru/bigpointvalue < -funkl;
  if funk then sell("xl.funk") this bar c;
  
  //PROFIT TARGET
  stopval = entryprice + (tl*MinMove points) + (slippage+commission)/bigpointvalue;
  stp     = c < stopval and stopval < maxstop;
  mkt     = c >= stopval;
  
  if stp then sell ("xl.tp") next bar stopval limit;
  if mkt then sell("xl.prftrgt") next bar at market;
  
  //MODAL EXIT
  stopval = entryprice + modl*MinMove points;
  stp     = currentcontracts = nos and c < stopval and stopval < maxstop;
  mkt     = currentcontracts = nos and c >= stopval;
  
  if stp then sell("xl.modl") nos/2 shares next bar at stopval limit;
  if mkt then sell("xl.modl.m") nos/2 shares next bar at market;
  
 end else if marketposition = -1 then begin
  
  //STOPLOSS
  stopval = entryprice + (stops*MinMove points) - (slippage+commission)/bigpointvalue;
  stp     = c < stopval and stopval < maxstop;
  mkt     = c >= stopval;
  
  if stp then buy to cover("xs.stp") next bar stopval stop;
  if mkt then buytocover("xs.stpls") next bar at market;
  
  //DAILY STOPLOSS
  if not funk then funk = dru/bigpointvalue < -funks;
  if funk then buytocover("xs.funk") this bar c;
  
  //PROFIT TARGET
  stopval = entryprice - (ts*MinMove points) + (slippage+commission)/bigpointvalue;
  stp     = c > stopval and stopval > minstop;
  mkt     = c <= stopval;
  
  if stp then buy to cover("xs.tp") next bar stopval limit;
  if mkt then buytocover("xs.prftrgt") next bar at market;
  
 end;
  
end;

if not funk and trade < 2 and 800 < t and t < 2200 then begin
 if c < upb and el then buy("el") nos shares next bar at upb stop;
 if c > lob and es then sellshort("es") nos shares next bar at lob stop;
end;
