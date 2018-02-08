
Inputs: NoS(2),LenL(45),KL(1),LenS(6),KS(1.85),ADXLen(14),ADXLimit(31);
Inputs: MaxDayEntries(1);
Inputs: DailyMaxLoss(2500), DailyRestart(1);
Inputs: MoneyMng(true);
Inputs: StopLoss(1000),BRK(300),TL(1000),TS(2200){,TRSL(1000),TRSS(1000)};


Vars: upperk(0,data2),lowerk(0,data2),adxval(0,data2);
Vars: underK(false,data2), overK(false,data2);
Vars: maxposprof(0),bounce(false),mp(0),trade(true);

Vars: dayEntries(1);
Vars: eqTotal(0), eqYestClose(0), eqDay(0), dayPos(0), newDay(false);
Vars: dayMaxLoss(0), dayRestart(0), dayTrade(true), dayIdxStop(0);
Vars: stopVal(0);

{ Process Variables }
Vars: OpenTime(930), CloseTime(1945);


{ INIT }
if CurrentBar <= 1 then begin
	if DailyMaxLoss > 0 then begin
		dayMaxLoss = DailyMaxLoss / BigPointValue;
		if DailyRestart > 0 then
			dayRestart = CalcTime(OpenTime, -BarInterval + DailyRestart)
		else
		if DailyRestart < 0 then
			dayRestart = CalcTime(OpenTime, -MaxList(BarInterval, DailyRestart));
	end;
end;

{ Day Position }
eqTotal = NetProfit + PositionProfit;
if Date > Date[1] then begin
	dayEntries = 0;
	if DailyMaxLoss <> 0 then begin
		eqYestClose = eqTotal[1]; newDay = true;
	end;
end;
if MarketPosition <> 0 and BarsSinceEntry = 0 then
	dayEntries = dayEntries + 1;

if not dayTrade and OpenTime <= time and time < CloseTime then begin
 //Engine (trading stopped)
 if adxval < adxlimit and trade and bounce = false then begin
  if dayPos < 1 and underK then
    if h >= upperk then dayPos = nos;
  if dayPos > -1 and overK then
    if l <= lowerk then dayPos = -nos;
 end;
end;

bounce = false;
mp = marketposition*currentcontracts;

if marketposition <> 0 then begin
 if barssinceentry = 0 then begin
  if marketposition = 1 then maxposprof = h - entryprice;
  if marketposition = -1 then maxposprof = entryprice - l;
 end
 else begin
  if marketposition = 1 then maxposprof = maxlist(h - entryprice,maxposprof);
  if marketposition = -1 then maxposprof = maxlist(entryprice - l,maxposprof);
 end;
end;

if mp <> mp[1] then trade = false;
//if barstatus(2) = 2 then trade = true;

// New TimeFrame2 bar
if BarStatus(2) = 2 then begin
 upperk = KeltnerChannel(h,lenl,kl)data2;
 lowerk = KeltnerChannel(l,lens,-ks)data2;
 adxval = adx(adxlen)data2;
 underK = c data2 < upperk;
 overK = c data2 > lowerk;
 trade = true;
end;   // of new TimeFrame2 bar

