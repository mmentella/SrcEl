{************ - GD KAMA - *************
 Engine: KAMA - Giulio
 Author: Giulio D'Urso
 Year: 2010
 Market: COCOA
 TimeFrame: 2 + 30 min.
 BackBars: 50
 Update: 26 Jul 2010
***************************************}


{******************
  Input parameters
 ******************}

Inputs: NoS(2);

{ Strategy Inputs }
//Inputs: Price(Close);
Inputs: LengthL(5), UpperPerc(2.1), LengthS(8), LowerPerc(2.8);
Inputs: ADXLenL(7), ADXBandL(20), ADXLenS(4), ADXBandS(30);
Inputs: StopTrade(false), StopLongPerc(6), StopShortPerc(6);
Inputs: DelayedBreak(true);

{ Money Management Inputs }
Inputs: MaxDayEntries(99);
Inputs: MoneyMng(true);
Inputs: StopLossLong(1900), StopLossShort(1900), StopBrkLoss(true);
Inputs: ProfTargLong(2000), ProfTargShort(1500), ModalExit(true);
Inputs: BrkStartLong(900), BrkStartShort(800);
//Inputs: TimeOutLong(0), TimeOutShort(60);
//Inputs: ATRlen(0), ATRsLong(0), ATRsShort(0);
//Inputs: LowestBars(0), HighestBars(0);
Inputs: TrailStartLong(1000), TrailPercLong(100), TrailDeltaLong(7000), TrailEndPercLong(5),
        TrailStartShort(800), TrailPercShort(50), TrailDeltaShort(3000), TrailEndPercShort(5);
Inputs: DailyMaxLoss(4000), DailyRestart(10);
Inputs: DayLimit("0"), SettleTime(0000);

{ Process Inputs }
Inputs: OpenTime(0800), CloseTime(2250);
Inputs: StartTime(1500), EndTime(0);
//Inputs: MinTradeTime(0);
//Inputs: DayBreak(false);
//Inputs: GoLong(true), GoShort(true);
//Inputs: PeriodAnalisys(0);


{*****************************
  Local Variables (Constants)
 *****************************}

{ Strategy Constants }
Variables: lenL(LengthL), lenS(LengthS), upPerc(UpperPerc), lowPerc(LowerPerc);
Variables: lADXL(ADXLenL), bADXL(ADXBandL), lADXS(ADXLenS), bADXS(ADXBandS);
Variables: stpLperc(StopLongPerc), stpSperc(StopShortPerc);

{ Money Management Constants }
//Variables: MaxDayEntries(99);
Variables: TimeOutLong(0), TimeOutShort(0);
Variables: lblNone(-1), lblStopLoss(10), lblStopBreak(15), lblProfit(20), lblBreakEven(30),
           lblTimeOut(35), lblTrailing(40), lblATR(50), lblHLbars(60);
Variables: numModal(Ceiling(NoS / 2));
Variables: tickUnit(MinMove / PriceScale),                         { MinMove, Points }
           hugePrice(999999 / BigPointValue),                      { Exhagerated index price, Points }
           tradeCost(Ceiling((Commission + Slippage) * 2 / BigPointValue * PriceScale) / PriceScale), { Points }
           hugeBarsTimeout(250 * 23 * 60 / BarInterval);           { Exhagerated Time interval, minutes }
Variables: stopLloss(IntPortion((StopLossLong / BigPointValue) / tickUnit) * tickUnit),      { Points }
           stopSloss(IntPortion((StopLossShort / BigPointValue) / tickUnit) * tickUnit),     { Points }
           stopLprof(IntPortion((ProfTargLong / BigPointValue) / tickUnit) * tickUnit),      { Points }
           stopSprof(IntPortion((ProfTargShort / BigPointValue) / tickUnit) * tickUnit),     { Points }
           startBrkL(BrkStartLong / BigPointValue), startBrkS(BrkStartShort / BigPointValue),{ Points }
           tOutL(Round(TimeOutLong * 60 / BarInterval of Data2, 0)),  { Bars }
           tOutS(Round(TimeOutShort * 60 / BarInterval of Data2, 0)); { Bars }
