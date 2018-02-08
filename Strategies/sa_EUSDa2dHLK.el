Inputs:NoS(2),FactorL(1),FactorS(2);

Inputs: ATRLen(10),ATRl(2.5), ATRs(2.5),KLenL(14),AKLenL(18),KLenS(6),AKLenS(15),MinLen(9),MaxLen(24);

Inputs: SLoss(600),PTarget(3800),SOD(1000),EOD(2000),ADXLen(20),ADXLimit(25);

Vars: PosLow(0),PosHigh(0),ATRVal(0);

Vars: UpperK(0),LowerK(0),ADXVal(0),K(0),SD(0),ASD(0),lenl(0),lens(0);

if currentbar = 0 then begin lenl = MinLen; lens = MinLen; end;

if Time>SOD and Time<EOD then begin
	
SetStopLoss(SLoss*NoS);
SetProfitTarget(PTarget*NoS);

SD = StdDev(High,KLenL);
K = 1 - sd[1]/sd;

lenl = lenl*(1 + K);
lenl = MinList(lenl,MaxLen);
lenl = MaxList(lenl,MinLen);
lenl = floor(lenl);

UpperK = KeltnerChannel(H, lenl, FactorL);

SD = StdDev(Low,KLenS);
K = 1 - sd[1]/sd;

lens = lens*(1 + K);
lens = MinList(lens,MaxLen);
lens = MaxList(lens,MinLen);
lens = floor(lens);

LowerK = KeltnerChannel(L, lens, -FactorS);

ADXVal = ADX(ADXLen);

if ADXVal < ADXLimit then begin
	if MarketPosition <> 1 then
		Buy("EL") NoS Shares next bar at UpperK stop;
	if MarketPosition <> -1 then
		Sellshort("ES") NoS Shares next bar at LowerK stop;
end;

if MarketPosition <> 0 then begin
	 if ADXVal >= ADXLimit then begin
	 	sell("XL") NoS Shares next bar UpperK stop;
		buytocover("XS") NoS Shares next bar LowerK stop;
	end;
end;

ATRVal = AvgTrueRange(atrlen) * ATRs;

If MarketPosition = -1 Then Begin
	If BarsSinceEntry = 0 Then
		PosLow = Low;
	If Low < PosLow Then
		PosLow = Low;
	buytocover ("ATR-XS") NoS shares Next Bar at PosLow + ATRVal Stop;
End
else
	buytocover ("ATR-XS eb") NoS shares Next bar at Low + ATRVal Stop;

ATRVal = AvgTrueRange(atrlen) * ATRl;

If MarketPosition = 1 Then Begin
	If BarsSinceEntry = 0 Then
		PosHigh = High;
	If High > PosHigh Then
		PosHigh = High;
	sell ("ATR-XL") NoS shares Next Bar at PosHigh - ATRVal Stop;
End
else
	sell ("ATR-XL eb") NoS shares Next bar at High - ATRVal Stop;

{Break Even}


end;{EOD}
