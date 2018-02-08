[LegacyColorValue = true]; 

Inputs:		Strength(2);

value1=swinghigh(1,h,Strength,80);
value2=swinglow(1,l,Strength,80);

if value1>-1 then plot1(value1,"BuyFractal");
if value2>-1 then plot2(value2,"SellFractal");
