vars: trnd(0),trgr(0),mom(0);

mom = 0.0909*Close + 0.4545*Close[1] - 0.4545*Close[3] - 0.0909*Close[4];

if currentbar < 5 then mom = close - close[1];

plot1(mom,"Mom");