Variables: gMinL(TrailStartLong / BigPointValue), gMaxL(TrailStartLong / BigPointValue),     { Points }
           gLossMinL(TrailStartLong / BigPointValue * TrailPercLong / 100), gainMulL(0),     { Points }
           gMinS(TrailStartShort / BigPointValue), gMaxS(TrailStartShort / BigPointValue),   { Points }
           gLossMinS(TrailStartShort / BigPointValue * TrailPercShort / 100), gainMulS(0);   { Points }
//Variables: atrL(ATRlen), atrLmul(ATRsLong), atrSmul(ATRsShort), lBars(LowestBars), hBars(HighestBars);
Variables: dayMax(0), dayPerc(false);

{ Process Constants }
//Variables: StartTime(0), EndTime(0);
//Variables: GoLong(true), GoShort(true);
Variables: inTime(OpenTime), goTime(StartTime), outTime(CloseTime);
Variables: lastTime(EndTime);
//Variables: intraDay(false);


{*****************
  Local variables
 *****************}

{ Strategy Variables }
Vars: _$MA(0, Data2), _$MB(0, Data2), _$RA(0, Data2), _$Rng(0, Data2);
Vars: _$UB(0, Data2), _$LB(0, Data2), _$US(0, Data2), _$LS(0, Data2);
Vars: sADXvalL(0, Data2), sADXvalS(0, Data2);
Vars: runLong(false, Data2), runShort(false, Data2), haltLong(false, Data2), haltShort(false, Data2);
Vars: elStopOk(false, Data2), esStopOk(false, Data2);
Vars: elStop(hugePrice), esStop(0), elTarget(hugePrice), esTarget(0);
Vars: inLong(hugePrice), inShort(0);

{ Money Management Variables }
Vars: dayEntries(0);
Vars: eqTotal(0), eqYestClose(0), eqDay(0), dayPos(0);
Vars: dayMaxLoss(0), dayTrade(true), minToEndDay(DailyRestart), dayRestart(0), dayIdxStop(0);
Vars: lastMMdate(0), lastEntry(0), lastTradeID(0);
Vars: posHi(0.0), posLo(0.0), numContracts(0), stopLbl(0);
Vars: stopMin(0.0), stopMax(hugePrice), settlePrice(0.0);    { Points }
Vars: posStop(0.0), posProf(0), posBrk(0); { Points }
Vars: stp$Loss(0), stp$Prof(0), prof$Val(0.0), stp$Brk(0), brk$Val(0.0); { $$$ }
Vars: gain(0.0), gLoss(0.0), stopVal(0); { Points }
Vars: ATRval(0, Data2);
Vars: atMarket(0), tradeBarLimit(0);

{ Process Variables }
Vars: screeningPeriod(false);
Vars: lastT1(0), lastT2(0, Data2);


{******
  Init
 ******}

if CurrentBar of Data2 <= 1 then begin

	{ Strategy Init }
	if LengthS = 0 then lenS = LengthL;
	if LowerPerc = 0 then lowPerc = UpperPerc;
	if ADXLenS = 0 then lADXS = ADXLenL;
	if ADXBandS = 0 then bADXS = ADXBandL;

	{ Money Management Init }
	if StopLossLong <= 0 then stopLloss = 0;
	if StopLossShort < 0 then stopSloss = 0
	else if StopLossShort = 0 then stopSloss = stopLloss;
	if ProfTargLong <= 0 then stopLprof = 0;
	if ProfTargShort < 0 then stopSprof = 0
	else if ProfTargShort = 0 then stopSprof = stopLprof;
	if BrkStartLong <= 0 then startBrkL = hugePrice;
	if BrkStartShort < 0 then startBrkS = hugePrice
	else if BrkStartShort = 0 then startBrkS = startBrkL;
	if TimeOutLong <= 0 then tOutL = hugeBarsTimeout;
	if TimeOutShort < 0 then tOutS = hugeBarsTimeout
	else if TimeOutShort = 0 then tOutS = tOutL;
	if TrailStartLong <= 0 then
		gMinL = hugePrice
	else
		if TrailDeltaLong > 0 then begin
			gMaxL = (TrailStartLong + TrailDeltaLong) / BigPointValue;
			gainMulL = (gMaxL * TrailEndPercLong / 100 - gLossMinL) / (TrailDeltaLong / BigPointValue);
		end;
	if TrailStartShort < 0 then
		gMinS = hugePrice
	else
	if TrailStartShort > 0 then begin
		if TrailDeltaShort > 0 then begin
			gMaxS = (TrailStartShort + TrailDeltaShort) / BigPointValue;
			gainMulS = (gMaxS * TrailEndPercShort / 100 - gLossMinS) / (TrailDeltaShort / BigPointValue);
		end;
	end else begin // TrailStartShort = 0
		gMinS = gMinL; gMaxS = gMaxL; gLossMinS = gLossMinL; gainMulS = gainMulL;
	end;
