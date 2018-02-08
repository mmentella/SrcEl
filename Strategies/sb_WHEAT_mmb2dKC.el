
Inputs: nos(4),lenl(22),kl(2.61),lens(23),ks(2.05),alpha(.21),adxlen(19),adxlimit(26),sod(800),eod(1930);
Inputs: stopl(1500),stops(1300),brkl(1700),brks(1500),modl(1600),mods(1000),tl(7600),ts(4000);
Inputs: StopLimitPerc(12), SettleTime(0);


vars: upk(0,data2),lok(0,data2),bsetup(false,data2),ssetup(false,data2),adxv(0,data2),mcp(0);
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


if currentbar > 10 then begin


mcp = MM.MaxContractProfit;

if barstatus(2) = 2 then begin

 upk = KeltnerChannel(h,lenl,kl)data2;
 lok = KeltnerChannel(l,lens,-ks)data2;

 upk = MM.Smooth(upk,alpha);
 lok = MM.Smooth(lok,alpha);

 bsetup = c data2 < upk;
 ssetup = c data2 > lok;

 adxv = adx(adxlen)data2;

end;


if t > sod and t < eod then begin
 
 if marketposition <> 0 then begin
  
  setstopshare;
  
  //STOPLOSS
  //setstoploss(iff(marketposition=1,MM.StopLoss(stopl),MM.StopLoss(stops)));
  if marketposition = 1 and stopl > 0 then begin
   stopVal = EntryPrice-MM.StopLoss(stopl)/bigpointvalue;
   if c <= stopVal then
    sell("xl.stop.m") next bar at market
   else
   if StopMin < StopVal and StopVal < StopMax then
    setstoploss(stopl);
  end else
  if marketposition = -1 and stops > 0 then begin
   stopVal = EntryPrice+MM.StopLoss(stops)/bigpointvalue;
   if c >= stopVal then
    buytocover("xs.stop.m") next bar at market
   else
   if StopMin < StopVal and StopVal < StopMax then
    setstoploss(stops);
  end;

  //PROFIT TARGET
  //setprofittarget(iff(marketposition=1,MM.ProfitTarget(tl),MM.ProfitTarget(ts)));
  if marketposition = 1 and tl > 0 then begin
   stopVal = entryprice+MM.ProfitTarget(tl)/bigpointvalue;
   if c >= stopVal then
    sell("xl.prof.m") next bar at market
   else
   if StopMin < StopVal and StopVal < StopMax then
    setprofittarget(tl);
  end
  else
  if marketposition = -1 and ts > 0 then begin
   stopVal = entryprice-MM.ProfitTarget(ts)/bigpointvalue;
   if c <= stopVal then
    buytocover("xs.prof.m") next bar at market
   else
   if StopMin < StopVal and StopVal < StopMax then
    setprofittarget(ts);
  end;

  //BREAK EVEN
  //if marketposition = 1 and mcp > brkl/bigpointvalue then
  // sell("xl.brk") next bar at MM.BreakEven(100) stop;
  //if marketposition = -1 and mcp > brks/bigpointvalue then
  // buytocover("xs.brk") next bar at MM.BreakEven(100) stop;
  stopVal = MM.BreakEven(100);
  if marketposition = 1 and mcp > brkl/bigpointvalue and brkl > 0 then begin
   if c <= stopVal then
    sell("xl.brk.m") next bar at market
   else
   if StopMin < StopVal and StopVal < StopMax then
    sell("xl.brk.s") next bar at stopVal stop;
  end
  else
  if marketposition = -1 and mcp > brks/bigpointvalue and brks > 0 then begin
   if c >= stopVal then
    buytocover("xs.brk.m") next bar at market
   else
    if StopMin < StopVal and StopVal < StopMax then
     buytocover("xs.brk.s") next bar at stopVal stop;
  end;

  if currentcontracts = nos and nos > 1 then begin
   //if marketposition = 1 then sell("xl.mod") nos/2 shares next bar at MM.ModalExit(modl) limit;
   //if marketposition = -1 then buytocover("xs.mod") nos/2 shares next bar at MM.ModalExit(mods) limit;   
   if marketposition = 1 and modl > 0 then begin
    stopVal = MM.ModalExit(modl);
    if c >= stopVal then
     sell("xl.mod.m") nos/2 shares next bar at market
    else
    if StopMin < StopVal and StopVal < StopMax then
     sell("xl.mod.s") nos/2 shares next bar at stopVal limit;
   end
   else
   if marketposition = -1 and mods > 0 then begin
    stopVal = MM.ModalExit(mods);
    if c <= stopVal then
     buytocover("xs.mod.m") nos/2 shares next bar at market
    else
    if StopMin < StopVal and StopVal < StopMax then
     buytocover("xs.mod.s") nos/2 shares next bar at stopVal limit;
   end;
  end;
  
 end;

 if adxv < adxlimit then begin

  if marketposition < 1 and bsetup then
   //buy("el") nos shares next bar at upk stop;
   if c >= upk then
    buy("el.m") nos shares next bar at market
   else
   if StopMin < upk and upk < StopMax then
    buy("el.s") nos shares next bar at upk stop;

  if marketposition > -1 and ssetup then
   //sellshort("es") nos shares next bar at lok stop;
   if c <= lok then
    sellshort("es.m") nos shares next bar at market
   else
   if StopMin < lok and lok < StopMax then
    sellshort("es.s") nos shares next bar at lok stop;

 end;

end;

end else begin
 if barstatus(2) = 2 then begin
  upk = KeltnerChannel(h,lenl,kl)data2;
  lok = KeltnerChannel(l,lens,-ks)data2;
 end;
end; 

//Inputs: stopl(1500),stops(1300),brkl(1700),brks(1500),modl(1600),mods(1000),tl(7600),ts(4000);
