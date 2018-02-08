Inputs: Price(medianprice);

value1 = MM.MesaFilter(Price);

plot1(value1,"MESA Cycle");
plot2(value1[1],"Trigger");
plot3(0,"Ref");