//	if ATRsShort = 0 then atrSmul = atrLmul;
//	if HighestBars = 0 then hBars = lBars;
	if DayLimit <> "" then
		if RightStr(DayLimit, 1) = "%" then begin
			dayMax = StrToNum(LeftStr(DayLimit, StrLen(DayLimit) - 1)); dayPerc = true; end
		else begin
			dayMax = StrToNum(DayLimit) / BigPointValue; dayPerc = false;
			dayMax = (Floor(dayMax / tickUnit) - 1) * tickUnit;
		end;

	{ Process Init }
	if OpenTime <= 0 then
		inTime = Sess1StartTime;
	if goTime < inTime then
		goTime = inTime;
	if CloseTime < 0 then
		outTime = CalcTime(Sess1EndTime, BarInterval)
	else
	if CloseTime = 0 then
		outTime = Sess1EndTime
	else
	if outTime > Sess1EndTime then
		outTime = Sess1EndTime;
//	if MinTradeTime <= 0 then begin
		if lastTime <= 0 or lastTime > outTime then
			lastTime = outTime;
//	end
//	else begin
//		intraDay = true;
//		lastTime = CalcTime(outTime, -MinTradeTime);
//	end;

	if DailyMaxLoss > 0 then begin
		dayMaxLoss = (DailyMaxLoss - .5 * tradeCost * NoS) / BigPointValue;
		if minToEndDay > 0 then dayRestart = MaxList(minToEndDay, BarInterval);
		dayRestart = CalcTime(outTime, -minToEndDay);
	end;

end
else begin

{
{*******************
  Periods screening
 *******************}

//screeningPeriod = ((1040501 <= Date and Date <= 1081015) or (1090101 <= Date and Date <= 1101231));
screeningPeriod = (1040501 <= Date and Date <= 1081015);
if PeriodAnalisys = 0
or (PeriodAnalisys < 0 and screeningPeriod)
or (PeriodAnalisys > 0 and not screeningPeriod)
then begin


{ Recover missing end-session bars / intraday problem }
if Date > Date[1] then
	if intraDay and MarketPosition <> 0 then begin
		Sell ("XL-EODmissed") CurrentContracts shares this bar on Close;
		BuyToCover ("XS-EODmissed") CurrentContracts shares this bar on Close;
	end;
}

{******************
  Position Update
 ******************}

{ Max/Min position level }
if MarketPosition > 0 then begin
	atMarket = EntryPrice; numContracts = CurrentContracts;
	if atMarket <> lastTradeID or High > posHi then begin
		posHi = High; lastTradeID = atMarket; end;
end
else
if MarketPosition < 0 then begin
	atMarket = -EntryPrice; numContracts = CurrentContracts;
	if atMarket <> lastTradeID or Low < posLo then begin
		posLo = Low; lastTradeID = atMarket; end;
end
else begin
	atMarket = 0; numContracts = NoS; end;

{ Day Position }
eqTotal = NetProfit + PositionProfit;
if Date > Date[1] then begin
	dayEntries = 0;
	if DailyMaxLoss <> 0 then begin
		eqYestClose = eqTotal[1]; dayTrade = true;
	end;
