Inputs: Length(3);

vars: var0(0,data2);

if barstatus(2) = 2 then var0 = Average(close,length) data2;

plot1(var0,"Average");
