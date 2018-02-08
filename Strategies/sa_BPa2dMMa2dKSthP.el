
Inputs: nos(4),lenl(31),kl(1.54),lens(39),ks(3.87),adxlen(14),adxlimit(29),alfa(.11);

Inputs: stoploss(1850),brk(500),tl(900),ts(1000),trsl(2500),trss(1900);

Inputs: StopLimitPerc(0), SettleTime(0);


Vars: upperk(0,data2),lowerk(0,data2),adxval(0,data2);
Vars: underK(false,data2),overK(false,data2),underATRl(false,data2),underATRs(false,data2);
Vars: lastT2(0,data2);

Vars: maxposprof(0),mpp(0),mp(0);

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


// New TimeFrame2 bar
if BarStatus(2) = 2 then begin

 upperk = KeltnerChannel(h,lenl,kl)data2;
 lowerk = KeltnerChannel(l,lens,-ks)data2;
 upperk = alfa*upperk + (1-alfa)*upperk[1];
 lowerk = alfa*lowerk + (1-alfa)*lowerk[1];

 underK = c data2 < upperk;
 overK = c data2 > lowerk;

 //underATRl = range data2 < AvgTrueRange(lenl) data2;
 underATRl = range data2 < Average(TrueRange data2,lenl) data2;
 //underATRs = range data2 < AvgTrueRange(lens) data2;
 underATRs = range data2 < Average(TrueRange data2,lens) data2;
 //adxval = adx(adxlen)data2;
 adxval = ADXCustom(h,l,c,adxlen)data2;

 lastT2 = time data2;

end;   // of new TimeFrame2 bar

mpp = MM.MaxContractProfit;

//if t data2 > 800 and t data2 < 2200 then begin
if 800 < lastT2 and lastT2 < 2200 then begin

 if marketposition <> 0 then begin
  
  setstopshare;

  //STOPLOSS
  //setstoploss(stoploss);
  if marketposition = 1 and stoploss > 0 then begin
   stopVal = EntryPrice-MM.StopLoss(stoploss)/bigpointvalue;
   if c <= stopVal then	
    sell("xl.stop.m") next bar at market
   else if StopMin < StopVal and StopVal < StopMax then
    setstoploss(stoploss);
  end else
  if marketposition = -1 and stoploss > 0 then begin
   stopVal = EntryPrice+MM.StopLoss(stoploss)/bigpointvalue;
   if c >= stopVal then
    buytocover("xs.stop.m") next bar at market
   else if StopMin < StopVal and StopVal < StopMax then
    setstoploss(stoploss);
  end;

  //BREAK EVEN
  //if mpp > brk/bigpointvalue then begin
  // if marketposition = 1 then sell("brkl") next bar at entryprice + 100/bigpointvalue stop;
  // if marketposition = -1 then buytocover("brks") next bar at entryprice - 100/bigpointvalue stop;
  //end;
  if mpp > brk/bigpointvalue and brk > 0 then begin
   if marketposition = 1 then begin
    stopVal = entryprice + 100/bigpointvalue;
    if c <= stopVal then
     sell("xl.brk.m") next bar at market
    else if StopMin < StopVal and StopVal < StopMax then
     sell("xl.brk.s") next bar at stopVal stop;
   end
   else
   if marketposition = -1 then begin
    stopVal = entryprice - 100/bigpointvalue;
    if c >= stopVal then
     buytocover("xs.brk.m") next bar at market
    else if StopMin < StopVal and StopVal < StopMax then
     buytocover("xs.brk.s") next bar at stopVal stop;
   end;
  end;

  //MODAL EXIT
  //if currentcontracts = nos and nos > 1 then begin
  // if marketposition = 1 then sell("tl") nos/2 shares next bar at entryprice + tl/bigpointvalue limit;
  // if marketposition = -1 then buytocover("ts") nos/2 shares next bar at entryprice - ts/bigpointvalue limit;
  //end;
  if currentcontracts = nos and nos > 1 then begin
   if marketposition = 1 and tl > 0 then begin
    stopVal = entryprice + tl/bigpointvalue;
    if c >= stopVal then
     sell("xl.mod.m") nos/2 shares next bar at market
    else if StopMin < StopVal and StopVal < StopMax then
     sell("xl.mod.s") nos/2 shares next bar at stopVal limit;
   end
   else
   if marketposition = -1 and ts > 0 then begin
    stopVal = entryprice - ts/bigpointvalue;
    if c <= stopVal then
     buytocover("xs.mod.m") nos/2 shares next bar at market
    else if StopMin < StopVal and StopVal < StopMax then
     buytocover("xs.mod.s") nos/2 shares next bar at stopVal limit;
   end;
  end;

 //TRAILING STOP
 //if currentcontracts = nos/2 then begin
 // if marketposition = 1 then sell("trsl") next bar at entryprice + (mpp - trsl/bigpointvalue) stop;
 // if marketposition = -1 then buytocover("trss") next bar at entryprice - (mpp - trss/bigpointvalue) stop;
 //end;
 if currentcontracts = nos/2 then begin
  if marketposition = 1 and trsl > 0 then begin
   stopVal = entryprice + (mpp - trsl/bigpointvalue);
   if c <= stopVal then
    sell("xl.trl.m") next bar at market
   else if StopMin < StopVal and StopVal < StopMax then
    sell("xl.trl.s") next bar at stopVal stop;
  end
  else
  if marketposition = -1 and trss > 0 then begin
   stopVal = entryprice - (mpp - trss/bigpointvalue);
   if c >= stopVal then
    buytocover("xs.trl.m") next bar at market
   else if StopMin < StopVal and StopVal < StopMax then
    buytocover("xs.trl.s") next bar at stopVal stop;
  end;
 end;
  
 end;

 //ENGINE
 if adxval < adxlimit then begin
  if marketposition < 1 and underK and c < upperk and underATRl then
   //buy("long") nos shares next bar at upperk stop;
   if c >= upperk then
    buy("el.m") nos shares next bar at market
   else if StopMin < upperk and upperk < StopMax then
    buy("el.s") nos shares next bar at upperk stop;
  if marketposition > -1 and overK and c > lowerk and underATRs then
   //sellshort("short") nos shares next bar at lowerk stop;
   if c <= lowerk then
    sellshort("es.m") nos shares next bar at market
   else if StopMin < lowerk and lowerk < StopMax then
    sellshort("es.s") nos shares next bar at lowerk stop;
 end;
 
end;
