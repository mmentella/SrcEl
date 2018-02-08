//[IntraBarOrderGeneration = true];
Inputs:NoS(2),LenL(5),FactorL(2),LenS(15),FactorS(2);

Inputs: KLen(6),AKLen(12),MinLen(5),MaxLen(30);

Inputs: SOD(1000),EOD(2000),ADXLen(14),ADXLimit(25);

Vars: K(0),SD(0),ASD(0),UpperK(0),LowerK(0),ADXVal(0);

if Time>SOD and Time<EOD then begin

if barstatus = 2 then begin
 K = StdDev(Close,KLen)/Average(StdDev(Close,KLen),AKLen);
 SD = StdDev(Close,KLen);
 ASD = Average(SD,AKLen);
 
 UpperK = KeltnerChannel(H, lenl, FactorL);
 LowerK = KeltnerChannel(L, lens, -FactorS);
 
 ADXVal = ADX(ADXLen);
end;

if marketposition(1) <> 0 then begin
 if marketposition = 0 then condition1 = barssinceexit(1) > 0;
end
else condition1 = true;

if ADXVal < ADXLimit then begin
 if condition1 then begin
  if close > UpperK then Buy("ELPats") NoS Shares Next Bar at market
  else Buy("EL") NoS Shares Next Bar at UpperK stop;
 end;
 if condition1 then begin
  if close < LowerK then Sellshort("ESPats") NoS Shares Next Bar at market
  else Sellshort("ES") NoS Shares Next Bar at LowerK stop;
 end;
end;

end;{EOD}
