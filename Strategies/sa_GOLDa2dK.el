Inputs:NoS(2),LenL(13),FactorL(.75),LenS(45),FactorS(1.6);

Inputs: ATRLen(21),ATRl(7), ATRs(4),KLenL(8),AKLenL(10),KLenS(5),AKLenS(13),MinLen(3),MaxLen(44);

Inputs: SLoss(2000),PTarget(1800),SOD(1100),EOD(2200),ADXLen(18),ADXLimit(30);

Vars: PosLow(0),PosHigh(0),ATRVal(0);

Vars: UpperK(0),LowerK(0),ADXVal(0),K(0),SD(0),ASD(0),len(0);

if Time>SOD and Time<EOD then begin
	
SetStopLoss(SLoss*NoS);
SetProfitTarget(PTarget*NoS);

SD = StdDev(High,KLenL);
ASD = Average(SD,AKLenL);
K = 1 - asd[1]/asd;

len = lenl*(1 + K);
len = MinList(len,MaxLen);
len = MaxList(len,MinLen);
len = floor(len);

UpperK = KeltnerChannel(H, len, FactorL);

SD = StdDev(Low,KLenS);
ASD = Average(SD,AKLenS);
K = 1 - asd[1]/asd;

len = lens*(1 + K);
len = MinList(len,MaxLen);
len = MaxList(len,MinLen);
len = floor(len);

LowerK = KeltnerChannel(L, len, -FactorS);

ADXVal = ADX(ADXLen);

if ADXVal < ADXLimit then begin
	if MarketPosition <> 1 then begin
		if marketposition = -1 then buytocover NoS shares next bar at UpperK stop;
		Buy("EL") Next Bar  NoS Shares at UpperK stop;
	end;
	if MarketPosition <> -1 then begin
		if marketposition = 1 then sell NoS shares next bar LowerK stop; 
		Sell Short("ES") Next Bar  NoS Shares at LowerK stop;
	end;
end;

if MarketPosition <> 0 then begin
	 if ADXVal >= ADXLimit then begin
	 	Sell("XL") Next Bar  NoS Shares UpperK stop;
		Buy to Cover("XS") Next Bar  NoS Shares LowerK stop;
	end;
end;

SD = StdDev(Low,KLenS);
ASD = Average(SD,AKLenS);
K = 1 - asd[1]/asd;

len = ATRLen*(1 + K);
len = MinList(len,MaxLen);
len = MaxList(len,MinLen);
len = floor(len);

ATRVal = AvgTrueRange(len) * ATRs;

If MarketPosition = -1 Then Begin
	If BarsSinceEntry = 0 Then
		PosLow = Low;
	If Low < PosLow Then
		PosLow = Low;
	Buy to Cover ("ATR-XS") NoS shares Next Bar at PosLow + ATRVal Stop;
End
else
	Buy to Cover ("ATR-XS eb") NoS shares Next bar at Low + ATRVal Stop;

SD = StdDev(High,KLenL);
ASD = Average(SD,AKLenL);
K = 1 - asd[1]/asd;

ATRVal = AvgTrueRange(len) * ATRl;

If MarketPosition = 1 Then Begin
	If BarsSinceEntry = 0 Then
		PosHigh = High;
	If High > PosHigh Then
		PosHigh = High;
	Sell ("ATR-XL") NoS shares Next Bar at PosHigh - ATRVal Stop;
End
else
	Sell ("ATR-XL eb") NoS shares Next bar at High - ATRVal Stop;

{Break Even}


end;{EOD}
