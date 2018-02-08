Inputs: price(medianprice),period(15);

vars: butter(0);

butter = MM.SuperSmoother(price,period,3);

plot1(butter,"SuperSmoother 3 Poles");
