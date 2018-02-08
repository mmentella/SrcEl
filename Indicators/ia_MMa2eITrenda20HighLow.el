Inputs: Price(MedianPrice),alpha(.07);

vars: trend(price),trigger(price),trendhi(0),trendlo(0),rng(0),var0(0);

MM.ITrend(price,alpha,trend,trigger);

trendhi = iff(trend > trend[1],trend,trendhi[1]);
trendlo = iff(trend < trend[1],trend,trendlo[1]);

rng = trendhi - trendlo;

var0 = StdDev(rng,intportion(2/alpha - 1));

plot1(trendhi,"Trend+");
plot2(trendlo,"Trend-");

if trendhi = trendhi[1] then begin
 plot3(trendlo+var0,"UP");
 plot4(trendlo-var0,"LW");
end;

if trendlo = trendlo[1] then begin
 plot3(trendhi+var0,"UP");
 plot4(trendhi-var0,"LW");
end;
