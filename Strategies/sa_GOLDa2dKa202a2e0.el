Inputs:NoS(2),LenL(13),FactorL(.75),LenS(45),FactorS(1.6);

Inputs: ATRLen(21),ATRl(7), ATRs(4),KLenL(8),AKLenL(10),KLenS(5),AKLenS(13),MinLen(3),MaxLen(44);

Inputs: SLoss(2000),PTarget(1800),SOD(1100),EOD(2200),ADXLen(18),ADXLimit(30);

Vars: PosLow(0),PosHigh(0),ATRVal(0);

Vars: UpperK(0),LowerK(0),ADXVal(0),K(0),SD(0),ASD(0),len(0),canShort(true),canLong(true);

canShort = true;
canLong = true;

if Time>SOD and Time<EOD then begin

if barssinceentry > 0 then begin
 setstopshare;
 SetStopLoss(SLoss);
 SetProfitTarget(PTarget);
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

if MarketPosition <> 0 then begin
 if ADXVal >= ADXLimit then begin
  if close > UpperK then Sell("XLPatS") Next Bar  NoS Shares at market
  else Sell("XL") Next Bar  NoS Shares UpperK stop;
  if close < LowerK then Buy to Cover("XSPatS") Next Bar  NoS Shares at market
  else  Buy to Cover("XS") Next Bar  NoS Shares LowerK stop;
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
 If BarsSinceEntry = 0 Then PosLow = Low;
 If Low < PosLow Then PosLow = Low;
 Buy to Cover ("ATR-XS") NoS shares Next Bar at PosLow + ATRVal Stop;
End;

SD = StdDev(High,KLenL);
ASD = Average(SD,AKLenL);
K = 1 - asd[1]/asd;

ATRVal = AvgTrueRange(len) * ATRl;

If MarketPosition = 1 Then Begin
 If BarsSinceEntry = 0 Then	PosHigh = High;
 If High > PosHigh Then PosHigh = High;
 Sell ("ATR-XL") NoS shares Next Bar at PosHigh - ATRVal Stop;
End;

end;{EOD}
