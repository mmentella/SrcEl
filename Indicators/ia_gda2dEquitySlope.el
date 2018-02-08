vars: slope(0),dayn(1);

if d <> d[1] then begin
 dayn = dayn + 1;
end;

plot1(i_OpenEquity/dayn,"Equity Slope");
