Inputs: NoS(2),LenL(13),FactorL(3.4),LenS(21),FactorS(4.8);
Inputs: ADXLen(18),ADXLimit(30);
Inputs: SLoss(1800),PTarget(1900),KTL(2.7),KTS(1),BRKL(500),BRKS(500);

Vars: UpperK(0,data2),LowerK(0,data2),ADXVal(0,data2),bl(false,data2),bs(false,data2);

if Time data2 > 1100 and Time data2 < 2200 then begin

if marketposition <> 0 then begin
 setstopshare;
 SetStopLoss(SLoss);
 if currentcontracts = nos then begin
  if marketposition = 1 then
   if h >= entryprice + ptarget/bigpointvalue then
    sell("tl.m") nos/2 shares next bar at market
   else
    sell("tl.s") nos/2 shares next bar at entryprice + ptarget/bigpointvalue limit;
  if marketposition = -1 then
   if l <= entryprice - ptarget/bigpointvalue then
    buytocover("ts.m") nos/2 shares next bar at market
   else
    buytocover("ts.s") nos/2 shares next bar at entryprice - ptarget/bigpointvalue limit;
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

if BarStatus(2) = 2 then begin

 UpperK = KeltnerChannel(H data2, lenl, FactorL) data2;
 LowerK = KeltnerChannel(L data2, lens, -FactorS) data2;
 ADXVal = ADX(ADXLen) data2;

 bl = false;
 bs = false;

 if marketposition = 1 then bl = lowerk < entryprice - sloss/bigpointvalue;
 if marketposition = -1 then bs = upperk > entryprice + sloss/bigpointvalue;

end;

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
