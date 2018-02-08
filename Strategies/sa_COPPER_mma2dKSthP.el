Inputs: NoS(2),LenL(23),KL(2),LenS(36),KS(1.98),alfa(.15);

Inputs: StopLoss(1100),BRKL(800),BRKS(500),TL(1800),TS(1650),TRSL(1200),TRSS(300);

Inputs: DayLimit("4500"), SettleTime(1900);   // $4,500 == 10% off of $5,000 daily limit


Vars: upperk(0,data2),lowerk(0,data2),adxval(0,data2);
Vars: underK(false,data2),overK(false,data2),underATRl(false,data2),underATRs(false,data2);
Vars: eltg(999999), estg(0),mpp(0);

Vars: stopVal(0), stopMin(0), stopMax(999999), SettlePrice(0);   
Vars: dayMax(0), dayPerc(false);


if currentbar <= 1 then begin
	if DayLimit <> "" then
		if RightStr(DayLimit, 1) = "%" then begin
			dayMax = StrToNum(LeftStr(DayLimit, StrLen(DayLimit) - 1)); dayPerc = true; end
		else begin
			dayMax = StrToNum(DayLimit) / bigpointvalue; dayPerc = false;
		end;
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


if barstatus(2) = 2 then begin

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
 adxval = ADXCustom(h,l,c,14)data2;

end;


if marketposition <> 0 then begin
 //MAX CONTRACT PROFIT
 if barssinceentry = 0 then begin
  if marketposition = 1 then mpp = h - entryprice;
  if marketposition = -1 then mpp = entryprice - l;
 end else begin
  if marketposition = 1 then mpp = maxlist(mpp,h-entryprice);
  if marketposition = -1 then mpp = maxlist(mpp,entryprice-l);
 end;
end;

if t > 800 and t < 2200 then begin
 
 if marketposition <> 0 then begin
  
  //STOPLOSS
  setstopshare;
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

  //BREAKEVEN
  //if mpp > brkl/bigpointvalue then if marketposition = 1 then
  // sell("brkl") next bar at entryprice + 100/bigpointvalue stop;
  //if mpp > brks/bigpointvalue then if marketposition = -1 then
  // buytocover("brks") next bar at entryprice - 100/bigpointvalue stop;
  if marketposition = 1 and mpp > brkl/bigpointvalue and brkl > 0 then begin
   stopVal = entryprice + 100/bigpointvalue;
   if c <= stopVal then
    sell("xl.brk.m") next bar at market
   else if StopMin < StopVal and StopVal < StopMax then
    sell("xl.brk.s") next bar at stopVal stop;
  end
  else
  if marketposition = -1 and mpp > brks/bigpointvalue and brks > 0 then begin
   stopVal = entryprice - 100/bigpointvalue;
   if c >= stopVal then
    buytocover("xs.brk.m") next bar at market
   else if StopMin < StopVal and StopVal < StopMax then
    buytocover("xs.brk.s") next bar at stopVal stop;
  end;

  //MODAL EXIT
  //if currentcontracts = nos and nos > 1 then begin
  // if marketposition = 1 then sell("tl") nos/2 shares next bar at entryprice + tl/bigpointvalue limit;
  // if marketposition = -1 then buytocover("ts") nos/2 shares next bar at entryprice - ts/bigpointvalue limit;
  //end;
  if currentcontracts = nos and nos > 1 then begin
   if marketposition = 1 and tl > 0 then begin
    stopVal = entryprice + tl/bigpointvalue;
    if h >= stopVal then
     sell("xl.mod1.m") nos/2 shares next bar at market
    else if StopMin < StopVal and StopVal < StopMax then
     sell("xl.mod1.s") nos/2 shares next bar at stopVal limit;
   end
   else
   if marketposition = -1 and ts > 0 then begin
    stopVal = entryprice - ts/bigpointvalue;
    if l <= stopVal then
     buytocover("xs.mod1.m") nos/2 shares next bar at market
    else if StopMin < StopVal and StopVal < StopMax then
     buytocover("xs.mod1.s") nos/2 shares next bar at stopVal limit;
   end;
  end;

  //TRAILING STOP
  //if marketposition = 1 then sell("trsl") next bar at entryprice + (mpp - trsl/bigpointvalue) stop;
  //if marketposition = -1 then buytocover("trss") next bar at entryprice - (mpp - trss/bigpointvalue) stop;
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
 
 //ENGINE
 if adxval < 30 and TradesToday(d) = 0 then begin
  // ORIGINAL:
  //if marketposition < 1 and c data2 < upperk and c < upperk and range data2 < AvgTrueRange(lenl) data2 then
  // buy("long") nos shares next bar at upperk stop;
  // FIRST CORRECTION:
  //if underK[1] and c[1] < upperk[1] and underATRl[1] and h > upperk[1] then
  // buy("el.m") nos shares next bar at market
  //else
  //if marketposition < 1 and underK and c < upperk and underATRl then
  // if StopMin < upperk and upperk < StopMax then
  //  buy("el.s") nos shares next bar at upperk stop;
  // REAL WORLD:
  if marketposition < 1 then
   if h > eltg then begin
    buy("el.m") nos shares next bar at market;
    eltg = 999999;
   end
   else begin
    eltg = 999999;
    if underK and c < upperk and underATRl then
     if StopMin < upperk and upperk < stopMax then
      buy("el.s") nos shares next bar at upperk stop
     else
      eltg = upperk;
   end;
  // ORIGINAL:
  //if marketposition > -1 and c data2 > lowerk and c > lowerk and range data2 < AvgTrueRange(lens) data2 then
  // sellshort("short") nos shares next bar at lowerk stop;
  // FIRST CORRECTION:
  //if overK[1] and c[1] > lowerk[1] and underATRs[1] and l < lowerk[1] then
  // sellshort("es.m") nos shares next bar at market
  //else
  //if marketposition > -1 and overK and c > lowerk and underATRs then
  // if StopMin < lowerk and lowerk < StopMax then
  //  sellshort("es.s") nos shares next bar at lowerk stop;
  // REAL WORLD:
  if marketposition > -1 then
   if l < estg then begin
    sellshort("es.m") nos shares next bar at market;
    estg = 0;
   end
   else begin
    estg = 0;
    if overK and c > lowerk and underATRs then
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

end
else begin
 eltg = 999999;
 estg = 0;

end;
