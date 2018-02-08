Inputs: price(close),alpm(0.1),alpd(0.05);

vars: mmskew(0);

mmskew = MM.Skewness(price,alpm,alpd);

plot1(mmskew  ,"Moving Skewness");
plot2(plot1[1],"Trigger");
plot3(0       ,"zero");
