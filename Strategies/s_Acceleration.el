Inputs: lenl(20),atrl(12),rngl(.61),lens(18),rngs(.86),atrs(3);

vars: accl(0),accs(0),trades(0);

if d <> d[1] then begin
 trades = 0;
end;

accl = TSMLRslope(h,lenl);
accs = TSMLRslope(l,lens);

if marketposition <> 0 and barssinceentry = 0 then trades = trades + 1;

if 700 < t and t < 2300 and trades < 1 then begin
 if accl > 0 then buy next bar c - rngl*AvgTrueRange(atrl) limit; 
 if accs < 0 then sellshort next bar c + rngs*AvgTrueRange(atrs) limit;  
end;
