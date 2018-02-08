Inputs: nos(4),lenl(31),kl(1.54),lens(39),ks(3.87),alpha(.11),adxlen(14),adxlimit(29);
Inputs: stopl(1200),stops(1400),brkl(500),brks(500),modl(900),mods(1000),tl(5600),ts(5000),trsl(2500),trss(1900);
Inputs: limitperc(0),el_settletime(0);

vars: upk(0),lok(0),adxv(0),mcp(0),minstop(-1),maxstop(999999),stopval(0),yc(0),mkt(false),stp(true),engine(true),
      cupk(false),clok(false),rangel(true),ranges(true);

//SETTLEMENT SAFE STOP ORDER

if el_settletime <> 0 then
 if t[1] <= el_settletime and el_settletime < t then yc = c[1]
else if d <> d[1] then yc = c[1];

if limitperc <> 0 then begin 
 maxstop = yc*(1+limitperc);
 minstop = yc*(1-limitperc); 
end;

mcp = MM.MaxContractProfit;

if currentbar > 10 then begin

upk  = KeltnerChannel(h,lenl,kl);
lok  = KeltnerChannel(l,lens,-ks);

upk  = MM.Smooth(upk,alpha);
lok  = MM.Smooth(lok,alpha);

cupk = c < upk;
clok = c > lok;

rangel = range < AvgTrueRange(lenl);
ranges = range < AvgTrueRange(lens);
 
adxv = adx(adxlen);

engine = t > 800 and t < 2200;

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
   
   //PROFIT TARGET
   stopval = entryprice + (tl + currentcontracts*(slippage+commission))/bigpointvalue;
   stp     = c < stopval and stopval < maxstop;
   mkt     = c >= stopval;
   
   if stp then setprofittarget(tl);
   if mkt then sell("xl.prftrgt") next bar at market;
   
   //BREAKEVEN
   stopval = entryprice + 100/bigpointvalue;
   stp     = mcp > brkl/bigpointvalue and minstop < stopval and stopval < c;
   mkt     = mcp > brkl/bigpointvalue and stopval >= c;
   
   if stp then sell("xl.brk") next bar at stopval stop;
   if mkt then sell("xl.brk.m") next bar at market;
   
   //MODAL EXIT
   stopval = entryprice + modl/bigpointvalue;
   stp     = currentcontracts = nos and c < stopval and stopval < maxstop;
   mkt     = currentcontracts = nos and c >= stopval;
   
   if stp then sell("xl.modl") nos/2 shares next bar at stopval limit;
   if mkt then sell("xl.modl.m") nos/2 shares next bar at market;
   
   //TRAILING STOP
   stopval = entryprice + (mcp - trsl/bigpointvalue);
   stp     = currentcontracts = nos/2 and minstop < stopval and stopval < c;
   mkt     = currentcontracts = nos/2 and c <= stopval;
   
   if stp then sell("xl.trs") next bar at stopval stop;
   if mkt then sell("xl.trs.m") next bar at market;
   
  end else begin
   
   //STOPLOSS
   stopval = entryprice + (stops - currentcontracts*(slippage+commission))/bigpointvalue;
   stp     = c < stopval and stopval < maxstop;
   mkt     = c >= stopval;
   
   if stp then setstoploss(stops);
   if mkt then buytocover("xs.stpls") next bar at market;
   
   //PROFIT TARGET
   stopval = entryprice - (ts + currentcontracts*(slippage+commission))/bigpointvalue;
   stp     = c > stopval and stopval > minstop;
   mkt     = c <= stopval;
   
   if stp then setprofittarget(ts);
   if mkt then buytocover("xs.prftrgt") next bar at market;
   
   //BREAKEVEN
   stopval = entryprice - 100/bigpointvalue;
   stp     = mcp > brks/bigpointvalue and maxstop > stopval and stopval > c;
   mkt     = mcp > brks/bigpointvalue and stopval <= c;
   
   if stp then buytocover("xs.brk") next bar at stopval stop;
   if mkt then buytocover("xs.brk.m") next bar at market;
   
   //MODAL EXIT
   stopval = entryprice - mods/bigpointvalue;
   stp     = currentcontracts = nos and c > stopval and stopval > minstop;
   mkt     = currentcontracts = nos and c <= stopval;
   
   if stp then buytocover("xs.modl") nos/2 shares next bar at stopval limit;
   if mkt then buytocover("xs.modl.m") nos/2 shares next bar at market;
   
   //TRAILING STOP
   stopval = entryprice - (mcp - trss/bigpointvalue);
   stp     = currentcontracts = nos/2 and maxstop > stopval and stopval > c;
   mkt     = currentcontracts = nos/2 and c >= stopval;
   
   if stp then buytocover("xs.trs") next bar at stopval stop;
   if mkt then buytocover("xs.trs.m") next bar at market;
   
  end;
  
 end;
 
end;//EOD

if adxv < adxlimit and minstop < lok and upk < maxstop and engine then begin
 if marketposition < 1 and c < upk and cupk and rangel then
  buy("el") nos shares next bar at upk stop;
 if marketposition > -1 and c > lok and clok and ranges then
  sellshort("es") nos shares next bar at lok stop;
end;

end else begin
 upk = KeltnerChannel(h,lenl,kl);
 lok = KeltnerChannel(l,lens,-ks);
end;