end;

{ Daily Limits }
if dayMax > 0 then begin
	if Date > Date[1] then begin
		if SettleTime = 0 or settlePrice = 0 then settlePrice = Close[1];
		if dayPerc then begin
			stopMax = (Floor(settlePrice * (1 + dayMax) / tickUnit) - 1) * tickUnit;
			stopMin = (Ceiling(settlePrice * (1 - dayMax) / tickUnit) + 1) * tickUnit;
		end else begin
			stopMax = settlePrice + dayMax;
			stopMin = settlePrice - dayMax;
		end;
		settlePrice = 0; 
	end else
		if Time >= SettleTime and settlePrice = 0 then settlePrice = Close;
	if High > stopMax then stopMax = High;
	if Low < stopMin then stopMin = Low;
end;


{******************
  Context Analisys
 ******************}

if DelayedBreak then begin
//	if Time < inTime or Time >= outTime or DayBreak then   { Out of day operations hours }
	// Save possibly hidden engine break-out
	if MarketPosition > 0 then InLong = hugePrice;
	if MarketPosition < 0 then inShort = 0;
	if runLong then begin
		if High >= _$UB then begin
			if MarketPosition <= 0 then InLong = _$UB;
			if Low > _$LB then InShort = 0;
		end;
	end;
	if runShort then begin
		if Low <= _$LB then begin
			if MarketPosition >= 0 then InShort = _$LB;
			if High < _$UB then inLong = hugePrice;
		end;
	end;
end;

if BarStatus(2) = 2 then begin

//	if atrL > 0 then
//		ATRval = Average(TrueRange of Data2, atrL) Data2;

	_$MA = gd.KAMA(TypicalPrice of Data2, LenL) Data2;
	_$MB = (_$MA * (LenL - 1) + TypicalPrice of Data2) / LenL;
	_$RA = gd.KAMA(TrueRange of Data2, LenL) Data2;
	_$Rng = (_$RA * (LenL - 1) + TrueRange of Data2) / LenL;
	_$UB = _$MB + (_$Rng * upPerc);
	sADXvalL = gdSADX(lADXL) Data2;
	if lenS <> lenL then begin
		_$MA = gd.KAMA(TypicalPrice of Data2, LenS) Data2;
		_$MB = (_$MA * (LenS - 1) + TypicalPrice of Data2) / LenS;
		_$RA = gd.KAMA(TrueRange of Data2, LenS) Data2;
		_$Rng = (_$RA * (LenS - 1) + TrueRange of Data2) / LenS;
	end;
	_$LB = _$MB - (_$Rng * lowPerc);
	runLong = (AbsValue(sADXvalL) < bADXL);
	if lADXS = lADXL then
		sADXvalS = sADXvalL
	else
		sADXvalS = gdSADX(lADXS) Data2;
	runShort = (AbsValue(sADXvalS) < bADXS);
	elStopOk = (stopMin < _$UB and _$UB < stopMax);
	esStopOk = (stopMin < _$LB and _$LB < stopMax);
	if StopTrade then begin
		_$US = _$MB + (_$Rng * stpSperc);
		_$LS = _$MB - (_$Rng * stpLperc);
		haltLong = (sADXvalL <= -bADXL);
		haltShort = (sADXvalS >= bADXS);
	end;

end;


{******************
  Daily Operations
 ******************}

elStop = elTarget; elTarget = hugePrice;
esStop = esTarget; esTarget = 0;

if inTime <= Time and Time < outTime {and not DayBreak} then begin   { Day operations hours }

	stopLbl = lblNone;
	if atMarket > 0 then stopVal = 0 else if atMarket < 0 then stopVal = hugePrice;

