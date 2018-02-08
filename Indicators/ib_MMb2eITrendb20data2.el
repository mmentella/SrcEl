Inputs: Price(MedianPrice),alpha(.07);

vars: trend(price,data2),trigger(price,data2);

if barstatus(2) = 2 then MM.ITrend(price,alpha,trend,trigger)data2;

plot1(trend,"Trend");
plot2(trigger,"Trigger");

//plot3(MM.Smooth(price,alpha),"XSmooth");;
