Input: Price(c);
Inputs: MaxLength(30),MinLength(5),MaxBound(1.75),MinBound(.25);

vars: n(0),k(0),std(0);

k = absvalue(price - price[1]);
std = StdDev(k,maxlength);

n = MM.VolatilityModuledLength(price,maxlength,minlength,minbound,maxbound);

n = .25*(n + 2*n[1] + n[2]);

if std > 0 then plot1(IntPortion(n),"Variable Length");