{*******************
  Strategy StartUps
 *******************}

	if goTime <= Time and Time < lastTime then begin   { Strategy operations hours }

		if dayTrade then begin
			if inLong < hugePrice then begin
				{if GoLong then} Buy("EL-Delayed.m") NoS shares next bar at Market
				{else BuyToCover ("XS-Delayed.m") CurrentContracts shares next bar at Market};
				inLong = hugePrice; if atMarket < 0 then stopVal = 0;
			end else
			if inShort > 0 then begin
				{if GoShort then} SellShort("ES-Delayed.m") NoS shares next bar at Market
				{else Sell ("XL-Delayed.m") CurrentContracts shares next bar at Market};
				inShort = 0; if atMarket > 0 then stopVal = hugePrice;
			end;
		end
		else begin
			if inLong < hugePrice then begin
				inLong = hugePrice;
				{if GoLong then} dayPos = NoS {else dayPos = 0}; end
			else
			if inShort > 0 then begin
				inShort = 0;
				{if GoShort then} dayPos = -NoS {else dayPos = 0}; end;
		end;

		if runLong then begin

			if dayTrade then begin
				//EntryLong-Condition...
				if {GoLong and} dayEntries < MaxDayEntries then begin
//					if MarketPosition <= 0 then begin
						if Close >= _$UB or High > elStop then begin
							Buy("EL.m") NoS shares next bar at Market;
							if atMarket < 0 then stopVal = 0; end;
						if elStopOk then begin
							Buy("EL.s") NoS shares next bar at _$UB Stop;
							if atMarket < 0 then stopVal = _$UB; end
						else
							elTarget = _$UB;
//						atMarket = Close; posHi = Close; lastTradeID = Close;
//						dayEntries = dayEntries + 1; numContracts = NoS;
//					end;
				end
				else if atMarket < 0 then begin
					BuyToCover ("XS.s") CurrentContracts shares next bar at _$UB Stop;
					stopVal = _$UB;
//					atMarket = 0;
				end;
			end

			else begin
				{ Day Position }
				if High >= elStop then
					{if GoLong then} dayPos = NoS {else dayPos = 0};
				elTarget = _$UB;
			
			end;

		end;

		if runShort then begin

			if dayTrade then begin
				//EntryShort-Condition...
				if {GoShort and} dayEntries < MaxDayEntries then begin
//					if MarketPosition >= 0 then begin
						if Close <= _$LB or Low < esStop or inShort > 0 then begin
							SellShort("ES.m") NoS shares next bar at Market;
							if atMarket > 0 then stopVal = hugePrice; end;
						if esStopOk then begin
							SellShort("ES.s") NoS shares next bar at _$LB Stop;
							if atMarket > 0 then stopVal = _$LB; end
						else
							esTarget = _$LB;
//						atMarket = -Close; posLo = Close; lastTradeID = Close;
//						dayEntries = dayEntries + 1; numContracts = NoS;
//					end;
				end
				else if atMarket > 0 then begin
					Sell ("XL.s") CurrentContracts shares next bar at _$LB Stop;
					stopVal = _$LB;
//					atMarket = 0;
				end;
			end

			else begin
				{ Day Position }
				if Low <= esStop then
					{if GoShort then} dayPos = -NoS {else dayPos = 0};
				esTarget = _$LB;
			
			end;

		end;

		if StopTrade then begin
			if dayTrade then begin
				if haltLong and atMarket > 0 then begin
					Sell ("XL-End.s") next bar at _$LS Stop; stopVal = _$LS; end;
				if haltShort and atMarket < 0 then begin
					BuyToCover ("XS-End.s") next bar at _$US Stop; stopVal = _$US; end;
			end
			else begin
				if haltLong and Low <= esStop then if dayPos > 0 then dayPos = 0;
				if haltShort and High >= elStop then if dayPos < 0 then dayPos = 0;
			end;
		end;

	end; { of strategy operations }


