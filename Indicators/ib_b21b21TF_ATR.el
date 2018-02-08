// **********************************  !!TF ATR  ******************************************
// **  Copyright (c) 2010 Horowitz Technology Partners, LLC All rights reserved. ***
	
Inputs:	
	ATRlen(10),
	TopOrBottom("top"),
	RightOrLeft("right"),
	ShowLen(FALSE),
	ShowDate(FALSE)
	;

Vars:
	IntrabarPersist DecimalPlaces(0),
	IntrabarPersist NewDay(FALSE),	
	IntrabarPersist ThisCategory(0),
	IntrabarPersist PrevATR(0),
	IntrabarPersist ThisATR(0),
	Location(0),
	LabelColor(RGB(205,173,0)),
	IntrabarPersist TextStr(""),
	IntrabarPersist LenStr(""),
	ShowLogo(TRUE),
	LogoTextID(0),
	LogofColor(RGB(205,173,0)),
	FirstDay(TRUE),
	Current_Session(0),
	Count(0),
	ThisLength(ATRLen),
	MinLen(0),
	IntrabarPersist ThisPrevClose(0),
	IntrabarPersist ThisDailyHigh(0),
	IntrabarPersist ThisDailyLow(0),
	ThisTrueHigh(0),
	ThisTrueLow(0),
	TrueRangeTotal(0)
	;

Arrays:
	TrueRanges[101](0)
	;
				
Once Begin
	Location = 3;
	If (TopOrBottom = "top") Then Begin
		If (RightOrLeft = "left") Then
			Location = 1

		Else If (RightOrLeft = "right") Then
			Location = 2;
	End
	Else If (TopOrBottom = "bottom") Then Begin
		If (RightOrLeft = "left") Then
			Location = 4

		Else If (RightOrLeft = "right") Then
			Location = 3;
	End;

	If ShowLen Then
		LenStr = NumToStr(ATRlen, 0) + " Day ";	
		
	LenStr = "TradeFormers.com: " + LenStr + "ATR ";

	If (ThisLength > 100) Then
		ThisLength = 100;

	MinLen = ThisLength + 1;

	DecimalPlaces = 3;
	If (Category = 12) Then
		DecimalPlaces = 6;
End;

If (BarType = 1) Then Begin	
	Current_Session = CurrentSession(0); 
	If ((Current_Session <> Current_Session[1]) OR FirstDay) Then Begin 
		PrevATR = ThisATR;

		FirstDay = FALSE;

		For Value99 = 1 To ThisLength - 1 Begin
			TrueRanges[Value99] = TrueRanges[Value99 + 1] ;
		End; 

		If (ThisPrevClose > ThisDailyHigh) Then
			ThisTrueHigh = ThisPrevClose

		Else
			ThisTrueHigh = ThisDailyHigh ;

		If ((ThisPrevClose > 0) AND (ThisPrevClose < ThisDailyLow)) Then 
			ThisTrueLow = ThisPrevClose

		Else
			ThisTrueLow = ThisDailyLow ;

		ThisATR = 0;

// Print(Date:8:0, Time:5:0, " ThisPrevClose=", ThisPrevClose, " ThisDailyHigh=", ThisDailyHigh, " ThisDailyLow=", ThisDailyLow);
	
		Value1 = (ThisTrueHigh - ThisTrueLow);
		TrueRanges[ThisLength] = Value1;
		TrueRangeTotal = TrueRangeTotal + Value1;

		If (ThisLength > 0.0) Then
			ThisATR = TrueRangeTotal / ThisLength ;

// Print(Date:8:0, Time:5:0, " TrueRanges[", ThisLength:1:0, "]=", TrueRanges[ThisLength], " ThisTrueHigh=", ThisTrueHigh, " ThisTrueLow=", ThisTrueLow, " ThisATR=", ThisATR);

		TrueRangeTotal = TrueRangeTotal - TrueRanges[1];
		ThisPrevClose = Close[1];
		ThisDailyHigh = 0;
		ThisDailyLow = 0;

		Count = Count + 1;
	End;
	
	If (High > ThisDailyHigh) Then
		ThisDailyHigh = High;

	If ((Low < ThisDailyLow) OR (ThisDailyLow = 0)) Then
		ThisDailyLow = Low;
End
Else Begin
	Count = Count + 1;
	ThisATR = AvgTrueRange(ATRlen);
End;
	
TextStr = LenStr;
If (ShowDate AND (Date > Date[1])) Then
	TextStr = LenStr + "as of " + DateToString(EncodeDate(1900+Year(Date[1]), Month(Date[1]), DayofMonth(Date[1])));

If TF_LastBarOnChart Then Begin		
	If ((ThisATR = 0) OR ((BarType = 1) AND (Count <= MinLen))) Then
		TextStr = "TradeFormers.com: Load at Least " + NumToStr(MinLen + 2, 0) + " Days of Data for ATR"
		
	Else If (ThisATR <> PrevATR) Then 		
		TextStr = TextStr + " = " +	NumToStr(Round(ThisATR, DecimalPlaces), DecimalPlaces) ;
		
	If (LogoTextID = 0) Then Begin
		LogoTextID = Text_New(Date, 0, 0, TextStr);
		If (LogoTextID < 0) Then
			RaiseRuntimeError("LogoTextID: Error: Code=" + NumToStr(LogoTextID, 0));

		Value1 = Text_SetColor(LogoTextID, LogofColor);
	End;
	
	Value1 = Text_SetString(LogoTextID, TextStr);
	Value1 = TF_TextLocale(LogoTextID, Location, LogofColor, 0);
End;

// **  Copyright (c) 2010 Horowitz Technology Partners, LLC All rights reserved. ***

