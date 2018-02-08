Inputs:NoS(2),LenL(5),FactorL(2),LenS(5),FactorS(1.5);

Inputs: ATRLen(6),ATRl(1.5), ATRs(1.5);

Inputs: SLoss(2500),PTarget(3750);

Vars: ADXLen(14),ADXLimit(30),PosLow(0),PosHigh(0),ATRVal(0);;

Vars: UpperK(0),LowerK(0),ADXVal(0);

SetStopLoss(SLoss*NoS);
SetProfitTarget(PTarget*NoS);

UpperK = KeltnerChannel(H, LenL, FactorL);
LowerK = KeltnerChannel(L, LenS, -FactorS);

ADXVal = ADX(ADXLen);

if ADXVal < ADXLimit then begin
if MarketPosition <> 1 then begin
 if close > UpperK then Buy("ELPatS") Next Bar  NoS Shares at market
 else	Buy("EL") Next Bar  NoS Shares at UpperK stop;
end;
if MarketPosition <> -1 then begin
 if close < LowerK then Sell Short("ESPatS") Next Bar  NoS Shares at market
 else Sell Short("ES") Next Bar  NoS Shares at LowerK stop;
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

ATRVal = AvgTrueRange(ATRLen) * ATRs;

If MarketPosition = -1 Then Begin
 If BarsSinceEntry = 0 Then PosLow = Low;
 If Low < PosLow Then	PosLow = Low;
 Buy to Cover ("ATR-XS") Next Bar at PosLow + ATRVal Stop;
End
else Buy to Cover ("ATR-XS eb") Next bar at Low + ATRVal Stop;

ATRVal = AvgTrueRange(ATRLen) * ATRl;

If MarketPosition = 1 Then Begin
 If BarsSinceEntry = 0 Then	PosHigh = High;
 If High > PosHigh Then PosHigh = High;
 Sell ("ATR-XL") Next Bar at PosHigh - ATRVal Stop;
End
else Sell ("ATR-XL eb") Next bar at High - ATRVal Stop;

