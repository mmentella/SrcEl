input: Price(C), Len(8), Exp1(0.5), Exp2(0.5);

var: min(0),max(0),x(0),fish(0);

min = Lowest(price,len);
max = Highest(price,len);

x = exp1*(2*((price - min)/(max - min) - 0.5)) + (1 - exp1)*x[1];

x = minlist(0.999,maxlist(-0.999,x));

fish = exp2*Log((1 - x)/(1 + x)) + (1-exp2)*fish[1];

plot1(fish,"Fish");
plot2(plot1[1],"Trig");
