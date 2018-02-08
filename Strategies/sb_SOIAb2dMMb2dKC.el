
Inputs: nos(4),lenl(15),kl(1.26),lens(47),ks(2.13),alpha(.2),adxlen(18),adxlimit(30),sod(1000),eod(1800);
Inputs: stopl(1000),stops(900),brkl(500),brks(300),modl(500),mods(500),tl(5400),ts(2500);
Inputs: StopLimitPerc(7), SettleTime(0);


Vars: upk(0,data2),lok(0,data2),adxv(0,data2),bst(false,data2),sst(false,data2),engine(false,data2),mcp(0);
Vars: stopVal(0), stopMin(0), stopMax(999999), SettlePrice(0);   


{ max/min Stop Update }
if StopLimitPerc > 0 then begin
 if Date > Date[1] then begin
  if SettleTime = 0 then SettlePrice = Close[1];
  stopMin = SettlePrice*(1-StopLimitPerc/100);
  stopMax = SettlePrice*(1+StopLimitPerc/100);
  settlePrice = 0; 
 end;
 if Time >= SettleTime and SettlePrice = 0 then SettlePrice = Close;
end;


//condition1 = (d > 1040801 and d < 1070101) or d > 1091001;
//if d = 1061229 then setexitonclose;

mcp = MM.MaxContractProfit;

if currentbar > 10 then begin

if barstatus(2) = 2 then begin
 upk = KeltnerChannel(h,lenl,kl)data2;
 lok = KeltnerChannel(l,lens,-ks)data2;
 
 upk = MM.Smooth(upk,alpha);
 lok = MM.Smooth(lok,alpha);
 
 bst = c data2 < upk;
 sst = c data2 > lok;
 
 adxv = adx(adxlen)data2;
 
 engine = t data2 > sod and t data2 < eod;
end;

if t > 800 and t < 2000 then begin
 
 if marketposition <> 0 then begin
  
  setstopshare;

  //STOPLOSS
  //setstoploss(iff(marketposition=1,MM.StopLoss(stopl),MM.StopLoss(stops)));
  if marketposition = 1 and stopl > 0 then begin
   stopVal = EntryPrice-MM.StopLoss(stopl)/bigpointvalue;
   if StopMin < StopVal and StopVal < StopMax then
    if c > stopVal then setstoploss(stopl)
    else                sell("xl.stop.m") next bar at market;
  end else
  if marketposition = -1 and stops > 0 then begin
   stopVal = EntryPrice+MM.StopLoss(stops)/bigpointvalue;
   if StopMin < StopVal and StopVal < StopMax then
    if c < stopVal then setstoploss(stops)
    else                buytocover("xs.stop.m") next bar at market;
  end;

  //PROFIT TARGET
  //setprofittarget(iff(marketposition=1,MM.ProfitTarget(tl),MM.ProfitTarget(ts)));
  if marketposition = 1 and tl > 0 then begin
   stopVal = entryprice+MM.ProfitTarget(tl)/bigpointvalue;
   if StopMin < StopVal and StopVal < StopMax then
    if c < stopVal then setprofittarget(tl)
    else                sell("xl.prof.m") next bar at market;
  end
  else
  if marketposition = -1 and ts > 0 then begin
   stopVal = entryprice-MM.ProfitTarget(ts)/bigpointvalue;
   if StopMin < StopVal and StopVal < StopMax then
    if c > stopVal then setprofittarget(ts)
    else                buytocover("xs.prof.m") next bar at market;
  end;

  //BREAK EVEN
  //if marketposition = 1 and mcp > brkl/bigpointvalue then
  // sell("xl.brk") next bar at MM.BreakEven(100) stop;
  //if marketposition = -1 and mcp > brks/bigpointvalue then
  // buytocover("xs.brk") next bar at MM.BreakEven(100) stop;
  stopVal = MM.BreakEven(100);
  if marketposition = 1 and mcp > brkl/bigpointvalue and brkl > 0 then begin
   if StopMin < StopVal and StopVal < StopMax then
    if c > stopVal then sell("xl.brk.s") next bar at stopVal stop
    else                sell("xl.brk.m") next bar at market;
  end
  else
  if marketposition = -1 and mcp > brks/bigpointvalue and brks > 0 then begin
   if StopMin < StopVal and StopVal < StopMax then
    if c < stopVal then buytocover("xs.brk.s") next bar at stopVal stop
    else                buytocover("xs.brk.m") next bar at market;
  end;

  //MODAL EXIT
  if currentcontracts = nos and nos > 1 then begin
   //if marketposition = 1 then sell("xl.mod") nos/2 shares next bar at MM.ModalExit(modl) limit;
   //if marketposition = -1 then buytocover("xs.mod") nos/2 shares next bar at MM.ModalExit(mods) limit;   
   if marketposition = 1 and modl > 0 then begin
    stopVal = MM.ModalExit(modl);
    if StopMin < StopVal and StopVal < StopMax then
     if c < stopVal then sell("xl.mod.s") nos/2 shares next bar at stopVal limit
     else                sell("xl.mod.m") nos/2 shares next bar at market;
   end
   else
   if marketposition = -1 and mods > 0 then begin
    stopVal = MM.ModalExit(mods);
    if StopMin < StopVal and StopVal < StopMax then
     if c > stopVal then buytocover("xs.mod.s") nos/2 shares next bar at stopVal limit
     else                buytocover("xs.mod.m") nos/2 shares next bar at market;
   end;
  end;
  
 end;

 if adxv < adxlimit and engine {and condition1} then begin
  if marketposition < 1 and bst then
   //buy("el") nos shares next bar at upk stop;
   if StopMin < upk and upk < StopMax then
    if c < upk then buy("el.s") nos shares next bar at upk stop
    else            buy("el.m") nos shares next bar at market;
  if marketposition > -1 and sst then
   //sellshort("es") nos shares next bar at lok stop;
   if StopMin < lok and lok < StopMax then
    if c > lok then sellshort("es.s") nos shares next bar at lok stop
    else            sellshort("es.m") nos shares next bar at market;
 end;

end;

end else begin
 upk = KeltnerChannel(h,lenl,kl)data2;
 lok = KeltnerChannel(l,lens,-ks)data2;
end;
