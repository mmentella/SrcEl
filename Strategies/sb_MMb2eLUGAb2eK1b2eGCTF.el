Inputs: alphal(0.2),lenl(21),rngl(0.2);
Inputs: stopl(3550),funkl(2500),tl(100000);

vars: trndl(0,data2),trgrl(0,data2),cycl(0,data2),fishl(0,data2),entryl(0,data2),_buy(true,data2);

vars: engine(true),trade(0),stpv(0),stp(true),mkt(false),dru(0),fnkl(false),bpv(1/bigpointvalue);

if d > d[1] then begin
 trade = 0;
 fnkl  = false;
end;

if barstatus(2) = 2 then begin
 
 MM.ITrend(.5*(h+l),alphal,trndl,trgrl)data2;
 cycl = MM.Cycle(.5*(h+l),alphal)data2;
 fishl = MM.FisherTransform(.5*(h+l),lenl,true)data2;
 
 _buy = trgrl > trndl and fishl > fishl[1];
 
 entryl = c data2 - rngl * (h data2 - l data2);
 
end;

dru = MM.DailyRunup;

if marketposition > 0 then begin

 if barssinceentry = 0 then trade = trade + 1;
 
 //TRADE STOPLOSS
 stpv = entryprice - stopl*bpv;
 stp  = c > stpv;
 mkt  = c <= stpv;
 
 if stp then sell("xl.stp") next bar stpv stop
 else if mkt then sell("xl.stp.m") this bar c;
 
 //DAILY STOPLOSS
 stpv = c - (dru + funkl)*bpv;
 stp  = c > stpv;
 mkt  = c <= stpv;
 
 if stp then sell("xl.funk") next bar stpv stop
 else if mkt then sell("xl.funk.m") this bar c;
 
 //TARGET
 stpv = entryprice + tl*bpv;
 stp  = c < stpv;
 mkt  = c >= stpv;
 
 if stp then sell("xl.trgt") next bar stpv limit
 else if mkt then sell("xl.trgt.m") this bar c;
 
end;

engine = -100 < t and t < 2500;

fnkl = dru <= -funkl;

if not fnkl and trade = 0 and engine then begin
 
 if marketposition < 1 and _buy and c > entryl then
  buy("el") next bar entryl limit;
 
end;
