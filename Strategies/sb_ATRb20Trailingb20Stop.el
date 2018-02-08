[LegacyColorValue = true]; 

Inputs: TrailingATRs(4), ATRLength(10);
Variables: PosHigh(0), PosLow(0), ATRVal(0);

ATRVal = AvgTrueRange(ATRLength) * TrailingATRs;

If MarketPosition = 1 Then Begin
	If BarsSinceEntry = 0 Then
		PosHigh = High;
	If High > PosHigh Then
		PosHigh = High;
	Sell Next Bar at PosHigh - ATRVal Stop;
End;

If MarketPosition = -1 Then Begin
	If BarsSinceEntry = 0 Then
		PosLow = Low;
	If Low < PosLow Then
		PosLow = Low;
	Buy to Cover Next Bar at PosLow + ATRVal Stop;
End;


