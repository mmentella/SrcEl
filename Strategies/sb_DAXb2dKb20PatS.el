Inputs:NoS(2),LenL(5),FactorL(2),LenS(15),FactorS(2);

Inputs: ATRLen(13),ATRl(1.5), ATRs(4.5),KLen(6),AKLen(12),MinLen(5),MaxLen(30);

Inputs: SLoss(1450),PTarget(4725),SOD(1000),EOD(2000),ADXLen(17),ADXLimit(25);

Vars: PosLow(0),PosHigh(0),ATRVal(0);

Vars: UpperK(0),LowerK(0),ADXVal(0),K(0),SD(0),ASD(0),len(0),s(0),p(0);

if Time>SOD and Time<EOD then begin

K = StdDev(Close,KLen)/Average(StdDev(Close,KLen),AKLen);
SD = StdDev(Close,KLen);
ASD = Average(SD,AKLen);

UpperK = KeltnerChannel(H, lenl, FactorL);
LowerK = KeltnerChannel(L, lens, -FactorS);

ADXVal = ADX(ADXLen);

if barssinceentry > 0 then begin
 SetStopLoss(SLoss*Nos);
 SetProfitTarget(PTarget*Nos);
end;

if ADXVal < ADXLimit then begin
if MarketPosition = 0 or (marketposition(1) = -1 and barssinceexit(1) = 0) then begin
 if close > UpperK then Buy("ELPats") NoS Shares Next Bar at market
 else Buy("EL") NoS Shares Next Bar at UpperK stop;
end;
if MarketPosition = 0 or (marketposition(1) = 1 and barssinceexit(1) = 0) then begin
 if close < LowerK then Sellshort("ESPats") NoS Shares Next Bar at market
 else Sellshort("ES") NoS Shares Next Bar at LowerK stop;
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

len = ATRLen*(1+((asd-asd[1])/asd));
len = MinList(len,MaxLen);
len = MaxList(len,MinLen);
len = floor(len);

ATRVal = AvgTrueRange(len) * ATRs;

If MarketPosition = -1 Then Begin
 If BarsSinceEntry = 0 Then	PosLow = Low;
 If Low < PosLow Then PosLow = Low;
 buytocover ("ATR-XS") Next Bar at PosLow + ATRVal Stop;
End
else buytocover ("ATR-XS eb") Next bar at Low + ATRVal Stop;

ATRVal = AvgTrueRange(len) * ATRl;

If MarketPosition = 1 Then Begin
 If BarsSinceEntry = 0 Then PosHigh = High;
 If High > PosHigh Then PosHigh = High;
 sell ("ATR-XL") Next Bar at PosHigh - ATRVal Stop;
End
else sell ("ATR-XL eb") Next bar at High - ATRVal Stop;

end;{EOD}
