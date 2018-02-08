Inputs: nos(2),lenl(31),kl(1.55),lens(39),ks(3.86),alpha(.11),adxlen(14),adxlimit(29);
Inputs: stopl(1950),stopdl(1200),brkl(650),modl(850),tl(4700),trsl(1200);


vars: upk(0,data2),lok(0,data2),adxv(0,data2),mcp(0),minstop(-1),maxstop(999999),stpv(0),yc(0),mkt(false),stp(true),engine(true,data2),
      cupk(false,data2),clok(false,data2),rangel(true,data2),ranges(true,data2),trades(0);
      
vars: stpw(0),reason(0),position(0),stoploss(10),daystop(11),breakeven(12),trailing(13),short1(true);

if d <> d[1] then begin
 yc     = c[1];
 trades = 0;
end;

mcp = MM.MaxContractProfit;

if marketposition <> 0 and barssinceentry = 0 then trades = trades + 1;

if currentbar > 10 then begin

if barstatus(2) = 2 then begin

 upk  = KeltnerChannel(h,lenl,kl)data2;
 lok  = KeltnerChannel(l,lens,-ks)data2;
 
 upk  = MM.Smooth(upk,alpha)data2;
 lok  = MM.Smooth(lok,alpha)data2;
 
 cupk = c data2 < upk;
 clok = c data2 > lok;
 
 rangel = range data2 < AvgTrueRange(lenl)data2;
 ranges = range data2 < AvgTrueRange(lens)data2;
  
 adxv = adx(adxlen)data2;
 
 engine = t data2 > 800 and t data2 < 2200;
 
end;

if t > 800 and t < 2200 then begin
 
 if marketposition <> 0 then begin
  
  if marketposition = 1 then begin
   
   //STOPLOSS
   stpv = entryprice - (stopl - currentcontracts*(slippage+commission))/bigpointvalue;
   stp  = c > stpv and stpv > minstop;
   mkt  = c <= stpv;
   
   if stp then setstoploss(stopl);
   if mkt then sell("xl.stpls") next bar at market;
   
   //DAILY STOPLOSS
   stpv = yc - stopdl/bigpointvalue;
   stp  = c > stpv and stpv > minstop;
   mkt  = c <= stpv;
   
   if d > entrydate then begin
    if stp then sell("xl.stpd") next bar at stpv stop;
    if mkt then sell("xl.stpd.m") next bar at market;
   end;
   
   //PROFIT TARGET
   stpv = entryprice + (tl + currentcontracts*(slippage+commission))/bigpointvalue;
   stp  = c < stpv and stpv < maxstop;
   mkt  = c >= stpv;
   
   if stp then setprofittarget(tl);
   if mkt then sell("xl.prftrgt") next bar at market;
   
   //BREAKEVEN
   stpv = entryprice + 100/bigpointvalue;
   stp  = mcp > brkl/bigpointvalue and minstop < stpv and stpv < c;
   mkt  = mcp > brkl/bigpointvalue and stpv >= c;
   
   if stp then sell("xl.brk") next bar at stpv stop;
   if mkt then sell("xl.brk.m") next bar at market;
   
   //MODAL EXIT
   stpv = entryprice + modl/bigpointvalue;
   stp  = currentcontracts = nos and c < stpv and stpv < maxstop;
   mkt  = currentcontracts = nos and c >= stpv;
   
   if stp then sell("xl.modl") nos/2 shares next bar at stpv limit;
   if mkt then sell("xl.modl.m") nos/2 shares next bar at market;
   
   //TRAILING STOP
   stpv = entryprice + (mcp - trsl/bigpointvalue);
   stp  = currentcontracts = nos/2 and minstop < stpv and stpv < c;
   mkt  = currentcontracts = nos/2 and c <= stpv;
   
   if stp then sell("xl.trs") next bar at stpv stop;
   if mkt then sell("xl.trs.m") next bar at market;
   
  end;
  
 end;
 
end;//EOD

if adxv < adxlimit and minstop < lok and upk < maxstop and engine then begin
 if marketposition < 1 and c < upk and cupk and rangel then
  buy("el") nos shares next bar at upk stop;
 if marketposition > -1 and c > lok and clok and ranges then
  sell("es") nos shares next bar at lok stop;
end;

end else begin
 upk   = KeltnerChannel(h,lenl,kl)data2;
 lok   = KeltnerChannel(l,lens,-ks)data2;
end;

