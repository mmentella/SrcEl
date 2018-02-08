Inputs:NoS(2),LenL(13),FactorL(3.4),LenS(21),FactorS(4.8);
Inputs: ADXLen(18),ADXLimit(30);
Inputs: SLoss(1800),PTarget(1900),KTL(2.7),KTS(1),BRKL(500),BRKS(500);

Vars: UpperK(0),LowerK(0),ADXVal(0),bl(false),bs(false),ATRVal(0),PosLow(0),PosHigh(0);

if Time>1100 and Time<2200 then begin

if marketposition <> 0 then begin
 setstopshare;
 SetStopLoss(SLoss);
 if currentcontracts = nos then begin
  if marketposition = 1 then sell("tl") nos/2 shares next bar at entryprice + ptarget/bigpointvalue limit;
  if marketposition = -1 then buytocover("ts") nos/2 shares next bar at entryprice - ptarget/bigpointvalue limit;
 end;
 if currentcontracts = nos/2 then begin
  if marketposition = 1 then begin
   sell("tl2") next bar at entryprice + ktl*ptarget/bigpointvalue limit;
  end;
  if marketposition = -1 then begin
   buytocover("ts2") next bar at entryprice - kts*ptarget/bigpointvalue limit;
  end;
 end;
end;

UpperK = KeltnerChannel(H, lenl, FactorL);
LowerK = KeltnerChannel(L, lens, -FactorS);
ADXVal = ADX(ADXLen);

bl = false;
bs = false;

if marketposition = 1 then bl = lowerk < entryprice - sloss/bigpointvalue;
if marketposition = -1 then bs = upperk > entryprice + sloss/bigpointvalue;

if ADXVal < ADXLimit then begin
 if MarketPosition <> 1 and bs = false then begin
  if Close > UpperK then Buy("ELPatS") NoS Shares Next Bar at market
  else Buy("EL") NoS Shares Next Bar  at UpperK stop;
 end;
 if MarketPosition <> -1 and bl = false then begin
  if Close < LowerK then Sell Short("ESPatS") Next Bar  NoS Shares at market
  else Sell Short("ES") Next Bar  NoS Shares at LowerK stop;
 end;
end;

end;{EOD}