//if time > 800 and time < 2300 then begin
if OpenTime <= time and time < CloseTime then begin

	if DailyMaxLoss > 0 then begin
		if newDay then begin
			newDay = false;
			if not dayTrade then begin
				dayTrade = true;
				//if Time >= dayRestart then begin
				if MarketPosition = 0 and DailyRestart > 0 then begin
					if dayPos > 0 then begin
						Buy ("EL-ReEnter.m") dayPos shares next bar at Market;
						dayEntries = dayEntries - 1; end
					else
					if dayPos < 0 then begin
						SellShort ("ES-ReEnter.m") -dayPos shares next bar at Market;
						dayEntries = dayEntries - 1; end;
				end;
			end;
		end
		else
		if DailyRestart < 0 and Time >= dayRestart then begin
			if not dayTrade then begin
				dayTrade = true;
				if dayPos > 0 then
					Buy ("EL-Restart.m") dayPos shares next bar at Market
				else
				if dayPos < 0 then
					SellShort ("ES-Restart.m") -dayPos shares next bar at Market;
				dayPos = 0;
			end;
		end
		else begin
			dayIdxStop = 0;
			eqDay = eqTotal - eqYestClose;
			if dayTrade then begin
				if eqDay <= -DailyMaxLoss then
					dayTrade = false
				else begin
					dayPos = Sign(MarketPosition) * CurrentContracts;
					if MarketPosition > 0 then begin
						dayIdxStop = Close - (eqDay / BigPointValue + dayMaxLoss) / CurrentContracts;
						Sell ("XL-DayStop.s") next bar at dayIdxStop Stop; end
					else if MarketPosition < 0 then begin
						dayIdxStop = Close + (eqDay / BigPointValue + dayMaxLoss) / CurrentContracts;
						BuyToCover ("XS-DayStop.s") next bar at dayIdxStop Stop; end;
				end;
			end;
			if not dayTrade then begin
				if MarketPosition > 0 then begin
					dayPos = CurrentContracts;
					Sell ("XL-DayAbort.m") next bar at Market;
				end
				else if MarketPosition < 0 then begin
					dayPos = -CurrentContracts;
					BuyToCover ("XS-DayAbort.m") next bar at Market;
				end;
			end;
		end;
	end;

 if marketposition <> 0 and MoneyMng then begin
  //StopLoss
  setstopshare;
  setstoploss(stoploss);
  //BreakEven Trailing Stop
  if maxposprof > brk/bigpointvalue then begin
   if marketposition = 1 then begin
    stopVal = entryprice + 80/bigpointvalue;
    if c <= stopVal then
     sell("XL-Brk.m") next bar at market
    else
     sell("XL-Brk.s") next bar at stopVal stop;
    //sell("trsl") next bar at entryprice + (maxposprof - trsl/bigpointvalue) stop;
    bounce = lowerk < entryprice + 80/bigpointvalue;
   end;
   if marketposition = -1 then begin
    stopVal = entryprice - 80/bigpointvalue;
    if c >= stopVal then
     buytocover("XS-Brk.m") next bar at market
    else
     buytocover("XS-Brk.s") next bar at stopVal stop;
    //buytocover("trss") next bar at entryprice - (maxposprof - trss/bigpointvalue) stop;
    bounce = upperk > entryprice - 80/bigpointvalue;
   end;
  end;
  //Uscita Modale
  if currentcontracts = nos and nos > 1 then begin
   if marketposition = 1 then begin
    stopVal = entryprice + tl/bigpointvalue;
    if h >= stopVal then
     sell("XL-Mod1.m") nos/2 shares next bar at market
    else
     sell("XL-Mod1.s") nos/2 shares next bar at stopVal limit;
   end;
   if marketposition = -1 then begin
    stopVal = entryprice - ts/bigpointvalue;
    if l <= stopVal then
     buytocover("XS-Mod1.m") nos/2 shares next bar at market
    else
     buytocover("XS-Mod1.s") nos/2 shares next bar at entryprice - ts/bigpointvalue limit;
   end;
  end;
 end;

 //Engine
 if dayTrade and adxval < adxlimit and trade and bounce = false then begin
  if marketposition < 1 and {c data2 < upperk} underK then begin
   if dayEntries < MaxDayEntries then begin
    if c >= upperk then
     buy("EL.m") nos shares next bar at market
    else
     buy("EL.s") nos shares next bar at upperk stop;
   end else begin
    if c >= upperk then
     buytocover("XS.m") currentcontracts shares next bar at market
    else
     buytocover("XS.s") currentcontracts shares next bar at upperk stop;
   end;
  end;
  if marketposition > -1 and {c data2 > lowerk} overK then begin
   if dayEntries < MaxDayEntries then begin
    if c <= lowerk then
     sellshort("ES.m") nos shares next bar at market
    else
     sellshort("ES.s") nos shares next bar at lowerk stop;
   end else begin
    if c <= lowerk then
     sell("XL.m") currentcontracts shares next bar at market
    else
     sell("XL.s") currentcontracts shares next bar at lowerk stop;
   end;
  end;
 end;

end;
