//[IntraBarOrderGeneration = true];
Inputs:NoS(2),LenL(5),FactorL(2),LenS(5),FactorS(1.5),ATRLen(9),KL(1.6), KS(1.2);
Inputs: SLoss(2500),PTarget(3750),BRKL(600),BRKS(500);

Vars: ADXLen(14),ADXLimit(30),UpperK(0),LowerK(0),ADXVal(0),PosLow(0),PosHigh(0),ATRL(0),ATRS(0);
Vars: intrabar(false);

if barssinceentry > 0 then begin
 setstopshare;
 SetStopLoss(SLoss);
 SetProfitTarget(PTarget);
end;

if barstatus = 2 then begin
 UpperK = KeltnerChannel(H, LenL, FactorL);
 LowerK = KeltnerChannel(L, LenS, -FactorS);
 ADXVal = ADX(ADXLen);
 ATRL = AvgTrueRange(ATRLen) * KL;
 ATRS = AvgTrueRange(ATRLen) * KS;
 If BarsSinceEntry = 0 Then PosLow = Low;
 If Low < PosLow Then PosLow = Low;
 If BarsSinceEntry = 0 Then	PosHigh = High;
 If High > PosHigh Then PosHigh = High;
 if marketposition <> 0 then intrabar = true;
 if marketposition = 0 and marketposition(1) <> 0 then intrabar = barssinceexit(1) = 0;
 if marketposition = 0 and marketposition(1) = 0 then intrabar = false;
end;

if barssinceentry > 0 then begin
 if marketposition = 1 and maxpositionprofit >= BRKL then
  sell("brkl") next bar at entryprice + 100/bigpointvalue stop;
 if marketposition = -1 and maxpositionprofit >= BRKS then
  buytocover("brks") next bar at entryprice - 100/bigpointvalue stop;
end;

if intrabar = false and ADXVal < ADXLimit then begin
 Buy("EL") Next Bar NoS Shares at UpperK stop;
 SellShort("ES") Next Bar NoS Shares at LowerK stop;
end;
if MarketPosition <> 0 then begin
 if ADXVal >= ADXLimit then begin
  Sell("XL") Next Bar UpperK stop;
  BuyToCover("XS") Next Bar LowerK stop;
 end;
end;
if barssinceentry > 0 then begin
 If MarketPosition = -1 Then Begin
  BuytoCover("ATR-XS") Next Bar at PosLow + ATRL Stop;
 End;
 If MarketPosition = 1 Then Begin
  Sell("ATR-XL") Next Bar at PosHigh - ATRS Stop;
 End;
end;
