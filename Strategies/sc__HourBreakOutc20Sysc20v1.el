[LegacyColorValue = TRUE];

Inputs: StopLoss(5), BreakHeavenAfterBars(3), BreakHeavenLevel(5), OpPeriodNr(2);
Vars: mPeriod(0), mBar(0), mHigh(0), mLow(0);
Vars: isBreakHSet(false), NrEntry(0);
Vars: EndTime(1800), ChangePeriod(false);
Array: Period[11](0);

{--------------------------------------------------------------------}
if currentbar=1 then begin
	{INIT}
	Period[1]= 0900;
	Period[2]= 0930;
	Period[3]= 1030;
	Period[4]= 1130;
	Period[5]= 1230; {begin flat period}
	Period[6]= 1400; {end flat period}
	Period[7]= 1500;
	Period[8]= 1600;
	Period[9]= 1700;
	Period[10]= EndTime;
	Period[11]= 1900;
end else begin
	{SYSTEM}
	if Date[1]<Date then begin
		ChangePeriod= false;
		mPeriod= 1;
		mBar= currentbar;
		NrEntry= 0;
	end;
	if BarsSinceEntry(0)=1 then
		NrEntry= NrEntry+1;

	if mBar>0 and Time<=EndTime then begin
			if Time>=Period[mPeriod+1] then begin
			ChangePeriod= true;
			if marketposition>0 then
				sell ("XL-end") this bar at close;
			if marketposition<0 then
				buytocover ("XS-end") this bar at close;
		end;
		if ChangePeriod then begin
			mPeriod= mPeriod+1;	
			ChangePeriod= false;
			mHigh= (Highest(high, currentbar -mBar)) data2;
			mLow= (Lowest(low, currentbar -mBar)) data2;
			mBar= currentbar;
			isBreakHSet= false;
			NrEntry= 0;
		end;

		if marketposition=0 then
			isBreakHSet= false;

		if BarsSinceEntry(0)>BreakHeavenAfterBars then begin
			if marketposition>0 and isBreakHSet=false then
				if high>entryprice+BreakHeavenLevel then
					isBreakHSet= true;
			if marketposition<0 and isBreakHSet=false then
				if low<entryprice-BreakHeavenLevel then
					isBreakHSet= true;
		end;

		if mHigh>0 and mLow>0 then begin
			if MinutesToTime(TimeToMinutes(Time)+1)<Period[mPeriod+1] and 
			 Time>=Period[2] and
			 mPeriod<>5 and {Flat period}
			 Time<EndTime and 
			 NrEntry<OpPeriodNr then begin
				if high[1] data2 <= mHigh or high[2] data2 <=mHigh and (RSI(C, 14)) data2 < 60 then
					buy ("Long") next bar at mHigh+1 stop;
				if low[1] data2 >=mLow or low[2] data2 >=mLow and (RSI(C, 14)) data2 > 35 then
					sellshort ("Short") next bar at mLow-1 stop;
			end;
		end;
		
		{BreakHeaven and StopLoss}
		if isBreakHSet then begin
			if marketposition>0 then
				sell ("XLBreakHeaven") Next Bar at entryprice Stop;
			if marketposition<0 then
				buytocover ("XSBreakHeaven") Next Bar at entryprice Stop;
		end else begin
			if marketposition>0 then
				sell ("XStopL") Next Bar at entryprice-StopLoss stop;
			if marketposition<0 then
				buytocover ("XStopS") Next Bar at entryprice+StopLoss stop;
		end;
	end;
end;
{--------------------------------------------------------------------}

