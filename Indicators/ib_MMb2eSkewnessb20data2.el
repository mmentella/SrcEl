Inputs: price(MedianPrice),alpm(0.1),alpd(0.05),showtrig(false);

vars: mmskew(0,data2);

if barstatus(2) = 2 then mmskew = MM.Skewness(price,alpm,alpd)data2;

plot1(mmskew  ,"Moving Skewness");
if showtrig then plot2(plot1[1],"Trigger");
plot3(0       ,"zero");
