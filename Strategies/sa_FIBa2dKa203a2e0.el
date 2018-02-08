[IntraBarOrderGeneration = true];
Inputs:NoS(2),LenL(5),FactorL(2),LenS(5),FactorS(1.5);

Inputs: ATRLen(6),ATRl(1.5), ATRs(1.5);

Inputs: SLoss(2500),PTarget(3750);

Vars: ADXLen(14),ADXLimit(30),PosLow(0),PosHigh(0),ATRVal(0);;

Vars: UpperK(0),LowerK(0),ADXVal(0);

SetStopLoss(SLoss*NoS);
SetProfitTarget(PTarget*NoS);

if barstatus = 2 then begin
 UpperK = KeltnerChannel(H, LenL, FactorL);
 LowerK = KeltnerChannel(L, LenS, -FactorS);
 ADXVal = ADX(ADXLen);
end;

if ADXVal < ADXLimit then begin
if MarketPosition <> 1 then
 Buy("EL") Next Bar  NoS Shares at UpperK stop;
if MarketPosition <> -1 then
 Sell Short("ES") Next Bar  NoS Shares at LowerK stop;
end;

if MarketPosition <> 0 then begin
 if ADXVal >= ADXLimit then begin
  Sell("XL") Next Bar UpperK stop;
  Buy to Cover("XS") Next Bar LowerK stop;
 end;
end;

ATRVal = AvgTrueRange(ATRLen) * ATRs;

If MarketPosition = -1 Then Begin
 If BarsSinceEntry = 0 Then PosLow = Low;
 If Low < PosLow Then PosLow = Low;
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

