Inputs: price(medianprice),alpha(.07),length(8),smooth(true);

vars: cycle(0,data2),fish(0,data2);

if barstatus(2) = 2 then begin
cycle = MM.Cycle(price,alpha)data2;
fish = MM.FisherTransform(cycle,length,smooth)data2;
end;
plot1(fish,"Fisher Cycle");
plot2(fish[1],"Trigger");
plot3(0,"Ref");
