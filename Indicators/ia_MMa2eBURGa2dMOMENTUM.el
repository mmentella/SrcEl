Inputs: Price(medianprice);

vars: dc(0),mom(0),smom(0);

dc = MM.BurgPeriod(price,6,.4);

mom = price - price[IntPortion(dc + .5)];
MM.ITrend(mom,.07,smom,value1);

plot1(smom,"BURG MOMENTUM");
plot2(0,"Ref");
