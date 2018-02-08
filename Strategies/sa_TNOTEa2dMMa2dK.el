Inputs: nos(2),lenl(1),kl(3.36),lens(1),ks(4.65),alpha(.75),adxlen(14),adxlimit(30);
Inputs: brkl(1800),brks(1800),modl(1200),mods(2500),trsl(5500),trss(4000);
Inputs: daylimit("3000"),el_settletime(0);

vars: upk(0),lok(0),adxval(0),stopval(0),stp(true),mkt(true),mcp(0);
vars: _daylimit(0),stopmax(999999),stopmin(0),yc(0),perc(false);

if currentbar = 1 and daylimit <> "" then begin
 if RightStr(daylimit,1) = "%" then begin perc = true; _daylimit = StrToNum(LeftStr(daylimit,StrLen(daylimit)-1)); end
 else begin perc = false; _daylimit = StrToNum(daylimit); end; 
end;

if _daylimit > 0 then begin
 yc = 0;
 if d > d[1] and el_settletime = 0 then yc = c[1];
 if yc = 0 and t >= el_settletime then yc = c;
 
 if perc then begin
  stopmax = yc*(1+_daylimit*.01);
  stopmin = yc*(1-_daylimit*.01);
 end;
 if not perc then begin
  stopmax = yc*(1+_daylimit);
  stopmin = yc*(1-_daylimit);
 end; 
end;

if currentbar > 10 then begin
 
 upk = KeltnerChannel(h,lenl,kl);
 lok = KeltnerChannel(l,lens,-ks);
 
 upk = MM.Smooth(upk,alpha);
 lok = MM.Smooth(lok,alpha);
 
 adxval = adx(adxlen);
 
 mcp = MM.MaxContractProfit;
 
 if t >= 800 and t <= 2200 then begin
  
  if marketposition <> 0 then begin
   
   setstopshare;
   
   if marketposition = 1 then begin
   
    //BREAKEVEN
    stopval = entryprice + 100/bigpointvalue;
    stp     = mcp > brkl/bigpointvalue and stopmin < stopval and stopval < c;
    mkt     = mcp > brkl/bigpointvalue and stopval >= c;
    
    if stp then sell("xl.brk") next bar at stopval stop;
    if mkt then sell("xl.brk.m") next bar at market;
    
    //TRAILING STOP
    stopval = entryprice + (mcp - trsl/bigpointvalue);
    stp     = stopmin < stopval and stopval < c;
    mkt     = c <= stopval;
    
    if stp then sell("xl.trs") next bar at stopval stop;
    if mkt then sell("xl.trs.m") next bar at market;
    
    //MODAL EXIT
    stopval = entryprice + modl/bigpointvalue;
    stp     = currentcontracts = nos and c < stopval and stopval < stopmax;
    mkt     = currentcontracts = nos and c >= stopval;
    
    if stp then sell("xl.modl") nos/2 shares next bar at stopval limit;
    if mkt then sell("xl.modl.m") nos/2 shares next bar at market;
    
   end else begin
    
    //BREAKEVEN
    stopval = entryprice - 100/bigpointvalue;
    stp     = mcp > brks/bigpointvalue and stopmax > stopval and stopval > c;
    mkt     = mcp > brks/bigpointvalue and stopval <= c;
    
    if stp then buytocover("xs.brk") next bar at stopval stop;
    if mkt then buytocover("xs.brk.m") next bar at market;
    
    //TRAILING STOP
    stopval = entryprice - (mcp - trss/bigpointvalue);
    stp     = stopmax > stopval and stopval > c;
    mkt     = c >= stopval;
    
    if stp then buytocover("xs.trs") next bar at stopval stop;
    if mkt then buytocover("xs.trs.m") next bar at market;
    
    //MODAL EXIT
    stopval = entryprice - mods/bigpointvalue;
    stp     = currentcontracts = nos and c > stopval and stopval > stopmin;
    mkt     = currentcontracts = nos and c <= stopval;
    
    if stp then buytocover("xs.modl") nos/2 shares next bar at stopval limit;
    if mkt then buytocover("xs.modl.m") nos/2 shares next bar at market;
    
   end;
   
  end;
 
  if adxval < adxlimit and stopmin < lok and upk < stopmax {and d < 1081231} then begin
   if marketposition < 1 and c < upk then
    buy("el") nos shares next bar at upk stop;
   if marketposition > -1 and c > lok then
    sellshort("es") nos shares next bar at lok stop;  
  end;
  
 end;
 
end else begin
 
 upk = KeltnerChannel(h,lenl,kl);
 lok = KeltnerChannel(l,lens,-ks);
 
end;

//if d = 1081231 then setexitonclose;
