[LegacyColorValue = true]; 

{*******************************************************************
Description	: TrendLines Automatic Long Entries
Provided By	: Omega Research, Inc. (c) Copyright 1999 
********************************************************************}

Inputs: RelativeHighStren(4);
Variables: RHTLRef(-1), RHTLRef2(-1), RHSet(-1), RHSet2(-1), RHArrayVal(0), RHColorVar(0); 
Variables: BuyPrice(0), PrevBuyPrice(0), BarsPast(0);
Arrays: RHDate[10](0), RHTime[10](0), RHVal[10](0);

{Identification of SwingHigh bars and corresponding TrendLines}
If SwingHighBar(1, High, RelativeHighStren, RelativeHighStren+1) = RelativeHighStren Then Begin
	For Value1 = 9 DownTo 0 Begin
		RHDate[Value1 + 1] = RHDate[Value1];
		RHTime[Value1 + 1] = RHTime[Value1];
		RHVal[Value1 + 1] = RHVal[Value1];
	End;
	RHDate[0] = Date[RelativeHighStren];
	RHTime[0] = Time[RelativeHighStren];
	RHVal[0] = High[RelativeHighStren];

	For Value22 = 1 To 10 Begin
		If RHVal[Value22] > RHVal[0] Then Begin
			RHArrayVal = Value22;
			Value22 = 11;
		End;
	End;
	If Value22 <> 11 Then Begin
		If RHSet >= 0 Then Begin
			RHSet2 = TL_SetExtRight(RHTLRef, False);
			TL_Delete(RHTLRef);
		End;
		RHTLRef = TL_New(RHDate[RHArrayVal], RHTime[RHArrayVal], RHVal[RHArrayVal], RHDate[0], RHTime[0], RHVal[0]);
		RHSet = TL_SetExtRight(RHTLRef, True);
	End;
End;

{Orders For Long Entry}
If RHTLRef <> -1 Then Begin
	BuyPrice = TL_GetValue(RHTLRef, Date, Time);
	PrevBuyPrice = TL_Getvalue(RHTLRef, Date[1], Time[1]);
	If Close Crosses Over BuyPrice Then
		Buy ("TLL") Next Bar at Market;
End;
