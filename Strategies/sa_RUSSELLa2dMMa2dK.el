Inputs: nos(2),lenl(26),kl(1.188),lens(82),ks(2.888),alphal(.121),alphas(.21),adxlen(13),adxlimit(29);
Inputs: stopl(2900),stopdl(2300),stops(2100),stopds(2700),modl(2200),tl(4400),ts(2000);

vars: upk(0),lok(0),adxval(0);
vars: stopval(0),minstop(-1),maxstop(999999),stp(false),mkt(false),mcp(0),yc(0);

if d <> d[1] then yc = c[1];

upk = KeltnerChannel(h,lenl,kl);
lok = KeltnerChannel(l,lens,-ks);

upk = MM.Smooth(upk,alphal);
lok = MM.Smooth(lok,alphas);

adxval = adx(adxlen);

mcp = MM.MaxContractProfit;

if t > 800 and t < 2200 then begin

 if marketposition <> 0 then begin
  
  setstopshare;  
  
  if marketposition = 1 then begin
   
   //STOPLOSS
   stopval = entryprice - (stopl - currentcontracts*(slippage+commission))/bigpointvalue;
   stp     = c > stopval and stopval > minstop;
   mkt     = c <= stopval;
   
   if stp then setstoploss(stopl);
   if mkt then sell("xl.stpls") next bar at market;
   
   //STOPLOSS DAILY
   stopval = yc - stopdl/bigpointvalue;
   stp     = c > stopval and stopval > minstop;
   mkt     = c <= stopval;
   
   if d > entrydate then begin
    if stp then sell("xl.stpd") next bar at stopval stop;
    if mkt then sell("xl.stpd.m") next bar at market;
   end;
   
   //PROFIT TARGET
   stopval = entryprice + (tl + currentcontracts*(slippage+commission))/bigpointvalue;
   stp     = c < stopval and stopval < maxstop;
   mkt     = c >= stopval;
   
   if stp then setprofittarget(tl);
   if mkt then sell("xl.prftrgt") next bar at market;
   
   //MODAL EXIT
   stopval = entryprice + modl/bigpointvalue;
   stp     = currentcontracts = nos and c < stopval and stopval < maxstop;
   mkt     = currentcontracts = nos and c >= stopval;
   
   if stp then sell("xl.modl") nos/2 shares next bar at stopval limit;
   if mkt then sell("xl.modl.m") nos/2 shares next bar at market;
      
  end else begin
   
   //STOPLOSS
   stopval = entryprice + (stops - currentcontracts*(slippage+commission))/bigpointvalue;
   stp     = c < stopval and stopval < maxstop;
   mkt     = c >= stopval;
   
   if stp then setstoploss(stops);
   if mkt then buytocover("xs.stpls") next bar at market;
   
   //STOPLOSS DAILY
   stopval = yc + stopds/bigpointvalue;
   stp     = c < stopval and stopval < maxstop;
   mkt     = c >= stopval;
   
   if d > entrydate then begin
    if stp then buytocover("xs.stpd") next bar at stopval stop;
    if mkt then buytocover("xs.stpd.m") next bar at market;
   end;
   
   //PROFIT TARGET
   stopval = entryprice - (ts + currentcontracts*(slippage+commission))/bigpointvalue;
   stp     = c > stopval and stopval > minstop;
   mkt     = c <= stopval;
   
   if stp then setprofittarget(ts);
   if mkt then buytocover("xs.prftrgt") next bar at market;
   
  end;
  
 end;

 if adxval < adxlimit then begin
  if marketposition < 1 and c < upk then
   buy("el") nos shares next bar at upk stop;
  if marketposition > -1 and c > lok then
   sellshort("es") nos shares next bar at lok stop;
 end;

end;
