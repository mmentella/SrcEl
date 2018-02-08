Inputs: NoS(2);

Inputs: LenL(54), KL(3.71), LenS(92), KS(2.09);
Inputs: ADXlen(14), ADXlimit(31);
Inputs: NumConfirm(2), MaxDayEntries(1);

{ Money Management Inputs }
Variables: _DailyMaxLoss(0);
Inputs: _StopLossLong(1550);
Inputs: _DayContractStopLong(1150);
Inputs: MoneyMng(true);
Inputs: _ModExitLong(1550), _TargetLong(2100);
Variables: _BrkStartLong(0);
Variables: _TrailStartLong(0), _TrailPercLong(0), _TrailDeltaLong(0), _TrailEndPercLong(0);
Inputs: DayLimit("0"), SettleTime(0);

{ Process Inputs }
Inputs: OpenTime(0900), CloseTime(1900){, PauseIn(0), PauseOut(0)};
Variables: StartEntry(0900), StopEntry(1900);


{ Money Management Constants }
Variables: lblNone(-1), lblStopLoss(10), lblStopAlgebric(15), lblModal(20), lblTarget(20), lblBreakEven(30), lblTrailing(40),
           lblATR(50), lblHLbars(60), lblTimeOut(70), lblDayProfit(90), lblDayStop(99), lblEngine(100), hugePrice(999999);
Variables: BPVinv(1 / BigPointValue);
Variables: tickUnit(MinMove / PriceScale),   { TickSize, Points }
           trade$Cost((Commission + Slippage) * 2),   { $$$ }
           tradeCost((IntPortion(trade$Cost * BPVinv / tickUnit) + 1) * tickUnit);   { Points }
Variables: NumModal(Ceiling(NoS / 2)), NumSpare(NoS - NumModal);


{ Strategy Variables }
vars: upk(0,data2),lok(0,data2),adxval(0,data2),el(true,data2),es(true,data2);
vars: _upk(0),_lok(0),_adxval(0),_el(true),_es(true);
vars: stp(false),mkt(false),yc(0),mp(0),trades(0);
vars: goL(0), goS(0);
Vars: dayEntries(0);


{ Money Management Variables }
Vars: MarketEntry(0);     // Could be 'EntryPrice' if LONG, '-EntryPrice' if SHORT
Vars: EntryLongPrice(hugePrice), EntryShortPrice(0), myStopVal(0), myLbl(lblNone);
Vars: StopOrderPrice(0), StopOrderLabel(0), NumContracts(0);
Vars: ModalOrderPrice(0), TargetOrderPrice(0);
Vars: stopMin(0), stopMax(hugePrice);
Vars: stopVal(0), numCntr(0);
Vars: dayMax(0), dayPerc(false), settlePrice(0);
Vars: dayTrade(true);


{****************
  Initialization
 ****************}

if CurrentBar <= 1 then begin
	{ Money Management Init }
	if DayLimit <> "" then
		if RightStr(DayLimit, 1) = "%" then begin
			dayMax = StrToNum(LeftStr(DayLimit, StrLen(DayLimit) - 1)) / 100; dayPerc = true; end
		else begin
			dayMax = StrToNum(DayLimit) / BigPointValue; dayPerc = false;
	 end;
end;


if d <> d[1] then begin
 trades = 0;
 yc = c[1];
end;

if BarsSinceEntry = 0 then begin
	if EntryPrice > 0 then begin
		dayEntries = dayEntries + 1;
		MarketEntry = EntryPrice * MarketPosition;
	end;
end;
if BarStatus(1) = 2 then begin
	if BarsSinceEntry of Data1 = 0 then
		if EntryPrice > 0 then
			if MarketPosition > 0 then MarketEntry = MaxList(EntryLongPrice, Open)
			else
			if MarketPosition < 0 then MarketEntry = -MinList(EntryShortPrice, Open);
end;
if MarketPosition = 0 then MarketEntry = 0;


{**************
  Daily Limits
 **************}

if dayMax > 0 then begin
	if Date > Date[1] then begin
		if settlePrice = 0 then settlePrice = Close[1];
		if dayPerc then begin
			stopMax = settlePrice * (1 + dayMax);
			stopMin = settlePrice * (1 - dayMax);
		end else begin
			stopMax = settlePrice + dayMax;
			stopMin = settlePrice - dayMax;
		end;
		settlePrice = 0;
	end else
		if SettleTime > 0 then
			if Time >= SettleTime and settlePrice = 0 then settlePrice = Close;
	if High > stopMax then stopMax = High;
	if Low < stopMin then stopMin = Low;
end;

if Date > Date[1] then begin
	//dayTrade = true;
	dayEntries = 0;
end;


{**********************
  Strategy Computation
 **********************}

{ Engine Stops Values }

EntryLongPrice = hugePrice; EntryShortPrice = 0;

if barstatus(2) = 2 then begin

 upk = KeltnerChannel(h data2,LenL,KL)data2;
 lok = KeltnerChannel(l data2,LenS,-KS)data2;

 el = c data2 < upk;
 es = c data2 > lok;

 adxval = adx(ADXlen)data2;

end;

mp = currentcontracts*marketposition;
if mp <> mp[1] then trades = trades + 1;

//mcp = MM.MaxContractProfit;


if IsTime2Market(OpenTime, CloseTime, 0, 0) then begin


