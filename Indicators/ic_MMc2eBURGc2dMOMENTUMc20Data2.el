Inputs: Price(medianprice);

vars: dc(0,data2),mom(0,data2),smom(0,data2);

dc = MM.BurgPeriod(price,6,.4)data2;

mom = price data2 - price[IntPortion(dc + .5)] data2;
MM.ITrend(mom,.07,smom,value3)data2;

plot1(smom,"BURG MOMENTUM");
plot2(0,"Ref");
