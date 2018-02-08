Inputs: price(medianprice),alpha(.07),length(8),smooth(true);

vars: cycle(0),fish(0);

cycle = MM.Cycle(price,alpha);
fish = MM.FisherTransform(cycle,length,smooth);

plot1(fish,"Fisher Cycle");
plot2(fish[1],"Trigger");
plot3(0,"Ref");
