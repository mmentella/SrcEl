vars: period(0),trend(0),trigger(0);

period = MM.CyclePeriod(medianprice,.07);
period = IntPortion((period - 1)/2);

MM.ITrend(medianprice,.07,trend,trigger);

plot1(trend - trend[period],"Adaptive Momentum");
plot2(0,"Ref");
