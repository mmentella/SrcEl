Inputs: SettlementTime(2015),CurrencyLimit(1500);

vars: settle(false),min(0),max(0);

if d <> d[1] then settle = false;

if not settle and t > SettlementTime then begin
 settle = true;
 min = c[1] - 1500/bigpointvalue;
 max = c[1] + 1500/bigpointvalue;
end;

plot1(max,"MAX");
plot2(min,"MIN");
