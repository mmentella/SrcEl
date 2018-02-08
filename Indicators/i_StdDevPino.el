Inputs: Price(c),Length(30);

vars: var0(0),k(0);

var0 = StdDevPino(price,length)data2;

if var0 <> 0 then k = 1 - var0[1]/var0;

plot1(k,"StdDev Pino");
