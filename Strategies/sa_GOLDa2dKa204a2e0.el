//[intrabarordergeneration = true];
Inputs:NoS(2),LenL(13),FactorL(.6),LenS(45),FactorS(1.6),ADXLen(14),ADXLimit(30);
Inputs: TargetL(2300),TargetS(1700),StopLossL(2500),StopLossS(2500);

Vars: UpperK(0),LowerK(0),ADXVal(0),valuate(false),bkl(false),bks(false),canShort(true),canLong(true),nbar(false);

valuate = barstatus(2) = 2;
bkl = false;
bks = false;
canshort = true;
canlong = true;
if marketposition(1)<>0 then
 nbar = barssinceexit(1)>0
else nbar = true;

if time > 800 and time < 2230 then begin 
 setstopshare;
 if marketposition = 1 then begin
  setstoploss(stoplossl);
  if currentcontracts = nos then begin
   sell("tl") (nos/2) shares next bar at entryprice + targetl/bigpointvalue limit;
  end;
  if maxpositionprofit > 2000 then begin 
   sell("bkl") next bar at entryprice + 100/bigpointvalue stop;
   bkl = true;
  end;
 end;
 if marketposition = -1 then begin
  setstoploss(stoplosss);
  if currentcontracts = nos then begin
   buytocover("ts") (nos/2) shares next bar at entryprice - targets/bigpointvalue limit;
  end;
  if maxpositionprofit > 1500 then begin
   buytocover("bks") next bar at entryprice - 100/bigpointvalue stop;
   bks = true;
  end;
 end; 
end;

if Time>1100 and Time<2200 then begin 
 if valuate then begin 
  UpperK = KeltnerChannel(H, lenl, FactorL) data2; 
  LowerK = KeltnerChannel(L, lens, -FactorS) data2; 
  ADXVal = ADX(ADXLen) data2;
 end;
 if bkl then begin
  canshort = (entryprice + 100/bigpointvalue) < lowerk;
  canlong = (entryprice + 100/bigpointvalue) < upperk;
 end;
 if bks then begin
  canlong = (entryprice - 100/bigpointvalue) > upperk;
  canshort = (entryprice - 100/bigpointvalue) > lowerk;
 end;
 if ADXVal < ADXLimit then begin
  if canlong and nbar then Buy("EL") NoS Shares Next Bar at UpperK stop;
  if canshort and nbar then Sell Short("ES") Next Bar  NoS Shares at LowerK stop;
 end;
 if ADXVal > ADXLimit then begin
  Sell("XL") Next Bar UpperK stop;
  Buy to Cover("XS") Next Bar LowerK stop;
 end;
end;