{******************
  Money Management
 ******************}

	{ Day Position Check }
	if DailyMaxLoss > 0 then begin
		if Time >= dayRestart then begin
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
			eqDay = eqTotal - eqYestClose;
			if eqDay <= -DailyMaxLoss then
				dayTrade = false
			else
				if dayTrade then
					dayPos = Sign(MarketPosition) * CurrentContracts;
			if MarketPosition <> 0 then begin
				if dayTrade then begin
					if MarketPosition > 0 then begin
						dayIdxStop = Close - (eqDay / BigPointValue + dayMaxLoss) / CurrentContracts;
						Sell ("XL-DayStop.s") next bar at dayIdxStop Stop; stopVal = dayIdxStop;
					end else begin
						dayIdxStop = Close + (eqDay / BigPointValue + dayMaxLoss) / CurrentContracts;
						BuyToCover ("XS-DayStop.s") next bar at dayIdxStop Stop; stopVal = dayIdxStop;
					end;
				end
				else begin
					if MarketPosition > 0 then begin
						dayPos = CurrentContracts;
						Sell ("XL-DayAbort.m") next bar at Market;
						stopVal = hugePrice;
					end;
					if MarketPosition < 0 then begin
						dayPos = -CurrentContracts;
						BuyToCover ("XS-DayAbort.m") next bar at Market;
						stopVal = 0;
					end;
				end;
			end;
		end;
	end;

	if atMarket <> 0 then begin   { being into the market, money management }
	if MoneyMng then begin

		if Date > lastMMdate then begin
		{ New Day = new STOP limits }
			lastMMdate = Date;
			if dayMax > 0 then begin
				prof$Val = stp$Prof;
				brk$Val = stp$Brk;
				if posProf < stopMin or posProf > stopMax then prof$Val = 0;
				if posBrk < stopMin or posBrk > stopMax then brk$Val = 0;
			end;
		end;

		if lastTradeID <> lastEntry then begin

			{ New trade started }
			dayEntries = dayEntries + 1;
			lastEntry = lastTradeID;
			if atMarket > 0 then begin
				posStop = atMarket - stopLloss + tradeCost;
				stp$Loss = StopLossLong;
				posProf = atMarket + stopLprof + tradeCost;
				stp$Prof = ProfTargLong;
				posBrk = atMarket + tradeCost * 1.5;
				stp$Brk = BrkStartLong;
				tradeBarLimit = CurrentBar of Data2 + tOutL;
			end
			else begin
				posStop = -atMarket + stopSloss - tradeCost;
				if StopLossShort = 0 then stp$Loss = StopLossLong else stp$Loss = StopLossShort;
				posProf = -atMarket - stopSprof - tradeCost;
				if ProfTargShort = 0 then stp$Prof = ProfTargLong else stp$Prof = ProfTargShort;
				posBrk = -atMarket - tradeCost * 1.5;
				if BrkStartShort = 0 then stp$Brk = BrkStartLong else stp$Brk = BrkStartShort;
				tradeBarLimit = CurrentBar of Data2 + tOutS;
			end;
			prof$Val = stp$Prof;
			brk$Val = stp$Brk;
			if dayMax > 0 then begin
				if posProf < stopMin or posProf > stopMax then prof$Val = 0;
				if posBrk < stopMin or posBrk > stopMax then brk$Val = 0;
			end;

		end;

		SetStopContract;

		{ LONG position Money Management }
		if atMarket > 0 then begin
			gain = PosHi - atMarket - tradeCost;
