Inputs: price(medianprice),alpha(.07);

vars: trigger(0),trend(0);

MM.ITrend(price,alpha,trend,trigger);

if trend[1] > 0 then plot1(100*(trend-trend[1])/trend[1],"ITrend Strength");
