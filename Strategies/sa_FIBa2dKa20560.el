Inputs:NoS(2),LenL(5),FactorL(2),LenS(5),FactorS(1.5);

Inputs: ATRLen(6),ATRl(4.6), ATRs(1.5);

Inputs: SLoss(1500),PTarget(3100),BRK(1300);

Vars: ADXLen(14),ADXLimit(30),PosLow(0,data2),PosHigh(0,data2),ATRVal(0,data2);

Vars: UpperK(0,data2),LowerK(0,data2),ADXVal(0,data2);

setstopshare;
SetStopLoss(SLoss);
setprofittarget(ptarget);

if maxcontractprofit > brk then begin
 if marketposition = 1 then sell("brkl") next bar at entryprice + 20 stop;
 if marketposition = -1 then buytocover("brks") next bar at entryprice - 20 stop;
end;

UpperK = KeltnerChannel(H, LenL, FactorL) data2;
LowerK = KeltnerChannel(L, LenS, -FactorS) data2;

ADXVal = ADX(ADXLen) data2;

if ADXVal < adxlimit then begin
 if MarketPosition <> 1 then begin
  if close > UpperK then Buy("ELPatS") NoS Shares Next Bar at market
  else	Buy("EL") NoS Shares Next Bar at UpperK stop;
 end;
 if MarketPosition <> -1 then begin
  if close < LowerK then Sell Short("ESPatS") NoS Shares Next Bar at market
  else Sell Short("ES") NoS Shares Next Bar at LowerK stop;
 end;
end;
{
//Trailing Stop
ATRVal = AvgTrueRange(ATRLen)data2 * ATRs;

If MarketPosition = -1 Then Begin
 If BarsSinceEntry = 0 Then PosLow = Low;
 If Low < PosLow Then PosLow = Low;
 Buy to Cover ("ATR-XS") Next Bar at PosLow + ATRVal Stop;
End else Buy to Cover ("ATR-XS eb") Next bar at Low + ATRVal Stop;

ATRVal = AvgTrueRange(ATRLen)data2 * ATRl;

If MarketPosition = 1 Then Begin
 If BarsSinceEntry = 0 Then	PosHigh = High;
 If High > PosHigh Then PosHigh = High;
 Sell ("ATR-XL") Next Bar at PosHigh - ATRVal Stop;
End else Sell ("ATR-XL eb") Next bar at High - ATRVal Stop;
}