//			stopVal = 0; stopLbl = lblNone;

			{ BreakEven relative Stop Loss }
			if StopBrkLoss and stp$Loss > 0 and 0 < gain and gain < startBrkL then begin
				gLoss = posStop + gain;
				if gLoss > stopVal then begin stopVal = gLoss; stopLbl = lblStopBreak; end;
			end
			else
			{ Absolute Stop Loss }
			if stp$Loss > 0 then
				if posStop > stopVal then begin stopVal = posStop; stopLbl = lblStopLoss; end;
{
			{ Stop 'Lowest' trailing Loss }
			if lBars > 0 then begin
				gLoss = Lowest(Low, lBars);
				if gLoss > stopVal then begin stopVal = gLoss; stopLbl = lblHLbars; end;
			end;

			{ Stop ATR trailing Loss }
			if atrLmul > 0 then begin
				gLoss = PosHi - ATRval * atrLmul;
				if gLoss > stopVal then begin stopVal = gLoss; stopLbl = lblATR; end;
			end;
}
			{ Trailing Stop }
			if gain >= gMinL then begin
				{ calculate allowed profit-loss between 'GainLossMin' and 'GainLossMax', or use 'GainLossMin' as fixed value }
				gLoss = posHi - (gLossMinL + (MinList(gain, gMaxL) - gMinL) * gainMulL) + tradeCost;
				if gLoss > stopVal then begin stopVal = gLoss; stopLbl = lblTrailing; end;
			end;

			{ Break-Even Stops }
			if gain < startBrkL and CurrentBar of Data2 < tradeBarLimit then begin
				if brk$Val > 0 then SetBreakEven(brk$Val);
			end else
				if CurrentBar of Data2 >= tradeBarLimit and gain < startBrkL then begin
					stopVal = hugePrice; stopLbl = lblTimeOut; end
				else
				if posBrk > stopVal then begin
					stopVal = posBrk; stopLbl = lblBreakEven; end;

			{ Absolute / Modal Profit Target }
			if stp$Prof > 0 then
				if ModalExit then begin
					if numContracts < NoS then
						prof$Val = 0
					else
						if High >= posProf then
							Sell ("XL-Mod1.m") numModal shares next bar at Market
						else
							if prof$Val > 0 then
								Sell ("XL-Mod1.s") numModal shares next bar at posProf Limit;
				end else
					if High >= posProf then
						Sell ("XL-Prof.m") numContracts shares next bar at Market
					else
						if prof$Val > 0 then
							SetProfitTarget(prof$Val);

			{ Put minimum STOP order at Market }
			if stopVal > 0 then
				if Close <= stopVal then begin
					switch stopLbl begin
						case lblStopLoss:  Sell ("XL-Stop.m") numContracts shares next bar at Market;
						case lblStopBreak: Sell ("XL-StBr.m") numContracts shares next bar at Market;
						case lblHLbars:    Sell ("XL-HBar.m") numContracts shares next bar at Market;
						case lblATR:       Sell ("XL-ATR.m") numContracts shares next bar at Market;
						case lblTrailing:  Sell ("XL-Trl.m") numContracts shares next bar at Market;
						case lblBreakEven: Sell ("XL-Brk.m") numContracts shares next bar at Market;
						case lblTimeOut:   Sell ("XL-Tout.m") numContracts shares next bar at Market;
						case lblNone:      ;
						default:           Abort;
					end;
				end else
				if stopMin < stopVal and stopVal < stopMax then begin
					switch stopLbl begin
						case lblStopLoss:  SetStopLoss(stp$Loss);
						case lblStopBreak: Sell ("XL-StBr.s") numContracts shares next bar at stopVal Stop;
						case lblHLbars:    Sell ("XL-HBar.s") numContracts shares next bar at stopVal Stop;
						case lblATR:       Sell ("XL-ATR.s") numContracts shares next bar at stopVal Stop;
						case lblTrailing:  Sell ("XL-Trl.s") numContracts shares next bar at stopVal Stop;
						case lblBreakEven: Sell ("XL-Brk.s") numContracts shares next bar at stopVal Stop;
						case lblNone:      ;
						default:           Abort;
					end;
				end;

		end { of LONG Position Management }

		{ SHORT position Money Management }
		else begin
			gain = -atMarket - PosLo - tradeCost;
