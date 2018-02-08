[IntraBarOrderGeneration = true];
Inputs:NoS(2),LenL(13),FactorL(.75),LenS(50),FactorS(1.8);

Inputs: ATRLen(30),KL(5), KS(2),KLenL(8),AKLenL(10),KLenS(5),AKLenS(13),MinLen(3),MaxLen(44);

Inputs: SLoss(1600),PTarget(1800),NumBars(7),BreakEven(1400),SOD(800),EOD(2200),ADXLen(18),ADXLimit(30);

Vars: PosLow(0),PosHigh(0),ATRL(0),ATRS(0);

Vars: UpperK(0),LowerK(0),ADXVal(0),K(0),SD(0),ASD(0),len(0),intrabar(false);

if Time>SOD and Time<EOD then begin

if barstatus = 2 then begin
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
 ATRL = AvgTrueRange(ATRLen) * KL;
 If BarsSinceEntry = 0 Then	PosHigh = High;
 If High > PosHigh Then PosHigh = High;
 ATRS = AvgTrueRange(ATRLen) * KS;
 If BarsSinceEntry = 0 Then PosLow = Low;
 If Low < PosLow Then PosLow = Low;
 if marketposition <> 0 then intrabar = true;
 if marketposition = 0 and marketposition(1) <> 0 then intrabar = barssinceexit(1) = 0;
 if marketposition = 0 and marketposition(1) = 0 then intrabar = false;
end;

if intrabar = false and ADXVal < ADXLimit then begin
 Buy("EL") Next Bar NoS Shares at UpperK stop;
 SellShort("ES") Next Bar NoS Shares at LowerK stop;
end;

if barssinceentry > 0 then begin
 setstopshare;
 SetStopLoss(SLoss);
end;

if positionprofit >= BreakEven then begin
 if marketposition = 1 then sell next bar at entryprice + (currentcontracts*50)/bigpointvalue stop;
 if marketposition = -1 then buytocover next bar at entryprice - (currentcontracts*50)/bigpointvalue stop;
end;

if marketposition <> 0 and barssinceentry >= NumBars then begin
 if maxpositionprofit < 300 then begin
  if marketposition = 1 then sell("L1") next bar at entryprice + 200/bigpointvalue limit;
  if marketposition = -1 then buytocover("S1") next bar at entryprice - 200/bigpointvalue limit;
 end;
end;

if currentcontracts = NoS then begin
 if marketposition = 1 then sell("T1L") (nos/2) shares next bar at entryprice + PTarget/bigpointvalue limit;
 if marketposition = -1 then buytocover("T1S") (nos/2) shares next bar at entryprice - PTarget/bigpointvalue limit;
end;

if barssinceentry > 0 then begin 
 If MarketPosition = -1 Then
  Buy to Cover ("ATR-XS") Next Bar at PosLow + ATRS Stop; 
 If MarketPosition = 1 Then
  Sell ("ATR-XL") Next Bar at PosHigh - ATRL Stop;
end;

end;{EOD}
