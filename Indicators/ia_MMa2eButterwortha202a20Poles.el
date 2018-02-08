Inputs: price(medianprice),period(15);

vars: butter(0);

butter = MM.ButterworthFilter(price,period,2);

plot1(butter,"Butterworth 2 Poles");
//plot2(price,"Price");
