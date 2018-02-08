Inputs:NoS(2),LenL(13),FactorL(.75),LenS(50),FactorS(1.8);

Inputs: ATRLen(30),ATRl(5), ATRs(2),KLenL(8),AKLenL(10),KLenS(5),AKLenS(13),MinLen(3),MaxLen(44);

Inputs: SLoss(1600),PTarget(1800),NumBars(7),BreakEven(1400),SOD(1100),EOD(2200),ADXLen(18),ADXLimit(30);

Vars: PosLow(0),PosHigh(0),ATRVal(0);

Vars: UpperK(0),LowerK(0),ADXVal(0),K(0),SD(0),ASD(0),len(0),canShort(true),canLong(true);

canShort = true;
canLong = true;

if Time>SOD and Time<EOD then begin

if barssinceentry > 0 then begin
 setstopshare;
 SetStopLoss(SLoss);
 //SetProfitTarget(PTarget);
end;

if positionprofit >= BreakEven then begin
 if marketposition = 1 then sell next bar at entryprice + (currentcontracts*50)/bigpointvalue stop;
 if marketposition = -1 then buytocover next bar at entryprice - (currentcontracts*50)/bigpointvalue stop;
end;

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

condition1 = marketposition = 0 or ((MarketPosition = 1 or marketposition = -1) and barssinceexit > 0 );

if ADXVal < ADXLimit then begin
 if  condition1 then begin
  if Close > UpperK then begin 
   Buy("ELPatS") NoS Shares Next Bar at market; 
   if barssinceentry < 1 then canShort = false; 
  end;
 end;
 if  condition1 then begin
  if Close < LowerK then begin 
   Sell Short("ESPatS") Next Bar  NoS Shares at market; 
   if barssinceentry < 1 then canLong = false; 
  end;
 end;
 if condition1 and high < UpperK and canLong then Buy("EL") NoS Shares Next Bar  at UpperK stop;
 if condition1 and low > LowerK and canShort then Sell Short("ES") Next Bar  NoS Shares at LowerK stop;
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


ATRVal = AvgTrueRange(ATRLen) * ATRs;

If MarketPosition = -1 Then Begin
 If BarsSinceEntry = 0 Then PosLow = Low;
 If Low < PosLow Then PosLow = Low;
 Buy to Cover ("ATR-XS") NoS shares Next Bar at PosLow + ATRVal Stop;
End;

ATRVal = AvgTrueRange(ATRLen) * ATRl;

If MarketPosition = 1 Then Begin
 If BarsSinceEntry = 0 Then	PosHigh = High;
 If High > PosHigh Then PosHigh = High;
 Sell ("ATR-XL") NoS shares Next Bar at PosHigh - ATRVal Stop;
End;

end;{EOD}
