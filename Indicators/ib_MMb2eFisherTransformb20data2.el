input: Price(C), Len(8), Exp1(0.5), Exp2(0.5);

var: min(0,data2),max(0,data2),x(0,data2),fish(0,data2);

if barstatus(2) = 2 then begin
 min = Lowest(price,len)data2;
 max = Highest(price,len)data2;

 x = exp1*(2*((price - min)/(max - min) - 0.5)) + (1 - exp1)*x[1];
 
 x = minlist(0.999,x)data2;
 x = maxlist(-0.999,x)data2;
 
 fish = exp2*(0.2*Log((1 + x)/(1 - x))) + (1 - exp2)*fish[1];
end;

plot1(fish,"Fish");
plot2(plot1[1],"Trig");
plot3(0,"Turning Point");