{***********************
  MoneyManagament Stops
 ***********************}

	NumContracts = CurrentContracts;

	dayTrade = gd.MoneyMngV1A(StopOrderPrice, StopOrderLabel,	ModalOrderPrice, TargetOrderPrice,
	                          NoS, MarketEntry,
	                          true,
	                          _DailyMaxLoss, _StopLossLong,-1, false,
	                          MoneyMng,
	                          _ModExitLong, _TargetLong, _BrkStartLong,
	                          _TrailStartLong, _TrailPercLong, _TrailDeltaLong, _TrailEndPercLong,
	                          -1, -1, -1,
	                          -1, -1, -1, -1
	                         );

	//DAILY STOPLOSS
	if marketposition > 0 then begin
		stopVal = yc - _DayContractStopLong/bigpointvalue;
		if stopVal > StopOrderPrice then begin
			StopOrderPrice = stopVal; StopOrderLabel = lblDayStop; end;
	end;


{*****************
  Market StartUps
 *****************}

	if StartEntry <= Time and Time < StopEntry then begin

		if NumConfirm <= 0 then begin

			//if trades = 0 and adxval < ADXlimit then begin
			if dayEntries < MaxDayEntries and adxval < ADXlimit then begin
			 if marketposition < 1 and c < upk and el then begin
			   buy("el.s") NoS shares next bar at upk stop;
			   EntryLongPrice = upk;
			  end;
			 if marketposition > -1 and c > lok and es then begin
			   sell("es.s") NoS shares next bar at lok stop;
			   EntryShortPrice = lok;
			  end;
			end;

		end
		else begin

			if barstatus(1) = 2 then begin
			 //if trades = 0 and _adxval < ADXlimit then begin
			 if dayEntries < MaxDayEntries and _adxval < ADXlimit then begin
			  if _el and h >= _upk and (goL > 0 or c[1] < _upk) then begin
			   goL = goL + 1;
			   if goL >= NumConfirm then begin
			    buy("el.m") NoS shares next bar at market;
			    goL = 0; EntryLongPrice = 0;
			   end;
			  end else
			   goL = 0;
			  if _es and l <= _lok and (goS > 0 or c[1] > _lok) then begin
			   goS = goS + 1;
			   if goS >= NumConfirm then begin
			    sell("es.m") NoS shares next bar at market;
			    goS = 0; EntryShortPrice = hugePrice;
			   end;
			  end else
			   goS = 0;
			 end
			 else begin
			  goL = 0; goS = 0;
			 end;
			 _upk = upk;_lok = lok;_adxval = adxval;_el = el;_es = es;
			end;

		end;

	end;

	{ MoneyManagament Exits }
	if MarketEntry > 0 then begin { LONG Position Management }

		{ LONG - Put nearest STOP order at Market }
		if StopOrderPrice > EntryShortPrice + tradeCost then
			if Close < StopOrderPrice + tickUnit then begin
				switch StopOrderLabel begin
					case lblStopLoss:     Sell ("XL-Stop.m") NumContracts shares next bar at Market;
					case lblStopAlgebric: Sell ("XL-StAl.m") NumContracts shares next bar at Market;
					case lblHLbars:       Sell ("XL-HBar.m") NumContracts shares next bar at Market;
					case lblATR:          Sell ("XL-ATR.m") NumContracts shares next bar at Market;
					case lblTrailing:     Sell ("XL-Trl.m") NumContracts shares next bar at Market;
					case lblBreakEven:    Sell ("XL-Brk.m") NumContracts shares next bar at Market;
					case lblTimeOut:      Sell ("XL-Tout.m") NumContracts shares next bar at Market;
					case lblDayStop:      Sell ("XL-DayStop.m") NumContracts shares next bar at Market;
					case lblNone:         ;
					default:              Abort;
				end;
			end else
			if StopOrderPrice > stopMin then begin
				switch StopOrderLabel begin
					case lblStopLoss:     Sell ("XL-Stop.s") NumContracts shares next bar at StopOrderPrice Stop;
					case lblStopAlgebric: Sell ("XL-StAl.s") NumContracts shares next bar at StopOrderPrice Stop;
					case lblHLbars:       Sell ("XL-HBar.s") NumContracts shares next bar at StopOrderPrice Stop;
					case lblATR:          Sell ("XL-ATR.s") NumContracts shares next bar at StopOrderPrice Stop;
					case lblTrailing:     Sell ("XL-Trl.s") NumContracts shares next bar at StopOrderPrice Stop;
					case lblBreakEven:    Sell ("XL-Brk.s") NumContracts shares next bar at StopOrderPrice Stop;
					case lblDayStop:      Sell ("XL-DayStop.s") NumContracts shares next bar at StopOrderPrice Stop;
					case lblNone:         ;
					default:              Abort;
				end;
			end;

		if ModalOrderPrice < hugePrice then
			if ModalOrderPrice <= High + tickUnit then
				Sell ("XL-Modal.m") NumModal shares next bar at Market
			else
			if ModalOrderPrice < stopMax then
				Sell ("XL-Modal.s") NumModal shares next bar at ModalOrderPrice Limit;
		
		if TargetOrderPrice < hugePrice and (ModalOrderPrice >= hugePrice or TargetOrderPrice > ModalOrderPrice) then
			if TargetOrderPrice <= High + tickUnit then
				Sell ("XL-Target.m") NumModal shares next bar at Market
			else
			if TargetOrderPrice < stopMax then begin
				numCntr = IFF(ModalOrderPrice < hugePrice, NumSpare, NumContracts);
				Sell ("XL-Target.s") numCntr shares next bar at TargetOrderPrice Limit;
			end;

	end; { of LONG Position Management }


end;
