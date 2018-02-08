input: Price(MedianPrice),alpha(.07),showtrig(true);

vars: trend(price),trigger(price),trendhi(0),trendlo(0);

MM.ITrend(price,alpha,trend,trigger);

plot1(trend,"Trend",white);
if showtrig then plot2(trigger,"Trigger",red);
