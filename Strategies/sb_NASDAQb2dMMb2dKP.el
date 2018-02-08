inputs: nos(6),lenl(3),kl(1.53),lens(19),ks(3.55),adxlen(14),adxlimit(30);
inputs: stopl(700),stops(750),modl(800),mods(800),trsl(2300),trss(2400),tl(4800),ts(4900);

inputs: sod(0800), eod(2215);
inputs: DayLimit("4.5%"), SettleTime(2210);


vars: upperk(0,data2),lowerk(0,data2),adxval(0,data2),bs(true,data2),ss(true,data2),mcp(0);
vars: mp(0),trade(true),bar2(true),nbar2(true,data2);
Vars: eltg(999999),estg(0);

Vars: stopVal(0), stopMin(0), stopMax(999999), SettlePrice(0);   
Vars: dayMax(0), dayPerc(false);


if currentbar <= 1 then begin
 if DayLimit <> "" then
  if RightStr(DayLimit, 1) = "%" then begin
   dayMax = StrToNum(LeftStr(DayLimit, StrLen(DayLimit) - 1)); dayPerc = true; end
  else begin
   dayMax = StrToNum(DayLimit)/bigpointvalue; dayPerc = false; end;
end;

{ max/min Stop Update }
if dayMax > 0 then begin
 if Date > Date[1] then begin
  if SettleTime = 0 then SettlePrice = Close[1];
  if dayPerc then begin
   stopMin = SettlePrice*(1-dayMax/100);
   stopMax = SettlePrice*(1+dayMax/100);
  end else begin
   stopMin = SettlePrice-dayMax;
   stopMax = SettlePrice+dayMax;
  end;
  settlePrice = 0;
 end;
 if Time >= SettleTime and SettlePrice = 0 then SettlePrice = Close;
end;


mp  = currentcontracts*marketposition;
mcp = MM.MaxContractProfit;

if barstatus(2) = 2 then begin
 upperk = keltnerchannel(h,lenl,kl)data2;
 lowerk = keltnerchannel(l,lens,-ks)data2;
 adxval = adx(adxlen)data2;
 bs     = c data2 < upperk;
 ss     = c data2 > lowerk;
 nbar2  = not nbar2;
end;

if mp   <> mp[1] then trade = false;
if bar2 <> nbar2 then trade = true;

if sod <= time and time < eod then begin   // start of day

if marketposition <> 0 then begin
  
 setstopshare;
 
 //STOPLOSS
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
 if marketposition = 1 and tl > 0 then begin
  stopVal = entryprice+MM.ProfitTarget(tl)/bigpointvalue;
  if h >= stopVal then
   sell("xl.prof.m") next bar at market
  else
  if StopMin < StopVal and StopVal < StopMax then
   setprofittarget(tl);
 end
 else
 if marketposition = -1 and ts > 0 then begin
  stopVal = entryprice-MM.ProfitTarget(ts)/bigpointvalue;
  if l <= stopVal then
   buytocover("xs.prof.m") next bar at market
  else
  if StopMin < StopVal and StopVal < StopMax then
   setprofittarget(ts);
 end;
 
 //MODAL EXIT
 if currentcontracts = nos and nos > 1 then begin
  if marketposition = 1 and modl > 0 then begin
   stopVal = MM.ModalExit(modl);
   if h >= stopVal then
    sell("xl.mod.m") nos/2 shares next bar at market
   else
   if StopMin < StopVal and StopVal < StopMax then
    sell("xl.mod.s") nos/2 shares next bar at stopVal limit;
  end
  else
  if marketposition = -1 and mods > 0 then begin
   stopVal = MM.ModalExit(mods);
   if l <= stopVal then
    buytocover("xs.mod.m") nos/2 shares next bar at market
   else
   if StopMin < StopVal and StopVal < StopMax then
    buytocover("xs.mod.s") nos/2 shares next bar at stopVal limit;
  end;
 end;
 
 //TRAILING STOP
 if currentcontracts = nos/2 then begin
  if marketposition = 1 and trsl > 0 then begin
   stopVal = MM.TrailingStop(trsl,mcp);
   if l <= stopVal then
    sell("xl.trl.m") nos/2 shares next bar at market
   else
   if StopMin < StopVal and StopVal < StopMax then
    sell("xl.trl.s") nos/2 shares next bar at stopVal stop;
  end
  else
  if marketposition = -1 and trss > 0 then begin
   stopVal = MM.TrailingStop(trss,mcp);
   if h >= stopVal then
    buytocover("xs.trl.m") nos/2 shares next bar at market
   else
   if StopMin < StopVal and StopVal < StopMax then
    buytocover("xs.trl.s") nos/2 shares next bar at stopVal stop;
  end;
 end;
 
end;

 //ENGINE
 if adxval < adxlimit and trade then begin
  //if marketposition < 1 and bs then
  // buy("long") nos shares next bar at upperk stop;
  if marketposition < 1 then
   if h > eltg then begin
    buy("el.m") nos shares next bar at market;
    eltg = 999999;
   end
   else begin
    eltg = 999999;
    if bs then
     if StopMin < upperk and upperk < stopMax then
      buy("el.s") nos shares next bar at upperk stop
     else
      eltg = upperk;
   end;
  //if marketposition > -1 and ss then
  // sellshort("short") nos shares next bar at lowerk stop;
  if marketposition > -1 then
   if l < estg then begin
    sellshort("es.m") nos shares next bar at market;
    estg = 0;
   end
   else begin
    estg = 0;
    if ss then
     if StopMin < lowerk and lowerk < StopMax then
      sellshort("es.s") nos shares next bar at lowerk stop
     else
      estg = lowerk;
   end;
 end
 else begin
  eltg = 999999;
  estg = 0;
 end;

end   // of day

else begin
 eltg = 999999;
 estg = 0;

end;

if barstatus(2) <> 2 then bar2 = nbar2;
