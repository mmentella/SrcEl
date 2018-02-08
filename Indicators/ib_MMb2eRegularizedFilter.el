Input: Price(medianprice),alpha(.33);

vars: var0(0);

var0 = MM.RegularizedFilter(price,alpha);

plot1(var0,"Regularized Filter");