//			stopVal = hugePrice; stopLbl = lblNone;

			{ BreakEven relative Stop Loss }
			if StopBrkLoss and stp$Loss > 0 and 0 < gain and gain < startBrkL then begin
				gLoss = posStop - gain;
				if gLoss < stopVal then begin stopVal = gLoss; stopLbl = lblStopBreak; end;
			end
			else
			{ Absolute Stop Loss }
			if stp$Loss > 0 then
				if posStop < stopVal then begin stopVal = posStop; stopLbl = lblStopLoss; end;
{
			{ Stop 'Highest' trailing Loss }
			if hBars > 0 then begin
				gLoss = Highest(High, hBars);
				if gLoss < stopVal then begin stopVal = gLoss; stopLbl = lblHLbars; end;
			end;

			{ Stop ATR trailing Loss }
			if atrSmul > 0 then begin
				gLoss = PosLo + ATRval * atrSmul;
				if gLoss < stopVal then begin stopVal = gLoss; stopLbl = lblATR; end;
			end;
}
			{ Trailing Stop }
			if gain >= gMinS then begin
				{ calculate allowed profit-loss between 'GainLossMin' and 'GainLossMax', or use 'GainLossMin' as fixed value }
				gLoss = posLo + (gLossMinS + (MinList(gain, gMaxS) - gMinS) * gainMulS) - tradeCost;
				if gLoss < stopVal then begin stopVal = gLoss; stopLbl = lblTrailing; end;
			end;

			{ Break-Even Stops }
			if gain < startBrkS and CurrentBar of Data2 < tradeBarLimit then begin
				if brk$Val > 0 then SetBreakEven(brk$Val);
			end else
				if CurrentBar of Data2 >= tradeBarLimit and gain < startBrkS then begin
					stopVal = 0; stopLbl = lblTimeOut;
				end else
				if posBrk < stopVal then begin
					stopVal = posBrk; stopLbl = lblBreakEven;
				end;

			{ Absolute / Modal Profit Target }
			if stp$Prof > 0 then
				if ModalExit then begin
					if numContracts < NoS then
						prof$Val = 0
					else
						if Low <= posProf then
							BuyToCover ("XS-Mod1.m") numModal shares next bar at Market
						else
							if prof$Val > 0 then
								BuyToCover ("XS-Mod1.s") numModal shares next bar at posProf Limit;
				end else
					if Low <= posProf then
						BuyToCover ("XS-Prof.m") numContracts shares next bar at Market
					else
						if prof$Val > 0 then
							SetProfitTarget(prof$Val);

			{ Put minimum STOP order at Market }
			if stopVal < hugePrice then
				if Close >= stopVal then begin
					switch stopLbl begin
						case lblStopLoss:  BuyToCover ("XS-Stop.m") numContracts shares next bar at Market;
						case lblStopBreak: BuyToCover ("XS-StBr.m") numContracts shares next bar at Market;
						case lblHLbars:    BuyToCover ("XS-HBar.m") numContracts shares next bar at Market;
						case lblATR:       BuyToCover ("XS-ATR.m") numContracts shares next bar at Market;
						case lblTrailing:  BuyToCover ("XS-Trl.m") numContracts shares next bar at Market;
						case lblBreakEven: BuyToCover ("XS-Brk.m") numContracts shares next bar at Market;
						case lblTimeOut:   BuyToCover ("XS-Tout.m") numContracts shares next bar at Market;
						case lblNone:      ;
						default:           Abort;
					end;
				end else
				if stopMin < stopVal and stopVal < stopMax then begin
					switch stopLbl begin
						case lblStopLoss:  SetStopLoss(stp$Loss);
						case lblStopBreak: BuyToCover ("XS-StBr.s") numContracts shares next bar at stopVal Stop;
						case lblHLbars:    BuyToCover ("XS-HBar.s") numContracts shares next bar at stopVal Stop;
						case lblATR:       BuyToCover ("XS-ATR.s") numContracts shares next bar at stopVal Stop;
						case lblTrailing:  BuyToCover ("XS-Trl.s") numContracts shares next bar at stopVal Stop;
						case lblBreakEven: BuyToCover ("XS-Brk.s") numContracts shares next bar at stopVal Stop;
						case lblNone:      ;
						default:           Abort;
					end;
				end;

		end; { of SHORT Position Management }
		
	end; { of Market Position management }
	end; { of Money Mng }

end; { of day operations }

{
if Time >= lastTime then
	if intraDay then begin
		Sell ("XL-EOD") CurrentContracts shares next bar at Market;
		BuyToCover ("XS-EOD") CurrentContracts shares next bar at Market;
	end;


{*******************
  Periods screening
 *******************}
end { of analized periods }

else begin
	Sell ("XL-OutScope") CurrentContracts shares next bar at Market;
	BuyToCover ("XS-OutScope") CurrentContracts shares next bar at Market;
end; { of excluded periods }
}


end; { of Strategy }
