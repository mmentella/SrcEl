inputs: alpha(.07);

vars: trend(0),trigger(0),cycle(0);

MM.ITrend(medianprice,alpha,trend,trigger);
cycle = MM.Cycle(medianprice,alpha);

plot1(trend + cycle,"ITCyc Model");
