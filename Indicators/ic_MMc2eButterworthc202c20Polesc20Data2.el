Inputs: price(medianprice),period(15);

vars: butter(0,data2);

butter = MM.ButterworthFilter(price,period,2)data2;

plot1(butter,"Butterworth 2 Poles");
