Inputs: Price(Close),Length(30);

vars: devs(0);

devs = StdDev(price,length);

plot1(devs*bigpointvalue,"Dev Std");
