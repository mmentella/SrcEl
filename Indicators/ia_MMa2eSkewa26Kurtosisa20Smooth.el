inputs: Price(medianprice),sa(0.225),ka(0.225);

var: skew_(0),kurt(0);

skew_ = MM.Smoother(Price- MM.Smoother(Price,sa),sa);
kurt = MM.Smoother(Price- MM.Smoother(Price,ka),ka);

plot1(skew_,"SKEW");
plot2(kurt,"Kurtosis");
plot3(0,"Zero");
