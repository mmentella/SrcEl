Inputs: Length(6),tim1(800),tim2(1600);

Inputs: stopl(500),tl(950);
Inputs: stops(320),ts(1200);

vars: trade(0),stpv(0),stp(true),mkt(false),bpv(1/bigpointvalue);

if d > d[1] then begin
 trade = 0;
end;

if marketposition <> 0 and barssinceentry = 0 then begin
 trade = trade + 1;
end;

if marketposition = 1 then begin
 
 stpv = entryprice - stopl*bpv;
 stp  = c > stpv;
 mkt  = c <= stpv;
 
 if stp then sell("xl.stpl") next bar stpv stop
 else if mkt then sell("xl.stpl.m") this bar c;
 
 stpv = entryprice + tl*bpv;
 stp  = c < stpv;
 mkt  = c >= stpv;
 
 if stp then sell("xl.tl") next bar stpv limit
 else if mkt then sell("xl.tl.m") this bar c;
 
end else if marketposition = -1 then begin
 
 stpv = entryprice + stops*bpv;
 stp  = c < stpv;
 mkt  = c >= stpv;
 
 if stp then buy to cover("xs.stpl") next bar stpv stop
 else if mkt then buy to cover("xs.stpl.m") this bar c;
 
 stpv = entryprice - ts*bpv;
 stp  = c > stpv;
 mkt  = c <= stpv;
 
 if stp then buy to cover("xs.tl") next bar stpv limit
 else if mkt then buy to cover("xs.tl.m") this bar c;
 
end;

condition1 = Range < Average(Range, Length*3);

If trade = 0 and tim1 < t and t < tim2 and condition1 then begin; 

IF MarketPosition < 1 then 
   Buy Next Bar at Highest(High,Length) + 1*MinMove point Stop;
 
 IF MarketPosition > -1 then
   Sell Short Next Bar at Lowest(Low,Length) - 1*MinMove point Stop;

end;
