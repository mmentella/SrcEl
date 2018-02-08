Inputs: NoS(2),LenL(13),FactorL(3.4),LenS(21),FactorS(4.8);
Inputs: ADXLen(18),ADXLimit(30);
Inputs: stopl(1800),modl(1900),ktl(2.7);

Vars: UpperK(0,data2),LowerK(0,data2),ADXVal(0,data2),bl(false,data2),bs(false,data2);

vars: short1(true),stpv(0),stpw(0),stp(true),mkt(true),reason(0),position(0),stoploss(10),bpv(1/bigpointvalue);

if Time data2 > 1100 and Time data2 < 2200 then begin

if BarStatus(2) = 2 then begin

 UpperK = KeltnerChannel(H data2, lenl, FactorL) data2;
 LowerK = KeltnerChannel(L data2, lens, -FactorS) data2;
 
 ADXVal = ADX(ADXLen) data2;

end;

short1 = adxval < adxlimit and marketposition = 1 and close > lowerk;

if marketposition <> 0 then begin

 reason = position;
 stpw   = lowerk;
 
 stpv = entryprice - stopl*bpv;
 
 if short1 then begin
  if stpv > stpw then begin
   reason = stoploss;
   stpw   = stpv;
  end;
 end else begin
  reason = stoploss;
  stpw   = stpv;
 end;
 
 if reason > position then begin
  
  stp = c >  stpw;
  mkt = c <= stpw;
  
  if stp then sell("xl.stp") next bar stpw stop
  else if mkt then sell("xl.stp.m") this bar c;
  
 end;
 
 stpw = entryprice + modl*bpv;
 stp  = currentcontracts = nos and c <  stpw;
 mkt  = currentcontracts = nos and c >= stpw;
 
 if stp then sell("xl.mod") .5*nos shares next bar stpw limit
 else if mkt then sell("xl.mod.m") .5*nos shares this bar c;
 
 stpw = entryprice + ktl*modl*bpv;
 stp  = currentcontracts = .5*nos and c <  stpw;
 mkt  = currentcontracts = .5*nos and c >= stpw;
 
 if stp then sell("xl.trgt") next bar stpw limit
 else if mkt then sell("xl.trgt.m") this bar c;
  
end;

if ADXVal < ADXLimit then begin

 if MarketPosition <> 1 then begin
  if Close > UpperK then Buy("ELPatS") NoS Shares Next Bar at market
  else Buy("EL") NoS Shares Next Bar  at UpperK stop;
 end;
 
 if MarketPosition = 1 then begin
  if Close < LowerK then Sell("ESPatS") Next Bar  NoS Shares at market
  else Sell("ES") Next Bar  NoS Shares at LowerK stop;
 end;
 
end;

end;{EOD}
