Inputs: price(medianprice),period(15);

vars: butter(0);

butter = MM.ButterworthFilter(price,period,3);

plot1(butter,"Butterworth 3 Poles");
