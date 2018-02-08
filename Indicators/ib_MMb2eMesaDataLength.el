Inputs: Price(medianprice),N(6),M100(40);

value1 = MM.BurgPeriod(price,N,M100);
if currentbar > 3 then value2 = Average(value1,3);

plot1(value2,"BURG CYCLE LENGTH");
