[LegacyColorValue = TRUE];


{***************************************
Written by: Emi 01feb05

 Description: applica APemi quando vola in rialzo e - in alternativa - il sideways con il ribasso
****************************************}

Inputs: ADXlimitinc(20),ADXlimitdec(39),lgavg(200);
variable: ADXlength(13),counterAPL(0),counterSdL(0);

condition1 = MirkoFvola cross above Xaverage(MirkoFvola,lgavg) AND ADX(ADXlength) > ADXlimitinc;
condition4 = MirkoFvola cross below Xaverage(MirkoFvola,lgavg) AND ADX(ADXlength) < ADXlimitdec;


If (Condition1  AND (condition4 = FALSE)) Then begin
	{usa APEmi per i segnali}

	Variables: Mom.d1(00,Data1), Mom.d2(00,Data2), Bias.d1(0),Bias.d2(0),FastMovAvg(12), SlowMovAvg(26), MACDMovAvg(9);

Mom.d1 = MACD(Close, FastMovAvg, SlowMovAvg) of Data1;
Mom.d2 = MACD(Close, FastMovAvg, SlowMovAvg) of Data2;

Bias.d1 = XAverage(Mom.d1, MACDMovAvg)[1];
Bias.d2 = XAverage(Mom.d2, MACDMovAvg)[1] of Data2;

	Condition2 = (CurrentBar > 2) AND (Mom.d1 >= Bias.d1) AND (Mom.d1 cross Above 0);
		
	Condition3 = (Mom.d2 > Bias.d2);
	

If (Condition2 AND Condition3) Then
	Buy ("APemi-LO")  this Bar at Close;
counterAPL = counterAPL + 1;
end

else
{ALTRIMENTI usa Sideways per i segnali}	
begin
Inputs: RSILength(5), OverSold(24);
Variables: RS.d1(00,Data1);

RS.d1 = RSI(Close, RSILength) of Data1;

If RS.d1 Cross Over OverSold  Then
	Buy ("SD-LO") this Bar at Close;
counterSdL=counterSdL + 1;
end;

if (Date  = @vrt.LastCalcDate) and (Time = @vrt.LastCalcTime)  then begin
  Print (@vrt.MMDDYYYY (Date), ", ", @vrt.HHMM.pm (Time), ", counterAPL=", counterAPL:1:0, ", counterSDL=", counterSdL:1:0) ;
end ;
