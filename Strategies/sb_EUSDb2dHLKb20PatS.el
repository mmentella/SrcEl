Inputs:NoS(2),LengthL(22),FactorL(.5),LengthS(37),FactorS(3.5);

Inputs: ATRLen(30),ATRl(4), ATRs(3.5),KLenL(14),AKLenL(18),KLenS(6),AKLenS(15),MinLen(5),MaxLen(20);

Inputs: SLoss(1470),PTarget(4500),BreakEven(500),SOD(1000),EOD(2000),ADXLen(20),ADXLimit(25);

Vars: PosLow(0),PosHigh(0),ATRVal(0);

Vars: UpperK(0),LowerK(0),ADXVal(0),K(0),SD(0),ASD(0),lenl(0),lens(0);

if currentbar = 0 then begin lenl = MinLen; lens = MinLen; end;

if Time>SOD and Time<EOD then begin
	
SetStopLoss(SLoss*NoS);
SetProfitTarget(PTarget*NoS);
setbreakeven(BreakEven*NoS);

UpperK = KeltnerChannel(h,lengthl,factorl);
lowerk = KeltnerChannel(l,lengths,-factors);

ADXVal = ADX(ADXLen);

if ADXVal < ADXLimit then begin
if MarketPosition <> 1 then begin
 if Close > UpperK then Buy("ELPatS") NoS Shares next bar at market
 else Buy("EL") NoS Shares next bar at UpperK stop;
end;
if MarketPosition <> -1 then begin
 if close < LowerK then Sellshort("ESPatS") NoS Shares next bar at market
 else Sellshort("ES") NoS Shares next bar at LowerK stop;
end;
end;

if MarketPosition <> 0 then begin
 if ADXVal >= ADXLimit then begin
  if close > UpperK then Sell("XLPatS") Next Bar  NoS Shares at market
  else Sell("XL") Next Bar  NoS Shares UpperK stop;
  if close < LowerK then Buy to Cover("XSPatS") Next Bar  NoS Shares at market
  else  Buy to Cover("XS") Next Bar  NoS Shares LowerK stop;
 end;
end;

ATRVal = AvgTrueRange(atrlen) * ATRs;

If MarketPosition = -1 Then Begin
 If BarsSinceEntry = 0 Then	PosLow = Low;
 If Low < PosLow Then PosLow = Low;
 buytocover ("ATR-XS") NoS shares Next Bar at PosLow + ATRVal Stop;
End
else
 buytocover ("ATR-XS eb") NoS shares Next bar at Low + ATRVal Stop;

ATRVal = AvgTrueRange(atrlen) * ATRl;

If MarketPosition = 1 Then Begin
 If BarsSinceEntry = 0 Then PosHigh = High;
 If High > PosHigh Then PosHigh = High;
 sell ("ATR-XL") NoS shares Next Bar at PosHigh - ATRVal Stop;
End
else
 sell ("ATR-XL eb") NoS shares Next bar at High - ATRVal Stop;

{Break Even}


end;{EOD}
