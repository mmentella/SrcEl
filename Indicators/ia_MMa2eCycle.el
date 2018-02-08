Inputs: price(MedianPrice),alpha(.07);

vars: cycle(0);

cycle = MM.Cycle(price,alpha);

plot1(cycle,"Cycle");
plot2(cycle[1],"Trigger");
plot3(0,"Ref");
