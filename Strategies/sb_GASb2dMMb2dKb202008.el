Inputs: nos(2),lenl(36),kl(1.995),lens(65),ks(2.005),alpha(.2),adxlen(14),adxlimit(30),maxtrades(1);
Inputs: modl(100000),mods(100000),tl(3600),ts(4200),trsl(2500),trss(2800);

vars: waitbar(0),upk(0),lok(0),adxval(0),trades(0);
vars: mcp(0),minstop(-1),maxstop(999999),stopval(0),stp(true),mkt(true);

if currentbar = 1 then waitbar = maxlist(lenl,lens);

if d <> d[1] then trades = 0;

if currentbar > waitbar then begin
 
 mcp = MM.MaxContractProfit;
 
 upk = KeltnerChannel(h,lenl,kl);
 lok = KeltnerChannel(l,lens,ks);
 
 upk = MM.Smooth(upk,alpha);
 lok = MM.Smooth(lok,alpha);
 
 adxval = adx(adxlen);
 
 if marketposition <> 0 then begin
  
  setstopshare;
  
  if barssinceentry = 0 then trades = trades + 1;
  
  if marketposition = 1 then begin
   
   //TRAILING STOP
   stopval = entryprice + (mcp - trsl/bigpointvalue);
   stp     = minstop < stopval and stopval < c;
   mkt     = c <= stopval;
   
   if stp then sell("xl.trs") next bar at stopval stop;
   if mkt then sell("xl.trs.m") next bar at market;
   
   //PROFIT TARGET
   stopval = entryprice + (tl + (slippage+commission))/bigpointvalue;
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
   
   //TRAILING STOP
   stopval = entryprice - (mcp - trss/bigpointvalue);
   stp     = maxstop > stopval and stopval > c;
   mkt     = c >= stopval;
   
   if stp then buytocover("xs.trs") next bar at stopval stop;
   if mkt then buytocover("xs.trs.m") next bar at market;
   
   //PROFIT TARGET
   stopval = entryprice - (ts + (slippage+commission))/bigpointvalue;
   stp     = c > stopval and stopval > minstop;
   mkt     = c <= stopval;
   
   if stp then setprofittarget(ts);
   if mkt then buytocover("xs.prftrgt") next bar at market;
   
   //MODAL EXIT
   stopval = entryprice - mods/bigpointvalue;
   stp     = currentcontracts = nos and c > stopval and stopval > minstop;
   mkt     = currentcontracts = nos and c <= stopval;
   
   if stp then buytocover("xs.modl") nos/2 shares next bar at stopval limit;
   if mkt then buytocover("xs.modl.m") nos/2 shares next bar at market;
   
  end;
  
 end;
  
 if adxval < adxlimit and trades < maxtrades then begin
  if marketposition < 1 and c < upk then
   buy("el") nos shares next bar at upk stop;
  if marketposition > -1 and c > lok then
   sellshort("es") nos shares next bar at lok stop;   
 end;
  
end else begin
 
 upk = KeltnerChannel(h,lenl,kl);
 lok = KeltnerChannel(l,lens,ks);
 
end; 
