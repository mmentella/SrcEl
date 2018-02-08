Inputs: price(MedianPrice),alpha(.07);

vars: cycle(0,data2),trigger(0,data2);

if barstatus(2) = 2 then begin
 trigger = cycle;
 cycle = MM.Cycle(price,alpha)data2;
 //trigger = cycle[1];
end;

plot1(cycle,"Cycle");
plot2(trigger,"Trigger");
plot3(0,"Ref");
