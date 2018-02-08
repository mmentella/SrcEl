[LegacyColorValue = true]; 

{*******************************************************************************
WRS - DAILY
di Matteo Zucchini
Copyright 2010
*******************************************************************************}

{Dichiarazione delle variabili}

Vars: NewH(0), NewTrail(0), NewL(999999), MP(0), EP(0);

If CCI(10) > 5 Then Begin
{Condizione d'ingresso long}
If RSI(C, 14) > 30 and (C < L + 0.35 * truerange) and (O > H - 0.35 * truerange) and (truerange >= AvgTrueRange(14) * 1.1) Then  Sell Short ("EL") next bar at L Stop;

{Condizione d'ingresso short}
If RSI(C, 14) < 55 and (O < L + 0.35 * truerange) and (C > H - 0.35 * truerange) and (truerange >= AvgTrueRange(14) * 1.1) Then Buy ("ES") next bar at H Stop;
End;

{******************************************************************************}
NewH=0;
NewL=999999;
EP = EntryPrice;
MP = MarketPosition;

If MP = 1 Then Begin
	If H > NewH Then NewH = H;
	NewTrail = NewH - NewH * 2/100;
            If C > EP * 108/100 Then Sell ("TS_LX") Next Bar  at NewTrail Stop;
            Sell ("SL_L") Next Bar  at (EP * 96/100) Stop; 
End;

If MP = -1 Then Begin
	If L < NewL Then NewL = L;
	NewTrail = NewL + NewL * 1.5/100;
	If C < EP * 92/100 Then Buy to Cover ("TS_SX") Next Bar  at NewTrail Stop;
	Buy to Cover ("SL_S") Next Bar  at (EP * 103/100) Stop; 
End;
