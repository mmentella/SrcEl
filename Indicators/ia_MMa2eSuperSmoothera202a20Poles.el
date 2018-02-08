Inputs: price(medianprice),period(15);

vars: butter(0);

butter = MM.SuperSmoother(price,period,2);

plot1(butter,"SuperSmoother 2 Poles");
