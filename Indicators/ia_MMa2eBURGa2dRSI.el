Inputs: N(6),M100(40),CycPart(.5),OverBougth(70),OverSold(30);

vars: dc(0);

dc = MM.BurgPeriod(medianprice,n,m100);

plot1(rsi(medianprice,IntPortion(cycpart*dc + .5)),"MESA RSI");
plot2(OverBougth,"OverBougth");
plot3(OverSold,"OverSold");
