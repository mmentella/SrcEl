[LegacyColorValue = true]; 

{ ricevuto da Marco Bulli il 31.07.09
}
Inputs:		waitPeriodMins(30), initTradesEndTime(1430), liqRevEndTime(1200),
				thrustPrcnt1(0.30), thrustPrcnt2(0.60), breakOutPrcnt(0.25),
				failedBreakOutPrcnt(0.25), protStopPrcnt1(0.25), protStopPrcnt2(0.15),
				protStopAmt(3.00), breakEvenPrcnt(0.50);

if Date <> Date[1] then 
begin
	Vars:		averageRange(0), yesterdayOCRRange(0), averageOCRange(0), canTrade(0);
	averageRange      = Average(Range,10) Data2; {Data 2 points to daily bars}
	yesterdayOCRRange = AbsValue(Open Data2-Close Data2);
	averageOCRange    = Average(AbsValue(Open Data2-Close Data2),10);
	canTrade = 0;
	if(yesterdayOCRRange< 0.85*averageOCRange) then 		canTrade = 1;
	Vars:		buyEasierDay(FALSE), sellEasierDay(FALSE);
	buyEasierDay  = FALSE;
	sellEasierDay = FALSE;

	if Close Data2 <= Close[1] Data2 then 		buyEasierDay  = TRUE;
	if Close Data2 >  Close[1] Data2 then 		sellEasierDay = TRUE;
	if buyEasierDay then
	begin
		Vars:		buyBOPoint(0), sellBOPoint(0);
		buyBOPoint  = Open data1 + thrustPrcnt1*averageRange;
		sellBOPoint = Open data1 - thrustPrcnt2*averageRange;
	{	Trading Strategies That Work 143}
	end;
	if sellEasierDay then
	begin
		sellBOPoint = Open data1 - thrustPrcnt1*averageRange;
		buyBOPoint  = Open data1 + thrustPrcnt2*averageRange;
	end;
	Vars:		longBreakPt(0), shortBreakPt(0), longFBOPoint(0), shortFBOPoint(0);
	longBreakPt   = High Data2 + breakOutPrcnt*averageRange;
	shortBreakPt  = Low  Data2 - breakOutPrcnt*averageRange;
	shortFBOPoint = High Data2 - failedBreakOutPrcnt*averageRange;
	longFBOPoint  = Low  Data2 + failedBreakOutPrcnt*averageRange;
	Vars:			barCount(0), intraHigh(0), intraLow(999999), buysToday(0), sellsToday(0), currTrdType(0);
	barCount    = 0;
	intraHigh   = 0;
	intraLow    = 999999; {Didn't know you could do this}
	buysToday   = 0;
	sellsToday  = 0;{You can put multiple statements on one	line}
	currTrdType = 0;
end; {End of the first bar of data}


if High > intraHigh then 		intraHigh = High;
if Low < intraLow   then 		intraLow = Low;
barCount = barCount + 1; {count the number of bars of intraday data}

if barCount > waitPeriodMins/BarInterval 
and canTrade = 1 
then begin
	Vars:			intraTradeHigh(0), intraTradeLow(999999);
	if MarketPosition = 0 then
	begin
		intraTradeHigh = 0;
		intraTradeLow = 999999;
	end;
	
	if MarketPosition = 1 then
	begin
		intraTradeHigh = MaxList(intraTradeHigh,High);
		buysToday = 1;
	end;
	
	if MarketPosition =-1 then
	begin
		intraTradeLow = MinList(intraTradeLow,Low);
		sellsToday = 1;
	end;
	
	if buysToday  = 0 and Time < initTradesEndTime then									Buy ("LBreakOut") next bar buyBOPoint  stop;
	if sellsToday = 0 and Time < initTradesEndTime then									Sell Short("SBreakout") next bar sellBOPoint stop;
	if  intraHigh > longBreakPt 
	and sellsToday = 0 
	and Time < initTradesEndTime 
	then																									Sell Short("SfailedBO") next bar shortFBOPoint stop;
	if  intraLow < shortBreakPt 
	and buysToday = 0 
	and Time < initTradesEndTime then															Buy ("BfailedBO") next bar longFBOPoint stop;
	
	{The next module keeps track of positions and places protective stops}
	if MarketPosition = 1 then
	begin
		Vars:		longLiqPoint(0), shortLiqPoint(0);
		longLiqPoint = EntryPrice - protStopPrcnt1*averageRange;
		longLiqPoint = MinList(longLiqPoint,EntryPrice - protStopAmt);
		if  MarketPosition(1) = -1 
		and BarsSinceEntry = 1 
		and High[1] >= shortLiqPoint 
		and shortLiqPoint < shortFBOPoint
		then				currTrdType = -2; {we just got long from a short liq reversal}
		if currTrdType = -2 then
		begin
			longLiqPoint = EntryPrice - protStopPrcnt2*averageRange;
			longLiqPoint = MinList(longLiqPoint,EntryPrice - protStopAmt);
		end;
		if intraTradeHigh >= EntryPrice + breakEvenPrcnt*averageRange then		longLiqPoint = EntryPrice; {BreakEven trade}
		if Time >= initTradesEndTime then													longLiqPoint = MaxList(longLiqPoint,Lowest(Low,3)); {Trailingstop}
		if Time < liqRevEndTime 
		and sellsToday = 0 
		and longLiqPoint <> EntryPrice 
		and BarsSinceEntry = 4 then																Sell Short ("LongLiqRev") next bar longLiqPoint stop
		else 																								Sell("LongLiq") next bar longLiqPoint stop;
	end;
	
	if MarketPosition =-1 then
	begin
		shortLiqPoint = EntryPrice+protStopPrcnt1*averageRange;
		shortLiqPoint = MaxList(shortLiqPoint,EntryPrice + protStopAmt);
		if MarketPosition(1) = 1 
		and BarsSinceEntry(0) = 1 
		and Low [1] <= longLiqPoint 
		and longLiqPoint > longFBOPoint then	currTrdType = +2; {we just got long from a short liq reversal}
		if currTrdType = +2  then
		begin
			shortLiqPoint = EntryPrice + protStopPrcnt2*averageRange;
			shortLiqPoint = MaxList(shortLiqPoint,EntryPrice + protStopAmt);
		end;
		if intraTradeLow <= EntryPrice - breakEvenPrcnt*averageRange then			shortLiqPoint = EntryPrice; {BreakEven trade}
		if Time >= initTradesEndTime then		shortLiqPoint = MinList(shortLiqPoint,Highest(High,3));
		
		{Trailing stop}
		if Time < liqRevEndTime 
		and buysToday = 0 
		and shortLiqPoint <> EntryPrice 
		and BarsSinceEntry = 4 then																Buy("ShortLiqRev") next bar shortLiqPoint stop
		else 																								Buy to Cover("ShortLiq") next bar shortLiqPoint stop;
	end;

end;
