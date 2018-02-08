inputs: nos(2),lenl(11),kl(2.19),lens(62),ks(2.19),mnymngmnt(1);
Inputs: stopl(775),stopdl(1625),modl(1900),tl(2125);
Inputs: stops(1200),stopds(700),ts(1200);

vars: upb(0,data2),lob(0,data2),el(true,data2),es(true,data2),engine(true,data2);
vars: trades(0),stopval(0),minstop(-1),maxstop(999999),stp(false),mkt(false),mcp(0),yc(0);

if d <> d[1] then begin
 trades = 0;
 yc = c[1];
 maxstop = yc + 70;
 minstop = yc - 70;
end;

if barstatus(2) = 2 then begin
 upb = BollingerBand(h,lenl,kl)data2;
 lob = BollingerBand(l,lens,-ks)data2;
 
 el = c data2 < upb;
 es = c data2 > lob;
 
 engine = 800 < t data2 and t data2 < 2015;
end;

if marketposition <> 0 and barssinceentry = 0 then begin
 trades = trades + 1; 
 //if t < 800 then raiseruntimeerror("Night Entry :: "+MM.ELDateToString_IT(d)+" "+MM.ELTimeToStr);
end;

mcp = MM.MaxContractProfit;

if mnymngmnt = 1 and 800 < t and t < 2015 then begin
  
 setstopshare;  
 
 if marketposition = 1 then begin
  
  //STOPLOSS
  stopval = entryprice - (stopl - (slippage+commission))/bigpointvalue;
  stp     = c > stopval and stopval > minstop;
  mkt     = c <= stopval;
  
  if stp then setstoploss(stopl);
  if mkt then sell("xl.stpls") next bar at market;
  
  //DAILY STOPLOSS
  stopval = yc - stopdl/bigpointvalue;
  stp     = c > stopval and stopval > minstop;
  mkt     = c <= stopval;
  
  if d > entrydate then begin
   if stp then sell("xl.stpd") next bar at stopval stop;
   if mkt then sell("xl.stpd.m") next bar at market;
  end;
  
  //PROFIT TARGET
  stopval = entryprice + (tl + (slippage+commission))/bigpointvalue;
  stp     = c < stopval and stopval < maxstop;
  mkt     = c >= stopval;
  
  if stp then setprofittarget(tl);
  if mkt then sell("xl.prftrgt") next bar at market;
  
  //MODAL EXIT
  stopval = entryprice + modl/bigpointvalue;
  stp     = currentcontracts = nos and nos > 1 and c < stopval and stopval < maxstop;
  mkt     = currentcontracts = nos and nos > 1 and c >= stopval;
  
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
  stopval = yc + stopds/bigpointvalue;
  stp     = c < stopval and stopval < maxstop;
  mkt     = c >= stopval;
  
  if d > entrydate then begin
   if stp then buytocover("xs.stpd") next bar at stopval stop;
   if mkt then buytocover("xs.stpd.m") next bar at market;
  end;
  
  //PROFIT TARGET
  stopval = entryprice - (ts + (slippage+commission))/bigpointvalue;
  stp     = c > stopval and stopval > minstop;
  mkt     = c <= stopval;
  
  if stp then setprofittarget(ts);
  if mkt then buytocover("xs.prftrgt") next bar at market;
  
 end;
  
end;

if trades < 1 and engine then begin
 if marketposition < 1 and upb < maxstop and el and c < upb then
  buy("el") nos shares next bar at upb stop;
 if marketposition > -1 and lob > minstop and es and c > lob then
  sellshort("es") nos shares next bar at lob stop;
end;
